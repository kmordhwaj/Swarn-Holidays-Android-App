import 'package:flutter/material.dart';
import 'components/body.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Your Cart',
        style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Colors.black),
      )),
      body: const Body(),
    );
  }
}
