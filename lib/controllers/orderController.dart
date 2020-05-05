import 'package:restaurante/models/order.dart';
import 'package:restaurante/services/orderService.dart';

class OrderController {
  static final OrderService _orderService = OrderService();

  Future<Order> create(Order order) async {
    return _orderService.create(order);
  }
}