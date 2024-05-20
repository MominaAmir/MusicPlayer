// ignore_for_file: unused_field, use_super_parameters, library_private_types_in_public_api,
// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_print, unnecessary_new,
// ignore_for_file: sized_box_for_whitespace, unnecessary_const

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Pages/mobile_files.dart';
import 'package:musicplayer/Pages/favorite_songs.dart';
import 'package:musicplayer/Pages/top_songs.dart';
import 'package:musicplayer/albums/aa_album.dart';
import 'package:musicplayer/albums/as_album.dart';
import 'package:musicplayer/albums/be_album.dart';
import 'package:musicplayer/albums/bts.dart';
import 'package:musicplayer/albums/dd_album.dart';
import 'package:musicplayer/albums/smw_album.dart';
import 'package:musicplayer/model/HomePageModel.dart';
// import 'package:musicplayer/model/albumModel.dart';
import 'package:musicplayer/model/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:http/http.dart' as http;

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
  final String apiUrl = 'https://youtube-music6.p.rapidapi.com/ytmusic/';
  late TextEditingController _searchController;
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();
    _model.initState(context);
    _searchController = TextEditingController();
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
                  child: customtitle,
                ),
              ),
              actions: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: IconButton(
                    hoverColor: const Color.fromARGB(255, 73, 1, 70),
                    icon: customIcon,
                    onPressed: () {
                      setState(() {
                        if (isSearchFieldVisible) {
                          isSearchFieldVisible = false;
                          customIcon = const Icon(Icons.search);
                          customtitle = Text(
                            'HOME',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.acme(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          isSearchFieldVisible = true;
                          customIcon = const Icon(Icons.cancel);
                          customtitle = TextField(
                            textInputAction: TextInputAction.go,
                            decoration: const InputDecoration(
                              hintText: "enter song name",
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            onSubmitted: (value) {
                              _searchSongs(value);
                            },
                          );
                        }
                      });
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
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 0, 0),
                  child: Text(
                    'Recently Played',
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
                  padding: const EdgeInsets.all(6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Stack(
                              alignment: const AlignmentDirectional(0, 1),
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/206/600',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.05, 0.67),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 0, 0),
                                    child: Text(
                                      'SongName',
                                      style: GoogleFonts.acme(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-0.78, 0.95),
                                  child: Text(
                                    'subtitle',
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Stack(
                              alignment: const AlignmentDirectional(0, 1),
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/206/600',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.05, 0.67),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 0, 0),
                                    child: Text(
                                      'SongName',
                                      style: GoogleFonts.acme(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-0.78, 0.95),
                                  child: Text(
                                    'subtitle',
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Stack(
                              alignment: const AlignmentDirectional(0, 1),
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/206/600',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.05, 0.67),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 0, 0),
                                    child: Text(
                                      'SongName',
                                      style: GoogleFonts.acme(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-0.78, 0.95),
                                  child: Text(
                                    'subtitle',
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Stack(
                              alignment: const AlignmentDirectional(0, 1),
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/206/600',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.05, 0.67),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 0, 0),
                                    child: Text(
                                      'SongName',
                                      style: GoogleFonts.acme(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-0.78, 0.95),
                                  child: Text(
                                    'subtitle',
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Stack(
                              alignment: const AlignmentDirectional(0, 1),
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/206/600',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.05, 0.67),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 0, 0),
                                    child: Text(
                                      'SongName',
                                      style: GoogleFonts.acme(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-0.78, 0.95),
                                  child: Text(
                                    'subtitle',
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              leading: const Icon(Icons.history),
              title: Text(
                'History',
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                // Handle Option 2 tap
                Navigator.pop(context); // Close the drawer
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
                // Handle Option 3 tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }

  void _searchSongs(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?q=$query'),
        headers: {
          'X-RapidAPI-Key':
              '049340387emsh1ef19f738c7e73bp152296jsnfe5238b04e6d',
          'X-RapidAPI-Host': 'youtube-music6.p.rapidapi.com'
        },
      );

      if (response.statusCode == 200) {
        // Parse the response and update _searchResults
        setState(() {
          _searchResults.clear();
          // Assuming your API returns a list of song names as strings
          _searchResults.addAll(response.body.split(','));
          print(_searchResults.length);
          print(_searchResults.first);
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class HomePageContainer extends StatefulWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  @override
  _HomePageContainerState createState() => _HomePageContainerState();
}

class _HomePageContainerState extends State<HomePageContainer> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer playaudio = AudioPlayer();
  bool isplaying = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const TopSongs(),
    const FavoriteSongs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
      // bottomSheet: const MiniPlayer(),
    );
  }
}
