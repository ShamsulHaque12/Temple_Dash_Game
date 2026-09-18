import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'storage_service.dart';
import '../constants/asset_constants.dart';

class AudioService extends GetxService {
  late final AudioPlayer _bgmPlayer;
  late final AudioPlayer _sfxPlayer;

  final RxBool isSoundOn = true.obs;
  final RxBool isMusicOn = true.obs;

  @override
  void onInit() {
    super.onInit();
    _bgmPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    
    final storage = Get.find<StorageService>();
    isSoundOn.value = storage.isSoundEnabled;
    isMusicOn.value = storage.isMusicEnabled;
  }

  void playBgm() async {
    if (!isMusicOn.value) return;
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource(AssetConstants.bgm));
    } catch (_) {
      // Graceful fallback if audio asset not present
    }
  }

  void stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  void playSfx(String sfxName) async {
    if (!isSoundOn.value) return;
    try {
      await _sfxPlayer.play(AssetSource(sfxName));
    } catch (_) {
      // Graceful fallback
    }
  }

  void toggleSound() {
    isSoundOn.value = !isSoundOn.value;
    Get.find<StorageService>().setSoundEnabled(isSoundOn.value);
  }

  void toggleMusic() {
    isMusicOn.value = !isMusicOn.value;
    Get.find<StorageService>().setMusicEnabled(isMusicOn.value);
    if (isMusicOn.value) {
      playBgm();
    } else {
      stopBgm();
    }
  }

  @override
  void onClose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.onClose();
  }
}
