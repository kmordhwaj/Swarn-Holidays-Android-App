import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'package:new_swarn_holidays/msssenger/chatscreen.dart';
import 'package:new_swarn_holidays/msssenger/constant.dart';
import 'package:provider/provider.dart';

class MessageButton extends StatefulWidget {
  const MessageButton({Key? key}) : super(key: key);

  @override
  State<MessageButton> createState() => _MessageButtonState();
}

class _MessageButtonState extends State<MessageButton> {
  String? currentUserId;
  String? firstname;
  String? secondname;
  String? profImg;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
    getMyInfo();
  }

  getMyInfo() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    setState(() {
      firstname = docSnapshot.data()!['firstName'];
      secondname = docSnapshot.data()!['secondName'];
      profImg = docSnapshot.data()!['profileImageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.contact_page_rounded),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        profileId: shbId,
                        currentUserId: currentUserId,
                        myfirstname: firstname,
                        mysecondname: secondname,
                        myprofImg: profImg,
                        firstname: shbfirstName,
                        secondname: shbsecondName,
                        profImg: shbprofileImageUrl,
                      )));
        });
  }
}
