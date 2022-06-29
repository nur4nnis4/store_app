import 'package:flutter/material.dart';
import 'package:store_app/models/theme_preferences.dart';

class ThemeChangeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();

  bool _isDarkTheme;
  ThemeChangeProvider(this._isDarkTheme);
  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    themePreferences.setTheme(value);
    notifyListeners();
  }
}
