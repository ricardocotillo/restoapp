import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/providers/cartProvider.dart';
import 'package:restaurante/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        // home: CheckoutView(),
        home: HomeView(),
      ),
    );
  }
}
