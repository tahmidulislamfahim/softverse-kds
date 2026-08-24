import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/models/kds_order_model.dart';
import '../../../core/models/order_card_model.dart';
import '../../../core/services/kds_order_store.dart';
import '../../../core/services/kds_sound_player.dart';
import '../../../core/services/main_station_client.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/kds_sounds.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../recall/controller/recall_controller.dart';
import '../../settings/controller/settings_controller.dart';

enum _OrderAlertKind { received, paid }

class HomeController extends GetxController {
  final currentPage = 0.obs;
  final remainingOrders = 0.obs;
  final orders = <OrderCardModel>[].obs;

  late final PageController pageController;
  Timer? _poller;
  StreamSubscription<MainStationEvent>? _orderStream;
  final _seenOrderIds = <String>{};
  final _paidAlertedOrderIds = <String>{};

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
    loadOrders();
    _orderStream = MainStationClient.instance.watchOrders().listen(
      _handleStationEvent,
    );
    // ponytail: fallback sync covers reconnects; WebSocket handles live updates.
    _poller = Timer.periodic(
      const Duration(seconds: 20),
      (_) => loadOrders(notifyNew: true),
    );
  }

  @override
  void onClose() {
    _poller?.cancel();
    _orderStream?.cancel();
    pageController.dispose();
    super.onClose();
  }

  Future<void> _alertOrderReceived() => _alert(
    Get.find<SettingsController>().orderReceivedSound.value,
    'New order received',
  );

  Future<void> _alertOrderPaid() =>
      _alert(Get.find<SettingsController>().orderPaidSound.value, 'Order paid');

  Future<void> _alertOrderCleared({String message = 'Order completed'}) =>
      _alert(Get.find<SettingsController>().orderClearedSound.value, message);

  Future<void> _alert(KdsSound sound, String message) async {
    await HapticFeedback.mediumImpact();
    if (Get.find<SettingsController>().notificationSoundEnabled.value) {
      await playKdsSound(sound);
    }
    AppHelperFunctions.showSuccessSnackBar(message);
  }

  /// Tracks which orders have already triggered a "received" and/or "paid"
  /// alert, so a status change (e.g. ongoing -> paid) on an already-seen
  /// order still gets its own alert instead of being silently skipped.
  _OrderAlertKind? _registerOrder(KdsOrderModel order) {
    final key = _orderKey(order);
    final isNew = _seenOrderIds.add(key);
    final isPaid = order.status.toLowerCase() == 'paid';

    if (isPaid) {
      return _paidAlertedOrderIds.add(key) ? _OrderAlertKind.paid : null;
    }
    return isNew ? _OrderAlertKind.received : null;
  }

  Future<void> clearRemainingOrders() async {
    if (orders.isEmpty) return;
    final ok = await MainStationClient.instance.clearAllOpenOrders();
    if (!ok) {
      AppHelperFunctions.showErrorSnackBar(
        'Could not reach Softverse main station.',
      );
    }
  }

  void onPageChanged(int index) => currentPage.value = index;

  Future<void> loadOrders({bool notifyNew = false}) async {
    final remoteOrders = await MainStationClient.instance.fetchOrders();
    for (final order in remoteOrders) {
      await KdsOrderStore.instance.upsert(order);
    }

    final kdsOrders = await KdsOrderStore.instance.listOpen();
    var anyReceived = false;
    var anyPaid = false;
    for (final order in kdsOrders) {
      switch (_registerOrder(order)) {
        case _OrderAlertKind.received:
          anyReceived = true;
        case _OrderAlertKind.paid:
          anyPaid = true;
        case null:
          break;
      }
    }
    if (notifyNew) {
      if (anyPaid) await _alertOrderPaid();
      if (anyReceived) await _alertOrderReceived();
    }
    orders.assignAll(
      kdsOrders.map((order) {
        final style = _cardStyleFor(order.createdAt);
        return OrderCardModel(
          orderId: order.orderId,
          customerName: order.customerName,
          subtitle: _clock(order.createdAt),
          table: order.tableName,
          actionLabel: order.status.capitalizeFirst ?? order.status,
          gradientColors: style.gradient,
          borderColor: style.border,
          textColor: style.text,
          items: order.items
              .map(
                (item) =>
                    OrderItemModel(name: item.name, quantity: item.quantity),
              )
              .toList(),
        );
      }),
    );
    remainingOrders.value = orders.length;
    if (currentPage.value >= orders.length) currentPage.value = 0;
  }

  Future<void> _handleStationEvent(MainStationEvent event) async {
    if (event.type == 'order_completed') {
      await KdsOrderStore.instance.markCompletedAny([
        event.id,
        ...event.keys,
      ], fallback: event.order);
      await _alertOrderCleared();
      await loadOrders();
      if (Get.isRegistered<RecallController>()) {
        await Get.find<RecallController>().loadHistory();
      }
      return;
    }

    if (event.type == 'orders_completed') {
      for (final key in event.keys) {
        await KdsOrderStore.instance.markCompleted(key);
      }
      if (event.keys.isNotEmpty) {
        final count = event.keys.length;
        await _alertOrderCleared(
          message: 'Cleared $count order${count == 1 ? '' : 's'}',
        );
      }
      await loadOrders();
      if (Get.isRegistered<RecallController>()) {
        await Get.find<RecallController>().loadHistory();
      }
      return;
    }

    final order = event.order;
    if (order == null) return;
    await KdsOrderStore.instance.upsert(order);
    switch (_registerOrder(order)) {
      case _OrderAlertKind.paid:
        await _alertOrderPaid();
      case _OrderAlertKind.received:
        await _alertOrderReceived();
      case null:
        break;
    }
    await loadOrders();
  }

  String _orderKey(KdsOrderModel order) {
    final id = order.id.isEmpty ? order.orderId : order.id;
    return id.isEmpty ? order.createdAt.toIso8601String() : id;
  }

  ({List<Color> gradient, Color border, Color text}) _cardStyleFor(
    DateTime createdAt,
  ) {
    final elapsed = DateTime.now().difference(createdAt).inSeconds;
    final settings = Get.find<SettingsController>();
    if (elapsed >= settings.dangerColorSeconds.value) {
      return (
        gradient: const [AppColors.dangerRed, AppColors.dangerRed],
        border: AppColors.dangerRed,
        text: Colors.white,
      );
    }
    if (elapsed >= settings.warningColorSeconds.value) {
      return (
        gradient: const [
          AppColors.accentOrangeStart,
          AppColors.accentOrangeEnd,
        ],
        border: AppColors.accentOrangeBorder,
        text: AppColors.darkText,
      );
    }
    return (
      gradient: const [AppColors.accentGreenStart, AppColors.accentGreenEnd],
      border: AppColors.accentGreenBorder,
      text: AppColors.darkText,
    );
  }

  String _clock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$hour.$minute.$second';
  }
}
