class LocationDataModel {
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String pincode;
  final DateTime timestamp;

  LocationDataModel({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.pincode,
    required this.timestamp,
  });
}
