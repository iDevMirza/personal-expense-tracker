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
  final LocationService _locationService = Get.find<LocationService>();
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  /// Location -> Cardiff
  static const LatLng _defaultLocation = LatLng(51.4816, -3.1791);

  LatLng _picked = _defaultLocation;
  String _address = 'Finding your location...';

  bool _resolvingAddress = false;
  bool _initializing = true;
  bool _searching = false;
  bool _suppressNextChange = false;
  bool _mapReady = false;

  String? _searchError;
  List<NominatimResult> _searchResults = [];

  Timer? _debounce;
  Timer? _idleTimer;
  int _searchRequestId = 0;

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

  String _coordinateFallback() {
    return '${_picked.latitude.toStringAsFixed(6)}, ${_picked.longitude.toStringAsFixed(6)}';
  }

  Future<void> _initFromCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();

      if (position != null) {
        _picked = LatLng(position.latitude, position.longitude);
      }

      await _resolveAddress();
    } catch (e) {
      debugPrint('Init current location failed: $e');

      if (mounted) {
        setState(() {
          _address = _coordinateFallback();
        });
      }
    } finally {
      if (!mounted) {
        return;
      }

      setState(() => _initializing = false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_mapReady) return;

        _suppressNextChange = true;
        _mapController.move(_picked, 16);
      });
    }
  }

  Future<void> _resolveAddress() async {
    if (!mounted) return;

    setState(() => _resolvingAddress = true);

    try {
      final address = await _locationService.getAddressFromCoords(
        _picked.latitude,
        _picked.longitude,
      );

      if (!mounted) return;

      setState(() {
        _address = address != null && address.trim().isNotEmpty
            ? address.trim()
            : _coordinateFallback();
        _resolvingAddress = false;
      });
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');

      if (!mounted) return;

      setState(() {
        _address = _coordinateFallback();
        _resolvingAddress = false;
      });
    }
  }

  Future<void> _moveToCurrentLocation() async {
    final position = await _locationService.getCurrentPosition();

    if (position == null) {
      Get.snackbar(
        'Location unavailable',
        'Please enable location permission and GPS.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final target = LatLng(position.latitude, position.longitude);

    _idleTimer?.cancel();

    setState(() {
      _picked = target;
      _address = 'Resolving address...';
    });

    if (_mapReady) {
      _suppressNextChange = true;
      _mapController.move(target, 16);
    }

    await _resolveAddress();
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (_suppressNextChange) {
      _suppressNextChange = false;
      return;
    }

    if (!hasGesture) return;

    _idleTimer?.cancel();

    _idleTimer = Timer(const Duration(milliseconds: 800), () async {
      if (!mounted) return;

      final center = _mapController.camera.center;

      setState(() {
        _picked = center;
        _address = 'Resolving address...';
      });

      await _resolveAddress();
    });
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _searching = false;
        _searchError = null;
      });
      return;
    }

    if (query.length < 3) {
      setState(() {
        _searchResults = [];
        _searching = false;
        _searchError = 'Type at least 3 characters';
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 900), () async {
      final requestId = ++_searchRequestId;

      if (!mounted) return;

      setState(() {
        _searching = true;
        _searchError = null;
      });

      try {
        final results = await _locationService.searchPlaces(query);

        if (!mounted) return;
        if (requestId != _searchRequestId) return;

        setState(() {
          _searchResults = results;
          _searching = false;
          _searchError = results.isEmpty ? 'No place found' : null;
        });
      } catch (e) {
        debugPrint('Search failed: $e');

        if (!mounted) return;
        if (requestId != _searchRequestId) return;

        setState(() {
          _searchResults = [];
          _searching = false;
          _searchError = 'Search failed. Please try again.';
        });
      }
    });
  }

  void _selectSearchResult(NominatimResult result) {
    final target = LatLng(result.lat, result.lon);

    _idleTimer?.cancel();
    _debounce?.cancel();

    setState(() {
      _picked = target;
      _address = result.displayName;
      _searchResults = [];
      _searchError = null;
      _searching = false;
      _searchCtrl.clear();
    });

    FocusScope.of(context).unfocus();

    if (_mapReady) {
      _suppressNextChange = true;
      _mapController.move(target, 16);
    }
  }

  void _confirmLocation() {
    Get.back(
      result: PickedLocation(
        latitude: _picked.latitude,
        longitude: _picked.longitude,
        address: _address.trim().isEmpty ? _coordinateFallback() : _address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Pick Location'),
        centerTitle: true,
      ),
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
                    onMapReady: () {
                      _mapReady = true;
                      _suppressNextChange = true;
                      _mapController.move(_picked, 16);
                    },
                    onPositionChanged: _onPositionChanged,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.expense_tracker',
                      maxZoom: 19,
                    ),
                  ],
                ),
                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    color: Colors.white70,
                    child: const Text(
                      '© OpenStreetMap',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      _SearchBox(
                        controller: _searchCtrl,
                        searching: _searching,
                        onChanged: _onSearchChanged,
                      ),
                      if (_searchResults.isNotEmpty || _searchError != null)
                        _SearchResultsList(
                          results: _searchResults,
                          error: _searchError,
                          onSelected: _selectSearchResult,
                        ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 205,
                  child: FloatingActionButton(
                    heroTag: 'current_location_button',
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
                  child: _SelectedLocationCard(
                    address: _address,
                    resolvingAddress: _resolvingAddress,
                    onConfirm: _resolvingAddress ? null : _confirmLocation,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final bool searching;
  final ValueChanged<String> onChanged;

  const _SearchBox({
    required this.controller,
    required this.searching,
    required this.onChanged,
  });

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _SearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search for a place...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.searching
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged('');
                      },
                      icon: const Icon(Icons.close),
                    )
                  : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final List<NominatimResult> results;
  final String? error;
  final ValueChanged<NominatimResult> onSelected;

  const _SearchResultsList({
    required this.results,
    required this.error,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final visibleResults = results.take(5).toList();

    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
          ),
        ],
      ),
      child: error != null
          ? Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: visibleResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final result = visibleResults[index];

                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.place_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    result.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () => onSelected(result),
                );
              },
            ),
    );
  }
}

class _SelectedLocationCard extends StatelessWidget {
  final String address;
  final bool resolvingAddress;
  final VoidCallback? onConfirm;

  const _SelectedLocationCard({
    required this.address,
    required this.resolvingAddress,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              const Text(
                'Selected location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (resolvingAddress)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onConfirm,
              child: const Text(
                'Confirm Location',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
