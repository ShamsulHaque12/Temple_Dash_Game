import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/game/bindings/game_binding.dart';
import '../../features/game/views/game_screen.dart';
import '../../features/leaderboard/views/leaderboard_screen.dart';
import '../../features/leaderboard/controllers/leaderboard_controller.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/settings/controllers/settings_controller.dart';

class AppPages {
  static const initial = Routes.home;

  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.game,
      page: () => const GameScreen(),
      binding: GameBinding(),
    ),
    GetPage(
      name: Routes.leaderboard,
      page: () => const LeaderboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LeaderboardController());
      }),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SettingsController());
      }),
    ),
  ];
}
