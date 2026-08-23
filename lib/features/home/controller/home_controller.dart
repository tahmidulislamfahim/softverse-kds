import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/models/kds_order_model.dart';
import '../../../core/models/order_card_model.dart';
import '../../../core/services/kds_order_store.dart';
import '../../../core/services/main_station_client.dart';
import '../../../core/utils/constants/colors.dart';

class HomeController extends GetxController {
  final currentPage = 0.obs;
  final remainingOrders = 0.obs;
  final orders = <OrderCardModel>[].obs;

  late final PageController pageController;
  Timer? _poller;
  StreamSubscription<MainStationEvent>? _orderStream;
  final _seenOrderIds = <String>{};

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

  void onPageChanged(int index) => currentPage.value = index;

  Future<void> loadOrders({bool notifyNew = false}) async {
    final remoteOrders = await MainStationClient.instance.fetchOrders();
    for (final order in remoteOrders) {
      await KdsOrderStore.instance.upsert(order);
    }

    final kdsOrders = await KdsOrderStore.instance.listOpen();
    if (notifyNew &&
        kdsOrders.any((order) => !_seenOrderIds.contains(_orderKey(order)))) {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.mediumImpact();
    }
    _seenOrderIds.addAll(kdsOrders.map(_orderKey));
    orders.assignAll(
      kdsOrders.map(
        (order) => OrderCardModel(
          orderId: order.orderId,
          customerName: order.customerName,
          subtitle: _clock(order.createdAt),
          table: order.tableName,
          actionLabel: order.status.capitalizeFirst ?? order.status,
          gradientColors: const [
            AppColors.accentGreenStart,
            AppColors.accentGreenEnd,
          ],
          borderColor: AppColors.accentGreenBorder,
          textColor: AppColors.darkText,
          items: order.items
              .map(
                (item) =>
                    OrderItemModel(name: item.name, quantity: item.quantity),
              )
              .toList(),
        ),
      ),
    );
    remainingOrders.value = orders.length;
    if (currentPage.value >= orders.length) currentPage.value = 0;
  }

  Future<void> _handleStationEvent(MainStationEvent event) async {
    if (event.type == 'order_completed') {
      await KdsOrderStore.instance.markCompleted(
        event.id,
        fallback: event.order,
      );
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.mediumImpact();
      await loadOrders();
      return;
    }

    final order = event.order;
    if (order == null) return;
    await KdsOrderStore.instance.upsert(order);
    final key = _orderKey(order);
    if (_seenOrderIds.add(key)) {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.mediumImpact();
    }
    await loadOrders();
  }

  String _orderKey(KdsOrderModel order) {
    final id = order.id.isEmpty ? order.orderId : order.id;
    return id.isEmpty ? order.createdAt.toIso8601String() : id;
  }

  String _clock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$hour.$minute.$second';
  }
}
