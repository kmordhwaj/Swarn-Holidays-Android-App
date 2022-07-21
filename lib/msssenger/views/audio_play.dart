import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/msssenger/views/audio_widget.dart';

class AudioPlay extends StatelessWidget {
  final String audioFile;
  const AudioPlay({Key? key, required this.audioFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purple])),
                child: const Center(
                  child: Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              AudioWidget(
                audioFile: audioFile,
              )
            ],
          ),
        ),
      ),
    );
  }
}
