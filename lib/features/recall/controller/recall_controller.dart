import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/kds_order_model.dart';
import '../../../core/models/order_card_model.dart';
import '../../../core/services/kds_order_store.dart';
import '../../../core/utils/constants/colors.dart';

class RecallController extends GetxController {
  final currentPage = 0.obs;
  final completedOrders = 0.obs;
  final orders = <OrderCardModel>[].obs;

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
    loadHistory();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> loadHistory() async {
    final kdsOrders = await KdsOrderStore.instance.listCompleted();
    orders.assignAll(kdsOrders.map(_cardFromOrder));
    completedOrders.value = orders.length;
    if (currentPage.value >= orders.length) currentPage.value = 0;
  }

  void onPageChanged(int index) => currentPage.value = index;

  OrderCardModel _cardFromOrder(KdsOrderModel order) {
    return OrderCardModel(
      orderId: order.orderId,
      customerName: order.customerName,
      subtitle: 'Completed',
      table: order.tableName,
      actionLabel: 'Recall',
      gradientColors: const [
        AppColors.accentPurpleStart,
        AppColors.accentPurpleEnd,
      ],
      borderColor: AppColors.accentPurpleBorder,
      textColor: Colors.white,
      items: order.items
          .map(
            (item) => OrderItemModel(name: item.name, quantity: item.quantity),
          )
          .toList(),
    );
  }
}
