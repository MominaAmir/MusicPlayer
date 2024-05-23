// AS_album.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/Pages/home.dart';
import 'package:musicplayer/Pages/miniplayer.dart';
import 'package:musicplayer/component/FirebaseSongList.dart';

class AS_Album extends StatefulWidget {
  const AS_Album({Key? key}) : super(key: key);

  @override
  _AS_AlbumState createState() => _AS_AlbumState();
}

class _AS_AlbumState extends State<AS_Album> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(150, 230, 143, 245),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("lib/assest/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: Stack(
          children: [
            CustomScrollView(
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
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePageContainer()));
                    },
                  ),
                  title: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: SelectionArea(
                      child: Text(
                        'Arijit Singh',
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
                SliverToBoxAdapter(
                  child: Align(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        width: 400,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'lib/assest/ArijitSingh.jpg',
                                  width: 400,
                                  height: 300,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: AlignmentDirectional(-0.93, 0.69),
                              child: Icon(
                                Icons.play_circle,
                                color: Colors.black87,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Arijit Singh')
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
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                imageurl:imageurl,
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
          ],
        ),
      ),
      bottomNavigationBar: MiniPlayer(),
    );
  }
}
