// import 'package:flutter/material.dart';
// import 'package:musicplayer/main.dart';
// import 'package:provider/provider.dart';

// class MiniPlayer extends StatelessWidget {
//   const MiniPlayer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final currentlyPlayingProvider = Provider.of<CurrentlyPlayingProvider>(context);
//     final Map<String, dynamic>? currentlyPlayingSong = currentlyPlayingProvider.currentlyPlayingSong;

//     if (currentlyPlayingSong == null) {
//       return const SizedBox.shrink(); // No song is currently playing
//     }

//     return Container(
//       color: Colors.grey[800],
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           if (currentlyPlayingSong['albumArtUrl'] != null)
//             Image.network(
//               currentlyPlayingSong['albumArtUrl'],
//               height: 50.0,
//               width: 50.0,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.music_note);
//               },
//             ),
//           const SizedBox(width: 8.0),
//           Expanded(
//             child: Text(
//               currentlyPlayingSong['title'],
//               style: const TextStyle(color: Colors.white),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.pause, color: Colors.white),
//             onPressed: () {
//               // Pause song logic
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
