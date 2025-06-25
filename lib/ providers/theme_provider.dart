import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Optional: You can use this version if you want to pass context in future
  void toggleThemeWithContext(BuildContext context) {
    toggleTheme(); // You can add logic here based on context if needed
  }
}
