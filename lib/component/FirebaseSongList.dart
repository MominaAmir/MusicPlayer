import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/model/music_player_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FirebaseSongList extends StatefulWidget {
  String? songName;
  String? subtitle;
  String? url;
  String? imageurl;
  String? artist;
  int index;
  AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  FirebaseSongList({
    super.key,
    required this.songName,
    required this.subtitle,
    required this.url,
    required this.imageurl,
    required this.index,
    required this.snapshot,
    required this.artist,
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 66, 20, 80).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: widget.imageurl != null
            ? Image.network(widget.imageurl!, fit: BoxFit.cover)
            : const Icon(Icons.music_note, size: 20),
        title: Text(
          widget.songName!,
          maxLines: 1,
        ),
        subtitle: Text(
          widget.subtitle!,
          maxLines: 1,
        ),
        trailing: Consumer<MusicPlayerModel>(
  builder: (context, model, child) {
    bool isDownloading = model.isDownloading(widget.songName!);
    bool isDownloaded = model.isDownloaded(widget.songName!);
    return IconButton(
      onPressed: isDownloaded
          ? null 
          : () {
              Provider.of<MusicPlayerModel>(context, listen: false)
                  .downloadSong(widget.url!, widget.songName!, context, widget.imageurl!, widget.artist!)
                  .then((_) {
                // Show Snackbar when download is completed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.songName} Downloaded Successfully!'),
                    duration: Duration(seconds: 3),
                  ),
                );
              });
            },
      icon: isDownloading
          ? CircularProgressIndicator() 
          : Icon(
              isDownloaded ? Icons.done : Icons.download_sharp,
              color: isDownloaded ? Colors.green : null, 
            ),
    );
  },
),

        // trailing: IconButton(
        //   onPressed: () {
        //     Provider.of<MusicPlayerModel>(context, listen: false).downloadSong(widget.url!, widget.songName!);
        //   },
        //   icon: Icon(Icons.download_sharp),
        // ),
        onTap: () async {
          try {
            Provider.of<MusicPlayerModel>(context, listen: false).play(widget.songName!, widget.url!, widget.imageurl!, widget.artist!);
            setState(() {});
          } catch (e) {
            print('Error playing song: $e');
          }
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










// // ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print, file_names

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:musicplayer/model/music_player_model.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:provider/provider.dart';

// class FirebaseSongList extends StatefulWidget {
//   String? songName;
//   String? subtitle;
//   String? url;
//   String? imageurl;
//   int index;
//   AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

//   FirebaseSongList({
//     super.key,
//     required this.songName,
//     required this.subtitle,
//     required this.url,
//     required this.imageurl,
//     required this.index,
//     required this.snapshot,
//   });

//   @override
//   State<FirebaseSongList> createState() => _FirebaseSongListState();
// }

// class _FirebaseSongListState extends State<FirebaseSongList> {
//   final OnAudioQuery audioQuery = OnAudioQuery();
//   final AudioPlayer playaudio = AudioPlayerSingleton().audioPlayer;
  
//   bool isplaying = false;

 
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.minPositive,
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 205, 96, 238).withOpacity(0.3),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ListTile(
//         leading: widget.imageurl != null
//             ? Image.network(widget.imageurl!, fit: BoxFit.cover)
//             : const Icon(Icons.music_note, size: 20),
//         title: Text(
//           widget.songName!,
//           maxLines: 1,
//         ),
//         subtitle: Text(
//           widget.subtitle!,
//           maxLines: 1,
//         ),
//         trailing: IconButton(
//           onPressed: (){},
//           icon: Icon(Icons.download_sharp),
//           ),
//         onTap: () async {
//           try {
//             Provider.of<MusicPlayerModel>(context, listen: false).play(widget.songName!,widget.url! );
//             setState(() {});
//           } catch (e) {
//             print('Error playing song: $e');
//           };
//         },
//       ),
//     );
//   }
// }

// class AudioPlayerSingleton {
//   static final AudioPlayerSingleton _instance =
//       AudioPlayerSingleton._internal();

//   factory AudioPlayerSingleton() {
//     return _instance;
//   }

//   late AudioPlayer _audioPlayer;

//   AudioPlayerSingleton._internal() {
//     _audioPlayer = AudioPlayer();
//   }

//   AudioPlayer get audioPlayer => _audioPlayer;
// }