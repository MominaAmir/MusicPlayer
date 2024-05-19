// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumSongs {
  String id;
  String name;
  String url;
  int duration; // Duration in seconds

  AlbumSongs({required this.id, required this.name, required this.url, required this.duration});

  factory AlbumSongs.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AlbumSongs(
      id: doc.id,
      name: data['name'] ?? '',
      url: data['url'] ?? '',
      duration: data['duration'] ?? 0,
    );
  }
}
