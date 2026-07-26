import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class PairController extends GetxController {
  final deviceName = 'Tom'.obs;
  final ipAddress = '192.152.11.145'.obs;

  void pairAsKds() => Get.offAllNamed(AppRoute.getHomeScreen());
}
