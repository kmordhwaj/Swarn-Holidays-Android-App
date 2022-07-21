import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback press;
  const RoundedIconButton({
    Key? key,
    required this.iconData,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      //getProportionateScreenWidth(40),
      width: 40,
      //getProportionateScreenWidth(40),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: press,
        child: Icon(
          iconData,
          color: kTextColor,
        ),
      ),
    );
  }
}
