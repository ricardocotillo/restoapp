import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categoria.g.dart';

@JsonSerializable(includeIfNull: false)
class Categoria {
  final int id;
  @JsonKey(name: 'name')
  final String title;
  final String image;
  @JsonKey(name: 'products')
  final List<Product> items;
  @JsonKey(ignore: true)
  bool isExpanded;

  Categoria(
      {this.id, this.title, this.image, this.items, this.isExpanded = false});

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      _$CategoriaFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriaToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Product {
  final int id;
  final String image;
  @JsonKey(ignore: true)
  final Image thumbnail;
  @JsonKey(name: 'name')
  final String title;
  final String sku;
  final String description;
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;
  @JsonKey(name: 'choice_types')
  List<Extra> extras;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.image,
      this.thumbnail,
      this.extras,
      this.sku});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Extra {
  final int id;
  @JsonKey(name: 'name')
  final String title;
  final List<Choice> choices;
  @JsonKey(name: 'is_multiple')
  final bool isMultiple;
  Extra({this.id, this.title, this.choices, this.isMultiple = true});

  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Choice {
  final int id;
  final String name;
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;
  bool chosen;

  Choice({this.id, this.name, this.price, this.chosen = false});

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
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
