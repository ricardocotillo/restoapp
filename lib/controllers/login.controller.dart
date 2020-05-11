import 'package:restaurante/models/login.model.dart';
import 'package:restaurante/services/login.service.dart';

class LoginController {
  static final LoginService _loginService = LoginService();
  Future<void> login(LoginModel data) async {
    return _loginService.login(data);
  }
}
