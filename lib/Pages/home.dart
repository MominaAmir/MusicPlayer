// ignore_for_file: unused_field, use_super_parameters, library_private_types_in_public_api,, prefer_final_fields
// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_print, unnecessary_new,
// ignore_for_file: sized_box_for_whitespace, unnecessary_const

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Pages/downloads.dart';
import 'package:musicplayer/Pages/miniplayer.dart';
import 'package:musicplayer/Pages/mobile_files.dart';
import 'package:musicplayer/Pages/searchPage.dart';
import 'package:musicplayer/Pages/top_songs.dart';
import 'package:musicplayer/albums/aa_album.dart';
import 'package:musicplayer/albums/animenow.dart';
import 'package:musicplayer/albums/as_album.dart';
import 'package:musicplayer/albums/be_album.dart';
import 'package:musicplayer/albums/bts.dart';
import 'package:musicplayer/albums/cocmelon.dart';
import 'package:musicplayer/albums/dd_album.dart';
import 'package:musicplayer/albums/smw_album.dart';
import 'package:musicplayer/component/FirebaseSongList.dart';
import 'package:musicplayer/model/HomePageModel.dart';
// import 'package:musicplayer/model/albumModel.dart';
import 'package:musicplayer/model/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayer();
  late HomePageModel _model;
  late SongDataController controller = new SongDataController();
  late BannerAd bannerads;

  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/9214589741";

  initBannerAd() {
    bannerads = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
      request: const AdRequest(),
    );
    bannerads.load();
  }

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();
    _model.initState(context);
    initBannerAd();
  }

  Icon customIcon = const Icon(
    Icons.search,
    color: Colors.white,
    size: 35,
  );

  Widget customtitle = Text(
    'HOME',
    textAlign: TextAlign.center,
    style: GoogleFonts.acme(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
  );

  bool isSearchFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(150, 230, 143, 245),
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
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              title: Align(
                alignment: const AlignmentDirectional(0, -1),
                child: SelectionArea(
                  child: Text(
                    'HOME',
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
            SliverToBoxAdapter(
                child: Align(
              child: isAdLoaded
                  ? SizedBox(
                      height: bannerads.size.height.toDouble(),
                      width: bannerads.size.width.toDouble(),
                      child: AdWidget(ad: bannerads),
                    )
                  : SizedBox(),
            )),
            SliverToBoxAdapter(
              child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 0, 10),
                  child: Text(
                    'Find Your Favorite Music',
                    style: GoogleFonts.acme(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Popular Album',
                            style: GoogleFonts.acme(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.local_fire_department_sharp,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    child: CarouselSlider(
                      items: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkResponse(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SMWAlbum()));
                              print('Image tapped!');
                            },
                            child: Image.asset(
                              'lib/assest/sidhu-moose-wala.jpg',
                              width: 350,
                              height: 300,
                              fit: BoxFit.cover,
                              alignment: const Alignment(0, 0),
                            ),
                          ),
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkResponse(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AS_Album()));
                                print('Image tapped!');
                              },
                              child: Image.asset(
                                'lib/assest/ArijitSingh.jpg',
                                width: 350,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkResponse(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BE_Album()));
                                print('Image tapped!');
                              },
                              child: Image.asset(
                                'lib/assest/billi ellish.jpeg',
                                width: 350,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkResponse(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DD_Album()));
                                print('Image tapped!');
                              },
                              child: Image.asset(
                                'lib/assest/Diljit-Dosanjh.jpg',
                                width: 350,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkResponse(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AA_Album()));
                                print('Image tapped!');
                              },
                              child: Image.asset(
                                'lib/assest/atifaslam.jpg',
                                width: 350,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkResponse(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BTS_Album()));
                                print('Image tapped!');
                              },
                              child: Image.asset(
                                'lib/assest/bts.jpg',
                                width: 350,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                      carouselController: _model.carouselController ??=
                          CarouselController(),
                      options: CarouselOptions(
                        initialPage: 1,
                        viewportFraction: 0.5,
                        disableCenter: false,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.25,
                        enableInfiniteScroll: true,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayInterval:
                            const Duration(milliseconds: (800 + 4000)),
                        autoPlayCurve: Curves.linear,
                        pauseAutoPlayInFiniteScroll: true,
                        onPageChanged: (index, _) =>
                            _model.carouselCurrentIndex = index,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 0, 10),
                  child: Text(
                    'Kids Listening',
                    style: GoogleFonts.acme(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Align(
              alignment: const AlignmentDirectional(-1, -1),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xFF975AC5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 5, 5, 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'lib/assest/animenow.jpeg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                            child: Text(
                              'Anime Now ',
                              style: GoogleFonts.acme(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Anime_Album()));
                              print('Image tapped!');
                            },
                          ),
                          SizedBox(width: 10),
                        ]),
                  ),
                  Card(
                    margin: EdgeInsets.all(10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xFF975AC5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'lib/assest/cocomelon.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            'Cocomelon ',
                            style: GoogleFonts.acme(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CocmelonAlbum()));
                            print('Image tapped!');
                          },
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            )),
            SliverToBoxAdapter(
              child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 0, 10),
                  child: Text(
                    'One Click Playlists',
                    style: GoogleFonts.acme(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
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
                        .collection('playlist')
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
                          String artist =
                              songData['artist'] ?? 'Unknown Artist';
                          String name = songData['name'] ?? 'Unknown Name';
                          String url = songData['url'] ??
                              ''; // You might want to handle this differently based on your use case
                          String imageurl =
                              songData['imageurl'] ?? 'default_image_url';

                          return FirebaseSongList(
                            songName: name,
                            subtitle: artist,
                            url: url,
                            index: index,
                            snapshot: snapshot,
                            imageurl: imageurl,
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 185, 72, 219),
              ),
              child: Text(
                'Welcome to Harmony',
                style: GoogleFonts.acme(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.perm_device_information_outlined),
              title: Text(
                'Local Storage files',
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocalDeviceData()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_done),
              title: Text(
                'Downloads',
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DownloadPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                'Settings',
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageContainer extends StatefulWidget {
  HomePageContainer({Key? key}) : super(key: key);

  @override
  _HomePageContainerState createState() => _HomePageContainerState();
}

class _HomePageContainerState extends State<HomePageContainer> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayer();
  bool isplaying = false;
  int _selectedIndex = 0;
  String? songName;
  String? url;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const TopSongs(),
    const SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(245, 216, 126, 236),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          MiniPlayer(),
          BottomNavigationBar(
            fixedColor: Colors.white,
            backgroundColor: const Color.fromARGB(245, 216, 126, 236),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.my_library_music),
                label: 'Top Songs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
          ),
        ]));
  }
}
