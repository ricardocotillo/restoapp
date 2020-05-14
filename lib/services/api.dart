import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:restaurante/common/messages.dart';

class Api {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static final String base = 'http://10.0.2.2:8000/api';
  // static final String base = 'http://demo.cotillo.tech/api';
  static Future<Map<String, String>> get contentHeader async => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _storage.read(key: 'access')}'
      };
}

class Http {
  static Future<dynamic> get(String url) async {
    http.Response res = await http.get(Api.base + url);
    if (res.statusCode >= 500) {
      return throw ErrorMessages.serverError;
    }
    String b = Utf8Decoder().convert(res.bodyBytes);
    dynamic json = jsonDecode(b);
    if (res.statusCode >= 400) {
      String message;
      message = json['detail'] ??
          (json as Map).values.firstWhere((e) => e != null)[0];
      throw message;
    }
    return json;
  }

  static Future<dynamic> post(String url,
      {dynamic body, Map<String, String> header}) async {
    http.Response res = await http.post(Api.base + url,
        body: body, headers: header ?? await Api.contentHeader);
    print(res.body);
    if (res.statusCode >= 500) {
      throw ErrorMessages.serverError;
    }
    String b = Utf8Decoder().convert(res.bodyBytes);
    dynamic json = jsonDecode(b);
    if (res.statusCode >= 400) {
      String message;
      message = json['detail'] ??
          (json as Map).values.firstWhere((e) => e != null)[0];
      throw message;
    }
    return json;
  }

  static Future<dynamic> put(String url, {dynamic body}) async {
    http.Response res = await http.put(Api.base + url,
        body: body, headers: await Api.contentHeader);
    if (res.statusCode >= 500) {
      throw ErrorMessages.serverError;
    }
    String b = Utf8Decoder().convert(res.bodyBytes);
    dynamic json = jsonDecode(b);
    if (res.statusCode >= 400) {
      String message = json['detail'] ??
          (json as Map).values.firstWhere((e) => e != null)[0];
      throw message;
    }
    return json;
  }

  static Future<dynamic> patch(String url, {dynamic body}) async {
    http.Response res = await http.patch(Api.base + url,
        body: body, headers: await Api.contentHeader);
    if (res.statusCode >= 500) {
      throw ErrorMessages.serverError;
    }
    String b = Utf8Decoder().convert(res.bodyBytes);
    dynamic json = jsonDecode(b);
    if (res.statusCode >= 400) {
      String message = json['detail'] ??
          (json as Map).values.firstWhere((e) => e != null)[0];
      throw message;
    }
    return json;
  }
}
