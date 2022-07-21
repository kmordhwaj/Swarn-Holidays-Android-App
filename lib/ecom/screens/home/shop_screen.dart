import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';
import 'components/home_screen_drawer.dart';

class ShopScreen extends StatelessWidget {
  final String? currentUserId;
  const ShopScreen({
    Key? key,
    this.currentUserId,
  }) : super(key: key);
  static const String routeName = "/shop";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(currentUserId: currentUserId),
      drawer: HomeScreenDrawer(currentUserId: currentUserId),
    );
  }
}
