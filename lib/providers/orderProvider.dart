import 'package:restaurante/models/order.dart';

class OrderProvider {
  String _name;
  String _phone;
  String _notes;
  String _address;
  String _apartmentNumber;
  int _paymentMethod;

  void savePersonal(String name, String phone, String notes) {
    _name = name;
    _phone = phone;
    _notes = notes;
  }

  void saveAddress(String address, String apartmentNumber) {
    _address = address;
    _apartmentNumber = apartmentNumber;
  }

  void savePayment(int paymentMethod) {
    _paymentMethod = paymentMethod;
  }

  Order getOrder() {
    Order order = Order(
        name: _name,
        phone: _phone,
        notes: _notes,
        address: _address,
        interior: _apartmentNumber);
    return order;
  }

  void clearOrder() {
    _name = null;
    _phone = null;
    _notes = null;
    _address = null;
    _apartmentNumber = null;
    _paymentMethod = null;
  }

  String get name => _name;
  String get phone => _phone;
  String get notes => _notes;
  String get address => _address;
  String get apartmentNumber => _apartmentNumber;
  int get paymentMethod => _paymentMethod;
}
