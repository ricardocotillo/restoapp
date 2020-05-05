import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Categoria.g.dart';

@JsonSerializable(includeIfNull: false)
class Categoria {
  @JsonKey(name: 'name')
  final String title;
  final String image;
  @JsonKey(name: 'products')
  final List<Item> items;
  @JsonKey(ignore: true)
  bool isExpanded;

  Categoria({this.title, this.image, this.items, this.isExpanded = false});

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      _$CategoriaFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriaToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Item {
  final String image;
  @JsonKey(ignore: true)
  final Image thumbnail;
  @JsonKey(name: 'name')
  final String title;
  final String sku;
  final String description;
  final double price;
  @JsonKey(name: 'choice_types')
  List<Extra> extras;

  Item(
      {this.title,
      this.description,
      this.price,
      this.image,
      this.thumbnail,
      this.extras,
      this.sku});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Extra {
  @JsonKey(name: 'name')
  final String title;
  final List<Choice> choices;
  @JsonKey(name: 'is_multiple')
  final bool isMultiple;
  Extra({this.title, this.choices, this.isMultiple = true});

  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Choice {
  final String name;
  final double price;
  bool chosen;

  Choice({this.name, this.price, this.chosen = false});

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
