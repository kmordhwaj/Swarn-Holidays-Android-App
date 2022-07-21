import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/general/categories.dart';
import 'package:provider/provider.dart';
import 'ecom/screens/home/shop_screen.dart';
import 'general/bottomnavigation.dart';
import 'general/profilescreen.dart';
import 'general/wishlist.dart';
import 'models/user_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController homePageController = PageController();
  String? currentUserId;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: homePageController,
          children: [
            ShopScreen(currentUserId: currentUserId),
            const Categories(),
            const Wishlist(),
            ProfileScreen(
              profileId: currentUserId,
            ),
          ],
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        BottomNavigationScreen(currentUserId: currentUserId)
      ],
    ));
  }
}
