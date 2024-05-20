// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class FirebaseSongList extends StatefulWidget {
  String? songName;
  String? subtitle;
  String? url;
  int index;
  AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
   Function(String, String) onSongTap;

  FirebaseSongList({
    super.key,
    required this.songName,
    required this.subtitle,
    required this.url,
    required this.index,
    required this.snapshot, required this.onSongTap,
  });

  @override
  State<FirebaseSongList> createState() => _FirebaseSongListState();
}

class _FirebaseSongListState extends State<FirebaseSongList> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayerSingleton().audioPlayer;
  
  bool isplaying = false;

 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.minPositive,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 205, 96, 238).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.music_note, size: 40),
        title: Text(
          widget.songName!,
          maxLines: 1,
        ),
        subtitle: Text(
          widget.subtitle!,
          maxLines: 1,
        ),
        trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          if (isplaying) {
                            AudioPlayerSingleton().audioPlayer.pause();
                          } else {
                            AudioPlayerSingleton().audioPlayer.play();
                          }
                          isplaying = !isplaying;
                        });
                      },
                      icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
                    ),
        onTap: () async {
          try {
            await AudioPlayerSingleton().audioPlayer.setUrl(widget.url!);
            await AudioPlayerSingleton().audioPlayer.play();
            widget.onSongTap(widget.songName!, widget.url!);
            setState(() {
        isplaying = true;
      });
          } catch (e) {
            print('Error playing song: $e');
          }
        },
      ),
    );
  }
}

class AudioPlayerSingleton {
  static final AudioPlayerSingleton _instance =
      AudioPlayerSingleton._internal();

  factory AudioPlayerSingleton() {
    return _instance;
  }

  late AudioPlayer _audioPlayer;

  AudioPlayerSingleton._internal() {
    _audioPlayer = AudioPlayer();
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}
