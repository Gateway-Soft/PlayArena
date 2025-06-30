import 'package:flutter/material.dart';

class LightTheme {
  ThemeData buildTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
