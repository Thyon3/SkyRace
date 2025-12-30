import 'package:flutter/material.dart';
import 'app_colors.dart';

class DesignSystem {
  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Border Radius
  static BorderRadius radiusSmall = BorderRadius.circular(8);
  static BorderRadius radiusMedium = BorderRadius.circular(16);
  static BorderRadius radiusLarge = BorderRadius.circular(24);
  static BorderRadius radiusFull = BorderRadius.circular(100);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Text Styles
  static TextStyle heading1 = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static TextStyle heading2 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    color: AppColors.textMedium,
  );

  static TextStyle caption = const TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
  );
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: DesignSystem.radiusMedium,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: DesignSystem.radiusMedium,
        child: child,
      ),
    );
  }
}
