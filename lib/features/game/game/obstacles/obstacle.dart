import 'package:flame/components.dart';
import '../components/game_component.dart';
import '../../../../core/enums/obstacle_type.dart';

abstract class Obstacle extends GameComponent {
  final int lane; // 0, 1, 2
  final ObstacleType type;
  double speed = 250.0;

  Obstacle({
    required this.lane,
    required this.type,
    required Vector2 initialPosition,
    required Vector2 obstacleSize,
  }) {
    position = initialPosition;
    size = obstacleSize;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (parent != null) {
      final gameHeight = (parent as dynamic).size.y as double;
      if (position.y > gameHeight + 100) {
        destroy();
      }
    }
  }
}
