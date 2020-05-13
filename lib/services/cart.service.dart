import 'dart:convert';

import 'package:restaurante/models/cart.dart';
import 'package:restaurante/services/api.dart';

class CartService {
  Future<void> update(int id, List<CartItem> data) async {
    final Map<String, dynamic> body = {'data': jsonEncode(data)};
    await Http.patch('/carts/$id/', body: body);
  }
}
