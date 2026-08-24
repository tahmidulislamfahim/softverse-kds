import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/services/kds_sound_player.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/kds_sounds.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final notificationSoundEnabled = true.obs;
  final orderReceivedSound = KdsSounds.orderReceived.obs;
  final orderPaidSound = KdsSounds.orderPaid.obs;
  final orderClearedSound = KdsSounds.clear.obs;
  final warningColorSeconds = 180.obs;
  final dangerColorSeconds = 300.obs;

  final ipAddress = ''.obs;
  final version = ''.obs;
  final account = 'softvence@corp.com';

  @override
  void onInit() {
    super.onInit();
    notificationSoundEnabled.value = StorageService.notificationSoundEnabled;
    orderReceivedSound.value = KdsSounds.byId(
      StorageService.orderReceivedSoundId,
    );
    orderPaidSound.value = KdsSounds.byId(StorageService.orderPaidSoundId);
    orderClearedSound.value = KdsSounds.byId(
      StorageService.orderClearedSoundId,
    );
    warningColorSeconds.value = StorageService.warningColorSeconds;
    dangerColorSeconds.value = StorageService.dangerColorSeconds;
    ipAddress.value = StorageService.mainStationUrl ?? 'Not paired';
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    version.value = '${info.version}+${info.buildNumber}';
  }

  Future<void> toggleNotificationSound(bool value) async {
    notificationSoundEnabled.value = value;
    await StorageService.setNotificationSoundEnabled(value);
  }

  Future<void> setOrderReceivedSound(KdsSound sound) async {
    orderReceivedSound.value = sound;
    await StorageService.setOrderReceivedSoundId(sound.id);
    await previewSound(sound);
  }

  Future<void> setOrderPaidSound(KdsSound sound) async {
    orderPaidSound.value = sound;
    await StorageService.setOrderPaidSoundId(sound.id);
    await previewSound(sound);
  }

  Future<void> setOrderClearedSound(KdsSound sound) async {
    orderClearedSound.value = sound;
    await StorageService.setOrderClearedSoundId(sound.id);
    await previewSound(sound);
  }

  Future<void> previewSound(KdsSound sound) async {
    await playKdsSound(sound);
  }

  Future<void> setWarningColorSeconds(int seconds) async {
    warningColorSeconds.value = seconds;
    await StorageService.setWarningColorSeconds(seconds);
  }

  Future<void> setDangerColorSeconds(int seconds) async {
    dangerColorSeconds.value = seconds;
    await StorageService.setDangerColorSeconds(seconds);
  }

  void logout() => Get.offAllNamed(AppRoute.getPairScreen());
}
