import 'package:get/get.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../game/controllers/game_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../leaderboard/controllers/leaderboard_controller.dart';

class SettingsController extends GetxController {
  final AudioService audioService = Get.find<AudioService>();
  final StorageService storageService = Get.find<StorageService>();

  RxBool get soundEnabled => audioService.isSoundOn;
  RxBool get musicEnabled => audioService.isMusicOn;

  void toggleSound() {
    audioService.toggleSound();
  }

  void toggleMusic() {
    audioService.toggleMusic();
  }

  Future<void> resetProgress() async {
    await storageService.resetAll();

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadStats();
    }
    if (Get.isRegistered<LeaderboardController>()) {
      Get.find<LeaderboardController>().loadLeaderboard();
    }
    if (Get.isRegistered<GameController>()) {
      Get.find<GameController>().highScore.value = 0;
    }

    Get.snackbar(
      'Reset Complete',
      'All high scores, leaderboard, and coin data have been reset.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
