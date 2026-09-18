import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Environment extends PositionComponent {
  double animationTimer = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    animationTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double screenW = size.x;
    final double screenH = size.y;

    // Deep Jungle & Ancient Temple Side Ruins Gradient Background
    final Paint leftJunglePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF022C22), Color(0xFF064E3B), Color(0xFF0F172A)],
      ).createShader(Rect.fromLTWH(0, 0, screenW * 0.2, screenH));

    final Paint rightJunglePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF064E3B), Color(0xFF022C22)],
      ).createShader(Rect.fromLTWH(screenW * 0.8, 0, screenW * 0.2, screenH));

    // Draw jungle sides
    canvas.drawRect(Rect.fromLTWH(0, 0, screenW * 0.2, screenH), leftJunglePaint);
    canvas.drawRect(Rect.fromLTWH(screenW * 0.8, 0, screenW * 0.2, screenH), rightJunglePaint);

    // Dynamic Torch Braziers on Temple Side Pillars
    final double torchY1 = screenH * 0.2;
    final double torchY2 = screenH * 0.6;
    final double torchY3 = screenH * 0.9;

    _drawTorchBrazier(canvas, Offset(screenW * 0.15, torchY1));
    _drawTorchBrazier(canvas, Offset(screenW * 0.85, torchY1));

    _drawTorchBrazier(canvas, Offset(screenW * 0.15, torchY2));
    _drawTorchBrazier(canvas, Offset(screenW * 0.85, torchY2));

    _drawTorchBrazier(canvas, Offset(screenW * 0.15, torchY3));
    _drawTorchBrazier(canvas, Offset(screenW * 0.85, torchY3));
  }

  void _drawTorchBrazier(Canvas canvas, Offset pos) {
    final double flicker = 4 * sin(animationTimer * 12 + pos.dy);
    final double flickerRadius = 35 + flicker;

    // Ambient Torch Glow
    final Paint glowPaint = Paint()
      ..color = const Color(0xFFFB8500).withValues(alpha: 0.35 + 0.1 * sin(animationTimer * 8))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, flickerRadius);

    canvas.drawCircle(pos, flickerRadius, glowPaint);

    // Stone Brazier Holder
    final Paint brazierPaint = Paint()..color = const Color(0xFF1E293B);
    final RRect holder = RRect.fromRectAndRadius(
      Rect.fromCenter(center: pos + const Offset(0, 10), width: 24, height: 18),
      const Radius.circular(4),
    );
    canvas.drawRRect(holder, brazierPaint);

    // Flame Core
    final Paint outerFlame = Paint()..color = const Color(0xFFEF4444);
    final Paint innerFlame = Paint()..color = const Color(0xFFFFB703);
    final Paint coreFlame = Paint()..color = const Color(0xFFFEF08A);

    final Path flamePath = Path()
      ..moveTo(pos.dx - 10, pos.dy + 4)
      ..quadraticBezierTo(pos.dx - 12 + flicker, pos.dy - 12, pos.dx, pos.dy - 28 + flicker)
      ..quadraticBezierTo(pos.dx + 12 - flicker, pos.dy - 12, pos.dx + 10, pos.dy + 4)
      ..close();

    canvas.drawPath(flamePath, outerFlame);
    canvas.drawCircle(pos - const Offset(0, 6), 7, innerFlame);
    canvas.drawCircle(pos - const Offset(0, 4), 4, coreFlame);
  }
}
