import 'package:flutter/material.dart';

enum AppThemeStyle { aurora, dune, midnight, forest, royal }

class ThemePalette {
  const ThemePalette({
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
  });

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
}

const Map<AppThemeStyle, ThemePalette> kThemePalettes = {
  AppThemeStyle.aurora: ThemePalette(
    gradients: [
      [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      [Color(0xFF1D2B64), Color(0xFF1D976C), Color(0xFF93F9B9)],
      [Color(0xFF42275A), Color(0xFF734B6D), Color(0xFFC2FFD8)],
    ],
    panelColor: Color(0x66152233),
    cardColor: Color(0x331C3A4B),
    cardBorder: Color(0x3349C5B6),
    navBackground: Color(0xAA101B2B),
    navBorder: Color(0x2249C5B6),
    navIndicator: Color(0x4449C5B6),
    accent: Color(0xFF4FFFB0),
    chipColor: Color(0x3349C5B6),
    heroHighlight: Color(0x1AFFFFFF),
  ),
  AppThemeStyle.dune: ThemePalette(
    gradients: [
      [Color(0xFFFF512F), Color(0xFFF09819), Color(0xFFED8D00)],
      [Color(0xFF8E2DE2), Color(0xFFDA4453), Color(0xFFFAD961)],
      [Color(0xFFE96443), Color(0xFF904E95), Color(0xFFFFC371)],
    ],
    panelColor: Color(0x661E0F08),
    cardColor: Color(0x33FFE0B2),
    cardBorder: Color(0x33FFD180),
    navBackground: Color(0xAAB24C14),
    navBorder: Color(0x33FFD180),
    navIndicator: Color(0x44FFAB40),
    accent: Color(0xFFFFC07F),
    chipColor: Color(0x33FFAB40),
    heroHighlight: Color(0x1AFFE0B2),
  ),
  AppThemeStyle.midnight: ThemePalette(
    gradients: [
      [Color(0xFF141E30), Color(0xFF243B55), Color(0xFF232526)],
      [Color(0xFF240B36), Color(0xFF2C5364), Color(0xFF283048)],
      [Color(0xFF000428), Color(0xFF004E92), Color(0xFF2C3E50)],
    ],
    panelColor: Color(0x66101425),
    cardColor: Color(0x3320324A),
    cardBorder: Color(0x332C82C9),
    navBackground: Color(0xAA101528),
    navBorder: Color(0x222C82C9),
    navIndicator: Color(0x442C82C9),
    accent: Color(0xFF5CC6FF),
    chipColor: Color(0x332C82C9),
    heroHighlight: Color(0x1A5CC6FF),
  ),
  AppThemeStyle.forest: ThemePalette(
    gradients: [
      [Color(0xFF0B486B), Color(0xFFF56217), Color(0xFF4ECDC4)],
      [Color(0xFF005C97), Color(0xFF363795), Color(0xFF56AB2F)],
      [Color(0xFF134E5E), Color(0xFF71B280), Color(0xFF3D7E91)],
    ],
    panelColor: Color(0x660E2A1D),
    cardColor: Color(0x333D614A),
    cardBorder: Color(0x334ED0C0),
    navBackground: Color(0xAA0F211A),
    navBorder: Color(0x224ED0C0),
    navIndicator: Color(0x444ED0C0),
    accent: Color(0xFF7EF29D),
    chipColor: Color(0x334ED0C0),
    heroHighlight: Color(0x1A7EF29D),
  ),
  AppThemeStyle.royal: ThemePalette(
    gradients: [
      [Color(0xFF240046), Color(0xFF5A189A), Color(0xFFF15BB5)],
      [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFDC830)],
      [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
    ],
    panelColor: Color(0x661A0F29),
    cardColor: Color(0x333D284B),
    cardBorder: Color(0x33F15BB5),
    navBackground: Color(0xAA1A0F29),
    navBorder: Color(0x33F15BB5),
    navIndicator: Color(0x44F15BB5),
    accent: Color(0xFFFFC857),
    chipColor: Color(0x33F15BB5),
    heroHighlight: Color(0x1AFFC857),
  ),
};

const Map<AppThemeStyle, String> kThemeNames = {
  AppThemeStyle.aurora: 'Aurora',
  AppThemeStyle.dune: 'Dune',
  AppThemeStyle.midnight: 'Midnight',
  AppThemeStyle.forest: 'Forest',
  AppThemeStyle.royal: 'Royal',
};