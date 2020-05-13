import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CustomerModel {
  final int id;
  final String username;
  final String address;
  final String interior;
  final String locality;
  final String city;

  CustomerModel({
    this.id,
    this.username,
    this.address,
    this.interior,
    this.locality,
    this.city,
  });
}
