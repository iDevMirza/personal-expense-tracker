// class PickedLocation {
//   final double latitude;
//   final double longitude;
//   final String address;
//
//   PickedLocation({
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//   });
// }

class PickedLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory PickedLocation.fromJson(Map<String, dynamic> json) {
    return PickedLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String? ?? '',
    );
  }
}