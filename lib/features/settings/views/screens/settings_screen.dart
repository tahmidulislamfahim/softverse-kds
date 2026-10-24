import '../../../../core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/gradient_app_bar.dart';
import '../../../../core/common/widgets/kds_bottom_nav.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/kds_sounds.dart';
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
        child: ResponsiveCenter(
          maxWidth: 680,
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
            Obx(
              () => _DetailRow(
                label: 'Order Received Sound',
                value: controller.orderReceivedSound.value.label,
                onTap: () => _pickSound(
                  title: 'Order Received Sound',
                  options: KdsSounds.forOrderReceived,
                  current: controller.orderReceivedSound.value,
                  onSelected: controller.setOrderReceivedSound,
                ),
              ),
            ),
            Obx(
              () => _DetailRow(
                label: 'Order Paid Sound',
                value: controller.orderPaidSound.value.label,
                onTap: () => _pickSound(
                  title: 'Order Paid Sound',
                  options: KdsSounds.forOrderPaid,
                  current: controller.orderPaidSound.value,
                  onSelected: controller.setOrderPaidSound,
                ),
              ),
            ),
            Obx(
              () => _DetailRow(
                label: 'Order Cleared Sound',
                value: controller.orderClearedSound.value.label,
                onTap: () => _pickSound(
                  title: 'Order Cleared Sound',
                  options: KdsSounds.forOrderCleared,
                  current: controller.orderClearedSound.value,
                  onSelected: controller.setOrderClearedSound,
                ),
              ),
            ),
            Obx(
              () => _DetailRow(
                label: 'Time until warning color (seconds)',
                value: '${controller.warningColorSeconds.value}',
                onTap: () => _editSeconds(
                  title: 'Time until warning color',
                  current: controller.warningColorSeconds.value,
                  onSubmit: controller.setWarningColorSeconds,
                ),
              ),
            ),
            Obx(
              () => _DetailRow(
                label: 'Time until danger color (seconds)',
                value: '${controller.dangerColorSeconds.value}',
                onTap: () => _editSeconds(
                  title: 'Time until danger color',
                  current: controller.dangerColorSeconds.value,
                  onSubmit: controller.setDangerColorSeconds,
                ),
              ),
            ),
            const _LinkRow(label: 'Help'),
            SizedBox(height: 16.h),
            _InlineRow(label: 'Account', value: controller.account),
            Obx(
              () => _InlineRow(
                label: 'IP address',
                value: controller.ipAddress.value,
              ),
            ),
            Obx(
              () => _InlineRow(
                label: 'Version',
                value: controller.version.value,
                showDivider: false,
              ),
            ),
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
    ),
      bottomNavigationBar: const KdsBottomNav(),
    );
  }

  void _pickSound({
    required String title,
    required List<KdsSound> options,
    required KdsSound current,
    required ValueChanged<KdsSound> onSelected,
  }) {
    Get.bottomSheet(
      isScrollControlled: true,
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.7,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final sound in options)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          sound.label,
                          style: getTextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          sound.kind == KdsSoundKind.phrase ? 'Voice' : 'Tone',
                          style: getTextStyle(
                            fontSize: 12,
                            color: AppColors.dotSemiActive,
                          ),
                        ),
                        trailing: sound.id == current.id
                            ? Icon(
                                Iconsax.tick_circle,
                                color: AppColors.brightBlue,
                              )
                            : null,
                        onTap: () {
                          Get.back();
                          onSelected(sound);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editSeconds({
    required String title,
    required int current,
    required ValueChanged<int> onSubmit,
  }) {
    final controller = TextEditingController(text: '$current');
    Get.defaultDialog(
      title: title,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          decoration: const InputDecoration(suffixText: 'seconds'),
        ),
      ),
      textCancel: 'Cancel',
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.brightBlue,
      onConfirm: () {
        final seconds = int.tryParse(controller.text);
        if (seconds != null && seconds > 0) onSubmit(seconds);
        Get.back();
      },
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
        border: Border(bottom: BorderSide(color: AppColors.orderCardBorder)),
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
  final VoidCallback? onTap;

  const _DetailRow({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.orderCardBorder),
          ),
        ),
        child: Row(
          children: [
            Expanded(
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
            ),
            if (onTap != null)
              Icon(Iconsax.arrow_right_3, color: AppColors.dotSemiActive, size: 18.sp),
          ],
        ),
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
        border: Border(bottom: BorderSide(color: AppColors.orderCardBorder)),
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
          SizedBox(width: 8.w),
          Text(
            value,
            style: getTextStyle(fontSize: 14, color: AppColors.dotSemiActive),
          ),
        ],
      ),
    );
  }
}
