import 'package:flutter/material.dart';
import 'package:musicplayer/model/music_player_model.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var musicPlayerModel = Provider.of<MusicPlayerModel>(context);

    return Container(
      // padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  musicPlayerModel.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: musicPlayerModel.playPause,
              ),
              Expanded(
                child: Text(
                  'Now Playing:    ${musicPlayerModel.songName}',
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
              children: [
                Text(musicPlayerModel.playing.toString().split('.')[0]),
                Slider(
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    value: musicPlayerModel.playing.inSeconds.toDouble(),
                    max: musicPlayerModel.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      musicPlayerModel.sliderChanges(value.toInt());
                      value = value;
                    }),
                      Text(musicPlayerModel.duration.toString().split('.')[0]),
              ],
            ),
        ],
      ),
    );
  }
}
