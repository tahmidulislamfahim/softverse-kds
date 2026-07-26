import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/gradient_app_bar.dart';
import '../../../../core/common/widgets/kds_bottom_nav.dart';
import '../../../../core/common/widgets/order_carousel.dart';
import '../../controller/recall_controller.dart';

class RecallScreen extends GetView<RecallController> {
  const RecallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GradientAppBar(
        title: 'Recall',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Obx(
        () => OrderCarousel(
          summaryLabel: 'Completed Order',
          summaryCount: controller.completedOrders.value,
          orders: controller.orders,
          pageController: controller.pageController,
          currentPage: controller.currentPage.value,
          onPageChanged: controller.onPageChanged,
        ),
      ),
      bottomNavigationBar: const KdsBottomNav(currentIndex: 1),
    );
  }
}
