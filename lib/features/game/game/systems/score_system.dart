import '../../../../core/constants/game_constants.dart';

class ScoreSystem {
  int currentScore = 0;
  int coins = 0;
  int gems = 0;
  int multiplier = 1;

  void updateScore(double distance, {required bool isMultiplierActive}) {
    multiplier = isMultiplierActive ? 2 : 1;
    currentScore = (distance.toInt() * 10 * multiplier) +
        (coins * GameConstants.coinScoreValue * multiplier) +
        (gems * GameConstants.gemScoreValue * multiplier);
  }

  void addCoin() {
    coins++;
  }

  void addGem() {
    gems++;
  }

  void reset() {
    currentScore = 0;
    coins = 0;
    gems = 0;
    multiplier = 1;
  }
}
