// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';



class FirebaseSongList extends StatefulWidget {
  String? songName;
  String? subtitle;
String? url;
  int index;
  AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  FirebaseSongList({
    super.key,
    required this.songName,
    required this.subtitle,
    required this.url,
    required this.index,
    required this.snapshot,
  });

  @override
  State<FirebaseSongList> createState() => _FirebaseSongListState();
}

class _FirebaseSongListState extends State<FirebaseSongList> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayerSingleton().audioPlayer;
  

  void showPopupMenu(BuildContext context, int index,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset offset = overlay.localToGlobal(Offset.zero);
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
      PopupMenuItem(
        value: "favorite",
        child: Row(
          children: [
            const Icon(Icons.favorite),
            const SizedBox(width: 8),
            Text(
              "Favorite",
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
        offset.dx,
        offset.dy + MediaQuery.of(context).padding.top + kToolbarHeight,
        offset.dx + MediaQuery.of(context).size.width,
        offset.dy + MediaQuery.of(context).padding.top + kToolbarHeight + 100,
      ),
      items: menuItems,
      initialValue: null,
    ).then((value) {
      if (value != null) {
        switch (value) {
          case "delete":
            if (snapshot.data!.docs.isEmpty) {
              snapshot.data!.docs.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Song Deleted"),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {},
                ),
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
          case "favorite":
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 217, 130, 243).withOpacity(0.3),
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
            showPopupMenu(context, widget.index, widget.snapshot);
          },
          icon: const Icon(Icons.more_vert),
        ),
        onTap: () {
          // context.read<SongModelProvider>().setId(widget.snapshot);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PlayScreen(
          //       songModel: widget.songModel!,
          //       audioplayer: playaudio,
          //     ),
          //   ),
          // );
          print(widget.snapshot.data!.docs.length);
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
