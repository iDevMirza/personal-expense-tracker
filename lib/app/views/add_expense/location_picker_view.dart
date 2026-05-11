import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/picked_location.dart';
import '../../data/services/location_service.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  final LocationService _locationService = Get.find();
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  LatLng _picked = const LatLng(51.4816, -3.1791); // Cardiff default
  String _address = 'Move the map to choose a location';
  bool _resolvingAddress = false;
  bool _initializing = true;
  bool _searching = false;

  List<NominatimResult> _searchResults = [];
  Timer? _debounce;
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    _initFromCurrentLocation();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _idleTimer?.cancel();
    _searchCtrl.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initFromCurrentLocation() async {
    final pos = await _locationService.getCurrentPosition();
    if (pos != null) {
      _picked = LatLng(pos.latitude, pos.longitude);
      await _resolveAddress();
    }
    if (mounted) {
      setState(() => _initializing = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_picked, 16);
      });
    }
  }

  Future<void> _resolveAddress() async {
    setState(() => _resolvingAddress = true);
    final addr = await _locationService.getAddressFromCoords(
      _picked.latitude,
      _picked.longitude,
    );
    if (!mounted) return;
    setState(() {
      _address = addr ?? 'Unknown location';
      _resolvingAddress = false;
    });
  }

  Future<void> _moveToCurrentLocation() async {
    final pos = await _locationService.getCurrentPosition();
    if (pos == null) return;
    final target = LatLng(pos.latitude, pos.longitude);
    setState(() => _picked = target);
    _mapController.move(target, 16);
    await _resolveAddress();
  }

  void _onPositionChanged(MapCamera position, bool hasGesture) {
    _picked = position.center;
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _resolveAddress();
    });
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.trim().isEmpty) {
        setState(() => _searchResults = []);
        return;
      }
      setState(() => _searching = true);
      final results = await _locationService.searchPlaces(value);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    });
  }

  void _selectSearchResult(NominatimResult r) {
    final target = LatLng(r.lat, r.lon);
    setState(() {
      _picked = target;
      _address = r.displayName;
      _searchResults = [];
      _searchCtrl.clear();
    });
    FocusScope.of(context).unfocus();
    _mapController.move(target, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location'), centerTitle: true),
      body: _initializing
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _picked,
              initialZoom: 16,
              minZoom: 3,
              maxZoom: 19,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.expense_tracker',
                maxZoom: 19,
              ),
            ],
          ),
          const IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Icon(Icons.location_on,
                    color: AppColors.primary, size: 48),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: Colors.white.withOpacity(0.7),
              child: const Text('© OpenStreetMap',
                  style: TextStyle(fontSize: 10, color: Colors.black87)),
            ),
          ),
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search for a place...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searching
                        ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                        : null,
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
              ),
              if (_searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _searchResults.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final r = _searchResults[i];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.place_outlined,
                            color: AppColors.primary),
                        title: Text(r.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87)),
                        onTap: () => _selectSearchResult(r),
                      );
                    },
                  ),
                ),
            ]),
          ),
          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    const Text('Selected location',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const Spacer(),
                    if (_resolvingAddress)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ]),
                  const SizedBox(height: 8),
                  Text(_address, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _resolvingAddress
                          ? null
                          : () => Get.back(
                        result: PickedLocation(
                          latitude: _picked.latitude,
                          longitude: _picked.longitude,
                          address: _address,
                        ),
                      ),
                      child: const Text('Confirm Location',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}