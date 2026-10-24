import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/order_card_model.dart';
import '../../utils/constants/colors.dart';
import '../../utils/responsive.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: ResponsiveCenter(
                maxWidth: AppResponsive.maxContentWidth,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: isWide ? 12.h : 16.h,
                  ),
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
                  child: isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              summaryLabel,
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkText,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                '$summaryCount',
                                style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
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
            ),
            SizedBox(height: isWide ? 12.h : 16.h),
            if (orders.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No orders',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
              )
            else if (isWide)
              Expanded(
                child: ResponsiveCenter(
                  maxWidth: AppResponsive.maxContentWidth,
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380,
                      mainAxisExtent: 390,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: orders[index]);
                    },
                  ),
                ),
              )
            else ...[
              Expanded(
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
              SizedBox(height: 12.h),
              _buildDots(orders.length, currentPage),
              SizedBox(height: 12.h),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDots(int count, int activeIndex) {
    if (count > 10) {
      return Text(
        '${activeIndex + 1} of $count',
        style: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.dotSemiActive,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i != 0) SizedBox(width: 8.w),
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _dotColor(i, activeIndex),
            ),
          ),
        ],
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
