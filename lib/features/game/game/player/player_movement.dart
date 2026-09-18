import '../../../../core/constants/game_constants.dart';
import '../../../../core/enums/player_state.dart';

class PlayerMovement {
  int currentLane = 1; // 0: Left, 1: Center, 2: Right
  double targetX = 0.0;
  double currentX = 0.0;
  
  PlayerState state = PlayerState.running;
  
  double jumpTimer = 0.0;
  double slideTimer = 0.0;
  double verticalOffset = 0.0; // Height when jumping

  void moveLeft() {
    if (currentLane > 0) {
      currentLane--;
    }
  }

  void moveRight() {
    if (currentLane < GameConstants.numberOfLanes - 1) {
      currentLane++;
    }
  }

  void jump() {
    if (state != PlayerState.jumping) {
      state = PlayerState.jumping;
      jumpTimer = 0.0;
    }
  }

  void slide() {
    if (state != PlayerState.sliding) {
      state = PlayerState.sliding;
      slideTimer = 0.0;
    }
  }

  void update(double dt, double screenWidth) {
    // Calculate target X position based on current lane
    final double centerLaneX = screenWidth / 2;
    targetX = centerLaneX + (currentLane - 1) * GameConstants.laneOffset;

    // Smooth horizontal interpolation towards lane X
    currentX += (targetX - currentX) * (15.0 * dt).clamp(0.0, 1.0);

    // Jump parabola calculation
    if (state == PlayerState.jumping) {
      jumpTimer += dt;
      final double progress = jumpTimer / GameConstants.jumpDuration;
      if (progress >= 1.0) {
        state = PlayerState.running;
        verticalOffset = 0.0;
      } else {
        // Parabolic arc: 4 * h * p * (1 - p)
        verticalOffset = 4 * GameConstants.jumpHeight * progress * (1 - progress);
      }
    }

    // Slide duration logic
    if (state == PlayerState.sliding) {
      slideTimer += dt;
      if (slideTimer >= GameConstants.slideDuration) {
        state = PlayerState.running;
      }
    }
  }

  void reset() {
    currentLane = 1;
    state = PlayerState.running;
    jumpTimer = 0.0;
    slideTimer = 0.0;
    verticalOffset = 0.0;
  }
}
