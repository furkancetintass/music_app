import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_music_app/constants/constants.dart';
import 'package:my_music_app/theme/my_theme.dart';
import 'package:my_music_app/view/screen/lyrics_page.dart';
import 'package:my_music_app/view_model/playing_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_music_app/service/admob_service.dart';

class LyricSongs extends StatefulWidget {
  @override
  _LyricSongsState createState() => _LyricSongsState();
}

class _LyricSongsState extends State<LyricSongs> {
  double selectedOpacity = 0.5;

  BannerAd _ad;
  bool isLoaded;

  InterstitialAd _interstitialAd;

  int clickCount = 0;

  Future<void> getInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.getInterstitial(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          print('Opened Ad');
          _interstitialAd=ad;
        }, onAdFailedToLoad: (ad) {
          print('Closed Add');
        }));
  }

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
        adUnitId: AdMobService.getBannerAdId(),
        request: AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (_, error) {
          print('Ad failed to load with error: $error');
        }));
    _ad.load();
    getInterstitialAd();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    if (isLoaded == true) {
      return Container(
        height: _ad.size.height.toDouble(),
        width: Get.width,
        child: AdWidget(ad: _ad),
        alignment: Alignment.center,
      );
    } else {
      return Container(
          height: _ad.size.height.toDouble(),
          width: _ad.size.width.toDouble(),
          child: Center(child: Container()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<MyAudio>(context);
    // String songName = audioProvider.playingIndexLyrics == null
    //     ? 'Parça Yok'
    //     : Constants.lyricSongs[audioProvider.playingIndexLyrics]['name'];

    // IconData _playButton = audioProvider.audioState == "Playing"
    //     ? FontAwesomeIcons.pause
    //     : FontAwesomeIcons.play;

    int globalIndex = audioProvider.playingIndexLyrics == null
        ? 0
        : audioProvider.playingIndexLyrics;
    return Scaffold(
        appBar: AppBar(title: Text('Song with Lyrics')),
        body: Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fill)),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: Constants.lyricSongs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if (clickCount < 3) {
                                  clickCount += 1;
                                } else {
                                  _interstitialAd.show();
                                  clickCount = 0;
                                  getInterstitialAd();
                                }
                                Get.to(LyricsPage(index: index),
                                    transition: Transition.cupertino);
                                setState(() {
                                  selectedOpacity = 0.8;
                                  globalIndex = index;

                                  audioProvider.playAudioLyrics(
                                      Constants.lyricSongs[index]['url'],
                                      index);
                                  // songName = Constants.lyricSongs[index]['name'];

                                  // _playButton = FontAwesomeIcons.pause;
                                });
                              },
                              child: Card(
                                  color: globalIndex ==
                                          Constants.lyricSongs.indexOf(
                                              Constants.lyricSongs[index])
                                      ? MyTheme.lightTheme.appBarTheme.color
                                          .withOpacity(1)
                                      : MyTheme.lightTheme.appBarTheme.color
                                          .withOpacity(0.3),
                                  child: ListTile(
                                      title: Text(
                                          Constants.lyricSongs[index]['name'],
                                          style: globalIndex == Constants.lyricSongs.indexOf(Constants.lyricSongs[index])
                                              ? MyTheme.selectedSongTheme
                                              : MyTheme.unSelectedSongTheme),
                                      trailing: Visibility(
                                          visible: globalIndex ==
                                                  Constants.lyricSongs.indexOf(
                                                      Constants.lyricSongs[index])
                                              ? true
                                              : false,
                                          child: FaIcon(
                                            FontAwesomeIcons.music,
                                            color: Colors.white,
                                          )))),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                checkForAd()
              ],
            )));
  }
}
