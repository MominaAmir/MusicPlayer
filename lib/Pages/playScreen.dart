import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:musicplayer/model/music_player_model.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen(
      {super.key, required this.songModel, required this.playnextsong});
  final SongModel songModel;
  final Function playnextsong;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool isplaying = false;
  Duration duration = const Duration();
  Duration playing = const Duration();

  late InterstitialAd interAds;
  bool isAdLoaded = false;

  adloaded() async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          setState(() {
            interAds = ad;
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: (error) {
          interAds.dispose();
          isAdLoaded = false;
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playSong();
    });
    adloaded();
  }

  void playSong() async {
    final player = Provider.of<MusicPlayerModel>(context, listen: false);
    player.play(widget.songModel.displayNameWOExt, widget.songModel.uri!, '');
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<MusicPlayerModel>(context);
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
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isAdLoaded == true) {
                    interAds.show();
                  }
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Container(),
              ),
              centerTitle: true,
              elevation: 10,
            ),
            SliverToBoxAdapter(
              child: Align(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: QueryArtworkWidget(
                          id: widget.songModel.id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 300,
                          artworkWidth: 300),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.songModel.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.songModel.artist.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(player.playing.toString().split('.')[0]),
                        Expanded(
                            child: Slider(
                                min: const Duration(microseconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                value: player.playing.inSeconds.toDouble(),
                                max: player.duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  player.sliderChanges(value.toInt());
                                })),
                        Text(player.duration.toString().split('.')[0]),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              // Implement previous song logic here
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
                            player.playPause();
                          },
                          icon: Icon(player.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                        ),
                        const SizedBox(
                          height: 22.0,
                        ),
                        IconButton(
                            onPressed: () {
                              widget.playnextsong();
                            },
                            icon: const Icon(Icons.skip_next, size: 30.0))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
