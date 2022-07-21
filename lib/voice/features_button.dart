// ignore_for_file: avoid_print

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:new_swarn_holidays/services/database.dart';

class FeatureButtonsView extends StatefulWidget {
  final Function onUploadComplete;
  final String chatRoomId;
  final String firstname;
  final String secondname;
  final String myfirstname;
  final String mysecondname;
  final String? profImg;
  final String? myprofImg;
  final String currentUserId;
  final String? profileId;
  const FeatureButtonsView(
      {Key? key,
      required this.onUploadComplete,
      required this.chatRoomId,
      required this.firstname,
      required this.secondname,
      required this.myfirstname,
      required this.mysecondname,
      required this.profImg,
      required this.myprofImg,
      required this.currentUserId,
      required this.profileId})
      : super(key: key);
  @override
  _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;
  String messageId = '';
  late AudioPlayer _audioPlayer;
  late String _filePath;
  late FlutterAudioRecorder2 _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _isRecorded
            ? _isUploading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: LinearProgressIndicator()),
                      Text(
                        'Uplaoding.....',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.replay,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: _onRecordAgainButtonPressed,
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: _onPlayButtonPressed,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.upload_file,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: _onFileUploadButtonPressed,
                      ),
                    ],
                  )
            : IconButton(
                icon: _isRecording
                    ? const Icon(
                        Icons.pause,
                        size: 40,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.fiber_manual_record,
                        size: 40,
                        color: Colors.white,
                      ),
                onPressed: _onRecordButtonPressed,
              ),
      ),
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    setState(() {
      _isUploading = true;
    });
    try {
      await uploadVoice();

      widget.onUploadComplete();
      Navigator.of(context).pop(); // most important line for me
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  uploadVoice() async {
    String voiceMsgUrl = await uploadfile(_filePath);
    var lastMsgTs = Timestamp.now();
    String mf = widget.myfirstname;
    String ms = widget.mysecondname;
    String f = widget.firstname;
    String s = widget.secondname;

    Map<String, dynamic> messageInfo = {
      'message': null,
      'voiceMsgUrl': voiceMsgUrl,
      'photoMsgUrl': null,
      'videoMsgUrl': null,
      'pdfMsgUrl': null,
      'sendBy': '$mf $ms',
      'ts': lastMsgTs,
      'imageUrl': widget.myprofImg,
    };

    //messageId
    if (messageId == '') {
      messageId = randomAlphaNumeric(12);
    }

    DatabaseMethods()
        .addMessage(widget.chatRoomId, messageId, messageInfo)
        .then((value) {
      Map<String, dynamic> lastMessageInfo = {
        'lastMessage': null,
        'lastVoiceMsgUrl': voiceMsgUrl,
        'lastPhotoMsgUrl': null,
        'lastVideoMsgUrl': null,
        'lastPdfMsgUrl': null,
        'lastMessageSendTs': lastMsgTs,
        'lastMessageSendBy': '$mf $ms',
        'lastMessageSendTo': '$f $s',
        'lastMessageSenderDp': widget.myprofImg,
        'lastMessageSendDp': widget.profImg,
        'lastMessageSenderId': widget.currentUserId,
        'lastMessageSendId': widget.profileId,
        'users': <String>[widget.currentUserId, widget.profileId!]
      };

      DatabaseMethods()
          .updateLastMessageSend(widget.chatRoomId, lastMessageInfo);
    });
  }

  Future<String> uploadfile(imgFile) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    UploadTask uploadTask = firebaseStorage
        .ref('voiceMsg')
        .child(
            _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
        .putFile(File(_filePath));
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      //    _audioPlayer.play(_filePath, isLocal: true);
      /*   _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      }); */
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool? hasRecordingPermission =
        await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
  }
}
