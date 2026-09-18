import 'package:flame/components.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/utils/random_utils.dart';
import '../obstacles/obstacle.dart';
import '../obstacles/rock.dart';
import '../obstacles/fire.dart';
import '../obstacles/tree.dart';
import '../collectibles/coin.dart';
import '../collectibles/gem.dart';
import '../collectibles/power_up.dart';

class SpawnSystem {
  double obstacleSpawnTimer = 0.0;
  double itemSpawnTimer = 0.0;

  final double obstacleInterval = 1.6;
  final double itemInterval = 0.9;

  void update(
    double dt,
    Vector2 screenSize,
    double currentSpeed,
    Function(Obstacle) onSpawnObstacle,
    Function(PositionComponent) onSpawnCollectible,
  ) {
    obstacleSpawnTimer += dt;
    itemSpawnTimer += dt;

    final double centerLaneX = screenSize.x / 2;

    // Obstacle Spawner
    if (obstacleSpawnTimer >= obstacleInterval) {
      obstacleSpawnTimer = 0.0;
      final int lane = RandomUtils.getInt(0, 2);
      final double posX = centerLaneX + (lane - 1) * GameConstants.laneOffset;
      final Vector2 pos = Vector2(posX, -60);

      final int typeIndex = RandomUtils.getInt(0, 2);
      Obstacle obstacle;
      if (typeIndex == 0) {
        obstacle = RockObstacle(lane: lane, position: pos);
      } else if (typeIndex == 1) {
        obstacle = FireObstacle(lane: lane, position: pos);
      } else {
        obstacle = TreeObstacle(lane: lane, position: pos);
      }
      obstacle.speed = currentSpeed;
      onSpawnObstacle(obstacle);
    }

    // Collectible Spawner (Coins, Gems, Power-ups)
    if (itemSpawnTimer >= itemInterval) {
      itemSpawnTimer = 0.0;
      final int lane = RandomUtils.getInt(0, 2);
      final double posX = centerLaneX + (lane - 1) * GameConstants.laneOffset;
      final Vector2 pos = Vector2(posX, -40);

      final double rand = RandomUtils.getDouble(0, 1);
      if (rand < 0.7) {
        for (int i = 0; i < 3; i++) {
          final coin = Coin(
            lane: lane,
            initialPosition: Vector2(posX, -40 - (i * 45.0)),
          );
          coin.speed = currentSpeed;
          onSpawnCollectible(coin);
        }
      } else if (rand < 0.9) {
        final gem = Gem(lane: lane, initialPosition: pos);
        gem.speed = currentSpeed;
        onSpawnCollectible(gem);
      } else {
        final pType = PowerUpType.values[RandomUtils.getInt(0, 2)];
        final pUp = PowerUp(
          lane: lane,
          powerUpType: pType,
          initialPosition: pos,
        );
        pUp.speed = currentSpeed;
        onSpawnCollectible(pUp);
      }
    }
  }

  void reset() {
    obstacleSpawnTimer = 0.0;
    itemSpawnTimer = 0.0;
  }
}
