import 'dart:io';

class AdMobService {
  static String getAdMobAppId() {
    if (Platform.isIOS) {
      //return 'ca-app-pub-7232392139557225~5522274828';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2726748129629037~9638502821';
      
    }
    return null;
  }

 static String getBannerAdId() {
    if (Platform.isIOS) {
      //return 'ca-app-pub-7232392139557225/5690151007';
    } else if (Platform.isAndroid) {
     
      return 'ca-app-pub-2726748129629037/2747459713'; //! canlı id
      // return 'ca-app-pub-3940256099942544/6300978111'; //! test id
    }
    return null;
  }

  static String getInterstitial(){
    if (Platform.isIOS) {
      //return 'ca-app-pub-7232392139557225/5690151007';
    } else if (Platform.isAndroid) {
     
      return 'ca-app-pub-2726748129629037/3893074326'; //! canlı id
      // return 'ca-app-pub-3940256099942544/1033173712'; //! test id
    }
    return null;
  }

}
