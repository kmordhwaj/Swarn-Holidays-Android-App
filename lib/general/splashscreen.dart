import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:new_swarn_holidays/general/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int? page = 0;
  late LiquidController liquidController;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
    Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect),
              blendMode: BlendMode.darken,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/1n.jpg"),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Stay",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.lightGreen,
                      ),
                    ),
                    Text(
                      "Connected",
                      style: TextStyle(
                          fontSize: 60.0,
                          color: Color(0xFFA1B6CC),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.0),
                    Divider(color: Colors.pink),
                    Text(
                      "Today or tomorrow, \nstay"
                      " connected with all those, \nwhom"
                      " you care about.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ))
          ],
        )),
    Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect),
              blendMode: BlendMode.darken,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/2n.jpg"),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Shop",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.pink,
                      ),
                    ),
                    Text(
                      "With Style",
                      style: TextStyle(
                          fontSize: 60.0,
                          color: Color(0xFFA1B6CC),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.0),
                    Divider(color: Colors.blue),
                    Text(
                      "Shop with wide range of products, \ndelivered"
                      " to your doorstep with just a click, \nin"
                      " a free and fast way.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    )
                  ],
                ))
          ],
        )),
    Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect),
              blendMode: BlendMode.darken,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/3n.jpg"),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Influence",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.pink,
                      ),
                    ),
                    Text(
                      "To Billions",
                      style: TextStyle(
                          fontSize: 60.0,
                          color: Color(0xFFA1B6CC),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.0),
                    Divider(color: Colors.green),
                    Text(
                      "Spread the world, \nthe"
                      " power of your style, \nby"
                      " influencing others with your profile.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    )
                  ],
                ))
          ],
        )),
    Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect),
              blendMode: BlendMode.darken,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/4n.jpg"),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Reward",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.lightGreen,
                    ),
                  ),
                  Text(
                    "Yourself",
                    style: TextStyle(
                        fontSize: 60.0,
                        color: Color(0xFFA1B6CC),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1.0),
                  Divider(color: Colors.red),
                  Text(
                    "Earn with your every action, \nfor"
                    " you and your loved ones, \nby"
                    " promoting others your style.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            )
          ],
        )),
  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    // ignore: sized_box_for_whitespace
    return Container(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.yellow,
          type: MaterialType.circle,
          child: SizedBox(
            width: 7.0 * zoom,
            height: 7.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: <Widget>[
          LiquidSwipe(
              pages: pages,
              enableLoop: false,
              fullTransitionValue: 600,
              waveType: WaveType.liquidReveal,
              onPageChangeCallback: pageChangeCallback,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(pages.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LogInScreen()));
                      //  setState(() {});
                    },
                    child: Container(
                        height: 35,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            gradient: const LinearGradient(colors: [
                              Colors.purple,
                              Colors.blue,
                            ])),
                        child: const Center(
                            child: Text(
                          'Start',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))))
                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [leftbuttonFn(), rightbuttonFn()],
                ) */
                ),
          )
        ]),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      // ignore: unnecessary_this
      this.page = lpage;
    });
  }

  rightbuttonFn() {
    if (page == 4) {
      return InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LogInScreen()));
            setState(() {});
          },
          child: Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: [
                    Colors.purple.shade300,
                    Colors.pink.shade300,
                  ])),
              child: const Center(child: Text('Start'))));
    } else {
      return TextButton(
          onPressed: () {
            setState(() {
              page = page! + 1;
            });
          },
          child: const Text('Next'));
    }
  }

  leftbuttonFn() {
    if (page == 0) {
      return const SizedBox();
    } else {
      return TextButton(
          onPressed: () {
            setState(() {
              page = page! - 1;
            });
          },
          child: const Text('Previous'));
    }
  }
}
