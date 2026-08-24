import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/widgets/gradient_app_bar.dart';
import '../../../../core/common/widgets/kds_bottom_nav.dart';
import '../../../../core/common/widgets/order_carousel.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Order',
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.orders.isEmpty
                  ? null
                  : () => _confirmClear(context, controller.orders.length),
              icon: const Icon(Iconsax.trash, color: Colors.white),
              tooltip: 'Clear remaining orders',
            ),
          ),
        ],
      ),
      body: Obx(
        () => OrderCarousel(
          summaryLabel: 'Remaining Orders',
          summaryCount: controller.remainingOrders.value,
          orders: controller.orders.toList(),
          pageController: controller.pageController,
          currentPage: controller.currentPage.value,
          onPageChanged: controller.onPageChanged,
        ),
      ),
      bottomNavigationBar: const KdsBottomNav(),
    );
  }

  void _confirmClear(BuildContext context, int count) {
    Get.defaultDialog(
      title: 'Clear remaining orders?',
      middleText: 'This marks all $count remaining order(s) as done.',
      textCancel: 'Cancel',
      textConfirm: 'Clear',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.dangerRed,
      onConfirm: () {
        Get.back();
        controller.clearRemainingOrders();
      },
    );
  }
}
