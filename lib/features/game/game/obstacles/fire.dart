import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'obstacle.dart';
import '../../../../core/enums/obstacle_type.dart';

class FireObstacle extends Obstacle {
  double animationTimer = 0.0;

  FireObstacle({
    required int lane,
    required Vector2 position,
  }) : super(
          lane: lane,
          type: ObstacleType.fire,
          initialPosition: position,
          obstacleSize: Vector2(80, 50),
        );

  @override
  void update(double dt) {
    super.update(dt);
    animationTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint outerFire = Paint()
      ..color = const Color(0xFFEF4444)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final Paint innerFire = Paint()..color = const Color(0xFFF59E0B);
    final Paint coreFire = Paint()..color = const Color(0xFFFEF08A);

    final double flicker = 5 * (animationTimer % 0.2);

    // Flames geometry
    final Path path = Path()
      ..moveTo(0, size.y)
      ..quadraticBezierTo(size.x * 0.25, -flicker, size.x * 0.5, size.y * 0.3)
      ..quadraticBezierTo(size.x * 0.75, -10 - flicker, size.x, size.y)
      ..close();

    canvas.drawPath(path, outerFire);
    canvas.drawPath(path, innerFire);
    canvas.drawCircle(Offset(size.x / 2, size.y * 0.6), 15, coreFire);
  }
}
