import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Provider - Manages light/dark theme switching
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark
  static const String _themePrefKey = 'theme_mode';

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Toggle between light and dark theme
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference();
    notifyListeners();
  }

  /// Set theme explicitly
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemePreference();
    notifyListeners();
  }

  /// Set to dark theme
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    _saveThemePreference();
    notifyListeners();
  }

  /// Set to light theme
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    _saveThemePreference();
    notifyListeners();
  }

  /// Load saved theme preference
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);
      
      if (savedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == savedTheme,
          orElse: () => ThemeMode.dark,
        );
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, keep default
      debugPrint('Error loading theme preference: $e');
    }
  }

  /// Save theme preference
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, _themeMode.toString());
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}
