import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurante/common/messages.dart';
import 'package:restaurante/controllers/auth.controller.dart';
import 'package:restaurante/models/auth.model.dart';
import 'package:restaurante/views/home.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  validator: _usernameValidator,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Nombre de usuario',
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: _emailValidator,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                TextFormField(
                  controller: _passController,
                  validator: _passValidator,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                TextFormField(
                  validator: _repeatValidator,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Repetir Contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                FlatButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState.validate()) {
                      AuthController authController = AuthController();
                      setState(() {
                        _loading = true;
                      });
                      try {
                        authController.register(RegisterModel(
                          username: _usernameController.text,
                          email: _emailController.text,
                          password: _passController.text,
                        ));
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            e.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                      setState(() {
                        _loading = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeView()),
                          (route) => false);
                    }
                  },
                  child: Text('Registrarme'),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: _loading
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _usernameValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    return null;
  }

  String _emailValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }

    if (!isEmail(s)) {
      return FieldMessages.email;
    }

    return null;
  }

  String _passValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    return null;
  }

  String _repeatValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    if (s != _passController.text) {
      return FieldMessages.repeatPass;
    }
    return null;
  }
}
