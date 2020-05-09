import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurante/models/cart.dart';
import 'package:restaurante/models/order.dart';

class CartProvider with ChangeNotifier {
  CartProvider() {
    _fetchCart();
  }

  final FlutterSecureStorage _storage = new FlutterSecureStorage();
  List<CartItem> _items = [];

  Future<void> _fetchCart() async {
    final String cartData = await _storage.read(key: 'cart');
    final List<dynamic> cart = jsonDecode(cartData);
    final List<CartItem> cartItems =
        cart.map((e) => CartItem.fromJson(e)).toList();
    _items = cartItems;
    notifyListeners();
  }

  double get totalPrice {
    double amount = 0;
    _items.forEach((item) => amount += item.price);
    return amount;
  }

  int get count => _items.length;

  List<CartItem> get items => _items;

  void clearCart() async {
    _items = [];
    await _storage.delete(key: 'cart');
    notifyListeners();
  }

  void addItem(CartItem item) async {
    _items.add(item);
    notifyListeners();
    await _storage.write(key: 'cart', value: jsonEncode(_items));
  }

  void deleteItem(int i) async {
    _items.removeAt(i);
    notifyListeners();
    // await _storage.write(key: 'cart', value: jsonEncode(_items));
  }

  List<OrderItem> get orderItems => _items.map((item) {
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
