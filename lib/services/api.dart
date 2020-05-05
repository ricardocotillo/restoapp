import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurante/common/messages.dart';

class Api {
  // static final String base = 'http://10.0.2.2:8000/api';
  static final String base = 'http://demo.cotillo.tech/api';
  static Map<String, String> get contentHeader =>
      {'Content-Type': 'application/json'};
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

  static Future<dynamic> post(String url, {dynamic body}) async {
    http.Response res = await http.post(Api.base + url, body: body, headers: Api.contentHeader);
    String b =  Utf8Decoder().convert(res.bodyBytes);
    dynamic json = jsonDecode(b);
    if (res.statusCode >= 400) {
      String message;
      message = json['detail'] ??
          (json as Map).values.firstWhere((e) => e != null)[0];
      throw message;
    }
    return json;
  }
}