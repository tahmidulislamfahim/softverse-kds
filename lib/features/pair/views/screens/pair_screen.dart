import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/pair_controller.dart';

class PairScreen extends GetView<PairController> {
  const PairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = AppResponsive.isWide(context);

    return Scaffold(
      backgroundColor: AppColors.brightBlue,
      body: isWide ? _buildWideLayout(context) : _buildPortraitLayout(context),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    final c = context.appColors;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            color: AppColors.brightBlue,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: _buildBrandingContent(context),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            color: c.cardBg,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppResponsive.maxFormWidth),
                    child: _buildPairForm(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final c = context.appColors;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Column(
      children: [
        if (keyboardOpen)
          SizedBox(height: MediaQuery.paddingOf(context).top + 16.h)
        else
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildBrandingContent(context),
              ),
            ),
          ),
        Flexible(
          fit: keyboardOpen ? FlexFit.tight : FlexFit.loose,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: c.cardBg,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppResponsive.maxFormWidth),
                child: _buildPairForm(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandingContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icons/Logo-white.png', width: 140.w),
        SizedBox(height: 20.h),
        Flexible(
          child: Image.asset(
            'assets/images/mobiles.png',
            width: 260.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20.w,
          runSpacing: 8.h,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
            GestureDetector(
              onTap: controller.pairAsKds,
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
    );
  }

  Widget _buildPairForm(BuildContext context) {
    final c = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Enter the Softverse main station IP to connect this KDS.',
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: controller.mainStationController,
          keyboardType: TextInputType.url,
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: c.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'http://192.168.0.104:8787',
            hintStyle: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
            filled: true,
            fillColor: c.fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => GestureDetector(
            onTap: controller.isPairing.value ? null : controller.pairAsKds,
            child: Container(
              width: 180.w,
              height: 52.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.brightBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: controller.isPairing.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Connect',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
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
    );
  }
}
