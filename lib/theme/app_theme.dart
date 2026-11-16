
import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0B14);
  static const Color surface = Color(0xFF151522);
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFFA78BFA);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color border = Color(0xFF29293B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: -2,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textSecondary,
          fontSize: 16,
          height: 1.6,
        ),
      ),
    );
  }
}
