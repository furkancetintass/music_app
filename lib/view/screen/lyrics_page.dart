import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_music_app/constants/constants.dart';
import 'package:my_music_app/view/widget/player_widget_lyrics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_music_app/service/admob_service.dart';

class LyricsPage extends StatefulWidget {
  LyricsPage({this.index});
  int index;
  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  String data;

  BannerAd _ad;
  bool isLoaded;

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
        width: _ad.size.width.toDouble(),
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

  loadString() async {
    return data =
        await getFileData(Constants.lyricSongs[widget.index]['lyric']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: PlayerWidgetLyrics(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  children: [
                    Expanded(
                      child: Container(
                        // height: Get.height * 0.6,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),
                              FutureBuilder(
                                future: loadString(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return 
                                    Center(
                                        child: Text(
                                      data,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ));
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PlayerWidgetLyrics(),
              checkForAd()
            ],
          ),
        ));
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
