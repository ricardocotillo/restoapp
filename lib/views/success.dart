import 'package:flutter/material.dart';
import 'package:restaurante/views/home.dart';

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeView())),
              child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.check_circle_outline, size: 80.0, color: Colors.white,),
              Padding(padding: const EdgeInsets.all(10.0)),
              Text('Tu pedido ha sido recibido con éxito', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              Padding(padding: const EdgeInsets.all(10.0)),
              Text('Tap para regresar al inicio', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 11.0),),
            ],
          ),
        ),
      ),
    );
  }
}
