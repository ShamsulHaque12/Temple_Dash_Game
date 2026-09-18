import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../controllers/game_controller.dart';
import 'player/player.dart';
import 'world/game_world.dart';
import 'obstacles/obstacle.dart';
import 'collectibles/coin.dart';
import 'collectibles/gem.dart';
import 'collectibles/power_up.dart';
import 'enemies/temple_guard.dart';
import 'effects/coin_effect.dart';
import 'effects/hit_effect.dart';
import 'systems/spawn_system.dart';
import 'systems/collision_system.dart';
import 'systems/difficulty_system.dart';
import 'systems/score_system.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/enums/game_state.dart';

class TempleDashGame extends FlameGame with DragCallbacks, TapCallbacks {
  final GameController gameController;

  final GameWorld gameWorld = GameWorld();
  final Player player = Player();
  final TempleGuard templeGuard = TempleGuard();

  final SpawnSystem spawnSystem = SpawnSystem();
  final DifficultySystem difficultySystem = DifficultySystem();
  final ScoreSystem scoreSystem = ScoreSystem();

  final List<Obstacle> obstacles = [];
  final List<PositionComponent> collectibles = [];

  double powerUpDurationTimer = 0.0;

  TempleDashGame({required this.gameController});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(gameWorld);
    await add(player);
    await add(templeGuard);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    gameWorld.updateSize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameController.gameState.value != GameState.playing) return;

    // 1. Difficulty & Speed update
    difficultySystem.update(dt);
    gameWorld.setSpeed(difficultySystem.currentSpeed);

    // 2. Score update
    scoreSystem.updateScore(
      difficultySystem.distanceTraveled,
      isMultiplierActive: player.isMultiplierActive,
    );

    gameController.currentScore.value = scoreSystem.currentScore;
    gameController.distanceRan.value = difficultySystem.distanceTraveled;
    gameController.coinsCollected.value = scoreSystem.coins;
    gameController.gemsCollected.value = scoreSystem.gems;

    // 3. Power-Up timer logic
    if (player.isShielded ||
        player.isMagnetActive ||
        player.isMultiplierActive) {
      powerUpDurationTimer -= dt;
      gameController.powerUpTimer.value = powerUpDurationTimer;
      if (powerUpDurationTimer <= 0) {
        player.isShielded = false;
        player.isMagnetActive = false;
        player.isMultiplierActive = false;
        gameController.activePowerUp.value = '';
      }
    }

    // 4. Update Enemy Temple Guard positioning
    templeGuard.updatePosition(
      player.position.x,
      size.y * 0.75,
      size.y,
    );

    // 5. Spawning system
    spawnSystem.update(
      dt,
      size,
      difficultySystem.currentSpeed,
      (obs) {
        obstacles.add(obs);
        add(obs);
      },
      (item) {
        collectibles.add(item);
        add(item);
      },
    );

    // 6. Collision checking for Obstacles
    final List<Obstacle> hitObstacles = [];
    for (final obs in obstacles) {
      if (CollisionSystem.checkPlayerObstacleCollision(player, obs)) {
        hitObstacles.add(obs);
      }
    }

    for (final obs in hitObstacles) {
      obstacles.remove(obs);
      obs.removeFromParent();

      if (player.isShielded) {
        player.isShielded = false;
        gameController.activePowerUp.value = '';
        add(HitEffect(initialPos: player.position.clone()));
      } else {
        add(HitEffect(initialPos: player.position.clone()));
        gameController.audioService.playSfx(AssetConstants.sfxHit);

        if (!templeGuard.isAlerted) {
          templeGuard.isAlerted = true;
        } else {
          // Double hit = Game Over!
          gameController.onGameOver();
        }
      }
    }

    // 7. Collision checking for Collectibles
    final List<PositionComponent> collectedItems = [];
    for (final item in collectibles) {
      if (CollisionSystem.checkCollectibleCollision(player, item)) {
        collectedItems.add(item);
      }
    }

    for (final item in collectedItems) {
      collectibles.remove(item);
      item.removeFromParent();

      if (item is Coin) {
        scoreSystem.addCoin();
        add(CoinEffect(initialPos: item.position.clone()));
        gameController.audioService.playSfx(AssetConstants.sfxCoin);
      } else if (item is Gem) {
        scoreSystem.addGem();
        add(CoinEffect(initialPos: item.position.clone()));
        gameController.audioService.playSfx(AssetConstants.sfxCoin);
      } else if (item is PowerUp) {
        gameController.audioService.playSfx(AssetConstants.sfxPowerup);
        powerUpDurationTimer = 8.0;

        if (item.powerUpType == PowerUpType.shield) {
          player.isShielded = true;
          gameController.activePowerUp.value = 'Shield';
        } else if (item.powerUpType == PowerUpType.magnet) {
          player.isMagnetActive = true;
          gameController.activePowerUp.value = 'Magnet';
        } else if (item.powerUpType == PowerUpType.multiplier) {
          player.isMultiplierActive = true;
          gameController.activePowerUp.value = '2X Score';
        }
      }
    }
  }

  // Swipe Gesture Handling
  Vector2 _dragDelta = Vector2.zero();

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragDelta = Vector2.zero();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragDelta = Vector2.zero();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _dragDelta += event.localDelta;

    if (_dragDelta.length > 30) {
      if (_dragDelta.x.abs() > _dragDelta.y.abs()) {
        if (_dragDelta.x > 0) {
          player.moveRight();
          gameController.audioService.playSfx(AssetConstants.sfxSlide);
        } else {
          player.moveLeft();
          gameController.audioService.playSfx(AssetConstants.sfxSlide);
        }
      } else {
        if (_dragDelta.y < 0) {
          player.jump();
          gameController.audioService.playSfx(AssetConstants.sfxJump);
        } else {
          player.slide();
          gameController.audioService.playSfx(AssetConstants.sfxSlide);
        }
      }
      _dragDelta = Vector2.zero();
    }
  }

  void resetGame() {
    for (final obs in obstacles) {
      obs.removeFromParent();
    }
    for (final item in collectibles) {
      item.removeFromParent();
    }
    obstacles.clear();
    collectibles.clear();

    spawnSystem.reset();
    difficultySystem.reset();
    scoreSystem.reset();
    player.reset();
    templeGuard.isAlerted = false;
    powerUpDurationTimer = 0.0;
  }
}
