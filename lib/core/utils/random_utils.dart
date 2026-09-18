import 'dart:math';

class RandomUtils {
  static final Random _random = Random();

  static int getInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  static double getDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  static bool getBool({double probability = 0.5}) {
    return _random.nextDouble() < probability;
  }

  static T getRandomElement<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }
}
