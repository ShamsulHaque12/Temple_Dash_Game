import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  GetStorage get _box => GetStorage();

  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }


  int get highScore => _box.read<int>(StorageKeys.highScore) ?? 0;
  int get totalCoins => _box.read<int>(StorageKeys.totalCoins) ?? 0;
  int get totalGems => _box.read<int>(StorageKeys.totalGems) ?? 0;
  double get totalDistance => _box.read<double>(StorageKeys.totalDistance) ?? 0.0;

  bool get isSoundEnabled => _box.read<bool>(StorageKeys.soundEnabled) ?? true;
  bool get isMusicEnabled => _box.read<bool>(StorageKeys.musicEnabled) ?? true;

  Future<void> saveHighScore(int score) async {
    if (score > highScore) {
      await _box.write(StorageKeys.highScore, score);
    }
  }

  Future<void> addCoins(int count) async {
    await _box.write(StorageKeys.totalCoins, totalCoins + count);
  }

  Future<void> addGems(int count) async {
    await _box.write(StorageKeys.totalGems, totalGems + count);
  }

  Future<void> addDistance(double distance) async {
    await _box.write(StorageKeys.totalDistance, totalDistance + distance);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _box.write(StorageKeys.soundEnabled, enabled);
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _box.write(StorageKeys.musicEnabled, enabled);
  }

  List<Map<String, dynamic>> get leaderboardData {
    final List<dynamic>? raw = _box.read<List<dynamic>>(StorageKeys.leaderboardData);
    if (raw == null) {
      return [];
    }
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> addLeaderboardEntry(String name, int score) async {
    final current = leaderboardData;
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    current.add({
      'name': name,
      'score': score,
      'date': dateStr,
    });
    current.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    if (current.length > 10) {
      current.removeRange(10, current.length);
    }
    await _box.write(StorageKeys.leaderboardData, current);
  }

  Future<void> resetAll() async {
    await _box.erase();
  }
}
