import 'package:flutter/material.dart';
import 'components/body.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
      //body: Body(),
    );
  }
}
