import 'package:get/get.dart';

import '../controller/nav_shell_controller.dart';
import '../controller/theme_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/pair/controller/pair_controller.dart';
import '../../features/recall/controller/recall_controller.dart';
import '../../features/settings/controller/settings_controller.dart';
import '../../features/splash/controller/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.put<NavShellController>(NavShellController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<PairController>(() => PairController(), fenix: true);
    Get.lazyPut<RecallController>(() => RecallController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
