import 'package:flame/components.dart';

abstract class GameComponent extends PositionComponent {
  bool isDestroyed = false;

  void destroy() {
    isDestroyed = true;
    removeFromParent();
  }
}
