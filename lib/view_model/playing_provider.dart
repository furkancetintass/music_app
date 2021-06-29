import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audio_cache.dart';

class MyAudio extends ChangeNotifier {
  Duration totalDuration;
  Duration position;
  String audioState;
  int playingIndexOffline;
  int playingIndexOnline;
  int playingIndexLyrics;

  AudioCache cache;

  MyAudio() {
    initAudio();
  }

  AudioPlayer audioPlayer = AudioPlayer();

  initAudio() {
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      totalDuration = updatedDuration;
      notifyListeners();
    });

    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      position = updatedPosition;
      notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.STOPPED) audioState = "Stopped";
      if (playerState == PlayerState.PLAYING) audioState = "Playing";
      if (playerState == PlayerState.PAUSED) audioState = "Paused";
      notifyListeners();
    });
  }

  playAudio(String song, index) async {
    cache = AudioCache(fixedPlayer: audioPlayer);
    cache.play(song);
    playingIndexOffline = index;
  }

  playAudioOnline(String url, index) async {
    playingIndexOnline = index;
    await audioPlayer.play(url);
  }

  playAudioLyrics(String url, index) async {
    playingIndexLyrics = index;
    await audioPlayer.play(url);
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  stopAudio() {
    audioPlayer.stop();
  }

  seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
  }
}
