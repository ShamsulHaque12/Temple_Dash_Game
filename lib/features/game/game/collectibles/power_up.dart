import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';

enum PowerUpType { magnet, shield, multiplier }

class PowerUp extends GameComponent {
  final int lane;
  final PowerUpType powerUpType;
  double speed = 250.0;
  double animationTimer = 0.0;

  PowerUp({
    required this.lane,
    required this.powerUpType,
    required Vector2 initialPosition,
  }) {
    position = initialPosition;
    size = Vector2(45, 45);
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

    Color bg;
    IconData icon;

    switch (powerUpType) {
      case PowerUpType.magnet:
        bg = Colors.blueAccent;
        icon = Icons.grid_view_rounded;
        break;
      case PowerUpType.shield:
        bg = Colors.purpleAccent;
        icon = Icons.security;
        break;
      case PowerUpType.multiplier:
        bg = Colors.amberAccent;
        icon = Icons.bolt;
        break;
    }

    final Paint bgPaint = Paint()..color = bg;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, bgPaint);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, borderPaint);

    TextPainter tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(size.x / 2 - tp.width / 2, size.y / 2 - tp.height / 2));
  }
}
