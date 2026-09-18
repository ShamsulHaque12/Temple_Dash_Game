import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';

class DustEffect extends GameComponent {
  double lifetime = 0.3;
  double timer = 0.0;

  DustEffect({required Vector2 initialPos}) {
    position = initialPos;
    size = Vector2(30, 20);
    anchor = Anchor.bottomCenter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    if (timer >= lifetime) {
      destroy();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final double opacity = (1.0 - (timer / lifetime)).clamp(0.0, 1.0);
    final Paint p = Paint()..color = const Color(0xFF94A3B8).withOpacity(opacity * 0.6);
    canvas.drawCircle(Offset(size.x * 0.3, size.y / 2), 10 * (1 + timer), p);
    canvas.drawCircle(Offset(size.x * 0.7, size.y / 2), 12 * (1 + timer), p);
  }
}
