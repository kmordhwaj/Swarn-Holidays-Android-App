import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/messagebutton.dart';

class HomeHeaderUp extends StatefulWidget {
  const HomeHeaderUp({
    Key? key,
  }) : super(key: key);

  @override
  _HomeHeaderUpState createState() => _HomeHeaderUpState();
}

class _HomeHeaderUpState extends State<HomeHeaderUp> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /*    GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: CircleAvatar(
            radius: 14,
          ),
        ),
        
        */
        IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
        /*    IconButton(
          icon: const Icon(Icons.person_add_alt_1_rounded),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FriendSuggestion()));
          },
        ),
        IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ActivityFeed()));
            }), */
        Center(
          child: SizedBox(
              width: 100,
              height: 50,
              child:
                  //   Shimmer.fromColors(
                  //    highlightColor: Colors.red,
                  //    baseColor: Colors.green,
                  //    child:
                  Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              )
              //  ),
              ),
        ),
        IconButton(
            icon: const Icon(Icons.offline_bolt_outlined), onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.celebration_outlined), onPressed: () {}),
        const MessageButton()
      ],
    );
  }
}
