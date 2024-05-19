// ignore_for_file: non_constant_identifier_names, avoid_print, collection_methods_unrelated_type

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteSongs extends StatefulWidget {
  const FavoriteSongs({super.key});

  @override
  State<FavoriteSongs> createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends State<FavoriteSongs> {

  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayer();

  void PlaySong(String? uri) {
    try {
      playaudio.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      playaudio.play();
    } on Exception {
      print("Error playing song");
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("lib/assest/background.jpg"),
              fit: BoxFit.cover,
            )),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  backgroundColor: const Color(0xF58C08A9),
                  automaticallyImplyLeading: false,
                  
                  title: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: SelectionArea(
                      child: Text(
                        'Favorites',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.acme(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: IconButton(
                        hoverColor: const Color.fromARGB(255, 73, 1, 70),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          print('Search IconButton pressed ...');
                        },
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(7),
                    child: Container(),
                  ),
                  centerTitle: true,
                  elevation: 10,
                ),
              ],
            ),
          ),
    );
  }
}

class FavoriteController extends GetxController {
  RxList<SongModel> favorites = <SongModel>[].obs;

  void addToFavorites() {
    // if (!favorites.contains()) {
    //   favorites.add();
    // }
  }

  void removeFromFavorites(String item) {
    favorites.remove(item);
  }
}