// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    interior: json['interior'] as String,
    total: _priceFromJson(json['total']),
    orderItems: (json['order_items'] as List)
        ?.map((e) =>
            e == null ? null : OrderItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    name: json['name'] as String,
    phone: json['phone'] as String,
    address: json['address'] as String,
    notes: json['notes'] as String,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'interior': instance.interior,
      'total': _priceToJson(instance.total),
      'notes': instance.notes,
      'order_items': instance.orderItems,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    sku: json['sku'] as String,
    name: json['name'] as String,
    price: _priceFromJson(json['price']),
    quantity: json['quantity'] as int,
    orderItemChoices: (json['order_item_choices'] as List)
        ?.map((e) => e == null
            ? null
            : OrderItemChoice.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalPrice: _priceFromJson(json['total_price']),
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'sku': instance.sku,
      'name': instance.name,
      'price': _priceToJson(instance.price),
      'total_price': _priceToJson(instance.totalPrice),
      'quantity': instance.quantity,
      'order_item_choices': instance.orderItemChoices,
    };

OrderItemChoice _$OrderItemChoiceFromJson(Map<String, dynamic> json) {
  return OrderItemChoice(
    name: json['name'] as String,
    price: _priceFromJson(json['price']),
  );
}

Map<String, dynamic> _$OrderItemChoiceToJson(OrderItemChoice instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': _priceToJson(instance.price),
    };
