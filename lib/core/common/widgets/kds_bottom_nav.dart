import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../controller/nav_shell_controller.dart';
import '../../utils/constants/colors.dart';
import '../styles/global_text_style.dart';

class KdsBottomNav extends StatelessWidget {
  const KdsBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavShellController>();
    return Obx(
      () => BottomNavigationBar(
        currentIndex: nav.currentIndex.value,
        onTap: nav.changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.brightBlue,
        unselectedItemColor: AppColors.dotSemiActive,
        selectedLabelStyle: getTextStyle(fontSize: 14),
        unselectedLabelStyle: getTextStyle(fontSize: 14),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.clock), label: 'Recall'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting_2),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
