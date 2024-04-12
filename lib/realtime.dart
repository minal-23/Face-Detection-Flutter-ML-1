// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:face_detection/Database.dart';
import 'package:face_detection/RecognizedPerson.dart';
import 'package:face_detection/nextscreen.dart';
import 'package:quiver/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'main.dart';

class RealTimeFaceDetection extends StatefulWidget {
  const RealTimeFaceDetection({super.key});

  @override
  State<RealTimeFaceDetection> createState() => _RealTimeFaceDetectionState();
}

class _RealTimeFaceDetectionState extends State<RealTimeFaceDetection> {
  var interpreter;
  List? e1;
  bool tapped = false;
  Directory? tempDir;
  File? jsonFile;
  bool _faceFound = false;
  dynamic data = {};
  dynamic controller;
  bool isBusy = false;
  dynamic faceDetector;
  double threshold = 1.0;
  double zoom = 1.0;
  double maxZoomLevel = 1.0;
  Set<RecognizedInfo> recognizedNames = {};

  late Size size;
  late List<Face> faces;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel().then((_) {
      print("Model loaded successfully.");
      // Ensure that the interpreter is not null before proceeding
      if (interpreter != null) {
        print("Interpreter is ready.");
        // Proceed with operations that require the interpreter
      } else {
        print("Failed to load the model.");
        // Handle the error appropriately
      }
    });
  }

  initializeCamera() async {
    // Initialize detector
    final options =
        FaceDetectorOptions(enableContours: true, enableLandmarks: true);
    faceDetector = FaceDetector(options: options);

    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize();

    if (!mounted) {
      return;
    }
    maxZoomLevel = await controller.getMaxZoomLevel();
    print(
        "zoooooooooooooooooooooooooooooooooommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm$maxZoomLevel");
    controller.startImageStream((image) {
      if (!isBusy) {
        isBusy = true;
        img = image;
        doFaceDetectionOnFrame();
      }
    });
  }

  //close all resources
  @override
  void dispose() {
    controller?.dispose();
    faceDetector.close();
    super.dispose();
  }

  //face detection on a frame
  dynamic _scanResults;
  CameraImage? img;

  Future loadModel() async {
    try {
      this.interpreter =
          await tfl.Interpreter.fromAsset('mobilefacenet.tflite');

      print(
          '**********\n Loaded successfully model mobilefacenet.tflite \n*********\n');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  doFaceDetectionOnFrame() async {
    // setState(() {
    //   recognizedNames.clear();
    // });
    if (!tapped) {
      dynamic finalResult = Multimap<String, Face>();
      var frameImg = getInputImage();
      List<Face> faces = await faceDetector.processImage(frameImg);
      imglib.Image convertedImage = _convertCameraImage(img!, camDirec);
      if (faces.length == 0) {
        _faceFound = false;
      } else {
        _faceFound = true;
      }
      for (Face face in faces) {
        // Calculate the bounding box with a margin
        double x = face.boundingBox.left - 10;
        double y = face.boundingBox.top - 10;
        double w = face.boundingBox.width + 10;
        double h = face.boundingBox.height + 10;

        // Crop the converted image to the face's bounding box
        // imglib.Image croppedImage = imglib.copyCrop(
        //     convertedImage, x.round(), y.round(), w.round(), h.round());
        imglib.Image croppedImage = imglib.copyCrop(
          convertedImage,
          x.round(),
          y.round(),
          w.round(),
          h.round(),
        );

        // Resize the cropped image if necessary
        croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);

        // Run the face recognition model on the processed image
        Map<String, String> res = await _recog(croppedImage);
        // print(_recog(croppedImage));
        finalResult.add(res["name"], face);

        if (res["name"] != "NOT RECOGNIZED") {
          setState(() {
            recognizedNames
                .add(RecognizedInfo(name: res["name"]!, upiId: res["upiId"]!));
          });
        }

        // Do something with the recognized name, e.g., display it on the screen
        // print("Recognized face: $recognizedName");
      }

      setState(() {
        // _scanResults = faces;
        _scanResults = finalResult;
        isBusy = false;
      });
    }
  }

  imglib.Image _convertCameraImage(
      CameraImage image, CameraLensDirection _dir) {
    int width = image.width;
    int height = image.height;
    var img = imglib.Image(width, height);
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (_dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }

  Future<Map<String, String>> _recog(imglib.Image img) async {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return await compare(
        e1!); // This now correctly returns a Future<Map<String, String>>
  }

  Future<Map<String, String>> compare(List currEmb) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
    if (rows.isEmpty) {
      return {"name": "NO FACE SAVED", "upiId": ""};
    }
    double minDist = 999;
    String predRes = "NOT RECOGNIZED";
    String predUpi = "";

    for (Map row in rows) {
      List e1 = json.decode(row[DatabaseHelper.columnEmbedding]);
      double currDist = euclideanDistance(e1, currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predUpi = row[DatabaseHelper.columnUpiId];
        predRes =
            row[DatabaseHelper.columnPayee]; // Use the payee name as the label
      }
    }
    print(minDist.toString() + " " + predRes);
    return {"name": predRes, "upiId": predUpi};
  }

  double euclideanDistance(List e1, List e2) {
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  Float32List imageToByteListFloat32(
      imglib.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
    final camera = description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(img!.format.raw);

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: img!.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    return inputImage;
  }

  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return Text('');
    }

    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, camDirec);
    return CustomPaint(
      painter: painter,
    );
  }

  //toggle camera direction
  void toggleCameraDirection() async {
    if (camDirec == CameraLensDirection.back) {
      camDirec = CameraLensDirection.front;
      description = cameras[1];
    } else {
      camDirec = CameraLensDirection.back;
      description = cameras[0];
    }
    await controller.stopImageStream();
    setState(() {
      controller;
    });

    initializeCamera();
  }

  void onPayNowTap(String name) {
    setState(() {
      tapped = true;
      controller = null;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextScreen(name: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height - 250,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );
      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height - 250,
            child: buildResult()),
      );
    }

    stackChildren.add(Positioned(
      top: size.height - 250,
      left: 0,
      width: size.width,
      height: 250,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: recognizedNames.length,
                    itemBuilder: (context, index) {
                      final RecognizedInfo recognizedInfo =
                          recognizedNames.elementAt(index);
                      return ListTile(
                        title: Text(
                          recognizedInfo.name,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        subtitle: Text(
                          "${recognizedInfo.upiId}",
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => onPayNowTap(recognizedInfo.upiId),
                          child: Text('Pay Now'),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.cached,
                        color: Colors.black,
                      ),
                      iconSize: 50,
                      color: Colors.black,
                      onPressed: () {
                        toggleCameraDirection();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
    stackChildren.add(Positioned(
        bottom: 10,
        left: 0,
        right: 0,
        child: Slider(
          value: zoom,
          min: 1.0,
          max: maxZoomLevel, // Use the max zoom level here
          onChanged: (value) {
            setState(() {
              zoom = value;
              controller.setZoomLevel(value);
            });
          },
        )));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          margin: const EdgeInsets.only(top: 0),
          color: Colors.white,
          child: Stack(
            children: stackChildren,
          )),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);
  final Size absoluteImageSize;
  final Multimap<String, Face> faces;
  CameraLensDirection camDire2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    // Correctly set the text style for drawing text
    final TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 20.0);

    for (String label in faces.keys) {
      for (Face face in faces[label]) {
        // Draw the bounding box
        canvas.drawRect(
          Rect.fromLTRB(
            camDire2 == CameraLensDirection.front
                ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
                : face.boundingBox.left * scaleX,
            face.boundingBox.top * scaleY,
            camDire2 == CameraLensDirection.front
                ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
                : face.boundingBox.right * scaleX,
            face.boundingBox.bottom * scaleY,
          ),
          paint,
        );

        // Draw the label (name) above the bounding box
        final TextSpan span = TextSpan(style: textStyle, text: label);
        final TextPainter textPainter =
            TextPainter(text: span, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            camDire2 == CameraLensDirection.front
                ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
                : face.boundingBox.left * scaleX,
            (face.boundingBox.top - 30) *
                scaleY, // Adjust the position as needed
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
