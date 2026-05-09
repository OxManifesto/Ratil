import 'package:flutter/material.dart';
import '../theme/theme_palette.dart';

class CompassBackground extends StatelessWidget {
  const CompassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [palette.cardColor, palette.background],
        ),
        border: Border.all(
          color: palette.mutedTextColor.withValues(alpha: 0.1),
        ),
      ),
      child: const Stack(
        children: [
          CardinalLabel(label: 'N', alignment: Alignment.topCenter),
          CardinalLabel(label: 'S', alignment: Alignment.bottomCenter),
          CardinalLabel(label: 'E', alignment: Alignment.centerRight),
          CardinalLabel(label: 'W', alignment: Alignment.centerLeft),
        ],
      ),
    );
  }
}

class CardinalLabel extends StatelessWidget {
  const CardinalLabel({
    super.key,
    required this.label,
    required this.alignment,
  });

  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: palette.mutedTextColor,
          ),
        ),
      ),
    );
  }
}
