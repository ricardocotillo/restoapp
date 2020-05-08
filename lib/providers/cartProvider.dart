import 'package:flutter/material.dart';
import 'package:restaurante/models/cart.dart';
import 'package:restaurante/models/order.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> items = [];

  double get totalPrice {
    double amount = 0;
    items.forEach((item) => amount += item.price);
    return amount;
  }

  int get count => items.length;

  void clearCart() {
    items = [];
    notifyListeners();
  }

  void addItem(CartItem item) {
    items.add(item);
    notifyListeners();
  }

  List<OrderItem> get orderItems => items.map((item) {
        List<OrderItemChoice> orderItemChoices = [];
        item.item.extras.forEach((e) {
          orderItemChoices = orderItemChoices +
              e.choices
                  .map((c) => OrderItemChoice(
                      name: '${e.title}: ${c.name} ' +
                          (c.price != null ? '(+${c.price})' : ''),
                      price: c.price))
                  .toList();
        });
        return OrderItem(
          name: item.item.title,
          sku: item.item.sku,
          price: item.price,
          quantity: item.quantity,
          orderItemChoices: orderItemChoices,
        );
      }).toList();
}
