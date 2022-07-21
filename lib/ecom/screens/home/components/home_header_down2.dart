import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_swarn_holidays/ecom/components/search_field2.dart';
import 'package:flutter/material.dart';
//import 'package:new_swarn_holidays/services/api/auth_service.dart';
import '../../../components/icon_button_with_counter.dart';

final storageRef = FirebaseStorage.instance.ref();

class HomeHeaderDown2 extends StatefulWidget {
  final Function? onSearchSubmitted;
  final Function onCartButtonPressed;

  const HomeHeaderDown2({
    Key? key,
    required this.onSearchSubmitted,
    required this.onCartButtonPressed,
  }) : super(key: key);

  @override
  _HomeHeaderDown2State createState() => _HomeHeaderDown2State();
}

class _HomeHeaderDown2State extends State<HomeHeaderDown2> {
  @override
  void initState() {
    super.initState();

    //  _listenToNotifications();
    //   AuthService.updateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SearchField2(
            onSubmit: widget.onSearchSubmitted!,
          ),
        ),
        const SizedBox(width: 5),
        IconButtonWithCounter(
          svgSrc: "assets/icons/Cart Icon.svg",
          numOfItems: 0,
          press: widget.onCartButtonPressed as void Function(),
        ),
      ],
    );
  }
}
