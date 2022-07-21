
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../size_config.dart';

class NothingToShowContainer extends StatelessWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key? key,
    this.iconPath = "assets/icons/empty_box.svg",
    this.primaryMessage = "Nothing to show",
    this.secondaryMessage = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.75,
      height: SizeConfig.screenHeight * 0.2,
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            color: kTextColor,
            width: 75
            //getProportionateScreenWidth(75),
          ),
          const SizedBox(height: 16),
          Text(
            primaryMessage,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 15,
            ),
          ),
          Text(
            secondaryMessage,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
