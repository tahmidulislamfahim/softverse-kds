import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/order_card_model.dart';
import '../../utils/constants/colors.dart';
import '../styles/global_text_style.dart';
import 'order_card.dart';

class OrderCarousel extends StatelessWidget {
  final String summaryLabel;
  final int summaryCount;
  final List<OrderCardModel> orders;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const OrderCarousel({
    super.key,
    required this.summaryLabel,
    required this.summaryCount,
    required this.orders,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.goldStart,
                  AppColors.goldMid,
                  AppColors.goldEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Column(
              children: [
                Text(
                  summaryLabel,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$summaryCount',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 355.h,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: OrderCard(order: orders[index]),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < orders.length; i++) ...[
              if (i != 0) SizedBox(width: 8.w),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _dotColor(i, currentPage),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Color _dotColor(int index, int activeIndex) {
    final distance = (index - activeIndex).abs();
    if (distance == 0) return AppColors.brightBlue;
    if (distance == 1) return AppColors.dotSemiActive;
    return AppColors.dotInactive;
  }
}
