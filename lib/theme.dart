// lib/theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryContainer = Color(0xFFDFF1FF);
  static const Color secondary = Color(0xFF90CAF9);
  static const Color accent = Color(0xFF0D47A1);
}

class AppTheme {
  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );

  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: lightScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: lightScheme.primary,
      foregroundColor: lightScheme.onPrimary,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: darkScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: darkScheme.primary,
      foregroundColor: darkScheme.onPrimary,
      centerTitle: true,
    ),
  );
}
