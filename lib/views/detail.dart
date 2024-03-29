import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/components/multipleChoice.dart';
import 'package:restaurante/controllers/cart.controller.dart';
import 'package:restaurante/models/categoria.dart';
import 'package:restaurante/models/cart.dart';
import 'package:restaurante/providers/cartProvider.dart';

class DetailView extends StatefulWidget {
  final Product item;
  DetailView({this.item});
  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  double _price;

  List<Extra> _extras;

  int _quantity = 1;

  final TextStyle _textStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  final EdgeInsets _padding = const EdgeInsets.all(15.0);

  @override
  void initState() {
    super.initState();
    _price = widget.item.price;
    _extras = widget.item.extras.where((e) => e.choices.length > 0).toList();
  }

  double getPrice() {
    if (_extras == null) {
      return _price;
    }
    double amount = _price;
    _extras.forEach((e) => e.choices.forEach((c) {
          if (c.chosen && c.price != null) {
            amount += c.price;
          }
        }));
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    CartProvider _cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.item.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                  SizedBox(
                    width: size.width,
                    height: 140,
                    child: FittedBox(
                      child: Image.network(widget.item.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: Text(widget.item.description ?? ''),
                  ),
                ] +
                (_extras != null
                    ? List.generate(
                        _extras.length,
                        (int index) => MultipleChoice(
                              multipleOnChange: (int i, bool v) {
                                setState(() {
                                  _extras[index].choices[i].chosen = v;
                                });
                              },
                              radioOnChange: (int current, int old) {
                                setState(() {
                                  _extras[index].choices[old].chosen = false;
                                  _extras[index].choices[current].chosen = true;
                                });
                              },
                              isRadio: !_extras[index].isMultiple,
                              title: _extras[index].title,
                              choices: _extras[index].choices,
                            ))
                    : []) +
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 40.0,
                        height: 40.0,
                        child: FlatButton(
                          child: Icon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                            size: 12.0,
                          ),
                          color: Colors.grey,
                          disabledColor: Colors.grey[400],
                          onPressed: _quantity > 1 ? _decreaseQuantity : null,
                        ),
                      ),
                      Text(_quantity.toString()),
                      ButtonTheme(
                        minWidth: 40.0,
                        height: 40.0,
                        child: FlatButton(
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 12.0,
                          ),
                          color: Colors.grey,
                          onPressed: _increaseQuantity,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 25.0))
                ],
          ),
        ),
        bottomSheet: Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: _padding,
                child: Text(
                  (getPrice() * _quantity).toStringAsFixed(2),
                  style: _textStyle,
                ),
              ),
              MaterialButton(
                  child: Text(
                    'Agregar a pedido',
                    style: _textStyle,
                  ),
                  onPressed: () => _addToOrder(_cartProvider))
            ],
          ),
        ));
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      _quantity--;
    });
  }

  void _addToOrder(CartProvider cartProvider) async {
    final CartItem cartItem = CartItem(
      quantity: _quantity,
      price: getPrice(),
      item: Product(
          image: widget.item.image,
          thumbnail: widget.item.thumbnail,
          title: widget.item.title,
          sku: widget.item.sku,
          description: widget.item.description,
          price: widget.item.price,
          extras: _extras
              .where((e) => e.choices.any((c) => c.chosen))
              .map((e) => Extra(
                  title: e.title,
                  isMultiple: e.isMultiple,
                  choices: e.choices.where((c) => c.chosen).toList()))
              .toList()),
    );

    cartProvider.addItem(cartItem);
    Navigator.of(context).pop();
  }
}
