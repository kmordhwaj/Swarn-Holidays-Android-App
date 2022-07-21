import 'package:new_swarn_holidays/ecom/screens/home/shop_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/sign_in/sign_in_screen.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';

class AuthentificationWrapper extends StatelessWidget {
  static const String routeName = "/authentification_wrapper";

  const AuthentificationWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthentificationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ShopScreen();
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}
