// ignore_for_file: file_names, unnecessary_import, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/provider/SongModelProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen(
      {super.key, required this.songModel, required this.audioplayer});
  final SongModel songModel;
  final AudioPlayer audioplayer;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool isplaying = false;
  Duration duration = const Duration();
  Duration playing = const Duration();

  @override
  void initState() {
    super.initState();
    PlaySongs();
  }

  void PlaySongs() async {
    try {
      Uri? artUri;
      String artUriString = widget.songModel.id.toString();
      if (Uri.tryParse(artUriString)?.hasAbsolutePath ?? false) {
        artUri = Uri.parse(artUriString);
      } else {
        print("Invalid artUri: $artUriString");
      }

      await widget.audioplayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel.uri!),
        tag: MediaItem(
          id: '${widget.songModel.id}',
          album: "${widget.songModel.album}",
          title: widget.songModel.displayNameWOExt,
          artUri: artUri,
        ),
      ));
      widget.audioplayer.play();
      setState(() {
        isplaying = true;
      });
    } catch (e) {
      print("Error playing songs: $e");
    }

    widget.audioplayer.durationStream.listen((dur) {
      if (dur != null && mounted) {
        setState(() {
          duration = dur;
        });
      }
    });

    widget.audioplayer.positionStream.listen((play) {
      if (mounted) {
        setState(() {
          playing = play;
        });
      }
    });
  }

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Align(
                alignment: const AlignmentDirectional(0, -1),
                child: SelectionArea(
                  child: Text(
                    'Now Playing',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      fontSize: 26.0,
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
                preferredSize: const Size.fromHeight(10),
                child: Container(),
              ),
              centerTitle: true,
              elevation: 10,
            ),
            SliverToBoxAdapter(
              child: Align(
                child: Center(
                  child: QueryArtworkWidget(
                      id: widget.songModel.id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: 300,
                      artworkWidth: 300),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                child: Text(
                  widget.songModel.displayNameWOExt,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                child: Text(
                  widget.songModel.artist.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                child: Row(
                  children: [
                    Text(playing.toString().split('.')[0]),
                    Expanded(
                        child: Slider(
                            min: const Duration(microseconds: 0)
                                .inSeconds
                                .toDouble(),
                            value: playing.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                sliderChanges(value.toInt());
                                value = value;
                              });
                            })),
                    Text(duration.toString().split('.')[0]),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (widget.audioplayer.hasPrevious) {
                            widget.audioplayer.seekToPrevious();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 30.0,
                        )),
                    const SizedBox(
                      height: 22.0,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (isplaying) {
                            widget.audioplayer.pause();
                          } else {
                            widget.audioplayer.play();
                          }
                          isplaying = !isplaying;
                        });
                      },
                      icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    IconButton(
                        onPressed: () {
                          if (widget.audioplayer.hasPrevious) {
                            widget.audioplayer.seekToPrevious();
                          }
                        },
                        icon: const Icon(Icons.skip_next, size: 30.0))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sliderChanges(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioplayer.seek(duration);
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 300,
      artworkWidth: 300,
      nullArtworkWidget: Icon(
        Icons.music_note,
        size: 100,
      ),
    );
  }
}
