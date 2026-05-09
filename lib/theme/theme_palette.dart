import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ThemePalette {
  const ThemePalette({
    required this.background,
    required this.gradients,
    required this.panelColor,
    required this.cardColor,
    required this.cardBorder,
    required this.navBackground,
    required this.navBorder,
    required this.navIndicator,
    required this.accent,
    required this.chipColor,
    required this.heroHighlight,
    required this.textColor,
    required this.mutedTextColor,
  });

  final Color background;
  final List<List<Color>> gradients;
  final Color panelColor;
  final Color cardColor;
  final Color cardBorder;
  final Color navBackground;
  final Color navBorder;
  final Color navIndicator;
  final Color accent;
  final Color chipColor;
  final Color heroHighlight;
  final Color textColor;
  final Color mutedTextColor;

  static ThemePalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const ThemePalette(
        background: AppColors.backgroundMain,
        gradients: [
          [
            AppColors.backgroundMain,
            AppColors.backgroundMain,
            AppColors.backgroundMain,
          ],
          [
            AppColors.backgroundMain,
            AppColors.backgroundMain,
            AppColors.backgroundMain,
          ],
        ],
        panelColor: AppColors.surfaceCard,
        cardColor: AppColors.surfaceCard,
        cardBorder: AppColors.surfaceCard,
        navBackground: AppColors.backgroundMain,
        navBorder: AppColors.surfaceCard,
        navIndicator: AppColors.primaryBrand,
        accent: AppColors.primaryBrand,
        chipColor: AppColors.surfaceCard,
        heroHighlight: AppColors.surfaceCard,
        textColor: Colors.white,
        mutedTextColor: Color(0xFFB0B0B0),
      );
    } else {
      return const ThemePalette(
        background: Color(0xFFF5F5F5),
        gradients: [
          [Color(0xFFF5F5F5), Color(0xFFF5F5F5), Color(0xFFF5F5F5)],
          [Color(0xFFF5F5F5), Color(0xFFF5F5F5), Color(0xFFF5F5F5)],
        ],
        panelColor: Colors.white,
        cardColor: Colors.white,
        cardBorder: Color(0xFFEEEEEE),
        navBackground: Colors.white,
        navBorder: Color(0xFFEEEEEE),
        navIndicator: Color(0xFFD4AF37),
        accent: Color(0xFFD4AF37),
        chipColor: Colors.white,
        heroHighlight: Color(0xFFE0E0E0),
        textColor: Color(0xFF212121),
        mutedTextColor: Color(0xFF757575),
      );
    }
  }
}
