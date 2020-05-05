import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/models/order.dart';
import 'package:restaurante/providers/orderProvider.dart';

class PaymentComponent extends StatefulWidget {
  final Function(Order) onConfirm;

  const PaymentComponent({Key key, this.onConfirm}) : super(key: key);
  @override
  _PaymentComponentState createState() => _PaymentComponentState();
}

class _PaymentComponentState extends State<PaymentComponent> {
  int _groupValue = 1;
  final TextStyle _titleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final OrderProvider _orderProvider = Provider.of<OrderProvider>(context); 
    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height,
          color: Colors.transparent,
        ),
        Container(
          height: size.height / 2,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/pay.jpg'), fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0))),
            height: size.height / 2 + 25,
            width: size.width,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Escoge un método de pago',
                  style: _titleTextStyle,
                ),
                RadioListTile(
                    dense: true,
                    selected: true,
                    title: Text('Contra entrega'),
                    value: 1,
                    groupValue: _groupValue,
                    secondary: Icon(FontAwesomeIcons.moneyBillWave),
                    onChanged: (int v) {
                      setState(() {
                        _groupValue = v;
                      });
                    }),
                Padding(padding: const EdgeInsets.all(5.0)),
                RaisedButton(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  onPressed: () {
                    _orderProvider.savePayment(_groupValue);
                    Order order = _orderProvider.getOrder();
                    _orderProvider.clearOrder();
                    widget.onConfirm(order);
                  },
                  child: Text('Confirmar'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
