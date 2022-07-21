import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                field(val: 'Resort', img: 'assets/images/1.jpg'),
                field(val: 'Villa', img: 'assets/images/2.jpg'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                field(val: 'Pent House', img: 'assets/images/3.jpg'),
                field(val: 'clubhouse', img: 'assets/images/4.jpg'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                field(val: 'bar', img: 'assets/images/1.jpg'),
                field(val: 'apartment', img: 'assets/images/2.jpg'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                field(val: 'hill house', img: 'assets/images/1.jpg'),
                field(val: 'luxury bhk', img: 'assets/images/2.jpg'),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Container field({
    required String val,
    required String img,
  }) {
    return Container(
      height: 150,
      width: 190,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.black38, BlendMode.darken),
              )),
            ),
          ),
          Center(
            child: Text(
              val,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
