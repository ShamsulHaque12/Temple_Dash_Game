import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';

class Gem extends GameComponent {
  final int lane;
  double speed = 250.0;
  double animationTimer = 0.0;

  Gem({
    required this.lane,
    required Vector2 initialPosition,
  }) {
    position = initialPosition;
    size = Vector2(42, 42);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTimer += dt;
    position.y += speed * dt;

    if (parent != null) {
      final gameHeight = (parent as dynamic).size.y as double;
      if (position.y > gameHeight + 50) {
        destroy();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double pulse = 3 * sin(animationTimer * 8);

    // Pulsing Emerald Glow
    final Paint glowPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.5 + 0.2 * sin(animationTimer * 6))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + pulse);

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 20 + pulse, glowPaint);

    // Faceted Emerald Diamond
    final Paint mainPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFA7F3D0), Color(0xFF10B981), Color(0xFF047857)],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    final Path diamondPath = Path()
      ..moveTo(size.x / 2, 2)
      ..lineTo(size.x - 2, size.y / 2)
      ..lineTo(size.x / 2, size.y - 2)
      ..lineTo(2, size.y / 2)
      ..close();

    final Paint borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(diamondPath, mainPaint);
    canvas.drawPath(diamondPath, borderPaint);

    // Inner Specular Facet Line
    final Paint facetPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(size.x / 2, 2), Offset(size.x / 2, size.y - 2), facetPaint);
    canvas.drawLine(Offset(2, size.y / 2), Offset(size.x - 2, size.y / 2), facetPaint);
  }
}
