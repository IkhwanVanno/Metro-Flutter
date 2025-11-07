import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF9D2503);
  static const Color secondary = Color(0xFFDF8543);
  static const Color accent = Color(0xFF7FA998);
  static const Color light = Color(0xFFF1F1B0);

  // Tambahan umum
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color red = Colors.red;
  static const Color yellow = Color(0xFFFFC50F);
  static const Color orange = Colors.orange;
  static const Color green = Colors.green;
  static const Color blue = Colors.blue;
  static const Color purple = Colors.purple;
  static const Color transparent = Colors.transparent;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,

      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        error: AppColors.red,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.black,
      ),
    );
  }
}
