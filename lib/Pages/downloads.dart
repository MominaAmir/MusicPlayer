import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/Pages/miniplayer.dart';
import 'package:musicplayer/component/songSearch.dart';
import 'package:provider/provider.dart';
import 'package:musicplayer/model/music_player_model.dart';

class DownloadPage extends StatefulWidget {
  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<Map<String, String>> downloadedSongs = [];

  void _showPopupMenu(BuildContext context, int index, Offset tapPosition) {
    final List<String> menuItems = ['Delete'];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 10,
        tapPosition.dy + 10,
      ),
      items: menuItems.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        switch (value) {
          case "Delete":
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Song Deleted"),
                duration: Duration(seconds: 3),
              ),
            );
            // Handle delete option
            final musicPlayerModel =
                Provider.of<MusicPlayerModel>(context, listen: false);
            final song = musicPlayerModel.downloadedSongs[index];
            musicPlayerModel.deleteFile(song['path']!);
            musicPlayerModel.removeDownloadedSong(index);
            setState(() {
              downloadedSongs.removeAt(index);
            });
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(150, 230, 143, 245),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assest/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: const Color(0xF58C08A9),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Align(
                alignment: const AlignmentDirectional(0, -1),
                child: SelectionArea(
                  child: Text(
                    'Your Downloads',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(7),
                child: Container(),
              ),
              centerTitle: true,
              elevation: 10,
            ),
            SliverFillRemaining(
              child: FutureBuilder<List<Map<String, String>>>(
                future: context.read<MusicPlayerModel>().fetchDownloadedSongs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No downloaded songs'));
                  } else {
                    downloadedSongs = snapshot.data!;
                    return ListView.builder(
                      itemCount: downloadedSongs.length,
                      itemBuilder: (context, index) {
                        var song = downloadedSongs[index];
                        return ListTile(
                          leading: song['imageurl'] != null
                              ? Image.network(
                                  song['imageurl']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.music_note,
                                        size: 20);
                                  },
                                )
                              : const Icon(Icons.music_note, size: 20),
                          title: Text(song['name'] ?? 'Unknown SongName'),
                          subtitle: Text(song['artist'] ?? 'Unknown Artist'),
                          trailing: GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              _showPopupMenu(
                                  context, index, details.globalPosition);
                            },
                            child: const Icon(Icons.more_vert),
                          ),
                          onTap: () async {
                            try {
                              Provider.of<MusicPlayerModel>(context,
                                      listen: false)
                                  .play(song['artist']!, song['url']!,
                                      song['imageurl']!, song['artist']!);
                              setState(() {});
                            } catch (e) {
                              print('Error playing song: $e');
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MiniPlayer(),
    );
  }
}
