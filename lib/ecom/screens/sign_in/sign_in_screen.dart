import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}
