import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_music_app/constants/constants.dart';
import 'package:my_music_app/theme/my_theme.dart';
import 'package:my_music_app/view_model/playing_provider.dart';
import 'package:provider/provider.dart';

class PlayerWidgetLyrics extends StatefulWidget {
  @override
  _PlayerWidgetLyricsState createState() => _PlayerWidgetLyricsState();
}

class _PlayerWidgetLyricsState extends State<PlayerWidgetLyrics> {
  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<MyAudio>(context);

    Widget slider() {
      return Slider.adaptive(
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.white,
          value: audioProvider.position == null
              ? 0
              : audioProvider.position.inMilliseconds.toDouble(),
          max: audioProvider.totalDuration == null
              ? 20
              : audioProvider.totalDuration.inMilliseconds.toDouble(),
          onChanged: (value) {
            audioProvider.seekAudio(Duration(milliseconds: value.toInt()));

            // seekToSec(value.toInt());
          });
    }

    String songName = audioProvider.playingIndexLyrics == null
        ? 'No Song'
        : Constants.lyricSongs[audioProvider.playingIndexLyrics]['name'];
    IconData _playButton = audioProvider.audioState == "Playing"
        ? FontAwesomeIcons.pause
        : FontAwesomeIcons.play;
    int globalIndex = audioProvider.playingIndexLyrics == null
        ? 0
        : audioProvider.playingIndexLyrics;
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: MyTheme.lightTheme.appBarTheme.color,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
      height: 135,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              songName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 20, 45, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (audioProvider.audioState == "Playing") {
                        setState(() {
                          audioProvider.pauseAudio();
                          _playButton = FontAwesomeIcons.play;
                        });
                      } else {
                        setState(() {
                          // songName = Constants.lyricSongs[globalIndex]['name'];
                          audioProvider.playAudioLyrics(
                             Constants.lyricSongs[globalIndex]['url'],
                              globalIndex);
                          
                          _playButton = FontAwesomeIcons.pause;
                        });
                      }
                    },
                    child: FaIcon(_playButton, color: Colors.white, )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Container(
                  width: 30,
                  child: Text(
                    audioProvider.position == null
                        ? '0:0'
                        : '${audioProvider.position.inMinutes}:${audioProvider.position.inSeconds.remainder(60)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: slider()),
                Container(
                  width: 30,
                  child: Text(
                      audioProvider.totalDuration == null
                          ? '0:0'
                          : '${audioProvider.totalDuration.inMinutes}:${audioProvider.totalDuration.inSeconds.remainder(60)}',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
