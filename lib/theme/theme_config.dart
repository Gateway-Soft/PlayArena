import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class AppThemeConfig {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}




// ✅ Use correct class names defined in respective files
final ThemeData lightTheme = LightTheme().buildTheme();
final ThemeData darkTheme = DarkTheme().buildTheme();
