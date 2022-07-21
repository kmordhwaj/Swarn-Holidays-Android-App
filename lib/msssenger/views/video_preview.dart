import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/msssenger/views/video_widget.dart';

class VideoPreview extends StatelessWidget {
  final File? videofile;
  const VideoPreview({Key? key, required this.videofile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: VideoWidget(videoFile: videofile),
          ),
        ),
      ),
    );
  }
}
