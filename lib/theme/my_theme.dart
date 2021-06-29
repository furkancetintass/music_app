import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class MyTheme{
static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.ralewayTextTheme(),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
        color: Color(0xff6E6A9F),
        textTheme: TextTheme(
            headline6:
                GoogleFonts.raleway(color: Colors.white, fontSize: 16))));

static const TextStyle selectedSongTheme = TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold);
static const TextStyle unSelectedSongTheme = TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.normal);
}


