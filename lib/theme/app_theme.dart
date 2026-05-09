import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Core Colors
    final Color background = isDark
        ? AppColors.backgroundMain
        : const Color(0xFFF5F5F5);
    final Color accent = isDark
        ? AppColors.primaryBrand
        : const Color(0xFFD4AF37);
    final Color surface = isDark ? AppColors.surfaceCard : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF212121);
    final Color mutedTextColor = isDark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF757575);
    final Color cardBorder = isDark
        ? AppColors.surfaceCard
        : const Color(0xFFEEEEEE);

    final baseText = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme
        .apply(
          bodyColor: textColor,
          displayColor: textColor,
          fontFamily: 'Noto Sans',
        );

    final TextTheme compactText = baseText.copyWith(
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontSize: 14,
        height: 1.4,
        color: textColor,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontSize: 13,
        height: 1.4,
        color: textColor,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontSize: 12,
        height: 1.4,
        color: mutedTextColor,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: baseText.labelMedium?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: baseText.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      scaffoldBackgroundColor: background,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: accent,
              secondary: accent.withValues(alpha: 0.9),
              surface: surface,
              onPrimary: background,
              onSecondary: background,
              onSurface: textColor,
              error: AppColors.accentError,
              onError: background,
            )
          : ColorScheme.light(
              primary: accent,
              secondary: accent.withValues(alpha: 0.9),
              surface: surface,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: textColor,
              error: AppColors.accentError,
              onError: Colors.white,
            ),
      textTheme: compactText,
      iconTheme: IconThemeData(color: textColor),
      dividerTheme: DividerThemeData(
        color: cardBorder.withValues(alpha: 0.6),
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 0 : 2,
        margin: EdgeInsets.zero,
        shadowColor: isDark ? Colors.transparent : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardBorder),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        iconColor: textColor,
        textColor: textColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        minVerticalPadding: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: mutedTextColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textColor,
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.all(3),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: accent,
        iconTheme: WidgetStatePropertyAll(IconThemeData(color: textColor)),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: isDark ? background : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: accent),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
      fontFamily: 'Noto Sans',
      fontFamilyFallback: const ['Noto Serif', 'Georgia'],
    );
  }

  static ThemeData get darkTheme => buildTheme(Brightness.dark);
  static ThemeData get lightTheme => buildTheme(Brightness.light);
}
