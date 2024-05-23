import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer/model/albumModel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String apiUrl = 'https://youtube-music6.p.rapidapi.com/ytmusic/';
  late TextEditingController _searchController;

  final List<AlbumSongs> _searchResults = [];
  late List<AlbumSongs> displayList;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    displayList = List.from(_searchResults);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        final List<dynamic> data = jsonDecode(response.body);

        // Debug: print the API response
        print('API Response: $data');

        setState(() {
          _searchResults.clear();
          _searchResults
              .addAll(data.map((e) => AlbumSongs.fromJson(e)).toList());
          displayList = List.from(_searchResults);
        });
      } else {
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
                    final song = displayList[index];
                    return Container(
                      width: double.minPositive,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 205, 96, 238)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: song.imageurl.isNotEmpty
                        ? Image.network(
                            song.imageurl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Icon(Icons.music_note);
                            },
                          )
                        : Icon(Icons.music_note),
                        title: Text(
                          song.title, // Assuming AlbumSongs has a 'title' field
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(song.name),
                        trailing: IconButton(
                            onPressed: () {}, icon: Icon(Icons.play_arrow)),
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
