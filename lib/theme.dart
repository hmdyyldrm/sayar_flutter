import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E88E5); // blue
  static const primaryContainer = Color(0xFFDFF1FF);
  static const secondary = Color(0xFF90CAF9);
  static const accent = Color(0xFF0D47A1);
}

class AppTheme {
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );

  static final lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      centerTitle: true,
    ),
   cardTheme: const CardThemeData(
  color: Colors.white,
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      centerTitle: true,
    ),
  );
}
