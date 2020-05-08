
import 'package:restaurante/models/categoria.dart';

class CartItem {
  final Product item;
  final int quantity;
  final double price;

  CartItem({this.quantity = 1, this.price, this.item});
}
