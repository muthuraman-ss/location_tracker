import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    final isDark = Provider.of<ThemeViewModel>(context, listen: false).isDark;
    _loadMapStyle(isDark);
  }

  Future<void> _loadMapStyle(bool isDark) async {
    final style = await rootBundle.loadString(
      isDark ? 'assets/map_style/dark.json' : 'assets/map_style/light.json',
    );
    _mapStyle = style;

    if (mapController != null && _mapStyle != null) {
      mapController!.setMapStyle(_mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationVM = Provider.of<LocationViewModel>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);

    final position = LatLng(
      locationVM.currentLocation!.latitude,
      locationVM.currentLocation!.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Current Location",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(themeVM.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () async {
              themeVM.toggleTheme();
              await _loadMapStyle(themeVM.isDark);

              if (mapController != null && _mapStyle != null) {
                mapController!.setMapStyle(_mapStyle);
              }

              setState(() {});
            },
          ),
        ],
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: position, zoom: 15),
        markers: {Marker(markerId: const MarkerId("m1"), position: position)},
        onMapCreated: (controller) {
          mapController = controller;

          if (_mapStyle != null) {
            controller.setMapStyle(_mapStyle);
          }
        },

        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
