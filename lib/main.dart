import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Location Tracker",
      themeMode: theme.currentMode,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
      ),

      home: const HomeView(),
    );
  }
}
