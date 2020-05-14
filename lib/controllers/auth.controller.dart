import 'package:restaurante/models/auth.model.dart';
import 'package:restaurante/services/auth.service.dart';

class AuthController {
  static final AuthService _authService = AuthService();
  Future<void> login(LoginModel data) async {
    return _authService.login(data);
  }

  Future<void> register(RegisterModel data) async {
    return _authService.register(data);
  }

  Future<void> logout() async {
    return _authService.logout();
  }
}
