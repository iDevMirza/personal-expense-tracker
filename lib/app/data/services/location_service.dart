import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LocationService extends GetxService {
  static const _userAgent = 'ExpenseTracker/1.0 (student@example.com)';

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location disabled', 'Please enable location services',
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission denied', 'Location permission is required',
            snackPosition: SnackPosition.BOTTOM);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Permission denied', 'Enable location from app settings',
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String?> getAddressFromCoords(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
            '?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1',
      );
      final res = await http.get(uri, headers: {'User-Agent': _userAgent});
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final addr = data['address'] as Map<String, dynamic>?;
      if (addr == null) return data['display_name'] as String?;

      final parts = <String?>[
        addr['amenity'] ?? addr['shop'] ?? addr['building'],
        addr['road'],
        addr['suburb'] ?? addr['neighbourhood'],
        addr['city'] ?? addr['town'] ?? addr['village'],
      ].where((s) => s != null && s.toString().trim().isNotEmpty).toSet().toList();

      if (parts.isEmpty) return data['display_name'] as String?;
      return parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  Future<List<NominatimResult>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
            '?format=json&q=${Uri.encodeQueryComponent(query)}&limit=5&addressdetails=1',
      );
      final res = await http.get(uri, headers: {'User-Agent': _userAgent});
      if (res.statusCode != 200) return [];
      final list = jsonDecode(res.body) as List;
      return list.map((e) => NominatimResult.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }
}

class NominatimResult {
  final double lat;
  final double lon;
  final String displayName;

  NominatimResult({required this.lat, required this.lon, required this.displayName});

  factory NominatimResult.fromMap(Map<String, dynamic> m) => NominatimResult(
    lat: double.parse(m['lat'].toString()),
    lon: double.parse(m['lon'].toString()),
    displayName: m['display_name'] ?? '',
  );
}