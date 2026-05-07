import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/theme.dart';

class ThemeProvider with ChangeNotifier {

  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {

    _themeData = themeData;

    notifyListeners();
  }

  void changeTheme() {

    if (_themeData == lightTheme) {

      themeData = darkTheme;

    } else {

      themeData = lightTheme;
    }
  }
}