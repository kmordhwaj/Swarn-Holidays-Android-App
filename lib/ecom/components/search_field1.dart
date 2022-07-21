import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class SearchField1 extends StatelessWidget {
  final Function onSubmit;
  const SearchField1({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search Users",
          prefixIcon: const Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(9)),
        ),
        onSubmitted: onSubmit as void Function(String)?,
      ),
    );
  }
}
