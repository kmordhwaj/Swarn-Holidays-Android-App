import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/general/splashscreen.dart';
import 'package:shimmer/shimmer.dart';

class FirstSplashScreen extends StatefulWidget {
  const FirstSplashScreen({Key? key}) : super(key: key);

  @override
  _FirstSplashScreenState createState() => _FirstSplashScreenState();
}

class _FirstSplashScreenState extends State<FirstSplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //  width: double.infinity,
        //  height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.blueGrey.shade900.withOpacity(0.3),
          Colors.pink.shade900.withOpacity(0.3)
        ])),
        child: Center(
          child: SizedBox(
            width: 250,
            height: 100,
            child: Shimmer.fromColors(
                highlightColor: Colors.red,
                baseColor: Colors.green,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
