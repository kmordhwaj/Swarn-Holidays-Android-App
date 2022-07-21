import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/general/categories.dart';
import 'package:new_swarn_holidays/general/profilescreen.dart';
import 'package:new_swarn_holidays/general/wishlist.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../ecom/screens/home/shop_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  final String? currentUserId;
  const BottomNavigationScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        ShopScreen(
          currentUserId: widget.currentUserId,
        ),
        const Categories(),
        const Wishlist(),
        ProfileScreen(
          profileId: widget.currentUserId,
        ),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.bag),
          title: ("Shop"),
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.activeBlue,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.gift_alt_fill),
          title: ("Categories"),
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.activeBlue,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.cart),
          title: ("My Cart"),
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.activeBlue,
        ),
        PersistentBottomNavBarItem(
          icon: CircleAvatar(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentUserId)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final ds = snapshot.data;
                    String firstname = ds['firstName'];
                    String secondname = ds['secondName'];
                    String? profImg = ds['profileImageUrl'];
                    bool isProfImg = profImg == null;

                    return CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: isProfImg
                            ? Center(
                                child: Text(
                                '${firstname[0].toUpperCase()} ${secondname[0].toUpperCase()}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ))
                            : CircleAvatar(
                                radius: 21,
                                backgroundImage:
                                    CachedNetworkImageProvider(profImg),
                              ));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const CircleAvatar(
                      child: Center(child: Icon(Icons.person)),
                    );
                  }
                  return Container();
                }),
          ),
          title: ("My Account"),
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.activeBlue,
        ),
      ];
    }

    return Scaffold(
      body: PersistentTabView(
        context,

        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.black,
        //  Colors.pink.shade100, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          colorBehindNavBar: Colors.transparent,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
