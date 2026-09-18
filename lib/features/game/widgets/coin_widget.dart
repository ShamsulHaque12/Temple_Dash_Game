import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/game_controller.dart';
import '../../../app/theme/app_colors.dart';

class CoinWidget extends GetView<GameController> {
  const CoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.coinYellow, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coinYellow.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_rounded, color: AppColors.coinYellow, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${controller.coinsCollected.value}',
                    style: const TextStyle(
                      color: AppColors.coinYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.gemEmerald, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gemEmerald.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.diamond_rounded, color: AppColors.gemEmerald, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${controller.gemsCollected.value}',
                    style: const TextStyle(
                      color: AppColors.gemEmerald,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )).animate().fadeIn(duration: 500.ms);
  }
}
