import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/kds_order_model.dart';
import 'storage_service.dart';

class MainStationEvent {
  final String type;
  final String id;
  final KdsOrderModel? order;

  const MainStationEvent({required this.type, this.id = '', this.order});
}

class MainStationClient {
  MainStationClient._();

  static final instance = MainStationClient._();
  static const port = 8787;

  static String normalize(String value) {
    var input = value.trim();
    if (input.isEmpty) return '';
    if (!input.startsWith('http://') && !input.startsWith('https://')) {
      input = 'http://$input';
    }

    final uri = Uri.parse(input);
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : port,
    ).toString();
  }

  Future<bool> test(String baseUrl) async {
    final url = normalize(baseUrl);
    if (url.isEmpty) return false;

    try {
      final response = await http
          .get(Uri.parse('$url/health'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<List<KdsOrderModel>> fetchOrders() async {
    final baseUrl = StorageService.mainStationUrl;
    if (baseUrl == null || baseUrl.isEmpty) return const [];

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/kds/orders'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final orders = data['orders'];
      return orders is List
          ? orders
                .whereType<Map>()
                .map(
                  (order) =>
                      KdsOrderModel.fromJson(order.cast<String, dynamic>()),
                )
                .toList()
          : const [];
    } catch (_) {
      return const [];
    }
  }

  Stream<MainStationEvent> watchOrders() async* {
    final baseUrl = StorageService.mainStationUrl;
    if (baseUrl == null || baseUrl.isEmpty) return;

    final httpUri = Uri.parse(baseUrl);
    final socketUri = httpUri.replace(
      scheme: httpUri.scheme == 'https' ? 'wss' : 'ws',
      path: '/kds/orders/stream',
    );

    while (true) {
      try {
        final socket = await WebSocket.connect(
          socketUri.toString(),
        ).timeout(const Duration(seconds: 3));
        await for (final raw in socket) {
          final data = jsonDecode(raw.toString()) as Map<String, dynamic>;
          final type = data['type']?.toString() ?? '';
          if (type != 'order' && type != 'order_completed') continue;
          final order = data['order'];
          if (type == 'order' && order is Map) {
            yield MainStationEvent(
              type: type,
              order: KdsOrderModel.fromJson(order.cast<String, dynamic>()),
            );
          } else if (type == 'order_completed') {
            yield MainStationEvent(
              type: type,
              id: data['id']?.toString() ?? '',
              order: order is Map
                  ? KdsOrderModel.fromJson(order.cast<String, dynamic>())
                  : null,
            );
          }
        }
      } catch (_) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}
