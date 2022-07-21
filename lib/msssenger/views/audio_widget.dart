import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWidget extends StatefulWidget {
  final String audioFile;
  const AudioWidget({Key? key, required this.audioFile}) : super(key: key);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  late bool _isPlaying;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _isPlaying = true;
    //  _audioPlayer.play(widget.audioFile);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(CupertinoIcons.backward_end_alt_fill, color: Colors.white),
        IconButton(
            onPressed: _onPlayButtonPressed,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_circle)),
        const Icon(Icons.double_arrow_rounded, color: Colors.white)
      ],
    );
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      //  _audioPlayer.play(widget.audioFile, isLocal: true);
      /*    _audioPlayer.onPlayerCompletion.listen((duration) {
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
}
