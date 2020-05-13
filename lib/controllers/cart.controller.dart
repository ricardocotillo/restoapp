import 'package:restaurante/models/cart.dart';
import 'package:restaurante/services/cart.service.dart';

class CartController {
  final CartService _cartService = CartService();
  Future<void> update(int id, List<CartItem> data) async {
    return _cartService.update(id, data);
  }
}