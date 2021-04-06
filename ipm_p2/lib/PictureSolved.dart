import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ipm_p2/CameraScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ConstantsInfo.dart';

class PictureSolved extends StatefulWidget {
  final List serverResponse;
  final String imagePath;

  PictureSolved({Key key, this.serverResponse, this.imagePath})
      : super(key: key);

  _PictureSolvedState createState() => _PictureSolvedState();
}

class _PictureSolvedState extends State<PictureSolved> {
  List serverResponse;
  String imagePath;
  bool isError;
  String errorMessage;
  List validResponse;

  @override
  void initState() {
    super.initState();
    imagePath = widget.imagePath;
    isError = widget.serverResponse.last;
    if (isError) {
      errorMessage = widget.serverResponse.first;
    } else {
      widget.serverResponse.removeLast();
      validResponse = widget.serverResponse;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget takeMoreButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: FloatingActionButton.extended(
          heroTag: "home",
          backgroundColor: ConstantsInfo.of(context).ksecondaryColor,
          elevation: 10.0,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take More!'),
          onPressed: () {
            try {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => CameraScreen(),
                  ));
            } catch (e) {
              print('Error : ${e.code}');
            }
          }
        )
      )
    );
  }

  Widget textResult() {
    return Align(
      alignment: Alignment.center,
      child: isError
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: errorMessage,
                          style: ConstantsInfo.of(context).headlineError
                        ),
                    ]
                  )
                )
              ])
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: validResponse[0],
                      style: ConstantsInfo.of(context).headline1
                    ),
                  ]
                )
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: validResponse[1],
                      style: ConstantsInfo.of(context).headline2
                    ),
                  ]
                )
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w300,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: validResponse[2],
                        style: ConstantsInfo.of(context).headline3
                    ),
                  ]
                )
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w300,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '...', 
                      style: ConstantsInfo.of(context).headline4
                    ),
                  ]
                )
              ),
            ],
          )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantsInfo.of(context).appBar,
      body: Container(
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(imagePath)), fit: BoxFit.cover),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: textResult(),
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              color: Colors.transparent,
              child: takeMoreButton(),
            ),
          ),
        ])
      )
    );
  }
}