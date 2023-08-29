import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF26AECB),
    primarySwatch: MaterialColor(0xFF26AECB, {
      50: Color(0xFF26AECB),
      100: Color(0xFF26AECB),
      200: Color(0xFF26AECB),
      300: Color(0xFF26AECB),
      400: Color(0xFF26AECB),
      500: Color(0xFF26AECB),
      600: Color(0xFF26AECB),
      700: Color(0xFF26AECB),
      800: Color(0xFF26AECB),
      900: Color(0xFF26AECB),
    }),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      centerTitle: true,
    ),
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xff26aecb),
      foregroundColor: Colors.white,
    ),
  );
}
