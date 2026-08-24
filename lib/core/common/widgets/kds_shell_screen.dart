import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/home/views/screens/home_screen.dart';
import '../../../features/recall/views/screens/recall_screen.dart';
import '../../../features/settings/views/screens/settings_screen.dart';
import '../../controller/nav_shell_controller.dart';

/// Keeps Home/Recall/Settings mounted in one IndexedStack so switching tabs
/// is instant and preserves each tab's state, instead of pushing a new route
/// (with a page-transition animation) on every bottom-nav tap.
class KdsShellScreen extends StatelessWidget {
  const KdsShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavShellController>();
    return Obx(
      () => IndexedStack(
        index: nav.currentIndex.value,
        children: const [HomeScreen(), RecallScreen(), SettingsScreen()],
      ),
    );
  }
}
