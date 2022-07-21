import 'package:flutter/material.dart';

import '../constants.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color color;
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      //getProportionateScreenHeight(56),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.pink,
          textStyle: TextStyle(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: const TextStyle(
            fontSize: 18,
            // getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
