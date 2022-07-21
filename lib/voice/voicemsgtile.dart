
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoiceMessageTile extends StatefulWidget {
  final String voiceMessage;
  final bool sendByMe;
  final bool isDeleted;
  final Timestamp time;
  const VoiceMessageTile(
      {Key? key,
      required this.voiceMessage,
      required this.sendByMe,
      required this.isDeleted,
      required this.time})
      : super(key: key);

  @override
  _VoiceMessageTileState createState() => _VoiceMessageTileState();
}

class _VoiceMessageTileState extends State<VoiceMessageTile> {
  late AudioPlayer audioPlayer;
  int? selectedIndex;
  bool isStarted = false;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDeleted
        ? Row(
            mainAxisAlignment: widget.sendByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  width: 230,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24))),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: const [
                      Icon(Icons.access_time_outlined,
                          color: Colors.grey, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'This message is deleted',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: widget.sendByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: widget.sendByMe
                          ? LinearGradient(
                              colors: [Colors.pink.shade400, Colors.purple])
                          : const LinearGradient(
                              colors: [Colors.green, Colors.purple]),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24))),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.music_note_rounded),
                              SizedBox(width: 5),
                              Text('Voice Message'),
                            ],
                          ),
                          IconButton(
                              onPressed: () => _onListTileButtonPressed(),
                              icon: isStarted
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow))
                        ],
                      ),
                      Text(
                        widget.time.toDate().toString(),
                        //   '${DateFormat.yMMMd().format(time)}  ${DateFormat.Hm().format(time)}',
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 8),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  _onListTileButtonPressed() {
    setState(() {
      isStarted = true;
    });
    /*   audioPlayer.play(widget.voiceMessage, isLocal: false);

    audioPlayer.onPlayerCompletion.listen((duration) {
      setState(() {
        isStarted = false;
      });
    }); */
  }
}
