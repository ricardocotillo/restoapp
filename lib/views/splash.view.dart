import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurante/views/home.dart';
import 'package:restaurante/views/login.view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _storage.read(key: 'access').then((accessToken) {
      if (accessToken != null) {
        return Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeView()));
      }
      return Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              width: 250,
              height: 250,
              child: Image.asset('assets/img/resto.png'),
            ),
          ),
          SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        ],
      )),
    );
  }
}
