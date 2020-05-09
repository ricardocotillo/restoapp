import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/models/categoria.dart';
import 'package:restaurante/models/cart.dart';
import 'package:restaurante/providers/cartProvider.dart';
import 'package:restaurante/views/checkout.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final EdgeInsets _padding = const EdgeInsets.all(15.0);
  final TextStyle _textStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  List<String> getExtras(Product item) {
    List<String> extraDesc = [];
    item.extras
        .where((e) => e.choices.any((c) => c.chosen))
        .forEach((e) => e.choices.forEach((c) {
              if (c.chosen) {
                extraDesc.add(
                    '${e.title}: ${c.name} (+${c.price != null ? c.price : ""})');
              }
            }));
    return extraDesc;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final items = _cartProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi pedido'),
      ),
      body: _cartProvider.count > 0
          ? ListView(
              children: List.generate(
              items.length,
              (index) => ListTile(
                dense: true,
                trailing: Text(
                  items[index].price.toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Text('1x'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items[index].item.extras != null
                      ? getExtras(items[index].item)
                          .map((e) => Text(e))
                          .toList()
                      : [],
                ),
                title: Text(items[index].item.title),
              ),
            ))
          : Center(
              child: Text(
              'Tu carrito está vacío',
              style: TextStyle(
                  color: Colors.grey[400], fontStyle: FontStyle.italic),
            )),
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: _padding,
              child: Text(
                _cartProvider.totalPrice.toStringAsFixed(2),
                style: _textStyle,
              ),
            ),
            MaterialButton(
                child: Text(
                  _cartProvider.count > 0 ? 'Agregar a pedido' : '',
                  style: _textStyle,
                ),
                onPressed: _cartProvider.count > 0
                    ? () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckoutView()));
                      }
                    : null)
          ],
        ),
      ),
    );
  }
}
