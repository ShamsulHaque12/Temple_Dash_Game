import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'obstacle.dart';
import '../../../../core/enums/obstacle_type.dart';

class RockObstacle extends Obstacle {
  RockObstacle({
    required int lane,
    required Vector2 position,
  }) : super(
          lane: lane,
          type: ObstacleType.rock,
          initialPosition: position,
          obstacleSize: Vector2(70, 70),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint rockPaint = Paint()..color = const Color(0xFF64748B);
    final Paint shadowPaint = Paint()..color = const Color(0xFF334155);
    final Paint highlightPaint = Paint()..color = const Color(0xFF94A3B8);

    final RRect rockRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(16),
    );

    canvas.drawRRect(rockRRect, rockPaint);

    // Cracks & Details
    canvas.drawRect(
      Rect.fromLTWH(10, 10, size.x * 0.4, size.y * 0.4),
      highlightPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.x * 0.5, size.y * 0.5, size.x * 0.4, size.y * 0.4),
      shadowPaint,
    );
  }
}
