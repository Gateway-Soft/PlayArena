import 'package:flutter/material.dart';

class DarkTheme {
  ThemeData buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
