import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NominatimResult {
  final String displayName;
  final double lat;
  final double lon;

  const NominatimResult({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory NominatimResult.fromJson(Map<String, dynamic> json) {
    return NominatimResult(
      displayName: json['display_name']?.toString() ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0,
      lon: double.tryParse(json['lon']?.toString() ?? '') ?? 0,
    );
  }
}

class LocationService extends GetxService {
  static const String _host = 'nominatim.openstreetmap.org';

  // Keep this unique for your app. Nominatim can reject generic clients.
  static const Map<String, String> _headers = {
    'User-Agent': 'PersonalExpenseTracker/1.0',
    'Accept': 'application/json',
    'Accept-Language': 'en',
  };

  Future<Position?> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        debugPrint('Location service is disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('Location permission denied');
        return null;
      }

      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('getCurrentPosition error: $e');
      return null;
    }
  }

  Future<String?> getAddressFromCoords(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.https(
        _host,
        '/reverse',
        {
          'format': 'jsonv2',
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'addressdetails': '1',
        },
      );

      debugPrint('Reverse URL: $uri');

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      debugPrint('Reverse geocode status: ${response.statusCode}');
      debugPrint('Reverse geocode body: ${response.body}');

      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) return null;

      final displayName = decoded['display_name']?.toString().trim();

      if (displayName == null || displayName.isEmpty) return null;

      return displayName;
    } catch (e) {
      debugPrint('getAddressFromCoords error: $e');
      return null;
    }
  }

  Future<List<NominatimResult>> searchPlaces(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 3) return [];

    try {
      final uri = Uri.https(
        _host,
        '/search',
        {
          'format': 'jsonv2',
          'q': trimmedQuery,
          'limit': '6',
          'addressdetails': '1',
        },
      );

      debugPrint('Search URL: $uri');

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      debugPrint('Search place status: ${response.statusCode}');
      debugPrint('Search place body: ${response.body}');

      if (response.statusCode != 200) return [];

      final decoded = jsonDecode(response.body);

      if (decoded is! List) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(NominatimResult.fromJson)
          .where((item) {
        return item.displayName.isNotEmpty && item.lat != 0 && item.lon != 0;
      }).toList();
    } catch (e) {
      debugPrint('searchPlaces error: $e');
      return [];
    }
  }
}
