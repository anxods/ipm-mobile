import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kprimaryColor = Color(0xFF15226B);
const ksecondaryColor = Color(0xFF435ada);
const kternaryColor = Color(0xFF5e75f2);

var headline1 = TextStyle(fontSize: 48.0, fontWeight: FontWeight.w300);
var headline2 = TextStyle(fontSize: 35.0, fontWeight: FontWeight.w300);
var headline3 = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300);
var headline4 = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);
var headlineError = TextStyle(fontSize: 48.0, fontWeight: FontWeight.w300, color: Colors.redAccent);

AppBar appBar = AppBar(
  automaticallyImplyLeading: false,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        child: Text('Image Recognition'),
      ),
      Image.asset(
        'assets/images/imagga.png',
        fit: BoxFit.contain,
        height: 90,
      ),
    ],
  ),
);

AppBar appBar2 = AppBar(
  automaticallyImplyLeading: true,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        child: Text('Image Recognition'),
      ),
      Image.asset(
        'assets/images/imagga.png',
        fit: BoxFit.contain,
        height: 90,
      ),
    ],
  ),
);

ThemeData appTheme = ThemeData(
  // Colors
  primaryColor: kprimaryColor,
  accentColor: ksecondaryColor,
  buttonColor: Color(0XFFFBFA),

  // Font
  fontFamily: GoogleFonts.openSans().fontFamily,
);