// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_music_app/service/admob_service.dart';
import 'package:my_music_app/view/screen/lyric_songs.dart';
import 'package:my_music_app/view/screen/online_song.dart';

import 'offline_song.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  BannerAd _ad;
  bool isLoaded;

  InterstitialAd _interstitialAd;
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

    getInterstitialAd();

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
    return Scaffold(
        // drawer: Drawer(),
        appBar: AppBar(
            title: Text(
          'BTS Song App',
        )),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: Get.height * 0.25,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(OfflineSong(),transition: Transition.cupertino);
                                    _interstitialAd.show();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/bts_logo.jpg'),
                                            fit: BoxFit.fill),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Offline Song',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19)),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () => Get.to(OnlineSong(),transition: Transition.cupertino),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/bts_logo.jpg'),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Online Song',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19)),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: Get.height * 0.25,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(LyricSongs(),transition: Transition.cupertino);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/bts_logo.jpg'),
                                            fit: BoxFit.fill),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Song with Lyrics',
                                        textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19)),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                checkForAd()
              ],
            )));
  }
}
