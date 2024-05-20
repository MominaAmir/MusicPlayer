// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/Pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicplayer/provider/SongModelProvider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
//  await JustAudioBackground.init(
//     androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
//     androidNotificationChannelName: 'Audio playback',
//     androidNotificationOngoing: true,
  // );
    return runApp( 
      ChangeNotifierProvider(create: (context) => SongModelProvider(),
      child: MyApp(),
      ),
    );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Harmony App',
        home: SplashScreen(), // Your main page
      
    );
  }
}

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
//       FirebaseFirestore.instance.collection('Diljit Dosanjh');
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
//       String artistName = 'Diljit Dosanjh';
      
//       // Add document to Firestore with automatic document ID
//       DocumentReference docRef = await _songsCollection.add({
//         'artist': artistName,
//         'name': songName,
//         'url': url,
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
//         await _storage.ref('Diljit Dosanjh').listAll();

//     for (Reference ref in result.items) {
//       String url = await ref.getDownloadURL();
//       urls.add(url);
//     }

//     return urls;
//   }
// String _extractSongNameFromUrl(String url) {
//   // Split the URL by '/' to get the file name
//   String fileName = url.split('/').last;

//   // Split the file name by '.' to remove the extension and get the song name
//   String songName = fileName.split('.').first;

//   // Return the extracted song name
//   return songName;
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
