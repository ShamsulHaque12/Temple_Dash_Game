import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'obstacle.dart';
import '../../../../core/enums/obstacle_type.dart';

class TreeObstacle extends Obstacle {
  TreeObstacle({
    required int lane,
    required Vector2 position,
  }) : super(
          lane: lane,
          type: ObstacleType.tree,
          initialPosition: position,
          obstacleSize: Vector2(100, 45), // Overhead branch: must slide under!
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint woodPaint = Paint()..color = const Color(0xFF78350F);
    final Paint leafPaint = Paint()..color = const Color(0xFF15803D);

    // Elevated log / low branch
    final RRect logRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y * 0.7),
      const Radius.circular(8),
    );

    canvas.drawRRect(logRRect, woodPaint);
    canvas.drawCircle(Offset(size.x * 0.2, 0), 20, leafPaint);
    canvas.drawCircle(Offset(size.x * 0.8, 0), 22, leafPaint);
  }
}
