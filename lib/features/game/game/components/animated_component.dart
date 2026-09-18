import 'game_component.dart';

abstract class AnimatedComponent extends GameComponent {
  double animationTimer = 0.0;
  int currentFrame = 0;
  final int totalFrames;
  final double frameDuration;

  AnimatedComponent({
    this.totalFrames = 4,
    this.frameDuration = 0.15,
  });

  @override
  void update(double dt) {
    super.update(dt);
    animationTimer += dt;
    if (animationTimer >= frameDuration) {
      animationTimer = 0.0;
      currentFrame = (currentFrame + 1) % totalFrames;
    }
  }
}
