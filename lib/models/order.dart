import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'order.g.dart';

@JsonSerializable()
class Order {
  final String name;
  final String phone;
  final String address;
  final String interior;
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  double total;
  final String notes;
  @JsonKey(name: 'order_items')
  List<OrderItem> orderItems;
  Order(
      {this.interior,
      this.total,
      this.orderItems,
      this.name,
      this.phone,
      this.address,
      this.notes});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItem {
  final String sku;
  final String name;
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;
  @JsonKey(name: 'total_price', fromJson: _priceFromJson, toJson: _priceToJson)
  final double totalPrice;
  final int quantity;
  @JsonKey(name: 'order_item_choices')
  final List<OrderItemChoice> orderItemChoices;

  OrderItem(
      {this.sku,
      this.name,
      this.price,
      this.quantity,
      this.orderItemChoices,
      this.totalPrice});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class OrderItemChoice {
  final String name;
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;

  OrderItemChoice({this.name, this.price});

  factory OrderItemChoice.fromJson(Map<String, dynamic> json) =>
      _$OrderItemChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemChoiceToJson(this);
}

_priceFromJson(dynamic json) {
  if (json is String) {
    return double.parse(json);
  }
  return json as double;
}

_priceToJson(double price) {
  return price.toStringAsFixed(2);
}
