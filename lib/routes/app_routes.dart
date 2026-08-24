import 'package:get/get.dart';

import '../core/common/widgets/kds_shell_screen.dart';
import '../features/pair/views/screens/pair_screen.dart';
import '../features/splash/views/screens/splash_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String shellScreen = "/shellScreen";
  static String pairScreen = "/pairScreen";

  static String getSplashScreen() => splashScreen;

  static String getShellScreen() => shellScreen;

  static String getPairScreen() => pairScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: shellScreen, page: () => const KdsShellScreen()),
    GetPage(name: pairScreen, page: () => const PairScreen()),
  ];
}
