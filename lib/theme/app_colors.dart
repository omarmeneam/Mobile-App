import 'package:flutter/material.dart';

class AppColors {
  // Primary semantic colors based on the provided palette
  static const Color primary = Color(0xFFE06B85); // Darker Pink for better contrast
  static const Color secondary = Color(0xFF62B7B4); // Darker Tiffany Blue
  static const Color tertiary = Color(0xFF93D6A4); // Darker Mint
  static const Color accent = Color(0xFFFBE7C6); // Yellow

  // Functional semantic colors
  static const Color success = Color(0xFF93D6A4); // Using darker Mint for success
  static const Color warning = Color(0xFFFBE7C6); // Using Yellow for warning
  static const Color error = Color(0xFFFF6B6B); // Custom error color
  static const Color info = Color(0xFF62B7B4); // Using darker Tiffany Blue for info

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
    Color(0xFFE06B85),
    Color(0xFFF095A9),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF62B7B4),
    Color(0xFF8ACBC9),
  ];
}
