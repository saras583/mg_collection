import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  ThemeController() {
    loadtheme();
  }

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
     Hive.box('settings').put('isDark', isDark);
      notifyListeners();
  }

  void loadtheme() {
    final box = Hive.box('settings');
    bool isDark = box.get('isDark', defaultValue: false);

    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }
  
}