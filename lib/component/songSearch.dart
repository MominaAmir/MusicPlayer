
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/component/FirebaseSongList.dart';

class SongSearchDelegate extends SearchDelegate<String> {
  final List<DocumentSnapshot> _songs;
  final AsyncSnapshot<QuerySnapshot<Object?>> _snapshot;

  SongSearchDelegate(this._songs, this._snapshot);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _songs.where((song) {
      var songData = song.data() as Map<String, dynamic>;
      String name = songData['name'];
      return name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var song = results[index];
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
          snapshot: _snapshot,
          imageurl: imageurl,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _songs.where((song) {
      var songData = song.data() as Map<String, dynamic>;
      String name = songData['name'];
      return name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(150, 230, 143, 245),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("lib/assest/background.jpg"),
          fit: BoxFit.cover,
        )),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          var song = suggestions[index];
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
            snapshot: _snapshot,
            imageurl: imageurl,
          );
        },
      ),
    ));
  }
}
