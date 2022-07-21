//import 'package:camera/camera.dart';
import 'package:new_swarn_holidays/ecom/components/rounded_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/ecom/components/search_field1.dart';
//import 'package:new_swarn_holidays/screens/a/screens.dart';
//import 'package:new_swarn_holidays/services/api/auth_service.dart';
//import 'package:new_swarn_holidays/utilities/constants.dart';
//import 'package:new_swarn_holidays/utilities/show_error_dialog.dart';

class HomeHeaderDown1 extends StatefulWidget {
  final Function onSearchSubmitted;
//  final List<CameraDescription>? cameras;

  const HomeHeaderDown1({
    Key? key,
    required this.onSearchSubmitted,
    //required this.cameras
  }) : super(key: key);

  @override
  _HomeHeaderDown1State createState() => _HomeHeaderDown1State();
}

class _HomeHeaderDown1State extends State<HomeHeaderDown1> {
  // late List<CameraDescription>? _cameras;
//  CameraConsumer _cameraConsumer = CameraConsumer.post;

  @override
  void initState() {
    super.initState();

    //   _getCameras();

    //  _listenToNotifications();
    //   AuthService.updateToken();
  }
/*
  Future<Null> _getCameras() async {
    if (widget.cameras != null) {
      setState(() {
        _cameras = widget.cameras;
      });
    } else {
      try {
        _cameras = await availableCameras();
      } on CameraException catch (_) {
        ShowErrorDialog.showAlertDialog(
            errorMessage: 'Cant get cameras!', context: context);
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SearchField1(
            onSubmit: widget.onSearchSubmitted,
          ),
        ),
        const SizedBox(width: 7),
        RoundedIconButton(
            iconData: Icons.add_a_photo,
            press: () {
              /*     Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CameraScreen(
                      _cameras,
                      //  backToHomeScreen,
                      _cameraConsumer)));
           */
            }),
      ],
    );
  }
}
