import 'package:flutter/material.dart';

class LightTheme {
  ThemeData buildTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}
