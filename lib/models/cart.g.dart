// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    quantity: json['quantity'] as int,
    price: (json['price'] as num)?.toDouble(),
    item: json['item'] == null
        ? null
        : Product.fromJson(json['item'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'item': instance.item,
      'quantity': instance.quantity,
      'price': instance.price,
    };
