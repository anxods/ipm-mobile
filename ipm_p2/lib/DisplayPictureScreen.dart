import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ipm_p2/post.dart';
import 'package:ipm_p2/PictureSolved.dart';
import 'ConstantsInfo.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String imagePath;
  bool isSetToWidth;
  bool isAsync = false;

  @override
  void initState() {
    super.initState();
    imagePath = widget.imagePath;
    isSetToWidth = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget changeAspectRatio() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.aspect_ratio_rounded,
                color: Colors.white,
              ),
              backgroundColor: ConstantsInfo.of(context).ksecondaryColor,
              onPressed: () {
                _setAspectRatio();
              }
            )
          ],
        )
      )
    );
  }

  void _setAspectRatio() {
    setState(() {
      isSetToWidth = !isSetToWidth;
    });
  }

  Widget buttonSendImage() {
    return Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.send,
                color: ConstantsInfo.of(context).ksecondaryColor,
              ),
              heroTag: "sendButton",
              backgroundColor: Colors.white,
              onPressed: () {
                _onPressedSendImage();
              }
            )
          ],
        )
      )
    );
  }

  _onPressedSendImage() async {
    setState(() {
      isAsync = true;
    });
    Post post = new Post();
    List response = await post.postImage(new File(imagePath));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PictureSolved(
          serverResponse: response,
          imagePath: imagePath,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantsInfo.of(context).appBar2,
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: isSetToWidth ? BoxFit.fitWidth : BoxFit.fitHeight),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    changeAspectRatio(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    buttonSendImage(),
                  ]
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: isAsync
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 2,
                  )
                : null,
            )
          ],
        ),
      ),
    );
  }
}
