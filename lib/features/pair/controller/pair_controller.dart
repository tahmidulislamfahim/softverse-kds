import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/main_station_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';

class PairController extends GetxController {
  final deviceName = 'Tom'.obs;
  late final mainStationController = TextEditingController(
    text: StorageService.mainStationUrl ?? '',
  );
  final isPairing = false.obs;

  Future<void> pairAsKds() async {
    final url = MainStationClient.normalize(mainStationController.text);
    if (url.isEmpty) {
      AppHelperFunctions.showWarningSnackBar(
        'Enter Softverse main station IP.',
      );
      return;
    }

    isPairing.value = true;
    try {
      final reachable = await MainStationClient.instance.test(url);
      if (!reachable) {
        AppHelperFunctions.showErrorSnackBar(
          'Could not reach Softverse main station.',
        );
        return;
      }

      await StorageService.setMainStationUrl(url);
      Get.offAllNamed(AppRoute.getShellScreen());
    } finally {
      isPairing.value = false;
    }
  }

  @override
  void onClose() {
    mainStationController.dispose();
    super.onClose();
  }
}
