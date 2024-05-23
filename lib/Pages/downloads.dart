import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:musicplayer/model/music_player_model.dart';

class DownloadPage extends StatefulWidget {
  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FutureBuilder(
                    future:
                        context.read<MusicPlayerModel>().fetchDownloadedSongs(),
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
                        var downloadedSongs = snapshot.data!;
                        return ListView.builder(
                          itemCount: downloadedSongs.length,
                          itemBuilder: (context, index) {
                            var song = downloadedSongs[index];
                            return ListTile(
                              leading: song['imageurl'] != null
                                  ? Image.network(song['imageurl']!,
                                      fit: BoxFit.cover)
                                  : const Icon(Icons.music_note, size: 20),
                              title: Text(song['name']!),
                              subtitle: Text(song['artist']!),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert),
                              ),
                            );
                          },
                        );
                      }
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
