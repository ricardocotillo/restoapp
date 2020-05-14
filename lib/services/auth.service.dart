import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurante/models/auth.model.dart';
import 'package:restaurante/services/api.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Future<void> login(LoginModel data) async {
    Map<String, dynamic> json = await Http.post('/token/',
        body: jsonEncode(data), header: {'Content-Type': 'application/json'});
    setTokens(json);
  }

  Future<void> register(RegisterModel data) async {
    Map<String, dynamic> json = await Http.post('/register/',
        body: jsonEncode(data), header: {'Content-Type': 'application/json'});
    setTokens(json['token']);
  }

  Future<void> logout() async {
    return _storage.deleteAll();
  }

  void setTokens(Map<String, dynamic> json) {
    _storage.write(key: 'access', value: json['access']);
    _storage.write(key: 'refresh', value: json['refresh']);
  }
}
