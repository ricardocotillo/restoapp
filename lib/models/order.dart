import 'package:json_annotation/json_annotation.dart';
part 'order.g.dart';

@JsonSerializable()
class Order {
  final String name;
  final String phone;
  final String address;
  final String interior;
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
  final double price;
  final int quantity;
  @JsonKey(name: 'order_item_choices')
  final List<OrderItemChoice> orderItemChoices;

  OrderItem(
      {this.sku, this.name, this.price, this.quantity, this.orderItemChoices});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class OrderItemChoice {
  final String name;
  final double price;

  OrderItemChoice({this.name, this.price});

  factory OrderItemChoice.fromJson(Map<String, dynamic> json) =>
      _$OrderItemChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemChoiceToJson(this);
}
