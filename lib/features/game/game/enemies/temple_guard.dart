import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/animated_component.dart';

class TempleGuard extends AnimatedComponent {
  double targetY = 0.0;
  double currentY = 0.0;
  double currentX = 0.0;
  double targetX = 0.0;
  
  bool isAlerted = false; // Moves close behind player when player hits an obstacle

  TempleGuard() {
    size = Vector2(90, 120);
    anchor = Anchor.center;
  }

  void updatePosition(double playerX, double groundY, double screenH) {
    targetX = playerX;
    targetY = isAlerted ? groundY + 40 : screenH + 80; // Follows right behind when alerted, else hides below screen
  }

  @override
  void update(double dt) {
    super.update(dt);
    currentX += (targetX - currentX) * (10.0 * dt).clamp(0.0, 1.0);
    currentY += (targetY - currentY) * (5.0 * dt).clamp(0.0, 1.0);
    position = Vector2(currentX, currentY);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint monsterPaint = Paint()..color = const Color(0xFF881337);
    final Paint eyePaint = Paint()..color = Colors.yellowAccent;
    final Paint shadowPaint = Paint()..color = Colors.black.withOpacity(0.5);

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y - 10),
        width: size.x * 0.8,
        height: 20,
      ),
      shadowPaint,
    );

    // Beast Body
    final Path monsterPath = Path()
      ..moveTo(size.x * 0.2, size.y * 0.8)
      ..quadraticBezierTo(0, size.y * 0.4, size.x * 0.2, size.y * 0.1)
      ..quadraticBezierTo(size.x * 0.5, -10, size.x * 0.8, size.y * 0.1)
      ..quadraticBezierTo(size.x, size.y * 0.4, size.x * 0.8, size.y * 0.8)
      ..close();

    canvas.drawPath(monsterPath, monsterPaint);

    // Glowing Eyes
    canvas.drawCircle(Offset(size.x * 0.35, size.y * 0.35), 8, eyePaint);
    canvas.drawCircle(Offset(size.x * 0.65, size.y * 0.35), 8, eyePaint);
  }
}
