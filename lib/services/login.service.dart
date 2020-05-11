import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurante/models/login.model.dart';
import 'package:restaurante/services/api.dart';

class LoginService {
  Future<void> login(LoginModel data) async {
    Map<String, dynamic> json = await Http.post('/token/',
        body: jsonEncode(data), header: {'Content-Type': 'application/json'});
    setTokens(json);
  }
}

void setTokens(Map<String, dynamic> json) {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  _storage.write(key: 'access', value: json['access']);
  _storage.write(key: 'refresh', value: json['refresh']);
}
