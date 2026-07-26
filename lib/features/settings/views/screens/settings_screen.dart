import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/gradient_app_bar.dart';
import '../../../../core/common/widgets/kds_bottom_nav.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GradientAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => _ToggleRow(
                label: 'Order Notification Sound',
                value: controller.notificationSoundEnabled.value,
                onChanged: controller.toggleNotificationSound,
              ),
            ),
            _DetailRow(label: 'Sound', value: controller.sound),
            _DetailRow(
              label: 'Time until warning color (seconds)',
              value: controller.warningColorSeconds,
            ),
            _DetailRow(
              label: 'Time until danger color (seconds)',
              value: controller.dangerColorSeconds,
            ),
            const _LinkRow(label: 'Help'),
            SizedBox(height: 16.h),
            _InlineRow(label: 'Account', value: controller.account),
            _InlineRow(label: 'IP address', value: controller.ipAddress),
            _InlineRow(label: 'Version', value: controller.version, showDivider: false),
            SizedBox(height: 40.h),
            Center(
              child: GestureDetector(
                onTap: controller.logout,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Log out',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const KdsBottomNav(currentIndex: 2),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.orderCardBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
                color: AppColors.brightBlue,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.brightBlue,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.orderCardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.left,
              color: AppColors.brightBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: getTextStyle(
              fontSize: 14,
              textAlign: TextAlign.left,
              color: AppColors.dotSemiActive,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label;

  const _LinkRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.orderCardBorder),
        ),
      ),
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
          color: AppColors.brightBlue,
        ),
      ),
    );
  }
}

class _InlineRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _InlineRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.orderCardBorder),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.left,
              color: AppColors.brightBlue,
            ),
          ),
          Text(
            value,
            style: getTextStyle(
              fontSize: 14,
              color: AppColors.dotSemiActive,
            ),
          ),
        ],
      ),
    );
  }
}
