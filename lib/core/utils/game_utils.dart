import 'package:flutter/material.dart';

class GameUtils {
  static String formatScore(int score) {
    return score.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  static String formatDistance(double meters) {
    return '${meters.toInt()}m';
  }

  static Color getPowerUpColor(String type) {
    switch (type) {
      case 'magnet':
        return Colors.blueAccent;
      case 'shield':
        return Colors.purpleAccent;
      case 'multiplier':
        return Colors.amberAccent;
      default:
        return Colors.greenAccent;
    }
  }
}
