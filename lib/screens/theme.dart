import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color.fromARGB(255, 234, 216, 216),
    primary: Color.fromARGB(255, 17, 17, 17),
  ),
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 16, 15, 15),
    primary: Color.fromARGB(255, 21, 20, 20),
  ),
);
