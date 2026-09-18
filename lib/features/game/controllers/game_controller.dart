import 'package:get/get.dart';
import '../../../core/enums/game_state.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/audio_service.dart';
import '../game/temple_dash_game.dart';

class GameController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AudioService audioService = Get.find<AudioService>();


  late TempleDashGame game;

  final Rx<GameState> gameState = GameState.initial.obs;
  final RxInt currentScore = 0.obs;
  final RxInt coinsCollected = 0.obs;
  final RxInt gemsCollected = 0.obs;
  final RxDouble distanceRan = 0.0.obs;
  final RxString activePowerUp = ''.obs;
  final RxDouble powerUpTimer = 0.0.obs;
  final RxInt highScore = 0.obs;

  @override
  void onInit() {
    super.onInit();
    highScore.value = _storageService.highScore;
    game = TempleDashGame(gameController: this);
  }

  void startGame() {
    currentScore.value = 0;
    coinsCollected.value = 0;
    gemsCollected.value = 0;
    distanceRan.value = 0.0;
    activePowerUp.value = '';
    powerUpTimer.value = 0.0;
    gameState.value = GameState.playing;
    audioService.playBgm();
  }

  void pauseGame() {
    if (gameState.value == GameState.playing) {
      gameState.value = GameState.paused;
      game.pauseEngine();
    }
  }

  void resumeGame() {
    if (gameState.value == GameState.paused) {
      gameState.value = GameState.playing;
      game.resumeEngine();
    }
  }

  void onGameOver() async {
    gameState.value = GameState.gameOver;
    game.pauseEngine();

    final score = currentScore.value;
    final coins = coinsCollected.value;
    final gems = gemsCollected.value;
    final distance = distanceRan.value;

    await _storageService.saveHighScore(score);
    await _storageService.addCoins(coins);
    await _storageService.addGems(gems);
    await _storageService.addDistance(distance);
    await _storageService.addLeaderboardEntry('Player', score);

    if (score > highScore.value) {
      highScore.value = score;
    }
  }

  void restartGame() {
    game.resetGame();
    startGame();
    game.resumeEngine();
  }
}
