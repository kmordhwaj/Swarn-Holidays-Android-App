import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangePhoneScreen extends StatelessWidget {
  const ChangePhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}
