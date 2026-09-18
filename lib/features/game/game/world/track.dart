import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../../../../core/constants/game_constants.dart';

class Track extends PositionComponent {
  double scrollOffset = 0.0;
  double speed = GameConstants.initialSpeed;
  double animationTimer = 0.0;

  Track() {
    anchor = Anchor.topLeft;
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTimer += dt;
    scrollOffset = (scrollOffset + speed * dt) % 120.0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double screenW = size.x;
    final double screenH = size.y;
    final double centerLaneX = screenW / 2;

    // 1. Dark Ancient Stone Base
    final Paint trackBgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1E293B), Color(0xFF0F172A), Color(0xFF1E293B)],
      ).createShader(Rect.fromLTWH(0, 0, screenW, screenH));

    final Rect trackRect = Rect.fromLTRB(
      centerLaneX - GameConstants.laneOffset * 1.6,
      0,
      centerLaneX + GameConstants.laneOffset * 1.6,
      screenH,
    );
    canvas.drawRect(trackRect, trackBgPaint);

    // 2. Horizontal Stone Tile Joint Lines (Scrolling)
    final Paint jointPaint = Paint()
      ..color = const Color(0xFF090D16).withValues(alpha: 0.8)
      ..strokeWidth = 4.0;

    for (double y = -120 + scrollOffset; y < screenH; y += 60) {
      canvas.drawLine(
        Offset(centerLaneX - GameConstants.laneOffset * 1.6, y),
        Offset(centerLaneX + GameConstants.laneOffset * 1.6, y),
        jointPaint,
      );
    }

    // 3. Lane Dividers - Glowing Ancient Gold Runes/Lines
    final Paint lineGlowPaint = Paint()
      ..color = const Color(0xFFFFB703).withValues(alpha: 0.3)
      ..strokeWidth = 10.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final Paint linePaint = Paint()
      ..color = const Color(0xFFFFB703).withValues(alpha: 0.9)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final double leftDividerX = centerLaneX - GameConstants.laneOffset * 0.5;
    final double rightDividerX = centerLaneX + GameConstants.laneOffset * 0.5;

    for (double y = -120 + scrollOffset; y < screenH; y += 90) {
      // Glow background
      canvas.drawLine(Offset(leftDividerX, y), Offset(leftDividerX, y + 50), lineGlowPaint);
      canvas.drawLine(Offset(rightDividerX, y), Offset(rightDividerX, y + 50), lineGlowPaint);

      // Main line
      canvas.drawLine(Offset(leftDividerX, y), Offset(leftDividerX, y + 50), linePaint);
      canvas.drawLine(Offset(rightDividerX, y), Offset(rightDividerX, y + 50), linePaint);
    }

    // 4. Ancient Carved Temple Border Walls
    final double leftBorderX = centerLaneX - GameConstants.laneOffset * 1.6;
    final double rightBorderX = centerLaneX + GameConstants.laneOffset * 1.6;

    final Paint wallPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF334155), Color(0xFF1E293B)],
      ).createShader(Rect.fromLTWH(0, 0, screenW, screenH));

    final Paint wallBorderPaint = Paint()
      ..color = const Color(0xFFFB8500)
      ..strokeWidth = 3.0;

    // Left wall pillar line
    canvas.drawRect(Rect.fromLTWH(leftBorderX - 16, 0, 16, screenH), wallPaint);
    canvas.drawLine(Offset(leftBorderX, 0), Offset(leftBorderX, screenH), wallBorderPaint);

    // Right wall pillar line
    canvas.drawRect(Rect.fromLTWH(rightBorderX, 0, 16, screenH), wallPaint);
    canvas.drawLine(Offset(rightBorderX, 0), Offset(rightBorderX, screenH), wallBorderPaint);

    // 5. Runic Carvings on Walls
    final Paint runePaint = Paint()
      ..color = const Color(0xFFFB8500).withValues(alpha: 0.4 + 0.2 * sin(animationTimer * 3));

    for (double y = -120 + scrollOffset; y < screenH; y += 180) {
      canvas.drawCircle(Offset(leftBorderX - 8, y + 30), 4, runePaint);
      canvas.drawCircle(Offset(rightBorderX + 8, y + 30), 4, runePaint);
    }
  }
}
