import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF263144),
  primaryColor: Color(0xFF2296CB),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.grey,
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFE5E5E5),
  primaryColor: Color(0xFF2296CB),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
);
