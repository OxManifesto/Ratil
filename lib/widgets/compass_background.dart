import 'package:flutter/material.dart';

class CompassBackground extends StatelessWidget {
  const CompassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.black.withValues(alpha: 0.3),
          ],
        ),
        border: Border.all(color: Colors.white24),
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
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
