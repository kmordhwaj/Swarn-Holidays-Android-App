// ignore_for_file: constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model.dart';

class LastMsgModal extends Model {
  static const String LAST_MSG = "lastMessage";
  static const String LAST_MSG_SENDER = "lastMessageSendBy";
  static const String LAST_MSG_SENDER_ID = "lastMessageSenderId";
  static const String LAST_MSG_SENDER_DP = "lastMessageSenderDp";
  static const String TIME = "lastMessageSendTs";
  static const String USERS = "users";

  String? lastMsg;
  String? lastMsgSender;
  String? lastMsgSenderId;
  String? lastMsgSenderDp;
  Timestamp? time;
  List<String?>? users;

  LastMsgModal(
      {String? id,
      this.lastMsg,
      this.lastMsgSender,
      this.lastMsgSenderId,
      this.lastMsgSenderDp,
      this.time,
      this.users})
      : super(id);

  factory LastMsgModal.fromMap(Map<String, dynamic> map, {String? id}) {
    return LastMsgModal(
        id: id,
        lastMsg: map[LAST_MSG],
        lastMsgSender: map[LAST_MSG_SENDER],
        lastMsgSenderId: map[LAST_MSG_SENDER_ID],
        lastMsgSenderDp: map[LAST_MSG_SENDER_DP],
        time: map[TIME],
        users: map[USERS]);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      LAST_MSG: lastMsg,
      LAST_MSG_SENDER: lastMsgSender,
      LAST_MSG_SENDER_ID: lastMsgSenderId,
      LAST_MSG_SENDER_DP: lastMsgSenderDp,
      TIME: time,
      USERS: users
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (lastMsg != null) map[LAST_MSG] = lastMsg;
    if (lastMsgSender != null) map[LAST_MSG_SENDER] = lastMsgSender;
    if (lastMsgSenderId != null) map[LAST_MSG_SENDER_ID] = lastMsgSenderId;
    if (lastMsgSenderDp != null) map[LAST_MSG_SENDER_DP] = lastMsgSenderDp;
    if (time != null) map[TIME] = time;
    if (users != null) map[TIME] = users;
    return map;
  }
}
