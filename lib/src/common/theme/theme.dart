import 'package:flutter/material.dart';

/// This class holds the theme used in the app
class AppTheme {
  /// Light theme of the app
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE5E5E5),
    primaryColor: const Color(0xFF2296CB),
    appBarTheme: const AppBarTheme(
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

  /// Dark theme of the app
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF263144),
    primaryColor: const Color(0xFF2296CB),
    appBarTheme: const AppBarTheme(
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
}
