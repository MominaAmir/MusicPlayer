import 'package:musicplayer/model/albumModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:musicplayer/model/music_player_model.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String apiUrl = 'https://youtube-music6.p.rapidapi.com/ytmusic/';
  final String downloaderApiUrl =
      'https://youtube-mp3-downloader2.p.rapidapi.com/ytmp3/ytmp3/';
  late TextEditingController _searchController;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<AlbumSongs> _searchResults = [];
  List<AlbumSongs> displayList = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResults = [];
    displayList = List.from(_searchResults);

    // Initialize notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


Future<void> saveDownloadedSong(String title, String artist, String imageUrl, String audioUrl) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? downloadedSongs = prefs.getStringList('downloaded_songs') ?? [];

  downloadedSongs.add('$title,$artist,$imageUrl,$audioUrl');
  await prefs.setStringList('downloaded_songs', downloadedSongs);
}


  void _searchSongs(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?query=$query'),
        headers: {
          'X-RapidAPI-Key':
              '049340387emsh1ef19f738c7e73bp152296jsnfe5238b04e6d',
          'X-RapidAPI-Host': 'youtube-music6.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug: print the API response
        print('API Response: $data');

        setState(() {
          _searchResults =
              (data as List).map((item) => AlbumSongs.fromJson(item)).toList();
          displayList = List.from(_searchResults);
        });
      } else {
        setState(() {
          displayList = [];
        });
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load data: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _playSong(String videoUrl, String songName, String imageurl) async {
    try {
      final response = await http.get(
        Uri.parse('$downloaderApiUrl?url=$videoUrl'),
        headers: {
          'X-RapidAPI-Key':
              '049340387emsh1ef19f738c7e73bp152296jsnfe5238b04e6d',
          'X-RapidAPI-Host': 'youtube-mp3-downloader2.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioUrl = data['dlink'] as String?;

        if (audioUrl != null && audioUrl.isNotEmpty) {
          Provider.of<MusicPlayerModel>(context, listen: false)
              .play(songName, audioUrl, imageurl);
          setState(() {});
        } else {
          throw Exception('Failed to load audio: audioUrl is empty');
        }
      } else {
        throw Exception('Failed to load audio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load audio: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _downloadSong(String videoUrl, String title, String artist, String imageUrl) async {
  try {
final response = await http.get(
        Uri.parse('$downloaderApiUrl?url=$videoUrl'),
        headers: {
          'X-RapidAPI-Key':
              '049340387emsh1ef19f738c7e73bp152296jsnfe5238b04e6d',
          'X-RapidAPI-Host': 'youtube-mp3-downloader2.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioUrl = data['dlink'];


    if (audioUrl != null && audioUrl.isNotEmpty) {
      }

      await saveDownloadedSong(title, artist, imageUrl, audioUrl);

      _showNotification('Download Started', 'Your download has started.');
    } else {
      throw Exception('Failed to download audio: audioUrl is empty');
    }
  } catch (e) {
    // Error handling code...
  }
}


  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'Harmony',
      channelDescription: 'My Music Player',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assest/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Search for a Song",
            style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xF58C08A9),
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  fillColor: Colors.black.withOpacity(0.3),
                  filled: true,
                  hintText: "Enter song name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.black,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                onSubmitted: (_searchControl) {
                  _searchSongs(_searchControl);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.minPositive,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 205, 96, 238)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: displayList[index].imageurl.isNotEmpty
                            ? Image.network(
                                displayList[index].imageurl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.music_note);
                                },
                              )
                            : const Icon(Icons.music_note),
                        title: Text(displayList[index].title,
                            style: TextStyle(color: Colors.black)),
                        subtitle: Text(displayList[index].artist),
                        trailing: IconButton(
                          onPressed: () {
                            _downloadSong(displayList[index].url,  displayList[index].title,displayList[index].artist,
                                displayList[index].imageurl, );
                          },
                          icon: Icon(Icons.download),
                        ),
                        onTap: () async {
                          try {
                            _playSong(
                                displayList[index].url,
                                displayList[index].title,
                                displayList[index].imageurl);
                          } catch (e) {
                            print('Error playing song: $e');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
