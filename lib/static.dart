// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class StaticFaceDetection extends StatefulWidget {
  const StaticFaceDetection({super.key});
  @override
  State<StaticFaceDetection> createState() => _StaticFaceDetectionState();
}

class _StaticFaceDetectionState extends State<StaticFaceDetection> {
  late ImagePicker imagePicker;
  File? _image;
  String result = '';
  dynamic image;
  late List<Face> faces;

  //declare detector
  dynamic faceDetector;

  @override
  void initState() {
    //implement initState
    super.initState();
    imagePicker = ImagePicker();
    //initialize detector
    final options = FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: true,
        enableClassification: true,
        enableTracking: true,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.fast);
    faceDetector = FaceDetector(options: options);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // capture image using camera
  imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  //choose image using gallery
  imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  //face detection code here
  doFaceDetection() async {
    result = "";
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);
    for (Face f in faces) {
      if (f.smilingProbability! > .5) {
        result += "Smiling";
      } else {
        result += "Serious";
      }
    }
    setState(() {
      _image;
      result;
    });
    drawRectangleAroundFaces();
  }

  //draw rectangles
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {
      image;
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: Stack(children: <Widget>[
                Center(
                  child: ElevatedButton(
                    onPressed: imgFromGallery,
                    onLongPress: imgFromCamera,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: Container(
                      width: 335,
                      height: 495,
                      margin: const EdgeInsets.only(
                        top: 45,
                      ),
                      child: image != null
                          ? Center(
                              child: FittedBox(
                                child: SizedBox(
                                  width: image.width.toDouble(),
                                  height: image.width.toDouble(),
                                  child: CustomPaint(
                                    painter: FacePainter(
                                        facesList: faces, imageFile: image),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.black,
                              width: 340,
                              height: 330,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
          ],
        ));
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});
  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;
    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }

    Paint p2 = Paint();
    p2.color = Colors.green;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 2;

    Paint p3 = Paint();
    p3.color = Colors.yellow;
    p3.style = PaintingStyle.stroke;
    p3.strokeWidth = 2;

    for (Face face in facesList) {
      Map<FaceContourType, FaceContour?> con = face.contours;
      List<Offset> offsetPoints = <Offset>[];
      con.forEach((key, value) {
        if (value != null) {
          List<Point<int>>? points = value.points;
          for (Point p in points) {
            Offset offset = Offset(p.x.toDouble(), p.y.toDouble());
            offsetPoints.add(offset);
          }
          canvas.drawPoints(PointMode.points, offsetPoints, p2);
        }
      });
      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears, eyes, cheeks, and nose available):
      final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
      final Point<int> leftEarPos = leftEar.position;
      canvas.drawRect(
          Rect.fromLTWH(
              leftEarPos.x.toDouble() - 5, leftEarPos.y.toDouble() - 5, 20, 20),
          p3);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
