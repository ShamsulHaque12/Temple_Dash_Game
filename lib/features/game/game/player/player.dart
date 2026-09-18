import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import '../components/game_component.dart';
import 'player_movement.dart';
import 'player_animation.dart';
import '../../../../core/enums/player_state.dart';

class Player extends GameComponent {
  final PlayerMovement movement = PlayerMovement();
  final PlayerAnimation animation = PlayerAnimation();

  ui.Image? player3dSprite;

  bool isShielded = false;
  bool isMagnetActive = false;
  bool isMultiplierActive = false;

  Player() {
    size = Vector2(75, 115);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      player3dSprite = await Flame.images.load('player_3d.png');
    } catch (_) {
      // Graceful fallback if image asset is loading
    }
  }

  void moveLeft() => movement.moveLeft();
  void moveRight() => movement.moveRight();
  void jump() => movement.jump();
  void slide() => movement.slide();

  PlayerState get playerState => movement.state;

  @override
  void update(double dt) {
    super.update(dt);
    if (parent == null) return;

    final gameSize = (parent as dynamic).size as Vector2;
    movement.update(dt, gameSize.x);

    animation.update(
      dt,
      currentX: movement.currentX,
      targetX: movement.targetX,
    );

    // Update position with vertical jump offset
    final double groundY = gameSize.y * 0.75;
    position = Vector2(
      movement.currentX,
      groundY - (movement.verticalOffset),
    );

    // Bounding box size during slide vs run
    if (movement.state == PlayerState.sliding) {
      size = Vector2(75, 65);
    } else {
      size = Vector2(75, 115);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    String activePUp = '';
    if (isShielded) activePUp = 'Shield';
    if (isMagnetActive) activePUp = 'Magnet';
    if (isMultiplierActive) activePUp = '2X Score';

    animation.renderPlayerCanvas(
      canvas,
      Size(size.x, size.y),
      movement.state,
      isShielded,
      activePowerUp: activePUp,
      sprite3d: player3dSprite,
    );
  }

  void reset() {
    movement.reset();
    isShielded = false;
    isMagnetActive = false;
    isMultiplierActive = false;
  }
}
