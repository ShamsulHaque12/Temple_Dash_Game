import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/game_utils.dart';

class LeaderboardScreen extends GetView<LeaderboardController> {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadLeaderboard();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TEMPLE LEADERBOARD'),
        backgroundColor: AppColors.obsidianBg,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.obsidianBg,
        child: Obx(() {
          final list = controller.leaderboardList;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No scores recorded yet!',
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final rank = index + 1;
              Color rankColor = Colors.white;
              if (rank == 1) rankColor = AppColors.primaryGold;
              if (rank == 2) rankColor = Colors.grey.shade300;
              if (rank == 3) rankColor = Colors.brown.shade300;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: rankColor.withOpacity(0.2),
                    child: Text(
                      '#$rank',
                      style: TextStyle(color: rankColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    item['name'] ?? 'Runner',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['date'] ?? '',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  trailing: Text(
                    GameUtils.formatScore((item['score'] as num).toInt()),
                    style: TextStyle(
                      color: rankColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
