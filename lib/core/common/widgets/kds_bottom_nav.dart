import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../utils/constants/colors.dart';
import '../styles/global_text_style.dart';
import '../../../routes/app_routes.dart';

class KdsBottomNav extends StatelessWidget {
  final int currentIndex;

  const KdsBottomNav({super.key, required this.currentIndex});

  static final _routes = [
    AppRoute.homeScreen,
    AppRoute.recallScreen,
    AppRoute.settingsScreen,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        Get.offNamed(_routes[index]);
      },
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
    );
  }
}
