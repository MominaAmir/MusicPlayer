// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopSongs extends StatefulWidget {
  const TopSongs({super.key});

  @override
  State<TopSongs> createState() => _TopSongsState();
}

class _TopSongsState extends State<TopSongs> {
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
                        'Top Songs',
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
              ],
            ),
          ),
    );
  }
}