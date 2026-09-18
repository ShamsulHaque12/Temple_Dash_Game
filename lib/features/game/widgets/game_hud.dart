import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/game_controller.dart';
import 'score_widget.dart';
import 'coin_widget.dart';
import 'pause_button.dart';
import '../../../core/utils/game_utils.dart';
import '../../../app/theme/app_colors.dart';

class GameHud extends GetView<GameController> {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ScoreWidget(),
                PauseButton(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CoinWidget(),
                Obx(() {
                  final meters = GameUtils.formatDistance(controller.distanceRan.value);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_run, color: AppColors.accentCyan, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          meters,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const Spacer(),

            // Active PowerUp Animated Indicator Banner
            Obx(() {
              if (controller.activePowerUp.value.isEmpty) return const SizedBox.shrink();
              final powerUpName = controller.activePowerUp.value;
              final color = GameUtils.getPowerUpColor(powerUpName.toLowerCase());
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 15),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        '$powerUpName ACTIVE (${controller.powerUpTimer.value.toInt()}s)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 300.ms).shimmer(duration: 1000.ms),
              );
            }),
            const SizedBox(height: 16),

            // On-Screen Glassmorphic Gesture Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(Icons.arrow_back_rounded, () => controller.game.player.moveLeft()),
                _buildControlButton(Icons.arrow_upward_rounded, () => controller.game.player.jump()),
                _buildControlButton(Icons.arrow_downward_rounded, () => controller.game.player.slide()),
                _buildControlButton(Icons.arrow_forward_rounded, () => controller.game.player.moveRight()),
              ],
            ).animate().slideY(begin: 0.3, end: 0, duration: 400.ms)
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(35),
        splashColor: AppColors.primaryGold.withValues(alpha: 0.4),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.6), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGold.withValues(alpha: 0.15),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primaryGold, size: 26),
        ),
      ),
    );
  }
}
