import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import 'map_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationViewModel>(context);
    final theme = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Location Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              theme.toggleTheme();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Allow Button
            if (!vm.permissionGranted)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text(
                    "Allow Location",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    vm.requestPermission();
                  },
                ),
              ),

            // Current Location Card
            if (vm.permissionGranted && vm.currentLocation != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (!theme.isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _rowItem("Latitude", "${vm.currentLocation!.latitude}"),
                    _rowItem("Longitude", "${vm.currentLocation!.longitude}"),
                    _rowItem("City", vm.currentLocation!.city),
                    _rowItem("State", vm.currentLocation!.state),
                    _rowItem("Pincode", vm.currentLocation!.pincode),
                    _rowItem(
                      "Updated",
                      DateFormat(
                        'hh:mm a',
                      ).format(vm.currentLocation!.timestamp),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text("Show on Map"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MapView()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            const Text(
              "History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            // History List
            Expanded(
              child: vm.history.isNotEmpty
                  ? ListView.builder(
                      itemCount: vm.history.length,
                      itemBuilder: (context, index) {
                        final item = vm.history[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.location_history),
                            title: Text(
                              "${item.city} | ${item.latitude.toStringAsFixed(3)}, ${item.longitude.toStringAsFixed(3)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('hh:mm a').format(item.timestamp),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No history yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable UI function
  Widget _rowItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
