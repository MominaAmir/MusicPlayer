// ignore_for_file: unused_field, use_super_parameters, library_private_types_in_public_api,
// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_print, unnecessary_new,
// ignore_for_file: sized_box_for_whitespace, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/Pages/home.dart';
import 'package:musicplayer/component/FirebaseSongList.dart';

class SMWAlbum extends StatefulWidget {
  const SMWAlbum({Key? key}) : super(key: key);

  @override
  _SMWAlbumState createState() => _SMWAlbumState();
}

class _SMWAlbumState extends State<SMWAlbum>
    with SingleTickerProviderStateMixin {
  // late Future<List<>>

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<Offset>(
      begin: const Offset(20.0, 0.0),
      end: const Offset(5.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // _controller.repeat(reverse: true);
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
        )),
        child: Builder(builder: (context) {
          return CustomScrollView(
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
                            builder: (context) => const HomePageContainer()));
                  },
                ),
                title: Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: SelectionArea(
                    child: Text(
                      'Sidhu Moose Wala',
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
                                'lib/assest/sidhu-moose-wala.jpg',
                                width: 400,
                                height: 300,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.67, 0.46),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 10, 0, 0),
                              child: SlideTransition(
                                position: _animation,
                                child: const Text(
                                  'Song Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.7, 0.84),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 8, 0, 5),
                              child: SlideTransition(
                                position: _animation,
                                child: const Text(
                                  'Hello World',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                          .collection('SidhuMooseWala')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          itemBuilder: (context, index) {
                            var song = snapshot.data!.docs[index];
                            var songData = song.data() as Map<String, dynamic>;
                            String artist = songData['artist'];
                            String name = songData['name'];
                            String url = songData['url'];
                            return FirebaseSongList(
                              songName: name,
                              subtitle: artist,
                              url: url,
                              snapshot: snapshot,
                              index: index,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}