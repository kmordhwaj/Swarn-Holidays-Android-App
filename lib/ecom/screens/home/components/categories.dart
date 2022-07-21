import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SafeArea(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width  * 0.4,
         decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.red,  Colors.yellow
          ])
         ),
          )
        ],
      )
    ],
  ),
    );
  }
}
