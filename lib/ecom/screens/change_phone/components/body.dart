import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'change_phone_number_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Change Phone Number",
                style: headingStyle,
              ),
              const ChangePhoneNumberForm(),
            ],
          ),
        ),
      ),
    );
  }
}
