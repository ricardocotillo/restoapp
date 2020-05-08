// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categoria _$CategoriaFromJson(Map<String, dynamic> json) {
  return Categoria(
    title: json['name'] as String,
    image: json['image'] as String,
    items: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoriaToJson(Categoria instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.title);
  writeNotNull('image', instance.image);
  writeNotNull('products', instance.items);
  return val;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    title: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num)?.toDouble(),
    image: json['image'] as String,
    extras: (json['choice_types'] as List)
        ?.map(
            (e) => e == null ? null : Extra.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sku: json['sku'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image', instance.image);
  writeNotNull('name', instance.title);
  writeNotNull('sku', instance.sku);
  writeNotNull('description', instance.description);
  writeNotNull('price', instance.price);
  writeNotNull('choice_types', instance.extras);
  return val;
}

Extra _$ExtraFromJson(Map<String, dynamic> json) {
  return Extra(
    title: json['name'] as String,
    choices: (json['choices'] as List)
        ?.map((e) =>
            e == null ? null : Choice.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isMultiple: json['is_multiple'] as bool,
  );
}

Map<String, dynamic> _$ExtraToJson(Extra instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.title);
  writeNotNull('choices', instance.choices);
  writeNotNull('is_multiple', instance.isMultiple);
  return val;
}

Choice _$ChoiceFromJson(Map<String, dynamic> json) {
  return Choice(
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    chosen: json['chosen'] as bool,
  );
}

Map<String, dynamic> _$ChoiceToJson(Choice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('price', instance.price);
  writeNotNull('chosen', instance.chosen);
  return val;
}
