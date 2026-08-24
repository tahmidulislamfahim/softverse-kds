import 'dart:convert';
import 'dart:io';

import '../models/kds_order_model.dart';
import 'kds_order_store.dart';

class KdsLocalServer {
  KdsLocalServer._();

  static final instance = KdsLocalServer._();
  static const port = 8787;

  HttpServer? _server;

  Future<void> start() async {
    if (_server != null) return;
    _server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      port,
      shared: true,
    );
    _server!.listen(_handle);
  }

  Future<void> _handle(HttpRequest request) async {
    request.response.headers.contentType = ContentType.json;

    try {
      if (request.method == 'GET' && request.uri.path == '/health') {
        return await _json(request, {'success': true, 'status': 'ok'});
      }

      if (request.method == 'POST' && request.uri.path == '/kds/orders') {
        final body = await utf8.decoder.bind(request).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final order = KdsOrderModel.fromJson(data);

        if (order.orderId.isEmpty || order.items.isEmpty) {
          request.response.statusCode = HttpStatus.badRequest;
          return await _json(request, {
            'success': false,
            'message': 'orderId and items are required',
          });
        }

        await KdsOrderStore.instance.upsert(order);
        return await _json(request, {'success': true});
      }

      request.response.statusCode = HttpStatus.notFound;
      return await _json(request, {'success': false, 'message': 'Not found'});
    } catch (error) {
      request.response.statusCode = HttpStatus.badRequest;
      return await _json(request, {
        'success': false,
        'message': error.toString(),
      });
    }
  }

  Future<void> _json(HttpRequest request, Map<String, Object?> data) async {
    request.response.write(jsonEncode(data));
    await request.response.close();
  }
}
