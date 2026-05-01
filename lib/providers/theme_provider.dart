import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/settings_schema.dart';

/// Theme Provider - Manages UserSettings and theme state
class ThemeProvider extends ChangeNotifier {
  UserSettings _settings = const UserSettings();
  static const String _settingsPrefKey = 'user_settings';

  ThemeProvider() {
    _loadSettings();
  }

  UserSettings get settings => _settings;

  /// Get ThemeMode for MaterialApp
  ThemeMode get themeMode {
    switch (_settings.theme) {
      case ThemeSetting.light:
        return ThemeMode.light;
      case ThemeSetting.dark:
        return ThemeMode.dark;
      case ThemeSetting.system:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode => _settings.theme == ThemeSetting.dark;
  bool get isLightMode => _settings.theme == ThemeSetting.light;

  /// Toggle between light and dark theme
  void toggleTheme() {
    final newTheme = _settings.theme == ThemeSetting.light
        ? ThemeSetting.dark
        : ThemeSetting.light;
    updateSettings(_settings.copyWith(theme: newTheme));
  }

  /// Set theme explicitly
  void setThemeMode(ThemeMode mode) {
    final themeSetting = mode == ThemeMode.light
        ? ThemeSetting.light
        : mode == ThemeMode.dark
            ? ThemeSetting.dark
            : ThemeSetting.system;
    updateSettings(_settings.copyWith(theme: themeSetting));
  }

  /// Set to dark theme
  void setDarkTheme() {
    updateSettings(_settings.copyWith(theme: ThemeSetting.dark));
  }

  /// Set to light theme
  void setLightTheme() {
    updateSettings(_settings.copyWith(theme: ThemeSetting.light));
  }

  /// Update settings (triggers save and notify)
  void updateSettings(UserSettings newSettings) {
    _settings = newSettings;
    _saveSettings();
    notifyListeners();
  }

  /// Load saved settings
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsPrefKey);

      if (settingsJson != null) {
        final Map<String, dynamic> decoded = {
          'theme': settingsJson.split(':')[0],
          'accent': settingsJson.split(':').length > 1
              ? settingsJson.split(':')[1]
              : 'defaultAccent',
          'logoVariant': settingsJson.split(':').length > 2
              ? settingsJson.split(':')[2]
              : 'auto',
        };
        _settings = UserSettings.fromJson(decoded);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  /// Save settings
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString =
          '${_settings.theme.name}:${_settings.accent.name}:${_settings.logoVariant.name}';
      await prefs.setString(_settingsPrefKey, settingsString);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
