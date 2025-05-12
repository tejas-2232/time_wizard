import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const primary = Color(0xFF0A84FF);
  static const primaryLight = Color(0xFF64D2FF);
  static const primaryDark = Color(0xFF0040DD);
  
  // Secondary colors
  static const secondary = Color(0xFF00C7BE);
  static const secondaryLight = Color(0xFF66EDE5);
  static const secondaryDark = Color(0xFF00958E);
  
  // Accent colors
  static const accent = Color(0xFFFF9500);
  static const accentLight = Color(0xFFFFD60A);
  static const accentDark = Color(0xFFFF3B30);
  
  // Neutral colors
  static const neutral900 = Color(0xFF1C1C1E);
  static const neutral800 = Color(0xFF2C2C2E);
  static const neutral700 = Color(0xFF3A3A3C);
  static const neutral600 = Color(0xFF48484A);
  static const neutral500 = Color(0xFF636366);
  static const neutral400 = Color(0xFF8E8E93);
  static const neutral300 = Color(0xFFAEAEB2);
  static const neutral200 = Color(0xFFC7C7CC);
  static const neutral100 = Color(0xFFE5E5EA);
  static const neutral50 = Color(0xFFF2F2F7);
  
  // Semantic colors
  static const success = Color(0xFF34C759);
  static const warning = Color(0xFFFF9500);
  static const error = Color(0xFFFF3B30);
  static const info = Color(0xFF5AC8FA);
}

class AppTheme {
  static const _fontFamily = 'SF Pro Display';
  
  static final _baseTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
    ),
  );
  
  static final lightTheme = _baseTheme.copyWith(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.neutral50,
      surface: Colors.white,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.neutral50,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.neutral900,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: AppColors.neutral900.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.neutral900,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.neutral900,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral900,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral900,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.neutral900,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.neutral800,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.neutral800,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.neutral900,
      ),
    ),
  );
  
  static final darkTheme = _baseTheme.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.neutral900,
      surface: AppColors.neutral800,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.neutral900,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.neutral800,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.neutral800,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.neutral100,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.neutral100,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}