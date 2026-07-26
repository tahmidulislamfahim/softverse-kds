import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final notificationSoundEnabled = true.obs;

  final sound = 'SIMToolkitPositiveACK';
  final warningColorSeconds = '240';
  final dangerColorSeconds = '240';
  final account = 'softvence@corp.com';
  final ipAddress = '192.152.11.145';
  final version = '1.21';

  void toggleNotificationSound(bool value) {
    notificationSoundEnabled.value = value;
  }

  void logout() => Get.offAllNamed(AppRoute.getPairScreen());
}
