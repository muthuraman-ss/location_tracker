import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location_data.dart';

class LocationViewModel extends ChangeNotifier {
  //  Secure API Key (inject from Gradle)
  final String apiKey = const String.fromEnvironment("API_KEY");

  bool permissionGranted = false;
  LocationDataModel? currentLocation;
  List<LocationDataModel> history = [];

  // 🟦 Polyline points for path
  List<LatLng> pathPoints = [];

  Future<void> requestPermission() async {
    await Future.delayed(const Duration(milliseconds: 300));

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      permissionGranted = true;
      notifyListeners();

      await getCurrentLocation();
      listenToLocationChanges();
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    await updateLocation(position);
  }

  void listenToLocationChanges() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      updateLocation(position);
    });
  }

  Future<void> updateLocation(Position position) async {
    final address = await getAddressFromAPI(
      position.latitude,
      position.longitude,
    );

    currentLocation = LocationDataModel(
      latitude: position.latitude,
      longitude: position.longitude,
      city: address["city"],
      state: address["state"],
      pincode: address["pincode"],
      timestamp: DateTime.now(),
    );

    // Add history
    history.add(currentLocation!);

    // Add path point
    pathPoints.add(LatLng(position.latitude, position.longitude));

    notifyListeners();
  }

  //  Call Google Geocode API securely
  Future<Map<String, dynamic>> getAddressFromAPI(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      String city = "";
      String state = "";
      String pincode = "";

      if (data["results"] != null && data["results"].isNotEmpty) {
        final components =
            data["results"][0]["address_components"] as List<dynamic>;

        for (var component in components) {
          if (component["types"].contains("locality")) {
            city = component["long_name"];
          }
          if (component["types"].contains("administrative_area_level_1")) {
            state = component["long_name"];
          }
          if (component["types"].contains("postal_code")) {
            pincode = component["long_name"];
          }
        }
      }

      return {"city": city, "state": state, "pincode": pincode};
    } catch (e) {
      return {"city": "", "state": "", "pincode": ""};
    }
  }
}
