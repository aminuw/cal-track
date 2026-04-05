import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:math';

class MacrosCircularProgress extends StatelessWidget {
  final String label;
  final int current;
  final int target;
  final Color color;

  const MacrosCircularProgress({
    super.key,
    required this.label,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Calcul du pourcentage (max 1.0)
    final double percentage = target > 0 ? (current / target).clamp(0.0, 1.0) : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: _NeonCircularPainter(
              percentage: percentage,
              color: color,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$current',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '/$target',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _NeonCircularPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _NeonCircularPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 4; // -4 pour l'épaisseur du trait

    // Pinceau d'arrière-plan
    final bgPaint = Paint()
      ..color = AppTheme.surfaceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawCircle(center, radius, bgPaint);

    // Pinceau de progression (Glow/Neon)
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      // Optionnel: effet glow. Pour les perfs en mobile, à utiliser avec modération.
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3.0);

    // Démarrage à -pi/2 (en haut)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percentage,
      false, // ne pas remplir le centre
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NeonCircularPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
