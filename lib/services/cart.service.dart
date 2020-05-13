import 'dart:convert';

import 'package:restaurante/models/cart.dart';
import 'package:restaurante/services/api.dart';

class CartService {
  Future<void> update(int id, List<CartItem> data) async {
    final String body = jsonEncode({'data': data});
    await Http.patch('/carts/$id/', body: body);
  }
}
