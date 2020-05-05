import 'package:restaurante/models/Categoria.dart';

class CartItem {
  final Item item;
  final int quantity;
  final double price;

  CartItem({this.quantity = 1, this.price, this.item});
}
