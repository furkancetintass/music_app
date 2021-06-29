// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_music_app/service/admob_service.dart';
import 'package:my_music_app/theme/my_theme.dart';
import 'package:my_music_app/constants/constants.dart';
import 'package:my_music_app/view/widget/player_widget.dart';
import 'package:my_music_app/view_model/playing_provider.dart';
import 'package:provider/provider.dart';

class OfflineSong extends StatefulWidget {
  @override
  _OfflineSongState createState() => _OfflineSongState();
}

class _OfflineSongState extends State<OfflineSong> {
  bool isLoaded;

  BannerAd _ad;
  InterstitialAd _interstitialAd;

  double selectedOpacity = 0.5;
  int clickCount = 0;

  void getBanner() {
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

   
  }

  @override
  void initState() {
    super.initState();
    getBanner();
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

  Future<void> getInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.getInterstitial(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          print('Opened Ad');
          _interstitialAd = ad;
        }, onAdFailedToLoad: (ad) {
          print('Closed Add');
        }));
  }

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<MyAudio>(context);
    String songName = audioProvider.playingIndexOffline == null
        ? 'No Song'
        : Constants.offlineSongs[audioProvider.playingIndexOffline];
    IconData _playButton = audioProvider.audioState == "Playing"
        ? FontAwesomeIcons.pause
        : FontAwesomeIcons.play;
    int globalIndex = audioProvider.playingIndexOffline == null
        ? 0
        : audioProvider.playingIndexOffline;

    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Songs'),
      ),
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
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: Constants.offlineSongs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (clickCount < 3) {
                                clickCount += 1;
                              } else {
                                _interstitialAd.show();
                                clickCount = 0;
                                getInterstitialAd();
                              }
                              selectedOpacity = 0.8;
                              globalIndex = index;

                              audioProvider.playAudio(
                                  'musics/${Constants.offlineSongs[index]}.mp3',
                                  index);
                              songName = Constants.offlineSongs[index];
                              // cache.play(
                              //     'musics/${Constants.offlineSongs[index]}.mp3');
                              // _playing = true;
                              _playButton = FontAwesomeIcons.pause;
                            });
                          },
                          child: Card(
                              color: globalIndex ==
                                      Constants.offlineSongs.indexOf(
                                          Constants.offlineSongs[index])
                                  ? MyTheme.lightTheme.appBarTheme.color
                                      .withOpacity(1)
                                  : MyTheme.lightTheme.appBarTheme.color
                                      .withOpacity(0.3),
                              child: ListTile(
                                  title: Text(Constants.offlineSongs[index],
                                      style: globalIndex ==
                                              Constants.offlineSongs.indexOf(
                                                  Constants.offlineSongs[index])
                                          ? MyTheme.selectedSongTheme
                                          : MyTheme.unSelectedSongTheme),
                                  trailing: Visibility(
                                      visible: globalIndex ==
                                              Constants.offlineSongs.indexOf(
                                                  Constants.offlineSongs[index])
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
                  SizedBox(height: 5),
                  PlayerWidget()
                ],
              ),
            ),
            // getBanner()
            checkForAd()
          ],
        ),
      ),
    );
  }
}
