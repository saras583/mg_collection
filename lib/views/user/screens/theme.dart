import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF5EFEF),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF5EFEF),
    primary: Color(0xFF111111),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF5DA9E9),
    unselectedItemColor: Colors.grey,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF100F0F), //  your dark surface
  cardColor: const Color(0xFF1E1E1E),               // for all containers
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF100F0F),
    primary: Color(0xFF151414),
    onSurface: Colors.white,                        //  text on surfaces
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E),                   //  text fields dark
    hintStyle: TextStyle(color: Colors.grey),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),             //  dark nav bar
    selectedItemColor: Color(0xFF5DA9E9),
    unselectedItemColor: Colors.grey,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
);