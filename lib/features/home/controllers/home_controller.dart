import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final RxInt highScore = 0.obs;
  final RxInt totalCoins = 0.obs;
  final RxInt totalGems = 0.obs;
  final RxDouble totalDistance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  void loadStats() {
    highScore.value = _storageService.highScore;
    totalCoins.value = _storageService.totalCoins;
    totalGems.value = _storageService.totalGems;
    totalDistance.value = _storageService.totalDistance;
  }
}
