import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/providers/cartProvider.dart';

class CartIcon extends StatelessWidget {
  final VoidCallback onTap;

  CartIcon({this.onTap});
  @override
  Widget build(BuildContext context) {
    CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60.0,
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: 40.0,
                child: Icon(Icons.shopping_basket, size: 25.0,),
              ),
              _cartProvider.count > 0 ? Positioned(
                  top: -2.0,
                  right: 2.0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      _cartProvider.count.toString(),
                      style: TextStyle(fontSize: 9.0),
                    ),
                  )) : null
            ].where((e) => e != null).toList(),
          ),
        ));
  }
}
