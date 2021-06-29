import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_music_app/theme/my_theme.dart';
import 'package:my_music_app/view/screen/home_page.dart';
import 'package:my_music_app/view_model/playing_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyAudio(),
        ),
       
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: MyTheme.lightTheme,
      ),
    );
  }
}
