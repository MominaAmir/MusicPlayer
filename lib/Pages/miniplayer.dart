import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/component/FirebaseSongList.dart';

class MiniPlayer extends StatefulWidget {
  final String songName;
  final String url;

  MiniPlayer({
    required this.songName,
    required this.url,
  });

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayer audioPlayer = AudioPlayerSingleton().audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: ListTile(
        leading: Icon(Icons.music_note, color: Colors.white),
        title: Text(
          widget.songName,
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
          onPressed: () {
            if (isPlaying) {
              audioPlayer.pause();
            } else {
              audioPlayer.play();
            }
          },
        ),
      ),
    );
  }
}
