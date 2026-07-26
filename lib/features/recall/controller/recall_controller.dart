import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/order_card_model.dart';
import '../../../core/utils/constants/colors.dart';

class RecallController extends GetxController {
  final currentPage = 0.obs;
  final completedOrders = 3.obs;

  late final PageController pageController;

  final List<OrderCardModel> orders = [
    _demoOrder(
      gradientColors: [AppColors.accentGreenStart, AppColors.accentGreenEnd],
      borderColor: AppColors.accentGreenBorder,
      textColor: AppColors.darkText,
    ),
    _demoOrder(
      gradientColors: [AppColors.accentGreenStart, AppColors.accentGreenEnd],
      borderColor: AppColors.accentGreenBorder,
      textColor: AppColors.darkText,
    ),
    _demoOrder(
      gradientColors: [AppColors.accentGreenStart, AppColors.accentGreenEnd],
      borderColor: AppColors.accentGreenBorder,
      textColor: AppColors.darkText,
    ),
    _demoOrder(
      gradientColors: [
        AppColors.accentPurpleStart,
        AppColors.accentPurpleEnd,
      ],
      borderColor: AppColors.accentPurpleBorder,
      textColor: Colors.white,
    ),
    _demoOrder(
      gradientColors: [
        AppColors.accentOrangeStart,
        AppColors.accentOrangeEnd,
      ],
      borderColor: AppColors.accentOrangeBorder,
      textColor: AppColors.darkText,
    ),
  ];

  static OrderCardModel _demoOrder({
    required List<Color> gradientColors,
    required Color borderColor,
    required Color textColor,
  }) {
    return OrderCardModel(
      orderId: 'POS-1 Order-1',
      customerName: 'Abs Corporation',
      subtitle: 'Completed in 30.45 minutes',
      table: 'Table-01',
      actionLabel: 'Recall',
      gradientColors: gradientColors,
      borderColor: borderColor,
      textColor: textColor,
      items: const [
        OrderItemModel(name: 'A4Ttech Keyboard', quantity: 1),
        OrderItemModel(name: 'Mouse + Keyboard', quantity: 1),
        OrderItemModel(name: 'HP Monitor', quantity: 1),
        OrderItemModel(name: 'A4Ttech Mouse', quantity: 1),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) => currentPage.value = index;
}
