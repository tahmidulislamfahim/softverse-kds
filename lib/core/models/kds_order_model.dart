class KdsOrderModel {
  final String id;
  final String orderId;
  final String customerName;
  final String tableName;
  final String status;
  final DateTime createdAt;
  final List<KdsOrderItemModel> items;

  const KdsOrderModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.tableName,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory KdsOrderModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'];
    final itemsJson = json['items'];

    return KdsOrderModel(
      id: _text(json['id'] ?? json['checkoutId'] ?? json['orderId']),
      orderId: _text(json['orderId'] ?? json['orderNumber'] ?? json['id']),
      customerName: _text(
        json['customerName'] ??
            (customer is Map ? customer['name'] : null) ??
            'Not Registered',
      ),
      tableName: _text(json['tableName'] ?? json['table'] ?? 'No Table'),
      status: _text(json['status'] ?? 'ongoing'),
      createdAt: DateTime.tryParse(_text(json['createdAt'])) ?? DateTime.now(),
      items: itemsJson is List
          ? itemsJson
                .whereType<Map>()
                .map(
                  (item) =>
                      KdsOrderItemModel.fromJson(item.cast<String, dynamic>()),
                )
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'customerName': customerName,
    'tableName': tableName,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((item) => item.toJson()).toList(),
  };

  static String _text(Object? value) => value?.toString().trim() ?? '';
}

class KdsOrderItemModel {
  final String name;
  final int quantity;

  const KdsOrderItemModel({required this.name, required this.quantity});

  factory KdsOrderItemModel.fromJson(Map<String, dynamic> json) {
    return KdsOrderItemModel(
      name: (json['name'] ?? json['itemName'] ?? json['productName'] ?? 'Item')
          .toString(),
      quantity:
          int.tryParse((json['quantity'] ?? json['qty'] ?? 1).toString()) ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};
}
