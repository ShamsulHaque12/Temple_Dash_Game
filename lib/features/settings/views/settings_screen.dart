import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../app/theme/app_colors.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        backgroundColor: AppColors.obsidianBg,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.obsidianBg,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => Card(
                  child: SwitchListTile(
                    title: const Text('Sound Effects (SFX)'),
                    subtitle: const Text('Enable jump, coin, and hit sounds'),
                    activeThumbColor: AppColors.primaryGold,
                    value: controller.soundEnabled.value,
                    onChanged: (_) => controller.toggleSound(),
                  ),
                )),
            const SizedBox(height: 12),
            Obx(() => Card(
                  child: SwitchListTile(
                    title: const Text('Background Music (BGM)'),
                    subtitle: const Text('Enable ambient temple track soundtrack'),
                    activeThumbColor: AppColors.primaryGold,
                    value: controller.musicEnabled.value,
                    onChanged: (_) => controller.toggleMusic(),
                  ),
                )),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rubyRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Reset All Data?',
                  middleText: 'This will erase high scores, coin counts, and progress!',
                  textConfirm: 'Reset',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: AppColors.rubyRed,
                  onConfirm: () {
                    controller.resetProgress();
                    Get.back();
                  },
                );
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('RESET ALL PROGRESS'),
            ),
          ],
        ),
      ),
    );
  }
}
