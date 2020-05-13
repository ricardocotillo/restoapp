import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/components/paymentComponent.dart';
import 'package:restaurante/components/addressComponent.dart';
import 'package:restaurante/components/personalComponent.dart';
import 'package:restaurante/controllers/orderController.dart';
import 'package:restaurante/models/order.dart';
import 'package:restaurante/providers/cartProvider.dart';
import 'package:restaurante/providers/orderProvider.dart';
import 'package:restaurante/views/success.dart';

class CheckoutView extends StatefulWidget {
  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView>
    with TickerProviderStateMixin {
  final OrderController _orderController = OrderController();
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Provider(
          create: (_) => OrderProvider(),
          child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                PersonalComponent(
                  onConfirm: _onConfirm,
                ),
                AddressComponent(
                  onConfirm: _onConfirm,
                ),
                PaymentComponent(
                  onConfirm: (Order order) async {
                    order.total = _cartProvider.totalPrice;
                    order.orderItems = _cartProvider.orderItems;
                    await _orderController.create(order);
                    _cartProvider.clearCart();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SuccessView()),
                        (route) => false);
                  },
                ),
              ]),
        ),
      ),
    );
  }

  void _onConfirm() {
    _controller.animateTo(_controller.index + 1);
  }
}
