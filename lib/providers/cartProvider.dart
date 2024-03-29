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
    if (cartData != null) {
      final List<dynamic> cart = jsonDecode(cartData);
      final List<CartItem> cartItems =
          cart.map((e) => CartItem.fromJson(e)).toList();
      _items = cartItems;
      notifyListeners();
    }
  }

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

  void deleteItem(int index) async {
    _items.removeAt(index);
    notifyListeners();
    await _storage.write(key: 'cart', value: jsonEncode(_items));
  }

  void increment(int index) async {
    _items[index].quantity++;
    _items[index].totalPrice = _items[index].price * _items[index].quantity;
    notifyListeners();
    await _storage.write(key: 'cart', value: jsonEncode(_items));
  }

  void decrement(int index) async {
    _items[index].quantity--;
    _items[index].totalPrice = _items[index].price * _items[index].quantity;
    notifyListeners();
    await _storage.write(key: 'cart', value: jsonEncode(_items));
  }

  double get totalPrice {
    double amount = 0;
    _items.forEach((item) => amount += item.totalPrice);
    return amount;
  }

  int get count => _items.fold<int>(
      0, (previousValue, element) => previousValue + element.quantity);

  List<CartItem> get items => _items;

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
          totalPrice: item.totalPrice,
          quantity: item.quantity,
          orderItemChoices: orderItemChoices,
        );
      }).toList();
}
