import 'package:flutter_test/flutter_test.dart';
import 'package:softverse_kds/core/models/kds_order_model.dart';

void main() {
  test('parses POS order payload into KDS order', () {
    final order = KdsOrderModel.fromJson({
      'checkoutId': 'checkout-1',
      'orderNumber': 'POS-1',
      'customer': {'name': 'Abs Corporation'},
      'table': 'Table-2',
      'status': 'ongoing',
      'createdAt': '2026-08-22T10:00:00.000Z',
      'items': [
        {'productName': 'Burger', 'qty': 2},
      ],
    });

    expect(order.id, 'checkout-1');
    expect(order.orderId, 'POS-1');
    expect(order.customerName, 'Abs Corporation');
    expect(order.tableName, 'Table-2');
    expect(order.items.single.name, 'Burger');
    expect(order.items.single.quantity, 2);
  });
}
