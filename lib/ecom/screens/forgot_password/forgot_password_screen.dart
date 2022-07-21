import 'package:flutter/material.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = "/forgot_password";

  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}