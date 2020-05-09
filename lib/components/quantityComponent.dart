import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuantityComponent extends StatelessWidget {
  final int quantity;
  final VoidCallback increment;
  final VoidCallback decrement;
  const QuantityComponent(
      {Key key, this.quantity, this.increment, this.decrement})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonTheme(
          height: 20.0,
          minWidth: 20.0,
          child: FlatButton(
            onPressed: decrement,
            child: Icon(
              FontAwesomeIcons.minus,
              size: 8.0,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(0),
            color: Colors.grey,
            disabledColor: Colors.grey[400],
          ),
        ),
        Text(quantity.toString()),
        ButtonTheme(
          height: 20.0,
          minWidth: 20.0,
          child: FlatButton(
            onPressed: increment,
            child: Icon(
              FontAwesomeIcons.plus,
              size: 8.0,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(0),
            color: Colors.grey,
            disabledColor: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
