import 'package:flutter/material.dart';
//import 'package:new_swarn_holidays/screens/a/friendsuggestion.dart';

class HomEHeader2 extends StatelessWidget {
  const HomEHeader2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        const Text('new_swarn_holidays',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 23)),
        IconButton(
          icon: const Icon(Icons.person_add_alt_1_rounded),
          onPressed: () {
            /*     Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FriendSuggestion())); */
          },
        ),
        IconButton(
            icon: const Icon(Icons.wallet_giftcard),
            onPressed: () {
              //    Navigator.of(context).push(
              //      MaterialPageRoute(builder: (context) => ActivityFeed()));
            }),
      ],
    );
  }
}
