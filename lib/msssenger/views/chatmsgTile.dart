// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageTile extends StatefulWidget {
  final String? message;
  final bool sendByMe;
  final bool longPressed;
//  final bool longPressedAgain;
//  final bool longPressedG;
  final bool isDeleted;
  final Timestamp time;
  final Function onLongPress;
  // final Function onPress;
  const ChatMessageTile(
      {Key? key,
      required this.message,
      required this.sendByMe,
      required this.isDeleted,
      required this.time,
      //   required this.longPressedG,
      //    required this.longPressedAgain,
      //   required this.onPress,
      required this.onLongPress,
      required this.longPressed})
      : super(key: key);

  @override
  _ChatMessageTileState createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends State<ChatMessageTile> {
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
        : GestureDetector(
            onLongPress: () {
              widget.onLongPress.call();
            },
            /*   onTap: widget.longPressedG
                ? () {
                    widget.onPress.call();
                  }
                : () {}, */
            child: Container(
              color: widget.longPressed
                  ? Colors.blue.withOpacity(0.3)
                  //     : widget.longPressedAgain
                  //         ? Colors.blue.withOpacity(0.3)
                  : Colors.transparent,
              child: Row(
                mainAxisAlignment: widget.sendByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.sendByMe ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(24),
                              bottomRight: widget.sendByMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(24),
                              topRight: const Radius.circular(24),
                              bottomLeft: widget.sendByMe
                                  ? const Radius.circular(24)
                                  : const Radius.circular(0))),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Text(
                            widget.message!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                          Text(
                            '${DateFormat.yMMMEd().format(widget.time.toDate())}  ${DateFormat.Hm().format(widget.time.toDate())}',
                            // widget.time.toDate().toString(),
                            //   '${DateFormat.yMMMd().format(time)}  ${DateFormat.Hm().format(time)}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
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
}
