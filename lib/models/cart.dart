import 'package:json_annotation/json_annotation.dart';
import 'package:restaurante/models/categoria.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartItem {
  final Product item;
  int quantity;
  double price;
  @JsonKey(name: 'total_price')
  double totalPrice;

  CartItem({this.quantity = 1, this.price, this.item})
      : totalPrice = quantity * price;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
