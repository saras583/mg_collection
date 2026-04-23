import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {

    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
