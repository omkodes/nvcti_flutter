import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color backgroundWhite = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF212121);

  // Dark mode — Midnight Academy palette
  static const Color darkBackground = Color(0xFF0F172A); // Deep Midnight Blue
  static const Color darkSurface = Color(0xFF1E293B);   // Slate Navy
  static const Color darkCard = Color(0xFF1E293B);      // Slate Navy
  static const Color darkInputFill = Color(0xFF0F172A); // Matches background
  static const Color darkDivider = Color(0xFF334155);   // Slate 700 divider

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE0E0E0),
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: textDark,
        secondary: Color(0xFF26C6DA),
        onSecondary: Colors.white,
        error: Colors.red,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F3F4),
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
        prefixIconColor: const Color(0xFF757575),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
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
        bodyMedium: TextStyle(color: Color(0xFF424242), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFF757575), fontSize: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      dividerColor: darkDivider,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF38BDF8),       // Sky Cobalt — brand color in dark
        onPrimary: Color(0xFF020617),
        surface: darkSurface,
        onSurface: Color(0xFFF1F5F9),     // Cool White
        secondary: Color(0xFF38BDF8),
        onSecondary: Color(0xFF020617),
        tertiary: Color(0xFF7DD3FC),
        error: Color(0xFFEF4444),         // Red 500
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: darkSurface,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.black87,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputFill,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        prefixIconColor: const Color(0xFF94A3B8),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFF1F5F9),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFFF1F5F9),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(0xFFF1F5F9), fontSize: 16),   // Cool White
        bodyMedium: TextStyle(color: Color(0xFF94A3B8), fontSize: 14), // Slate 400
        bodySmall: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),  // Slate 400
      ),
    );
  }
}
