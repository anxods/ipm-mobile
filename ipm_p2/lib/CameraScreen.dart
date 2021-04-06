import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ipm_p2/ConstantsInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'DisplayPictureScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List cameras; //holds the list of av. cameras.
  int selectedCameraIndex; //current selected camera.
  CameraController cameraController;
  String _galleryImagePath;
  NativeDeviceOrientation _orientation;

  Future initCamera(CameraDescription cameraDescription) async {
    // If there's an existant CameraController, we have to get rid of it
    if (cameraController != null) {
      await cameraController.dispose();
    }
    // Responsible for establishing a connection to the dev. camera
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    // Adding to the list of listeners (observers)
    cameraController.addListener(() {
      // This will notify the framework that the internal state of this object
      // has changed
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    }

    // We try to initialize a new CameraController
    try {
      await cameraController.initialize();
    } catch (e) {
      print('Error ${e.code} \nError message: ${e.description}');
    }

    // Notify that the state has changed
    if (mounted) {
      setState(() {});
    }
  }

  // Initialization of the class
  @override
  void initState() {
    super.initState();
    _orientation = NativeDeviceOrientation.portraitUp;
    availableCameras().then((value) {
      cameras = value;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0; // make the back camera default
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {});
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  // This returns a CameraPreview widget if the camera controller object
  // is initialized successfully, else it'll return a loading screen.
  Widget cameraPreview() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w300,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Loading...', 
                  style: ConstantsInfo.of(context).headline1
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
                  text: 'Please, check that the camera and/or gallery have permisions at settings.',
                  style: ConstantsInfo.of(context).headline3
                )
              ]
            )
          )
        ]
      );
    }

    int aux;
    switch (_orientation) {
      case NativeDeviceOrientation.portraitUp:
        aux = 0;
        break;
      case NativeDeviceOrientation.landscapeLeft:
        aux = 3;
        break;
      case NativeDeviceOrientation.landscapeRight:
        aux = 1;
        break;
      case NativeDeviceOrientation.portraitDown:
        aux = 2;
        break;
      default:
        break;
    }

    return RotatedBox(
      quarterTurns: aux,
      child: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      ),
    );
  }

  // This widget is responsible of taking pictures.
  Widget cameraControl(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "photoButton",
              child: Icon(
                Icons.camera,
                color: ConstantsInfo.of(context).ksecondaryColor,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                onCapture(context);
              }
            )
          ],
        )
      )
    );
  }

  // Widget for changing between front and back cameras.
  Widget cameraToggle() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FloatingActionButton(
          child: Icon(
            getCameraLensIcons(lensDirection),
            color: Colors.white,
            size: 24,
          ),
          backgroundColor: ConstantsInfo.of(context).ksecondaryColor,
          onPressed: () {
            onSwitchCamera();
          },
        ),
      ),
    );
  }

  Widget openPhoto() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "OpenPhotoGalleryButton",
              child: Icon(
                Icons.perm_media_outlined,
                color: Colors.white,
              ),
              backgroundColor: ConstantsInfo.of(context).ksecondaryColor,
              onPressed: () {
                getImage();
              }
            )
          ],
        )
      )
    );
  }

  onCapture(context) async {
    try {
      final p = await getTemporaryDirectory();
      final name = DateTime.now();
      final path = "${p.path}/$name.png";

      await cameraController.takePicture(path).then((value) {
        //print(path);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(imagePath: path),
            ));
      });
    } catch (e) {
      print('Error : ${e.code}');
    }
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return Icons.camera_front;
      case CameraLensDirection.front:
        return Icons.camera_rear;
      case CameraLensDirection.external:
        return Icons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    initCamera(selectedCamera);
  }

  Future getImage() async {
    MediaQueryData queryData = MediaQuery.of(context);
    final filePicked = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: queryData.size.height,
        maxWidth: queryData.size.width);

    _galleryImagePath =
        await FlutterAbsolutePath.getAbsolutePath(filePicked.path);

    if (filePicked != null) {
      setState(() {});

      try {
        //print(path);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DisplayPictureScreen(imagePath: _galleryImagePath),
          )
        );
      } catch (e) {
        print('Error : ${e.code}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantsInfo.of(context).appBar,
      backgroundColor: Colors.black,
      body: NativeDeviceOrientationReader(
        builder: (context) {
          _orientation = NativeDeviceOrientationReader.orientation(context);
          if (_orientation == NativeDeviceOrientation.portraitUp ||
              _orientation == NativeDeviceOrientation.portraitDown)
            return _portraitMode();
          else
            return _landscapeMode();
        }
      ),
    );
  }

  Widget _portraitMode() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: cameraPreview(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(15),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                cameraToggle(),
                Spacer(),
                cameraControl(context),
                Spacer(),
                openPhoto(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _landscapeMode() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: cameraPreview(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(5),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                cameraToggle(),
                Spacer(),
                cameraControl(context),
                Spacer(),
                openPhoto(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
