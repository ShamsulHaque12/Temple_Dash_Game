import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';

class CoinEffect extends GameComponent {
  double lifetime = 0.4;
  double timer = 0.0;

  CoinEffect({required Vector2 initialPos}) {
    position = initialPos;
    size = Vector2(40, 40);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    position.y -= 60 * dt; // Float up
    if (timer >= lifetime) {
      destroy();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final double opacity = (1.0 - (timer / lifetime)).clamp(0.0, 1.0);
    final Paint p = Paint()..color = Colors.amberAccent.withOpacity(opacity);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * (0.5 + timer), p);
  }
}
