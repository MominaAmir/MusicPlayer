import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MusicPlayerModel extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _songName = 'null';
  String _url = '';
  String _imageurl = '';
  bool _isPlaying = false;
  Duration duration = const Duration();
  Duration playing = const Duration();
  List<Map<String, String>> downloadedSongs = [];

  String get songName => _songName;
  String get url => _url;
  String get imageurl => _imageurl;
  bool get isPlaying => _isPlaying;

  MusicPlayerModel() {
    _audioPlayer.positionStream.listen((play) {
      playing = play;
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

  Future<void> play(String songName, String urlOrUri, String imageurl) async {
    _songName = songName;
    _url = urlOrUri;
    _imageurl = imageurl;

    if (Uri.tryParse(urlOrUri)?.isAbsolute ?? false) {
      await _audioPlayer.setUrl(urlOrUri);
    } else {
      final file = File(urlOrUri);
      if (await file.exists()) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.file(urlOrUri),
            tag: MediaItem(
              id: songName ?? 'Unknown Song',
              album: "Album",
              title: songName ?? 'Unknown Song',
              artUri: Uri.tryParse(imageurl ?? ''),
            ),
          ),
        );
      } else {
        print("File not found: $urlOrUri");
      }
    }

    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> downloadSong(String url, String songName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$songName.mp3';
      final ref = FirebaseStorage.instance.refFromURL(url);
      final file = File(filePath);
      await ref.writeToFile(file);
      downloadedSongs.add({'name': songName, 'path': filePath});
      notifyListeners();
      print('Downloaded $songName to $filePath');
    } catch (e) {
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

// class MusicPlayerModel extends ChangeNotifier {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   String _songName = 'null';
//   late String _url;

//   Duration duration = const Duration();
//   Duration playing = const Duration();

//   String get songName => _songName;
//   String get url => _url;
//   bool get isPlaying => _audioPlayer.playing;

//   MusicPlayerModel() {
//     _audioPlayer.positionStream.listen((play) {
//       playing = play;
//       notifyListeners(); // Ensure UI updates continuously
//     });

//     _audioPlayer.durationStream.listen((dur) {
//       if (dur != null) {
//         duration = dur;
//         notifyListeners(); // Ensure UI updates continuously
//       }
//     });
//   }

//   Future<void> play(String songName, String url) async {
//     _songName = songName;
//     _url = url;
//     await _audioPlayer.setUrl(url);
//     await _audioPlayer.play();
//     notifyListeners();
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

//   Future<void> playNext() async {
//     // Implement logic for playing the next song
//     print("Next Song Playing");
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }
