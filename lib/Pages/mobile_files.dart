// ignore_for_file: unused_field, use_super_parameters, library_private_types_in_public_api,
// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_print, unnecessary_new,
// ignore_for_file: sized_box_for_whitespace, unnecessary_const

import 'package:flutter/material.dart';
import 'package:musicplayer/component/song_list.dart';
import 'package:musicplayer/model/song_data_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/Pages/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalDeviceData extends StatefulWidget {
  const LocalDeviceData({Key? key});

  @override
  _LocalDeviceDataState createState() => _LocalDeviceDataState();
}

class _LocalDeviceDataState extends State<LocalDeviceData> {
  late SongDataController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SongDataController());
    // Call getLocalSongs() here
    controller.getLocalSongs();
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
        child: Builder(builder: (context) {
          return Obx(() {
            if (controller.localsonglist.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
                            builder: (context) =>  HomePageContainer()));
                  },
                ),
                title: Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: SelectionArea(
                    child: Text(
                      'Device Files',
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
                          future: controller.getLocalSongAtIndex(index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text("Error loading songs"),
                              );
                            } else {
                              final song = snapshot.data as SongModel;
                              return SongList(
                                songName: song.title,
                                subtitle: song.artist,
                                songModel: song,
                                id: song.id,
                                index: index,
                                controller: controller,
                              );
                            }
                          },
                        );
                      },
                      childCount: controller.localsonglist.length,
                    ),
                  ),
                ],
              );
            }
          });
        }),
      ),
    );
  }
}



// class SongDataController extends GetxController {
//   final audioQuery = OnAudioQuery();
  
//   RxList<SongModel> localsonglist = <SongModel>[].obs;
//   var deviceSong = true.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     getLocalSongs();
//     requestPermission();
//   }

  
//   void requestPermission() {
//     Permission.storage.request();
//   }


//   void getLocalSongs() async {
//     localsonglist.value = await audioQuery.querySongs(
//       ignoreCase: true,
//       orderType: OrderType.ASC_OR_SMALLER,
//       sortType: null,
//       uriType: UriType.EXTERNAL,
//     );
//    deviceSong.value = localsonglist.isNotEmpty;
//     print(localsonglist.length);
//     // ignore: invalid_use_of_protected_member
//     print(localsonglist.value);

//   }
// }

