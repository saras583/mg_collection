import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFF5EFEF),
    primary: Color(0xFFF5EFEF),
  ),
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 16, 15, 15),
    primary: Color.fromARGB(255, 21, 20, 20),
  ),
);
