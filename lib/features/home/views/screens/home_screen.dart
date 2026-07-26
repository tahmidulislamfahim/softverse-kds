import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/gradient_app_bar.dart';
import '../../../../core/common/widgets/kds_bottom_nav.dart';
import '../../../../core/common/widgets/order_carousel.dart';
import '../../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GradientAppBar(title: 'Order'),
      body: Obx(
        () => OrderCarousel(
          summaryLabel: 'Remaining Orders',
          summaryCount: controller.remainingOrders.value,
          orders: controller.orders,
          pageController: controller.pageController,
          currentPage: controller.currentPage.value,
          onPageChanged: controller.onPageChanged,
        ),
      ),
      bottomNavigationBar: const KdsBottomNav(currentIndex: 0),
    );
  }
}
