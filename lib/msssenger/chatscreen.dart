// ignore_for_file: library_prefixes, unnecessary_string_escapes, unnecessary_this, sized_box_for_whitespace

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as Im;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/home_header_down2.dart';
import 'package:new_swarn_holidays/msssenger/views/audio_play.dart';
import 'package:new_swarn_holidays/msssenger/views/audio_widget.dart';
import 'package:new_swarn_holidays/msssenger/views/chatmsgTile.dart';
import 'package:new_swarn_holidays/msssenger/views/musicmsgTile.dart';
import 'package:new_swarn_holidays/msssenger/views/pdfmsgTile.dart';
import 'package:new_swarn_holidays/msssenger/views/photo_preview.dart';
import 'package:new_swarn_holidays/msssenger/views/photomsgTile.dart';
import 'package:new_swarn_holidays/msssenger/views/video_preview.dart';
import 'package:new_swarn_holidays/msssenger/views/video_widget.dart';
import 'package:new_swarn_holidays/msssenger/views/videomsgtile.dart';
import 'package:new_swarn_holidays/msssenger/views/viewpdf.dart';
import 'package:new_swarn_holidays/voice/features_button.dart';
import 'package:new_swarn_holidays/voice/voicemsgtile.dart';
import 'package:new_swarn_holidays/widgets/common/universal_variables.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import '../../services/database.dart';

class ChatScreen extends StatefulWidget {
  final String? profileId;
  final String? currentUserId;
  final Function? abc;
  final String? caption;
  final String? myfirstname;
  final String? mysecondname;
  final String? myprofImg;
  final String? firstname;
  final String? secondname;
  final String? profImg;

  const ChatScreen({
    Key? key,
    required this.profileId,
    required this.currentUserId,
    this.abc,
    this.caption,
    required this.myfirstname,
    required this.mysecondname,
    required this.myprofImg,
    required this.firstname,
    required this.secondname,
    required this.profImg,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId = '';
  String messageId = '';
  bool isUploading = false;
  TextEditingController msgController = TextEditingController();
  Stream<QuerySnapshot>? messageStream;
  final ImagePicker? imgPicker = ImagePicker();
  File? mFile;
  final _formKey = GlobalKey<FormState>();
  String fileType = 'photo';
  bool chatScr = true;
  int mLength = 0;
  File? videoPreviewImage;
  TextEditingController captionController = TextEditingController();
  bool longPressed = false;
  bool longPressedAgain = false;
  String? replyPreviousText;
  String? replyPreviousMedia;
  int? replyPreviousMediaLength;
  bool isReplyingMusic = false;
  bool isReplyingPdf = false;
  bool replyButtonPressed = false;
  bool isReplying = false;
  String appbarLongPressed = 'chat';
  String appbarLongPressedAgain = 'chat';
  bool longPressedC = false;
  bool longPressedP = false;
  bool longPressedM = false;
  bool longPressedVd = false;
  bool longPressedVo = false;
  bool longPressedPd = false;
  bool longPressedG = false;
  String msgId = '';
  List<String> list = <String>[];

  getMyInfo() {
    chatRoomId = getChatRoomId(widget.profileId!, widget.currentUserId!);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfo();
    getAndSetMessages();
  }

  @override
  void initState() {
    super.initState();
    doThisOnLaunch();
  }

  @override
  Widget build(BuildContext context) {
    bool isProfImg = widget.profImg == null;
    return chatScr ? chatScreen(isProfImg) : buildUploadForm();
  }

  Scaffold chatScreen(isProfImg) {
    return Scaffold(
      appBar: longPressed
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        pressFn();
                        setState(() {
                          appbarLongPressed = '';
                        });
                      },
                      icon: const Icon(Icons.clear)),
                  IconButton(
                      onPressed: () {
                        pressFn();
                        setState(() {
                          replyButtonPressed = true;
                          appbarLongPressed = '';
                        });
                      },
                      icon: const Icon(Icons.reply_rounded)),
                  IconButton(
                      onPressed: deleteFn, icon: const Icon(Icons.delete)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.copy)),
                  IconButton(
                      onPressed: deleteAll,
                      icon: const Icon(Icons.delete_sweep_rounded)),
                ],
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Row(
                children: [
                  const SizedBox(width: 2),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 3),
                  CircleAvatar(
                    child: isProfImg
                        ? Center(
                            child: Text(
                              '${widget.firstname![0].toUpperCase()} ${widget.secondname![0].toUpperCase()}',
                              style: TextStyle(color: Colors.purple.shade300),
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(widget.profImg!)),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.firstname} ${widget.secondname}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                IconButton(
                    onPressed: () {
                      //       CallUtils.dial(from: currentUserId, to: widget.profileId);
                    },
                    icon: const Icon(Icons.video_call))
              ],
            ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            chatMessages(),
            isUploading
                ? Positioned(
                    bottom: 15,
                    left: 3,
                    right: 3,
                    child: Container(
                      height: 100,
                      color: Colors.black,
                      child: Column(
                        children: [
                          const LinearProgressIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.green,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              bottomFileView(),
                              const Text(
                                'Uploading....',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
                : Positioned(
                    left: 8,
                    right: 8,
                    bottom: 20,
                    child: replyButtonPressed
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  replyWidget(),
                                  Positioned(
                                      right: 3,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            replyButtonPressed = false;
                                          });
                                        },
                                        child: const CircleAvatar(
                                          radius: 15,
                                          child: Icon(
                                            Icons.close,
                                            size: 15,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 7),
                              Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: noAbc1(context),
                              ),
                            ],
                          )
                        : Container(
                            height: 60,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: noAbc(context),
                          ),
                  )
          ],
        ),
      ),
    );
  }

  addMessage(bool sendClicked) async {
    if (msgController.text != '') {
      String message = msgController.text;

      DateTime dateNow = DateTime.now();

      var lastMsgTs = Timestamp.fromDate(dateNow);

      //messageId
      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      Map<String, dynamic> messageInfo = {
        'messageId': messageId,
        'message': message,
        'voiceMsgUrl': null,
        'musicMsgUrl': null,
        'photoMsgUrl': null,
        'videoMsgUrl': null,
        'videoPreviewImage': null,
        'pdfMsgUrl': null,
        'mediaLength': null,
        'sendBy': '${widget.myfirstname} ${widget.mysecondname}',
        'ts': lastMsgTs,
        'imageUrl': widget.myprofImg,
        'isDeleted': false
      };

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfo)
          .then((value) {
        Map<String, dynamic> lastMessageInfo = {
          'messageId': messageId,
          'lastMessage': message,
          'lastVoiceMsgUrl': null,
          'lastMusicMsgUrl': null,
          'lastPhotoMsgUrl': null,
          'lastVideoMsgUrl': null,
          'lastPdfMsgUrl': null,
          'lastMediaLength': mLength,
          'lastMessageSendTs': lastMsgTs,
          'lastMessageSendByFN': widget.myfirstname,
          'lastMessageSendBySN': widget.mysecondname,
          'lastMessageSendToFN': widget.firstname,
          'lastMessageSendToSN': widget.secondname,
          'lastMessageSenderDp': widget.myprofImg,
          'lastMessageSendDp': widget.profImg,
          'lastMessageSenderId': widget.currentUserId,
          'lastMessageSendId': widget.profileId,
          'users': <String>[widget.currentUserId!, widget.profileId!],
          'isDeleted': false
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfo);

        if (sendClicked) {
          //remove the text in the message field
          msgController.text = '';
          //make msg id blank to get regenerated on next msg send
          messageId = '';
        }
      });
    }
  }

  addMessage1(bool sendClicked) async {
    if (msgController.text != '') {
      String message = msgController.text;

      DateTime dateNow = DateTime.now();

      var lastMsgTs = Timestamp.fromDate(dateNow);

      //messageId
      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      Map<String, dynamic> messageInfo = {
        'messageId': messageId,
        'message': message,
        'voiceMsgUrl': null,
        'musicMsgUrl': null,
        'photoMsgUrl': null,
        'videoMsgUrl': null,
        'videoPreviewImage': null,
        'pdfMsgUrl': null,
        'mediaLength': null,
        'sendBy':
            //  myusername,
            '${widget.myfirstname} ${widget.mysecondname}',
        'ts': lastMsgTs,
        'imageUrl': widget.myprofImg,
        'isDeleted': false,
        'isReplied': true
      };

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfo)
          .then((value) {
        Map<String, dynamic> lastMessageInfo = {
          'messageId': messageId,
          'lastMessage': message,
          'lastVoiceMsgUrl': null,
          'lastMusicMsgUrl': null,
          'lastPhotoMsgUrl': null,
          'lastVideoMsgUrl': null,
          'lastPdfMsgUrl': null,
          'lastMediaLength': mLength,
          'lastMessageSendTs': lastMsgTs,
          'lastMessageSendByFN': widget.myfirstname,
          'lastMessageSendBySN': widget.mysecondname,
          'lastMessageSendToFN': widget.firstname,
          'lastMessageSendToSN': widget.secondname,
          'lastMessageSenderDp': widget.myprofImg,
          'lastMessageSendDp': widget.profImg,
          'lastMessageSenderId': widget.currentUserId,
          'lastMessageSendId': widget.profileId,
          'users': <String>[widget.currentUserId!, widget.profileId!],
          'isDeleted': false
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfo);

        if (sendClicked) {
          //remove the text in the message field
          msgController.text = '';
          //make msg id blank to get regenerated on next msg send
          messageId = '';
        }
      });
    }
  }

  replyWidget() {
    bool isReplyPreviousMedia = replyPreviousMedia == null;
    return Container(
      height: replyButtonPressed ? 70 : 40,
      color: replyButtonPressed
          ? Colors.green.withOpacity(0.4)
          : Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: replyButtonPressed
            ? Column(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.reply,
                        color: Colors.lightBlue,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Replying to',
                        style: TextStyle(color: Colors.lightBlue, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      isReplyPreviousMedia
                          ? isReplyingMusic
                              ? Container(
                                  height: 34,
                                  width: 34,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      gradient: LinearGradient(colors: [
                                        Colors.deepPurple,
                                        Colors.purple
                                      ])),
                                  child: const Center(
                                      child: Icon(CupertinoIcons.music_note)),
                                )
                              : isReplyingPdf
                                  ? Container(
                                      height: 34,
                                      width: 34,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          gradient: LinearGradient(colors: [
                                            Colors.orange,
                                            Colors.pink
                                          ])),
                                      child: Center(
                                          child: Text('.Pdf',
                                              style: TextStyle(
                                                  color:
                                                      Colors.blue.shade900))),
                                    )
                                  : Container()
                          : Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          replyPreviousMedia!),
                                      fit: BoxFit.cover))),
                      const SizedBox(width: 7),
                      Text(replyPreviousText!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15))
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  isReplyPreviousMedia
                      ? isReplyingMusic
                          ? Container(
                              height: 34,
                              width: 34,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  gradient: LinearGradient(colors: [
                                    Colors.deepPurple,
                                    Colors.purple
                                  ])),
                              child: const Center(
                                  child: Icon(CupertinoIcons.music_note)),
                            )
                          : isReplyingPdf
                              ? Container(
                                  height: 34,
                                  width: 34,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      gradient: LinearGradient(colors: [
                                        Colors.orange,
                                        Colors.pink
                                      ])),
                                  child: Center(
                                      child: Text('.Pdf',
                                          style: TextStyle(
                                              color: Colors.blue.shade900))),
                                )
                              : Container()
                      : Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      replyPreviousMedia!),
                                  fit: BoxFit.cover))),
                  const SizedBox(width: 7),
                  Text(replyPreviousText!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 15))
                ],
              ),
      ),
    );
  }

  Widget replyMessageTile(
      {required String message,
      required bool sendByMe,
      required Timestamp time}) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          longPressed = true;
        });
      },
      child: Container(
        color: longPressed ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        child: Row(
          mainAxisAlignment:
              sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: sendByMe ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(24),
                        bottomRight: sendByMe
                            ? const Radius.circular(0)
                            : const Radius.circular(24),
                        topRight: const Radius.circular(24),
                        bottomLeft: sendByMe
                            ? const Radius.circular(24)
                            : const Radius.circular(0))),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    replyWidget(),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      time.toDate().toString(),
                      //   '${DateFormat.yMMMd().format(time)}  ${DateFormat.Hm().format(time)}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 8),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 16),
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  bool isDeleted = ds['isDeleted'];
                  String mesgId = ds['messageId'];
                  String? msg = ds['message'];
                  final voicemsgurl = ds['voiceMsgUrl'];
                  final musicmsgurl = ds['musicMsgUrl'];
                  final photomsgurl = ds['photoMsgUrl'];
                  final vdomsgurl = ds['videoMsgUrl'];
                  final vdoprevw = ds['videoPreviewImage'];
                  final pdfmsgurl = ds['pdfMsgUrl'];
                  final medialength = ds['mediaLength'];
                  bool isVoice = voicemsgurl == null;
                  bool isMusic = musicmsgurl == null;
                  bool isPhoto = photomsgurl == null;
                  bool isVideo = vdomsgurl == null;
                  bool isPdf = pdfmsgurl == null;
                  return isPhoto
                      ? isVoice
                          ? isMusic
                              ? isVideo
                                  ? isPdf
                                      ? ChatMessageTile(
                                          onLongPress: () {
                                            setState(() {
                                              this.appbarLongPressed = mesgId;
                                              this.msgId = mesgId;
                                            });
                                            pressFn1(mesgId);
                                            setState(() {
                                              this.replyPreviousText = msg;
                                              this.replyPreviousMedia =
                                                  photomsgurl;
                                            });
                                          },
                                          longPressed: pressFn3(mesgId),
                                          isDeleted: isDeleted,
                                          message: msg,
                                          sendByMe:
                                              '${widget.myfirstname} ${widget.mysecondname}' ==
                                                  ds['sendBy'],
                                          time: ds['ts'])
                                      : PdfMessageTile(
                                          onLongPress: () {
                                            setState(() {
                                              this.appbarLongPressed = mesgId;
                                              this.msgId = mesgId;
                                            });
                                            pressFn1(mesgId);
                                            setState(() {
                                              this.replyPreviousText = msg;
                                              isReplyingPdf = true;
                                            });
                                          },
                                          isDeleted: isDeleted,
                                          longPressed: pressFn3(mesgId),
                                          pdfMessage: pdfmsgurl,
                                          message: msg,
                                          sendByMe:
                                              '${widget.myfirstname} ${widget.mysecondname}' ==
                                                  ds['sendBy'],
                                          time: ds['ts'])
                                  : VideoMessageTile(
                                      onLongPress: () {
                                        setState(() {
                                          this.appbarLongPressed = mesgId;
                                          this.msgId = mesgId;
                                        });
                                        pressFn1(mesgId);
                                        setState(() {
                                          this.replyPreviousText = msg;
                                          this.replyPreviousMedia = vdoprevw;
                                          this.replyPreviousMediaLength =
                                              medialength;
                                        });
                                      },
                                      isDeleted: isDeleted,
                                      longPressed: pressFn3(mesgId),
                                      message: msg,
                                      videoMessage: vdomsgurl,
                                      videoPreview: vdoprevw,
                                      sendByMe:
                                          '${widget.myfirstname} ${widget.mysecondname}' ==
                                              ds['sendBy'],
                                      time: ds['ts'],
                                      medialength: medialength)
                              : MusicMessageTile(
                                  onLongPress: () {
                                    setState(() {
                                      this.appbarLongPressed = mesgId;
                                      this.msgId = mesgId;
                                    });
                                    pressFn1(mesgId);
                                    setState(() {
                                      this.replyPreviousText = msg;
                                      isReplyingMusic = true;
                                      this.replyPreviousMediaLength =
                                          medialength;
                                    });
                                  },
                                  isDeleted: isDeleted,
                                  longPressed: pressFn3(mesgId),
                                  message: msg,
                                  audioMessage: musicmsgurl,
                                  sendByMe:
                                      '${widget.myfirstname} ${widget.mysecondname}' ==
                                          ds['sendBy'],
                                  time: ds['ts'],
                                  medialength: medialength)
                          : VoiceMessageTile(
                              voiceMessage: voicemsgurl,
                              isDeleted: isDeleted,
                              sendByMe:
                                  '${widget.myfirstname} ${widget.mysecondname}' ==
                                      ds['sendBy'],
                              time: ds['ts'])
                      : PhotoMessageTile(
                          onLongPress: () {
                            setState(() {
                              this.appbarLongPressed = mesgId;
                              this.msgId = mesgId;
                            });
                            pressFn1(mesgId);
                            setState(() {
                              this.replyPreviousText = msg;
                              this.replyPreviousMedia = photomsgurl;
                            });
                          },
                          isDeleted: isDeleted,
                          longPressed: pressFn3(mesgId),
                          message: msg,
                          photoMessage: photomsgurl,
                          sendByMe:
                              '${widget.myfirstname} ${widget.mysecondname}' ==
                                  ds['sendBy'],
                          time: ds['ts']);
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
          }
          return Container();
        });
  }

  pressFn1(mesgId) {
    if (appbarLongPressed == mesgId) {
      setState(() {
        longPressed = true;
        //    longPressedFired = false;
      });
    } else {
      setState(() {
        longPressed = false;
        //   longPressedFired = false;
      });
    }
  }

  bool pressFn3(mesgId) {
    if (appbarLongPressed == mesgId) {
      return true;
    } else {
      return false;
    }
  }

  pressFn2(String element) {
    if (appbarLongPressedAgain == element) {
      setState(() {
        longPressedAgain = true;
        //    longPressedFired = false;
      });
    } else {
      setState(() {
        longPressedAgain = false;
        //   longPressedFired = false;
      });
    }
  }

  pressFn() {
    if (appbarLongPressed == msgId) {
      setState(() {
        longPressed = false;
        //    longPressedFired = false;
      });
    } else {
      setState(() {
        longPressed = true;
        //   longPressedFired = false;
      });
    }
  }

  deleteFn() async {
    await pressFn();

    final a = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('messageId', isEqualTo: msgId)
        .get();
    for (final doc in a.docs) {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(doc.id)
          .update({'isDeleted': true});
      //  .delete();
    }

    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(msgId)
        .update({'isDeleted': true});
  }

  deleteAll() async {
    await pressFn();

    final a = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('users', arrayContains: widget.currentUserId)
        .orderBy('lastMessageSendTs', descending: true)
        .get();
    for (final doc in a.docs) {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(doc.id)
          .delete();
    }

    final b = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .get();
    for (final doc1 in b.docs) {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('chats')
          .doc(doc1.id)
          .delete();
    }
  }

  bottomFileView() {
    if (fileType == 'photo') {
      return imageWidget();
    } else if (fileType == 'video') {
      return videoWidget();
    } else if (fileType == 'audio') {
      return audioWidget();
    }
  }

  Widget imageWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PhotoPreview(photofile: mFile)));
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: FileImage(mFile!), fit: BoxFit.cover)),
      ),
    );
  }

  Widget videoWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPreview(videofile: mFile)));
      },
      child: Stack(
        children: [
          Container(
            width: 140,
            height: 90,
            child: VideoPreview(videofile: mFile),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 65),
            child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 15,
                child: Center(
                    child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                ))),
          )
        ],
      ),
    );
  }

  Widget audioWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AudioPlay(audioFile: mFile!.path)));
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient:
                LinearGradient(colors: [Colors.deepPurple, Colors.purple])),
        child: const Center(
          child: Icon(
            Icons.music_note_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Row noAbc1(context) {
    return Row(children: [
      IconButton(
          onPressed: () {}, icon: const Icon(Icons.emoji_emotions_rounded)),
      Expanded(
          child: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Please type something first.....";
            }
            return null;
          },
          controller: msgController,
          onSaved: (value) {
            addMessage(false);
            // msgController.text = value!;
          },
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.orange),
              hintText: 'Type a message'),
        ),
      )),
      IconButton(
          onPressed: () {
            showAttachmentBottomSheet(context);
          },
          icon: const Icon(
            Icons.attachment_rounded,
            color: Colors.lightBlue,
          )),
      const SizedBox(width: 8),
      InkWell(
          onTap: () {
            addMessage1(true);
          },
          child: const Icon(Icons.send, color: Colors.pink)),
      const SizedBox(width: 8),
    ]);
  }

  Row noAbc(context) {
    return Row(children: [
      IconButton(
          onPressed: () {}, icon: const Icon(Icons.emoji_emotions_rounded)),
      Expanded(
          child: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Please type something first.....";
            }
            return null;
          },
          controller: msgController,
          onSaved: (value) {
            addMessage(false);
            // msgController.text = value!;
          },
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.orange),
              hintText: 'Type a message'),
        ),
      )),
      IconButton(
          onPressed: () {
            showAttachmentBottomSheet(context);
          },
          icon: const Icon(
            Icons.attachment_rounded,
            color: Colors.lightBlue,
          )),
      const SizedBox(width: 8),
      InkWell(
          onTap: () {
            addMessage(true);
          },
          child: const Icon(Icons.send, color: Colors.pink)),
      const SizedBox(width: 8),
    ]);
  }

  showAttachmentBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: 135,
              child: Wrap(spacing: 20, children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FeatureButtonsView(
                                onUploadComplete: () {
                                  getAndSetMessages();
                                },
                                chatRoomId: chatRoomId,
                                firstname: widget.firstname!,
                                secondname: widget.secondname!,
                                myfirstname: widget.myfirstname!,
                                mysecondname: widget.mysecondname!,
                                profImg: widget.profImg,
                                myprofImg: widget.myprofImg,
                                currentUserId: widget.currentUserId!,
                                profileId: widget.profileId)));
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.purple]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                          child: Icon(Icons.mic, color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => selectImage(context),
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.green, Colors.purple]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                          child: Icon(Icons.photo, color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => showOptionsDialog(context),
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.red, Colors.purple]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                          child: Icon(Icons.video_camera_back_rounded,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        await pickAudio();
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                          child: Icon(Icons.music_note_rounded,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await pickPdf();
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.purple]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                          child: Icon(Icons.file_copy_rounded,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.orange, Colors.purple]),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Center(
                        child: Icon(Icons.celebration_rounded,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ]));
        });
  }

  pickAudio() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);
    if (result == null) {
      return;
    }
    final file = result.files.first;
    final newFile = await saveFilePermanently(file);
    setState(() {
      this.mFile = newFile;
      this.fileType = 'audio';
      chatScr = false;
    });
  }

  pickPdf() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null) {
      return;
    }
    final file = result.files.first;
    final newFile = await saveFilePermanently(file);
    setState(() {
      this.mFile = newFile;
      this.fileType = 'pdf';
      chatScr = false;
    });
    openPdf();
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  void openFile(newFile) {
    OpenFile.open(newFile.path!);
  }

  handleTakePhoto() async {
    final XFile? file = await imgPicker!
        .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);

    final File? imageFile = File(file!.path);

    setState(() {
      this.mFile = imageFile;
      chatScr = false;
    });
    Navigator.of(context).pop();
  }

  handleChooseFromGallery() async {
    final XFile? file = await imgPicker!.pickImage(source: ImageSource.gallery);
    final File? imageFile = File(file!.path);
    setState(() {
      this.mFile = imageFile;
      chatScr = false;
    });
    Navigator.of(context).pop();
  }

  selectImage(BuildContext context) {
    Navigator.of(context).pop();
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: const Center(
                  child: Text(
                'Create Post',
                style: TextStyle(
                    color: Colors.purpleAccent,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 25),
              )),
              backgroundColor: Colors.black87,
              children: [
                SimpleDialogOption(
                  child: const Center(
                    child: Text(
                      'Photo with camera',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                  onPressed: handleTakePhoto,
                ),
                const SizedBox(height: 5),
                SimpleDialogOption(
                  child: const Center(
                      child: Text(
                    'Image from Gallery',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  )),
                  onPressed: handleChooseFromGallery,
                ),
                const SizedBox(height: 5),
                SimpleDialogOption(
                  child: const Center(
                      child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  InkWell micSend() {
    if (msgController.text != '') {
      return InkWell(
          onTap: () {
            addMessage(true);
          },
          child: const Icon(Icons.send, color: Colors.pink));
    }
    return InkWell(
        onTap: () {
          setState(() {
            //    isMicy = false;
          });
        },
        child: Icon(Icons.mic, color: Colors.lightGreen.withBlue(30)));
  }

  clearFile() {
    setState(() {
      mFile = null;
      chatScr = true;
    });
  }

  buildUploadForm() {
    if (fileType == 'photo') {
      return imageUploadForm();
    } else if (fileType == 'video') {
      return videoUploadForm();
    } else if (fileType == 'audio') {
      return audioUploadForm();
    } else if (fileType == 'pdf') {
      return pdfUploadForm();
    }
  }

  Scaffold imageUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: clearFile,
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Center(
            child: Text('Send Image', style: TextStyle(color: Colors.black))),
        actions: [
          IconButton(
              onPressed: () => handleSubmit(),
              icon: const Icon(Icons.done, color: Colors.blue))
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(mFile!), fit: BoxFit.cover)),
            ),
          ),
          caption()
        ],
      ),
    );
  }

  Scaffold videoUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: clearFile,
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Center(
            child: Text('Send Video', style: TextStyle(color: Colors.black))),
        actions: [
          IconButton(
              onPressed: () => uploadVideo(),
              icon: const Icon(Icons.done, color: Colors.blue))
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width * 0.9,
              child: VideoWidget(
                videoFile: mFile,
              ),
            ),
          ),
          caption()
        ],
      ),
    );
  }

  Scaffold audioUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: clearFile,
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Center(
            child: Text('Send Audio', style: TextStyle(color: Colors.black))),
        actions: [
          IconButton(
              onPressed: () => uploadAudio(),
              icon: const Icon(Icons.done, color: Colors.blue))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purple])),
                child: const Center(
                  child: Icon(Icons.music_note),
                ),
              ),
            ),
            AudioWidget(
              audioFile: mFile!.path,
            ),
            const SizedBox(height: 20),
            caption()
          ],
        ),
      ),
    );
  }

  Scaffold pdfUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: clearFile,
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Center(
            child:
                Text('Send Pdf File', style: TextStyle(color: Colors.black))),
        actions: [
          IconButton(
              onPressed: () => uploadPdf(),
              icon: const Icon(Icons.done, color: Colors.blue))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: openPdf,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient:
                          LinearGradient(colors: [Colors.orange, Colors.pink])),
                  child: Center(
                    child: Text(
                      '.pdf',
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            caption()
          ],
        ),
      ),
    );
  }

  openPdf() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewPdf(file: mFile)));
  }

  Padding caption() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListTile(
        leading: const CircleAvatar(child: Center(child: Icon(Icons.edit))),
        title: Container(
            width: 200,
            child: TextField(
              controller: captionController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write about this photo....'),
            )),
      ),
    );
  }

  uploadPdfToStorage(String id) async {
    UploadTask storageUploadTask =
        storageRef.child('message/Pdf/$messageId.pdf').putFile(mFile!);
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() {});
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadPdf() async {
    setState(() {
      chatScr = true;
      messageId = const Uuid().v4();
      isUploading = true;
    });

    String pdf = await uploadPdfToStorage(messageId);
    String? msg = captionController.text;
    DateTime dateNow = DateTime.now();
    String mid = messageId;
    var lastMsgTs = Timestamp.fromDate(dateNow);

    Map<String, dynamic> messageInfo = {
      'messageId': messageId,
      'message': msg,
      'voiceMsgUrl': null,
      'musicMsgUrl': null,
      'photoMsgUrl': null,
      'videoMsgUrl': null,
      'videoPreviewImage': null,
      'pdfMsgUrl': pdf,
      'mediaLength': mLength,
      'sendBy': '${widget.myfirstname} ${widget.mysecondname}',
      'ts': lastMsgTs,
      'imageUrl': widget.myprofImg,
      'isDeleted': false
    };

    DatabaseMethods()
        .addMessage(chatRoomId, messageId, messageInfo)
        .then((value) {
      Map<String, dynamic> lastMessageInfo = {
        'messageId': mid,
        'lastMessage': msg,
        'lastVoiceMsgUrl': null,
        'lastMusicMsgUrl': null,
        'lastPhotoMsgUrl': null,
        'lastVideoMsgUrl': null,
        'lastPdfMsgUrl': pdf,
        'lastMediaLength': null,
        'lastMessageSendTs': lastMsgTs,
        'lastMessageSendByFN': widget.myfirstname,
        'lastMessageSendBySN': widget.mysecondname,
        'lastMessageSendToFN': widget.firstname,
        'lastMessageSendToSN': widget.secondname,
        'lastMessageSenderDp': widget.myprofImg,
        'lastMessageSendDp': widget.profImg,
        'lastMessageSenderId': widget.currentUserId,
        'lastMessageSendId': widget.profileId,
        'users': <String>[widget.currentUserId!, widget.profileId!],
        'isDeleted': false
      };

      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pdf Sent Successfully!')),
    );
    setState(() {
      mFile = null;
      isUploading = false;
      captionController.clear();
      messageId = const Uuid().v4();
      fileType = 'photo';
    });
    getAndSetMessages();
  }

  uploadAudioToStorage(String id) async {
    UploadTask storageUploadTask =
        storageRef.child('message/Audio/$messageId.mp3').putFile(mFile!);
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() {});
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadAudio() async {
    setState(() {
      chatScr = true;
      messageId = const Uuid().v4();
      isUploading = true;
    });

    String audio = await uploadAudioToStorage(messageId);
    String? msg = captionController.text;
    DateTime dateNow = DateTime.now();
    String mid = messageId;
    var lastMsgTs = Timestamp.fromDate(dateNow);

    Map<String, dynamic> messageInfo = {
      'messageId': messageId,
      'message': msg,
      'voiceMsgUrl': null,
      'musicMsgUrl': audio,
      'photoMsgUrl': null,
      'videoMsgUrl': null,
      'videoPreviewImage': null,
      'pdfMsgUrl': null,
      'mediaLength': mLength,
      'sendBy': '${widget.myfirstname} ${widget.mysecondname}',
      'ts': lastMsgTs,
      'imageUrl': widget.myprofImg,
      'isDeleted': false
    };

    DatabaseMethods()
        .addMessage(chatRoomId, messageId, messageInfo)
        .then((value) {
      Map<String, dynamic> lastMessageInfo = {
        'messageId': mid,
        'lastMessage': msg,
        'lastVoiceMsgUrl': null,
        'lastMusicMsgUrl': audio,
        'lastPhotoMsgUrl': null,
        'lastVideoMsgUrl': null,
        'lastPdfMsgUrl': null,
        'lastMediaLength': mLength,
        'lastMessageSendTs': lastMsgTs,
        'lastMessageSendByFN': widget.myfirstname,
        'lastMessageSendBySN': widget.mysecondname,
        'lastMessageSendToFN': widget.firstname,
        'lastMessageSendToSN': widget.secondname,
        'lastMessageSenderDp': widget.myprofImg,
        'lastMessageSendDp': widget.profImg,
        'lastMessageSenderId': widget.currentUserId,
        'lastMessageSendId': widget.profileId,
        'users': <String>[widget.currentUserId!, widget.profileId!],
        'isDeleted': false
      };

      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio Sent Successfully!')),
    );
    setState(() {
      mFile = null;
      isUploading = false;
      captionController.clear();
      messageId = const Uuid().v4();
      fileType = 'photo';
    });
    getAndSetMessages();
  }

  pickVideoCamera() async {
    final XFile? video =
        await ImagePicker().pickVideo(source: ImageSource.camera);
    final File? videoFile = File(video!.path);
    //  Navigator.of(context).pop();
    setState(() {
      this.mFile = videoFile;
      this.mLength = videoFile!.length() as int;
      chatScr = false;
      this.fileType = 'video';
    });
    Navigator.of(context).pop();
  }

  pickVideoGallery() async {
    final XFile? video =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    final File? videoFile = File(video!.path);
    //  Navigator.of(context).pop();
    setState(() {
      this.mFile = videoFile;
      this.mLength = videoFile!.length() as int;
      chatScr = false;
      this.fileType = 'video';
    });
    Navigator.of(context).pop();
  }

  showOptionsDialog(BuildContext context) {
    Navigator.of(context).pop();
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickVideoGallery(),
                child: Row(
                  children: [
                    const Icon(Icons.image),
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: Text(
                        "Gallery",
                        style: latoStyle(20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickVideoCamera(),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt),
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: Text(
                        "Camera",
                        style: latoStyle(20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    const Icon(Icons.cancel),
                    Padding(
                        padding: const EdgeInsets.all(7),
                        child: Text(
                          "Cancel",
                          style: latoStyle(20),
                        )),
                  ],
                ),
              ),
            ],
          );
        });
  }

  compressVideo() async {
    final compressedVideo = await VideoCompress.compressVideo(
      mFile!.path,
      quality: VideoQuality.MediumQuality,
    );
    return File(compressedVideo!.path!);
  }

  getPreviewImage() async {
    final previewImage = await VideoCompress.getFileThumbnail(mFile!.path);
    setState(() {
      this.videoPreviewImage = previewImage;
    });
    return previewImage;
  }

  uploadVideoToStorage(String id) async {
    UploadTask storageUploadTask = storageRef
        .child('message/Video/$messageId.mp4')
        .putFile(await compressVideo());
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() {});
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadImageToStorage(String id) async {
    UploadTask storageUploadTask =
        imagesRef.child(id).putFile(await getPreviewImage());
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() {});
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo() async {
    setState(() {
      chatScr = true;
      messageId = const Uuid().v4();
      isUploading = true;
    });

    String video = await uploadVideoToStorage(messageId);
    String previewImage = await uploadImageToStorage(messageId);

    DateTime dateNow = DateTime.now();
    String? msg = captionController.text;
    var lastMsgTs = Timestamp.fromDate(dateNow);
    String mid = messageId;
    Map<String, dynamic> messageInfo = {
      'messageId': messageId,
      'message': msg,
      'voiceMsgUrl': null,
      'musicMsgUrl': null,
      'photoMsgUrl': null,
      'videoMsgUrl': video,
      'videoPreviewImage': previewImage,
      'pdfMsgUrl': null,
      'mediaLength': mLength,
      'sendBy': '${widget.myfirstname} ${widget.mysecondname}',
      'ts': lastMsgTs,
      'imageUrl': widget.myprofImg,
      'isDeleted': false
    };

    DatabaseMethods()
        .addMessage(chatRoomId, messageId, messageInfo)
        .then((value) {
      Map<String, dynamic> lastMessageInfo = {
        'messageId': mid,
        'lastMessage': msg,
        'lastVoiceMsgUrl': null,
        'lastMusicMsgUrl': null,
        'lastPhotoMsgUrl': null,
        'lastVideoMsgUrl': video,
        'lastPdfMsgUrl': null,
        'lastMediaLength': mLength,
        'lastMessageSendTs': lastMsgTs,
        'lastMessageSendByFN': widget.myfirstname,
        'lastMessageSendBySN': widget.mysecondname,
        'lastMessageSendToFN': widget.firstname,
        'lastMessageSendToSN': widget.secondname,
        'lastMessageSenderDp': widget.myprofImg,
        'lastMessageSendDp': widget.profImg,
        'lastMessageSenderId': widget.currentUserId,
        'lastMessageSendId': widget.profileId,
        'users': <String>[widget.currentUserId!, widget.profileId!],
        'isDeleted': false
      };

      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video Sent Successfully!')),
    );
    setState(() {
      mFile = null;
      isUploading = false;
      captionController.clear();
      messageId = const Uuid().v4();
      fileType = 'photo';
    });
    getAndSetMessages();
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imgFile = Im.decodeImage(mFile!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$messageId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imgFile!, quality: 25));
    setState(() {
      mFile = compressedImageFile;
    });
  }

  Future<String> uploadImage(imgFile) async {
    UploadTask uploadTask =
        storageRef.child('message/Image/$messageId.jpg').putFile(imgFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {
    setState(() {
      chatScr = true;
      isUploading = true;
      messageId = const Uuid().v4();
    });
    await compressImage();
    String mediaUrl = await uploadImage(mFile);

    String mid = messageId;
    DateTime dateNow = DateTime.now();
    String? msg = captionController.text;
    var lastMsgTs = Timestamp.fromDate(dateNow);

    Map<String, dynamic> messageInfo = {
      'messageId': messageId,
      'message': msg,
      'voiceMsgUrl': null,
      'musicMsgUrl': null,
      'photoMsgUrl': mediaUrl,
      'videoMsgUrl': null,
      'videoPreviewImage': null,
      'pdfMsgUrl': null,
      'mediaLength': null,
      'sendBy': '${widget.myfirstname} ${widget.mysecondname}',
      'ts': lastMsgTs,
      'imageUrl': widget.myprofImg,
      'isDeleted': false
    };

    DatabaseMethods()
        .addMessage(chatRoomId, messageId, messageInfo)
        .then((value) {
      Map<String, dynamic> lastMessageInfo = {
        'messageId': mid,
        'lastMessage': msg,
        'lastVoiceMsgUrl': null,
        'lastMusicMsgUrl': null,
        'lastPhotoMsgUrl': mediaUrl,
        'lastVideoMsgUrl': null,
        'lastPdfMsgUrl': null,
        'lastMediaLength': null,
        'lastMessageSendTs': lastMsgTs,
        'lastMessageSendByFN': widget.myfirstname,
        'lastMessageSendBySN': widget.mysecondname,
        'lastMessageSendToFN': widget.firstname,
        'lastMessageSendToSN': widget.secondname,
        'lastMessageSenderDp': widget.myprofImg,
        'lastMessageSendDp': widget.profImg,
        'lastMessageSenderId': widget.currentUserId,
        'lastMessageSendId': widget.profileId,
        'users': <String>[widget.currentUserId!, widget.profileId!],
        'isDeleted': false
      };

      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfo);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image Sent Successfully!')),
    );
    setState(() {
      captionController.clear();
      mFile = null;
      isUploading = false;
      messageId = const Uuid().v4();
    });
    getAndSetMessages();
  }
}
