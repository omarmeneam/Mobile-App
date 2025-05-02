import 'package:flutter/material.dart';

class AppColors {
  // Primary semantic colors based on the provided palette
  static const Color primary = Color(0xFFFFAEBC); // Hot Pink
  static const Color secondary = Color(0xFFA0E7E5); // Tiffany Blue
  static const Color tertiary = Color(0xFFB4F8C8); // Mint
  static const Color accent = Color(0xFFFBE7C6); // Yellow

  // Functional semantic colors
  static const Color success = Color(0xFFB4F8C8); // Using Mint for success
  static const Color warning = Color(0xFFFBE7C6); // Using Yellow for warning
  static const Color error = Color(0xFFFF6B6B); // Custom error color
  static const Color info = Color(0xFFA0E7E5); // Using Tiffany Blue for info

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Background colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color backgroundTertiary = Color(0xFFEEEEEE);

  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);

  // Overlay colors
  static const Color overlay = Color(0x80000000);
  
  // Status colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFFBDBDBD);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFFFFAEBC),
    Color(0xFFFFC3CF),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFFA0E7E5),
    Color(0xFFBFF0EF),
  ];
}
