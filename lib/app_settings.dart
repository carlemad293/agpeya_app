import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkTheme = false;
  double _fontSize = 16.0;
  Locale _locale = Locale('en');

  bool get isDarkTheme => _isDarkTheme;
  double get fontSize => _fontSize;
  Locale get locale => _locale;

  AppSettings() {
    _loadSettings();
  }

  void toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
  }

  void updateFontSize(double newSize) async {
    _fontSize = newSize;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', _fontSize);
  }

  void changeLocale(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', _locale.languageCode);
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    String? languageCode = prefs.getString('languageCode');
    _locale = languageCode != null ? Locale(languageCode) : Locale('en');
    notifyListeners();
  }
}
