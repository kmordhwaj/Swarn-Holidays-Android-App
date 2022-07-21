// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_swarn_holidays/msssenger/views/viewpdfurl.dart';

class PdfMessageTile extends StatefulWidget {
  final String? message;
  final bool sendByMe;
  final String pdfMessage;
  final bool longPressed;
  final bool isDeleted;
  final Timestamp time;
  final Function onLongPress;
  const PdfMessageTile(
      {Key? key,
      required this.message,
      required this.sendByMe,
      required this.pdfMessage,
      required this.time,
      required this.isDeleted,
      required this.onLongPress,
      required this.longPressed})
      : super(key: key);

  @override
  _PdfMessageTileState createState() => _PdfMessageTileState();
}

class _PdfMessageTileState extends State<PdfMessageTile> {
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewPdfUrl(file: widget.pdfMessage)));
            },
            onLongPress: () {
              widget.onLongPress.call();
            },
            child: Row(
              mainAxisAlignment: widget.sendByMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.pink])),
                              child: Center(
                                child: Text(
                                  '.pdf',
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            description()
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.only(
                                  topLeft: widget.sendByMe
                                      ? const Radius.circular(24)
                                      : const Radius.circular(0),
                                  bottomRight: widget.sendByMe
                                      ? const Radius.circular(24)
                                      : const Radius.circular(0),
                                  topRight: widget.sendByMe
                                      ? const Radius.circular(0)
                                      : const Radius.circular(24),
                                  bottomLeft: widget.sendByMe
                                      ? const Radius.circular(0)
                                      : const Radius.circular(24))),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${DateFormat.yMMMEd().format(widget.time.toDate())}  ${DateFormat.Hm().format(widget.time.toDate())}',
                              style: const TextStyle(
                                  color: Colors.lightBlue, fontSize: 13),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  description() {
    int msgl = widget.message!.length;
    bool noMsg = msgl == 0;
    return noMsg
        ? Container()
        : Positioned(
            bottom: 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 37, 34, 34).withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  widget.message!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          );
  }
}
