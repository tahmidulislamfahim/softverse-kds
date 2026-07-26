import 'package:get/get.dart';

import '../features/home/views/screens/home_screen.dart';
import '../features/pair/views/screens/pair_screen.dart';
import '../features/recall/views/screens/recall_screen.dart';
import '../features/settings/views/screens/settings_screen.dart';
import '../features/splash/views/screens/splash_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String homeScreen = "/homeScreen";
  static String pairScreen = "/pairScreen";
  static String recallScreen = "/recallScreen";
  static String settingsScreen = "/settingsScreen";

  static String getSplashScreen() => splashScreen;

  static String getHomeScreen() => homeScreen;

  static String getPairScreen() => pairScreen;

  static String getRecallScreen() => recallScreen;

  static String getSettingsScreen() => settingsScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: pairScreen, page: () => const PairScreen()),
    GetPage(name: recallScreen, page: () => const RecallScreen()),
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),
  ];
}
