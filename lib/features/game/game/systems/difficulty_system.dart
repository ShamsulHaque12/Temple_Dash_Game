import '../../../../core/constants/game_constants.dart';

class DifficultySystem {
  double currentSpeed = GameConstants.initialSpeed;
  double distanceTraveled = 0.0;

  void update(double dt) {
    distanceTraveled += (currentSpeed * dt) / GameConstants.metersPerSecondMultiplier;
    
    if (currentSpeed < GameConstants.maxSpeed) {
      currentSpeed += GameConstants.speedAcceleration * dt;
    }
  }

  void reset() {
    currentSpeed = GameConstants.initialSpeed;
    distanceTraveled = 0.0;
  }
}
