import 'package:flutter/material.dart';

import 'components/body.dart';

class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}
