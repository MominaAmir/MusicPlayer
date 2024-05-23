// ignore_for_file: file_names

class AlbumSongs {
  String title;
  String id;
  String name;
  String url;
  String imageurl;
  String duration; // Duration in seconds

  AlbumSongs({required this.id, required this.name, required this.url, required this.duration, required this.title, required this.imageurl});

   factory AlbumSongs.fromJson(Map<String, dynamic> json) {
    return AlbumSongs(
      title: json['title'] ?? 'Unknown Title', id: json['id']?? 'Unknown id',
       name:(json['artists'] != null && json['artists'].isNotEmpty)
          ? json['artists'][0]['name']
          : 'Unknown artist',
       url: json['url']?? '', duration: json['duration']?? '',
      imageurl: (json['thumbnails'] != null && json['thumbnails'].isNotEmpty)
          ? json['thumbnails'][0]['url']
          : '',
    );
  }
}
