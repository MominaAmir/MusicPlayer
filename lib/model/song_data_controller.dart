
// ignore_for_file: avoid_print

import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class SongDataController extends GetxController {
  final audioQuery = OnAudioQuery();
  
  RxList<SongModel> localsonglist = <SongModel>[].obs;
  var deviceSong = true.obs;
  @override
  void onInit() {
    super.onInit();
    getLocalSongs();
    requestPermission();
  }

  
  void requestPermission() {
    Permission.storage.request();
  }

  void getLocalSongs() async {
    localsonglist.value = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );
   deviceSong.value = localsonglist.isNotEmpty;
    print(localsonglist.length);
    // ignore: invalid_use_of_protected_member
    print(localsonglist.value);

  }

   Future<SongModel> getLocalSongAtIndex(int index) async {
    // Check if index is valid
    if (index >= 0 && index < localsonglist.length) {
      return localsonglist[index];
    } else {
      throw Exception('Invalid index');
    }
  }
}



// // ignore_for_file: avoid_print

// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';


// class SongDataController extends GetxController {
//   final audioQuery = OnAudioQuery();  
//   RxList<SongModel> localsonglist = <SongModel>[].obs;
//   var  deviceSong = true.obs;
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
//   }
// }
