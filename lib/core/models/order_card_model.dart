import 'package:flutter/material.dart';

class OrderItemModel {
  final String name;
  final int quantity;

  const OrderItemModel({required this.name, required this.quantity});
}

class OrderCardModel {
  final String orderId;
  final String customerName;
  final String subtitle;
  final String table;
  final String actionLabel;
  final List<Color> gradientColors;
  final Color borderColor;
  final Color textColor;
  final List<OrderItemModel> items;

  const OrderCardModel({
    required this.orderId,
    required this.customerName,
    required this.subtitle,
    required this.table,
    required this.actionLabel,
    required this.gradientColors,
    required this.borderColor,
    required this.textColor,
    required this.items,
  });
}
