// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Pages/playScreen.dart';
import 'package:musicplayer/model/music_player_model.dart';
import 'package:musicplayer/model/song_data_controller.dart';
import 'package:musicplayer/provider/SongModelProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';



class SongList extends StatefulWidget {
  String? songName;
  String? subtitle;
  SongModel? songModel;
  int id;
  int index;
  SongDataController controller;

  SongList({
    super.key,
    required this.songName,
    required this.subtitle,
    required this.songModel,
    required this.id,
    required this.index,
    required this.controller,
  });

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayerSingleton().audioPlayer;
  Uint8List? artwork;

  @override
  void initState() {
    super.initState();
    _loadArtwork();
  }
 void _loadArtwork() async {
    final result = await audioQuery.queryArtwork(widget.id, ArtworkType.AUDIO);
    if (mounted) {
      setState(() {
        artwork = result;
      });
    }
  }

  void showPopupMenu(BuildContext context, int index, SongDataController controller,  Offset tapPosition) {
    final menuItems = [
      PopupMenuItem(
        value: "delete",
        child: Row(
          children: [
            const Icon(Icons.delete),
            const SizedBox(width: 8),
            Text(
              "Delete",
              style: GoogleFonts.arimo(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: "edit",
        child: Row(
          children: [
            const Icon(Icons.edit),
            const SizedBox(width: 8),
            Text(
              "Edit",
              style: GoogleFonts.arimo(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      
    ];

    showMenu(
      context: context,
     position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 10,
        tapPosition.dy + 10,
      ),
      items: menuItems,
      initialValue: null,
    ).then((value) {
      if (value != null) {
        switch (value) {
          case "delete":
            if (controller.localsonglist.isNotEmpty) {
              controller.localsonglist.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Song Deleted"),
                duration: Duration(seconds: 3),
              ));
            } else {
              print("List is empty");
            }
            break;
          case "edit":
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Song name Edited"),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {},
              ),
            ));
            break;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 66, 20, 80).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: artwork != null
            ? Image.memory(artwork!, fit: BoxFit.cover)
            : const Icon(Icons.music_note, size: 40),
        title: Text(
          widget.songName!,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
        ),
        subtitle: Text(
          widget.subtitle!,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
        ),
       
        trailing:  GestureDetector(
                            onTapDown: (TapDownDetails details) {
            showPopupMenu(context, widget.index, widget.controller, details.globalPosition);
                            },
                            child: const Icon(Icons.more_vert),
                          ),
        onTap: () async{
          context.read<SongModelProvider>().setId(widget.songModel!.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayScreen(
                songModel: widget.songModel!,
                controller: widget.controller,
                index: widget.index,
              ),
            ),
          );
          print(widget.songModel!.displayNameWOExt);
        },
      ),
    );
  }
}



class AudioPlayerSingleton {
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._internal();

  factory AudioPlayerSingleton() {
    return _instance;
  }

  late AudioPlayer _audioPlayer;

  AudioPlayerSingleton._internal() {
    _audioPlayer = AudioPlayer();
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}

