import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/pair_controller.dart';

class PairScreen extends GetView<PairController> {
  const PairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: AppColors.brightBlue,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Logo-white.png',
                      width: 140.w,
                    ),
                    SizedBox(height: 24.h),
                    Image.asset(
                      'assets/images/mobiles.png',
                      width: 260.w,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.wifi, color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Softverse POS',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 32.w),
                        GestureDetector(
                          onTap: controller.pairAsKds,
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.wifi,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Softverse KDS',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: c.cardBg,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'To get started, pair this device in the Softverse POS settings.',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => Text(
                    'Device name: ${controller.deviceName.value}',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    'IP Address: ${controller.ipAddress.value}',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'New to Softverse?',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brightBlue,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Help',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brightBlue,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Privacy Policy . Terms of Use',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
