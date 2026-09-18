import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/game_controller.dart';
import '../../../app/theme/app_colors.dart';

class PauseButton extends GetView<GameController> {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.pauseGame();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryGold, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withValues(alpha: 0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(
          Icons.pause_rounded,
          color: AppColors.primaryGold,
          size: 26,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(delay: 100.ms);
  }
}
