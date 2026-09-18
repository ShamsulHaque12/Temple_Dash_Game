import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../../../core/utils/game_utils.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class GameOverDialog extends GetView<GameController> {
  const GameOverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.secondaryOrange, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryOrange.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: AppColors.rubyRed,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            _buildStatRow('FINAL SCORE', GameUtils.formatScore(controller.currentScore.value), AppColors.primaryGold),
            const SizedBox(height: 10),
            _buildStatRow('DISTANCE', GameUtils.formatDistance(controller.distanceRan.value), Colors.white),
            const SizedBox(height: 10),
            _buildStatRow('COINS', '${controller.coinsCollected.value}', AppColors.coinYellow),
            const SizedBox(height: 10),
            _buildStatRow('HIGH SCORE', GameUtils.formatScore(controller.highScore.value), AppColors.accentCyan),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      controller.restartGame();
                    },
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white10,
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.home);
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
