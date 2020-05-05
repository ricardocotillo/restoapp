import 'dart:convert';

import 'package:restaurante/models/order.dart';
import 'package:restaurante/services/api.dart';

class OrderService {
  Future<Order> create(Order order) async {
    final String data = jsonEncode(order);
    Map<String, dynamic> json = await Http.post('/orders/', body: data);
    return Order.fromJson(json);
  }
}