import 'package:flutter/material.dart';
import 'components/body.dart';

class ManageAddressesScreen extends StatelessWidget {
  const ManageAddressesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}
