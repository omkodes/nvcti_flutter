import 'package:flutter/material.dart';

class AppTheme {
  // Extracted from the App Bar color in the screenshot
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color backgroundWhite = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF212121);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: primaryBlue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textDark, fontSize: 16),
      ),
    );
  }
}
