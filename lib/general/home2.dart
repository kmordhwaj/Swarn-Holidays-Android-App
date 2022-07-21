import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/home.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'package:new_swarn_holidays/widgets/common/progress.dart';
import 'package:provider/provider.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  bool _isTimerDone = false;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2), () => setState(() => _isTimerDone = true));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !_isTimerDone) {
          return circularProgress();
        }
        if (snapshot.hasData && _isTimerDone && snapshot.data != null) {
          Provider.of<UserData>(context, listen: false).currentUserId =
              snapshot.data!.uid;
          return const Home();
        } else {
          return circularProgress();
        }
      },
    );
  }
}
