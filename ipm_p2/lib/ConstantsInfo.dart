import 'package:flutter/material.dart';

class ConstantsInfo extends InheritedWidget {

  final kprimaryColor;
  final ksecondaryColor;
  final kternaryColor;
  final headline1;
  final headline2;
  final headline3;
  final headline4;
  final headlineError;
  final AppBar appBar;
  final AppBar appBar2;

  ConstantsInfo({
    this.appBar, 
    this.appBar2,
    this.kprimaryColor, 
    this.ksecondaryColor, 
    this.kternaryColor,
    this.headline1,
    this.headline2, 
    this.headline3,
    this.headline4,
    this.headlineError, child
  }) : super(child: child);

  static ConstantsInfo of(BuildContext context) =>
    context.inheritFromWidgetOfExactType(ConstantsInfo) as ConstantsInfo;

  @override
  bool updateShouldNotify(ConstantsInfo oldWidget) => true;

}