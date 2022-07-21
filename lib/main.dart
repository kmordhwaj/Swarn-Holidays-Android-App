import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_swarn_holidays/general/firstsplashscreen.dart';
import 'package:new_swarn_holidays/general/home1.dart';
import 'package:new_swarn_holidays/general/loginscreen.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'package:new_swarn_holidays/general/registerscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? false;

    //Set Navigation bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: darkModeOn ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            darkModeOn ? Brightness.light : Brightness.dark));

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<UserData>(create: (context) => UserData()),

      //   ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
      /*   ChangeNotifierProvider<VideoProvider>(
          create: (context) => VideoProvider()), 
      ChangeNotifierProvider<ThemeNotifier>(
          create: (context) =>
              ThemeNotifier(darkModeOn ? darkTheme : lightTheme)) */
    ], child: const MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isTimerDone = false;

  @override
  void initState() {
    Timer(
        const Duration(seconds: 3), () => setState(() => _isTimerDone = true));
    super.initState();
  }

  Widget _getScreenId() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // userChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !_isTimerDone) {
          return const FirstSplashScreen();
        }
        if (snapshot.hasData && _isTimerDone && snapshot.data != null) {
          Provider.of<UserData>(context, listen: false).currentUserId =
              snapshot.data!.uid;
          return const Home1(
            isCameFromLogin: false,
          );
          //const Home();
        }
        if (!snapshot.hasData) {
          return const FirstSplashScreen();
        } else {
          return const LogInScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //  final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'new_swarn_holidays',
      theme: ThemeData.dark(),
      //    themeNotifier.getTheme(),
      home: _getScreenId(),

      routes: {
        //   Feed.id: (context) => Feed(),
        LogInScreen.id: (context) => const LogInScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        //    Home.id: (context) => Home(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
