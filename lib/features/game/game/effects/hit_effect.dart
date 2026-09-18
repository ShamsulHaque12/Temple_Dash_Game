import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';

class HitEffect extends GameComponent {
  double lifetime = 0.25;
  double timer = 0.0;

  HitEffect({required Vector2 initialPos}) {
    position = initialPos;
    size = Vector2(80, 80);
    anchor = Anchor.center;
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
    final double scale = 1.0 + (timer / lifetime);
    final Paint p = Paint()
      ..color = Colors.redAccent.withOpacity((1.0 - timer / lifetime).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 30 * scale, p);
  }
}
