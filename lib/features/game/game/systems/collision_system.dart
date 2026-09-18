import 'dart:ui';
import 'package:flame/components.dart';
import '../player/player.dart';
import '../obstacles/obstacle.dart';
import '../obstacles/tree.dart';
import '../obstacles/fire.dart';
import '../collectibles/coin.dart';
import '../../../../core/enums/player_state.dart';

class CollisionSystem {
  static bool checkPlayerObstacleCollision(Player player, Obstacle obstacle) {
    if (obstacle is TreeObstacle) {
      if (player.playerState == PlayerState.sliding) {
        return false;
      }
    } else if (obstacle is FireObstacle) {
      if (player.playerState == PlayerState.jumping) {
        return false;
      }
    }

    final Rect playerRect = player.toRect();
    final Rect obstacleRect = obstacle.toRect();

    final Rect shrunkPlayer = playerRect.deflate(10);
    final Rect shrunkObstacle = obstacleRect.deflate(10);

    return shrunkPlayer.overlaps(shrunkObstacle);
  }

  static bool checkCollectibleCollision(Player player, PositionComponent item) {
    final Rect playerRect = player.toRect();
    final Rect itemRect = item.toRect();

    if (player.isMagnetActive && item is Coin) {
      final double dist = (player.position - item.position).length;
      if (dist < 250) {
        item.position += (player.position - item.position).normalized() * 400 * 0.016;
      }
    }

    return playerRect.overlaps(itemRect);
  }
}
