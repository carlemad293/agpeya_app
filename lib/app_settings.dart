// app_settings.dart

import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkTheme = false;
  double _fontSize = 16.0;
  Locale _locale = Locale('en');

  // Getters
  bool get isDarkTheme => _isDarkTheme;
  double get fontSize => _fontSize;
  Locale get locale => _locale;

  // Toggles the theme between dark and light
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  // Updates the font size
  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  // Changes the locale (language)
  void changeLocale(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
