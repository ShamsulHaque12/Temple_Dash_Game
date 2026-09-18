import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_hud.dart';
import '../widgets/game_over_dialog.dart';
import '../../../core/enums/game_state.dart';
import '../../../app/theme/app_colors.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Start game session when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startGame();
    });

    return Scaffold(
      body: Stack(
        children: [
          // Flame Game Widget
          GameWidget(game: controller.game),

          // HUD Overlay
          const GameHud(),

          // Pause Dialog Overlay
          Obx(() {
            if (controller.gameState.value == GameState.paused) {
              return Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Card(
                    color: AppColors.cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.primaryGold, width: 2),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'GAME PAUSED',
                            style: TextStyle(
                              color: AppColors.primaryGold,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () => controller.resumeGame(),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('RESUME'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () => controller.restartGame(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('RESTART'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Game Over Dialog Overlay
          Obx(() {
            if (controller.gameState.value == GameState.gameOver) {
              return const GameOverDialog();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
