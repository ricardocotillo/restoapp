import 'package:json_annotation/json_annotation.dart';
import 'package:restaurante/models/categoria.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartItem {
  final Product item;
  final int quantity;
  final double price;

  CartItem({this.quantity = 1, this.price, this.item});

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
