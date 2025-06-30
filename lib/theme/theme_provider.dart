// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'isDarkMode';

  bool _isDarkMode = false;

  ThemeProvider() {
    _loadTheme(); // Load saved preference at startup
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    _saveTheme(isDark);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }
}
