import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfo) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .set(messageInfo);
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .set({
      'messageId': messageId,
      'lastMessage': null,
      'lastVoiceMsgUrl': null,
      'lastMusicMsgUrl': null,
      'lastPhotoMsgUrl': null,
      'lastVideoMsgUrl': null,
      'lastPdfMsgUrl': null,
      'lastMediaLength': null,
      'lastMessageSendTs': null,
      'lastMessageSendByFN': null,
      'lastMessageSendBySN': null,
      'lastMessageSendToFN': null,
      'lastMessageSendToSN': null,
      'lastMessageSenderDp': null,
      'lastMessageSendDp': null,
      'lastMessageSenderId': null,
      'lastMessageSendId': null,
      'users': <String>[],
      'isDeleted': false,
    });
  }

/*
  Future addPhotoMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfo) async {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('photoChats')
        .doc(messageId)
        .set(messageInfo);
  }
   */
  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfo) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .set(lastMessageInfo);
  }
/*
  updateLastPhotoMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfo) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .update(lastMessageInfo);
  }
   */
/*  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfo) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .set(chatRoomInfo);
    }
  }   */

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms(currentUserId) async {
    //  final currentUserId = AuthentificationService().currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .where('users', arrayContains: currentUserId)
        .orderBy('lastMessageSendTs', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getUsers() async {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoomPhotoMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('photoChats')
        .orderBy('ts', descending: true)
        .snapshots();
  }
}
