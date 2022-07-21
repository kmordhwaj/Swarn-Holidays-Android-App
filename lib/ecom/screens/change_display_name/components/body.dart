import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'change_display_name_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Text(
              "Change Display Name",
              style: headingStyle,
            ),
            const ChangeDisplayNameForm(),
          ],
        ),
      ),
    );
  }
}
