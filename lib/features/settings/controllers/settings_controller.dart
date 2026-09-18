import 'package:get/get.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';

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
    Get.snackbar(
      'Reset Complete',
      'All high scores and coin data have been reset.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
