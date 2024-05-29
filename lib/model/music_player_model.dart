import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MusicPlayerModel extends ChangeNotifier {
  late final AudioPlayer _audioPlayer;
  String _songName = 'null';
  String _url = '';
  String _imageurl = '';
  bool _isPlaying = false;
  Duration duration = const Duration();
  Duration playing = const Duration();
  List<Map<String, String>> downloadedSongs = [];
  Map<String, bool> _isDownloading = {};
  Map<String, bool> _isDownloaded = {};

  String get songName => _songName;
  String get url => _url;
  String get imageurl => _imageurl;
  bool get isPlaying => _isPlaying;

  MusicPlayerModel() {
    _audioPlayer = AudioPlayer();

    _audioPlayer.positionStream.listen((play) {
      playing = play;

      // Check if the playtime equals the duration
      if (playing >= duration && duration != Duration.zero) {
        _audioPlayer.seek(Duration.zero);
      }

      notifyListeners();
    });

    _audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration = dur;
        notifyListeners();
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      _isPlaying = playerState.playing;
      notifyListeners();
    });
  }

  Future<void> play(String songName, String urlOrUri, String imageurl, String artist) async {
    _songName = songName;
    _url = urlOrUri;
    _imageurl = imageurl;

    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    }

      try {
      final mediaItem = MediaItem(
        id: urlOrUri,
        album: 'Unknown Album',
        title: songName,
        artist: artist ?? 'Unknown Artist',
        artUri: Uri.parse(imageurl),
      );

      if (Uri.tryParse(urlOrUri)?.isAbsolute ?? false) {
        await _audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(urlOrUri),
          tag: mediaItem,
        ));
      } else {
          print("File not found: $urlOrUri");
          return; // Return early if the file does not exist
        }

      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      print("Error playing song: $e");
    }
  }
 final _downloadedSongsStreamController = StreamController<List<Map<String, String>>>();

  Stream<List<Map<String, String>>> get downloadedSongsStream => _downloadedSongsStreamController.stream;

  void removeDownloadedSong(int index) async{
    await downloadedSongs.removeAt(index);
   _downloadedSongsStreamController.add(downloadedSongs);
    notifyListeners();
  }
  
  void deleteFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await file.delete();
  }
  notifyListeners();
}

  Future<void> downloadSong(String url, String songName, BuildContext context, String imageurl, String artist) async {
    _isDownloading[songName] = true;
    _isDownloaded[songName] = false;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$songName.mp3';
      final ref = FirebaseStorage.instance.refFromURL(url);
      final file = File(filePath);
      await ref.writeToFile(file);
      downloadedSongs.add({'name': songName, 'path': filePath, 'url': url , 'imageurl': imageurl , 'artist' :artist});

      _isDownloading[songName] = false;
      _isDownloaded[songName] = true;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$songName downloaded successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Downloaded $songName to $filePath');
    } catch (e) {
      _isDownloading[songName] = false;
      _isDownloaded[songName] = false;
      notifyListeners();
      print('Error downloading song: $e');
    }
  }

  Future<List<Map<String, String>>> fetchDownloadedSongs() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().where((file) => file.path.endsWith('.mp3')).toList();
    downloadedSongs = files.map((file) {
      return {'name': file.path.split('/').last, 'path': file.path};
    }).toList();
    return downloadedSongs;
  }

  bool isDownloading(String songName) => _isDownloading[songName] ?? false;
  bool isDownloaded(String songName) => _isDownloaded[songName] ?? false;

  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    notifyListeners();
  }

  Future<void> sliderChanges(int seconds) async {
    Duration duration = Duration(seconds: seconds);
    await _audioPlayer.seek(duration);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}












// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class MusicPlayerModel extends ChangeNotifier {
//   late final AudioPlayer _audioPlayer;
//   String _songName = 'null';
//   String _url = '';
//   String _imageurl = '';
//   bool _isPlaying = false;
//   Duration duration = const Duration();
//   Duration playing = const Duration();
//   List<Map<String, String>> downloadedSongs = [];

//   String get songName => _songName;
//   String get url => _url;
//   String get imageurl => _imageurl;
//   bool get isPlaying => _isPlaying;

//   MusicPlayerModel() {
//     _audioPlayer = AudioPlayer();

//     _audioPlayer.positionStream.listen((play) {
//       playing = play;

//       // Check if the playtime equals the duration
//       if (playing >= duration && duration != Duration.zero) {
//         _audioPlayer.seek(Duration.zero);
//       }

//       notifyListeners();
//     });

//     _audioPlayer.durationStream.listen((dur) {
//       if (dur != null) {
//         duration = dur;
//         notifyListeners();
//       }
//     });

//     _audioPlayer.playerStateStream.listen((playerState) {
//       _isPlaying = playerState.playing;
//       notifyListeners();
//     });
//   }

//   Future<void> play(String songName, String urlOrUri, String imageurl) async {
//     _songName = songName;
//     _url = urlOrUri;
//     _imageurl = imageurl;

//     if (_audioPlayer.playing) {
//       await _audioPlayer.pause();
//     }

//     try {
//       if (Uri.tryParse(urlOrUri)?.isAbsolute ?? false) {
//         await _audioPlayer.setUrl(urlOrUri);
//       } else {
//         final file = File(urlOrUri);
//         if (await file.exists()) {
//           final mediaItem = MediaItem(
//             id: songName,
//             album: "Album",
//             title: songName,
//             artUri: Uri.tryParse(imageurl ?? ''),
//           );

//           await _audioPlayer.setAudioSource(
//             AudioSource.uri(
//               Uri.file(file.path),
//               tag: mediaItem,
//             ),
//           );
//         } else {
//           print("File not found: $urlOrUri");
//           return; // Return early if the file does not exist
//         }
//       }

//       await _audioPlayer.play();
//       notifyListeners();
//     } catch (e) {
//       print("Error playing song: $e");
//     }
//   }

//   Future<void> downloadSong(String url, String songName) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/$songName.mp3';
//       final ref = FirebaseStorage.instance.refFromURL(url);
//       final file = File(filePath);
//       await ref.writeToFile(file);
//       downloadedSongs.add({'name': songName, 'path': filePath});
//       notifyListeners();
//       print('Downloaded $songName to $filePath');
//     } catch (e) {
//       print('Error downloading song: $e');
//     }
//   }

//   Future<List<Map<String, String>>> fetchDownloadedSongs() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final files = directory.listSync().where((file) => file.path.endsWith('.mp3')).toList();
//     downloadedSongs = files.map((file) {
//       return {'name': file.path.split('/').last, 'path': file.path};
//     }).toList();
//     return downloadedSongs;
//   }

//   Future<void> pause() async {
//     await _audioPlayer.pause();
//     notifyListeners();
//   }

//   Future<void> playPause() async {
//     if (isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.play();
//     }
//     notifyListeners();
//   }

//   Future<void> sliderChanges(int seconds) async {
//     Duration duration = Duration(seconds: seconds);
//     await _audioPlayer.seek(duration);
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }
