class LoginModel {
  final String username;
  final String password;

  LoginModel({this.username, this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class RegisterModel {
  final String username;
  final String email;
  final String password;

  RegisterModel({this.username, this.email, this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}
