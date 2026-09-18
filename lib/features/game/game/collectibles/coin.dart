import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';

class Coin extends GameComponent {
  final int lane;
  double speed = 250.0;
  double spinTimer = 0.0;

  Coin({
    required this.lane,
    required Vector2 initialPosition,
  }) {
    position = initialPosition;
    size = Vector2(36, 36);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    spinTimer += dt * 6;
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

    // 3D Coin Horizontal Spin compression effect
    final double widthScale = (0.2 + 0.8 * (1.0 + sin(spinTimer)).abs() / 2.0).clamp(0.2, 1.0);

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.scale(widthScale, 1.0);

    // Drop Shadow
    final Paint shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(const Offset(0, 3), size.x / 2, shadow);

    // Outer Metallic Gold Gradient
    final Paint coinGradient = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFF066), Color(0xFFFFB703), Color(0xFFB45309)],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: size.x / 2));

    final Paint borderPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final Paint innerRing = Paint()
      ..color = const Color(0xFFFFF066)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset.zero, size.x / 2, coinGradient);
    canvas.drawCircle(Offset.zero, size.x / 2, borderPaint);
    canvas.drawCircle(Offset.zero, size.x / 2 - 4, innerRing);

    // Center $ Symbol
    TextPainter tp = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
          color: Color(0xFF78350F),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

    canvas.restore();
  }
}
