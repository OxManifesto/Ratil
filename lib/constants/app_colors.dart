import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Brand Color - Emerald Green
  // Used for active states, toggles, play buttons, and primary icons.
  static const Color primaryBrand = Color(0xFF10B981);

  // Background Main - Standard Dark Mode Background
  // Neutral and deep. Replaces the current dark blue/charcoal background.
  static const Color backgroundMain = Color(0xFF121212);

  // Surface Card - Standard Surface Color
  // Slightly lighter than background for cards (Surah list, prayer times).
  static const Color surfaceCard = Color(0xFF1E1E1E);

  // Text Primary - Pure White
  // For main headings and verses.
  static const Color textPrimary = Color(0xFFFFFFFF);

  // Text Secondary - Light Grey
  // For subtitles, translations, and inactive text.
  static const Color textSecondary = Color(0xFFB0B0B0);

  // Accent Error - Standard Material Error color
  static const Color accentError = Color(0xFFCF6679);
}
