import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class LeaderboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<Map<String, dynamic>> leaderboardList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  void loadLeaderboard() {
    leaderboardList.value = _storageService.leaderboardData;
  }
}
