import 'package:flutter/material.dart';
import 'constants.dart';
import 'CameraScreen.dart';
import 'ConstantsInfo.dart';

class CameraApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return ConstantsInfo(
      appBar: appBar,
      appBar2: appBar2,
      kprimaryColor: kprimaryColor,
      ksecondaryColor: ksecondaryColor,
      kternaryColor: kternaryColor,
      headline1: headline1,
      headline2: headline2,
      headline3: headline3,
      headline4: headline4,
      headlineError: headlineError,
      child: MaterialApp(
        theme: appTheme,
        home: CameraScreen(),
      ),
    );
  }
    
}