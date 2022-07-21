import 'package:flutter/cupertino.dart';
import 'package:new_swarn_holidays/models/models.dart';

class UserData extends ChangeNotifier {
  String? currentUserId;

  // String profileImageUrl;

  bool cameFromRegisterScreen = false;

  UserModal currentUser = UserModal();
}
