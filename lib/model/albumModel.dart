
class AlbumSongs {
  final String title;
  final String artist;
  final String url;
  final String albumName; // Add albumName parameter
  final String albumId;
  String imageurl; // Add albumId parameter

  AlbumSongs(
      {required this.title,
      required this.artist,
      required this.url,
      required this.albumName,
      required this.albumId,
      required this.imageurl});

  factory AlbumSongs.fromJson(Map<String, dynamic> json) {
    var albumData = json['album'];
    var albumName =
        albumData != null && albumData['name'] != null ? albumData['name'] : '';
    var albumId =
        albumData != null && albumData['id'] != null ? albumData['id'] : '';

    return AlbumSongs(
      title: json['title'] ?? '',
      artist: (json['artists'] != null && json['artists'].isNotEmpty)
          ? json['artists'][0]['name'] ?? ''
          : '',
      url: 'https://www.youtube.com/watch?v=${json['videoId']}',
      albumName: albumName,
      albumId: albumId,
      imageurl: (json['thumbnails'] != null && json['thumbnails'].isNotEmpty)
          ? json['thumbnails'][0]['url']
          : '',
    );
  }
}

