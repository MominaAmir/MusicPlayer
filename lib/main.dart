// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/Pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicplayer/model/music_player_model.dart';
import 'package:musicplayer/provider/SongModelProvider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // var devices =["958FCF36108DCF41C72B37C6BD1C51FA"];
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.myapp.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    notificationColor: Colors.black,
  );
  await MobileAds.instance.initialize;
  // RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  try {
    await FlutterDownloader.initialize(
      debug: true,
    );
    print('FlutterDownloader initialized successfully');
  } catch (e) {
    print('Initialization failed: $e');
  }
  adloaded();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SongModelProvider()),
        ChangeNotifierProvider(create: (_) => MusicPlayerModel()),
      ],
      child: MyApp(),
    ),
  );
}

AppOpenAd? _openAd;

bool isAdLoaded = false;

adloaded() async {
  AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/9257395921',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        _openAd = ad;
        isAdLoaded = true;
          _openAd!.show();
      }, onAdFailedToLoad: (error) {
        _openAd!.dispose();
      }),
      );
      
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Harmony App',
      home: SplashScreen(), // Your main page
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:musicplayer/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Add Image URLs to Firestore'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               await addAllImageUrlsToFirestore('topsongs_cover_images');
//             },
//             child: Text('Add Image URLs'),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> addAllImageUrlsToFirestore(String folderName) async {
//     try {
//       // Reference to the folder in Firebase Storage
//       ListResult result = await FirebaseStorage.instance.ref(folderName).listAll();

//       // Iterate over each file in the folder
//       for (var ref in result.items) {
//         // Get the file name without extension
//         String fileName = ref.name.split('.').first;

//         // Retrieve the download URL
//         String downloadURL = await ref.getDownloadURL();

//         // Reference to the Firestore collection
//         CollectionReference collectionReference = FirebaseFirestore.instance.collection('TopSongs');

//         // Query Firestore for the document with a matching name
//         QuerySnapshot querySnapshot = await collectionReference.where('name', isEqualTo: fileName).get();

//         // Check if a matching document was found
//         if (querySnapshot.docs.isNotEmpty) {
//           // Get the first matching document (assuming unique names)
//           DocumentSnapshot matchedDoc = querySnapshot.docs.first;

//           // Get the document ID
//           String docId = matchedDoc.id;

//           // Update the document with the image URL
//           await collectionReference.doc(docId).update({'imageurl': downloadURL});

//           print('Image URL for $fileName added to Firestore successfully');
//         } else {
//           print('No document found with the name: $fileName');
//         }
//       }
//     } catch (e) {
//       print('Failed to add image URLs to Firestore: $e');
//     }
//   }
// }

// ignore_for_file: library_private_types_in_public_api
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:musicplayer/firebase_options.dart';

// class Song {
//   String artist;
//   String name;
//   String url;

//   Song({required this.artist, required this.name, required this.url});

//   Map<String, dynamic> toJson() {
//     return {
//       'artist': artist,
//       'name': name,
//       'url': url,
//     };
//   }
// }

// class FirebaseOperations extends StatefulWidget {
//   @override
//   _FirebaseOperationsState createState() => _FirebaseOperationsState();
// }

// class _FirebaseOperationsState extends State<FirebaseOperations> {
//   FirebaseStorage _storage = FirebaseStorage.instance;
//   CollectionReference _songsCollection =
//       FirebaseFirestore.instance.collection('anime');
//   String _message = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Operations'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _copyUrlsToDatabase,
//               child: Text('Copy URLs to Firestore'),
//             ),
//             SizedBox(height: 20),
//             Text(_message),
//           ],
//         ),
//       ),
//     );
//   }

//  Future<void> _copyUrlsToDatabase() async {
//   setState(() {
//     _message = 'Copying URLs...';
//   });

//   try {
//     List<String> songUrls = await _fetchSongUrlsFromStorage();

//     for (int i = 0; i < songUrls.length; i++) {
//       String url = songUrls[i];
//       String songName = _extractSongNameFromUrl(url);
//       String artistName = 'unknown';
      
//       // Add document to Firestore with automatic document ID
//       DocumentReference docRef = await _songsCollection.add({
//         'artist': artistName,
//         'name': songName,
//         'url': url,
//         'imageurl': '',
//       });

//       // Extract and store the document ID along with song details
//       Song song = Song(artist: artistName, name: songName, url: url);
//       await docRef.update({'doc_id': 'song${i + 1}'}); // Incrementing the document ID
//     }

//     setState(() {
//       _message = 'URLs copied to Firestore successfully.';
//     });
//   } catch (error) {
//     setState(() {
//       _message = 'Error: $error';
//     });
//   }
// }
//   Future<List<String>> _fetchSongUrlsFromStorage() async {
//     List<String> urls = [];
//     ListResult result =
//         await _storage.ref('AnimeNow').listAll();

//     for (Reference ref in result.items) {
//       String url = await ref.getDownloadURL();
//       urls.add(url);
//     }

//     return urls;
//   }
// String _extractSongNameFromUrl(String url) {
//   String fileName = url.split('/').last;

//   fileName = Uri.decodeComponent(fileName);

//   RegExp regExp = RegExp('(\bDIOR\b)', caseSensitive: false);
//   RegExpMatch? match = regExp.firstMatch(fileName);

//   if (match != null) {
//     return match.group(1) ?? '';
//   } else {
//     return 'Unknown';
//   }
// }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
//   runApp(MaterialApp(
//     home: FirebaseOperations(),
//   ));
// }



