import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
