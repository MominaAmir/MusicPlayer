// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:musicplayer/Pages/miniplayer.dart';
import 'package:musicplayer/component/FirebaseSongList.dart';
import 'package:musicplayer/component/songSearch.dart';

class TopSongs extends StatefulWidget {
  const TopSongs({super.key});

  @override
  State<TopSongs> createState() => _TopSongsState();
}

class _TopSongsState extends State<TopSongs> {
  List<DocumentSnapshot> _songs = [];
  AsyncSnapshot<QuerySnapshot<Object?>>? _snapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Top Songs',
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
                      if (_snapshot != null) {
                        showSearch(
                          context: context,
                          delegate: SongSearchDelegate(_songs, _snapshot!),
                        );
                      }
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('TopSongs')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No songs found.'),
                        );
                      }

                      _snapshot =
                          snapshot; // Set the snapshot for the search delegate
                      _songs = snapshot.data!.docs; // Update the songs list

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var song = snapshot.data!.docs[index];
                          var songData = song.data() as Map<String, dynamic>;
                          String artist = songData['artist'];
                          String name = songData['name'];
                          String url = songData['url'];
                          String imageurl = songData['imageurl'];
                          return FirebaseSongList(
                            songName: name,
                            subtitle: artist,
                            url: url,
                            index: index,
                            snapshot: snapshot,
                            imageurl: imageurl,
                          );
                        },
                      );
                    },
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
