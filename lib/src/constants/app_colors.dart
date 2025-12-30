import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF00A991);
  static const Color primaryDark = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFFB2DFDB);
  
  // Secondary Palette
  static const Color secondary = Color(0xFF263238);
  static const Color accent = Color(0xFFFFC107);
  
  // Neutral Palette
  static const Color background = Color(0xFFF8FAFB);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1A1C1E);
  static const Color textMedium = Color(0xFF42474E);
  static const Color textLight = Color(0xFF72777F);
  static const Color border = Color(0xFFDDE2E9);
  
  // Semantic Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00A991), Color(0xFF00796B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1C1E), Color(0xFF263238)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
