import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/general/home2.dart';
import 'package:new_swarn_holidays/home.dart';


class Home1 extends StatefulWidget {
  final bool isCameFromLogin;
  const Home1({Key? key, required this.isCameFromLogin}) : super(key: key);

  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  @override
  Widget build(BuildContext context) {
    return widget.isCameFromLogin ? const  Home2() : const Home();
  }
}