// // // ignore_for_file: prefer_const_constructors

// import 'dart:math';
// import 'dart:ui';
// import 'dart:convert';
// import 'dart:io';
// import 'utils.dart';
// import 'package:path_provider/path_provider.dart';
// import 'nextscreen.dart';
// import 'package:image/image.dart' as imglib;
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'package:flutter/material.dart';
// import 'package:quiver/collection.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import 'main.dart';

// class RealTimeFaceDetection extends StatefulWidget {
//   const RealTimeFaceDetection({super.key});

//   @override
//   State<RealTimeFaceDetection> createState() => _RealTimeFaceDetectionState();
// }

// // class _RealTimeFaceDetectionState extends State<RealTimeFaceDetection> {
// //   List? _predictedData;
// //   double threshold = 1.0;
// //   dynamic data = {};
// //   dynamic controller;
// //   tfl.Interpreter? interpreter;
// //   bool _isDetecting = false;
// //   dynamic faceDetector;
// //   Directory? _savedFacesDir;
// //   late Size size;
// //   File? jsonFile;
// //   bool _faceFound = false;
// //   late List<Face> faces;
// //   late CameraDescription description = cameras[1];
// //   CameraLensDirection camDirec = CameraLensDirection.front;
// //   @override
// //   void initState() {
// //     super.initState();
// //     initializeCamera();
// //     loadModel().then((_) {
// //       print(
// //           "hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii modellllllllllllllllllllllllllllllllllllllll");
// //     });
// //   }

// //   Future loadModel() async {
// //     try {
// //       this.interpreter =
// //           await tfl.Interpreter.fromAsset('mobilefacenet.tflite');

// //       print(
// //           '**********\n Loaded successfully model mobilefacenet.tflite \n*********\n');
// //     } catch (e) {
// //       print('Failed to load model.');
// //       print(e);
// //     }
// //   }

// //   //code to initialize the camera feed
// //   initializeCamera() async {
// //     //initialize detector
// //     await loadModel();
// //     final options =
// //         FaceDetectorOptions(enableContours: false, enableLandmarks: false);
// //     faceDetector = FaceDetector(options: options);

// //     controller = CameraController(description, ResolutionPreset.high);
// //     await controller.initialize();
// //     if (!mounted) {
// //       return;
// //     }

// //     _savedFacesDir = await getApplicationDocumentsDirectory();
// //     String _fullPathSavedFaces = _savedFacesDir!.path + '/savedFaces.json';
// //     jsonFile = File(_fullPathSavedFaces);

// //     if (jsonFile!.existsSync()) {
// //       data = json.decode(jsonFile!.readAsStringSync());
// //       print('Saved faces from memory: ' + data.toString());
// //     }
// //     dynamic finalResults = Multimap<String, Face>();
// //     controller.startImageStream((image) {
// //       print('STREAMINGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
// //       if (!_isDetecting) {
// //         _isDetecting = true;
// //         img = image;
// //         doFaceDetectionOnFrame().then((dynamic result) {
// //           if (result.length == 0) {
// //             _faceFound = false;
// //           } else {
// //             _faceFound = true;
// //             Face _face;
// //             imglib.Image convertedImage = _convertCameraImage(image, camDirec);

// //             for (_face in result) {
// //               double x, y, w, h;
// //               x = (_face.boundingBox.left - 10);
// //               y = (_face.boundingBox.top - 10);
// //               w = (_face.boundingBox.width + 10);
// //               h = (_face.boundingBox.height + 10);
// //               imglib.Image croppedImage = imglib.copyCrop(
// //                   convertedImage, x.round(), y.round(), w.round(), h.round());
// //               croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
// //               // Assuming _recognizeFace is defined elsewhere and returns a result
// //               String res = _recognizeFace(croppedImage);
// //               print(
// //                   "Matched Name************************************************************************************************: $res");
// //               finalResults.add(res, _face);
// //             }
// //             setState(() {
// //               _scanResults = finalResults;
// //             });
// //           }
// //           _isDetecting = false;
// //         }).catchError((error) {
// //           // Handle any errors that occur during face detection
// //           print("Error during face detection: $error");
// //           _isDetecting = false;
// //         });
// //       }
// //     });
// //   }

// //   imglib.Image _convertCameraImage(
// //       CameraImage image, CameraLensDirection _dir) {
// //     print("CALLING CONVERT CAMERAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
// //     int width = image.width;
// //     int height = image.height;
// //     // imglib -> Image package from https://pub.dartlang.org/packages/image
// //     var img = imglib.Image(width, height); // Create Image buffer
// //     const int hexFF = 0xFF000000;
// //     final int uvyButtonStride = image.planes[1].bytesPerRow;
// //     final int uvPixelStride = image.planes[1].bytesPerPixel!;
// //     for (int x = 0; x < width; x++) {
// //       for (int y = 0; y < height; y++) {
// //         final int uvIndex =
// //             uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
// //         final int index = y * width + x;
// //         final yp = image.planes[0].bytes[index];
// //         final up = image.planes[1].bytes[uvIndex];
// //         final vp = image.planes[2].bytes[uvIndex];
// //         // Calculate pixel color
// //         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
// //         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
// //             .round()
// //             .clamp(0, 255);
// //         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
// //         // color: 0x FF  FF  FF  FF
// //         //           A   B   G   R
// //         img.data[index] = hexFF | (b << 16) | (g << 8) | r;
// //       }
// //     }
// //     var img1 = (_dir == CameraLensDirection.front)
// //         ? imglib.copyRotate(img, -90)
// //         : imglib.copyRotate(img, 90);
// //     return img1;
// //   }

// //   String _recognizeFace(imglib.Image img) {
// //     print("Embeddingssssssssssssssssssssss--------------");
// //     List input = imageToByteListFloat32(img, 112, 128, 128);
// //     input = input.reshape([1, 112, 112, 3]);
// //     List output = List.generate(1, (index) => List.filled(192, 0));
// //     if (interpreter == null) {
// //       throw Exception('Interpreter is not initialized.');
// //     }
// //     interpreter?.run(input, output);
// //     output = output.reshape([192]);
// //     _predictedData = List.from(output);
// //     print(_predictedData);
// //     return _compareExistSavedFaces(_predictedData).toUpperCase();
// //   }

// //   String _compareExistSavedFaces(List? currEmb) {
// //     if (data == null || data.length == 0) return "No Face saved";
// //     double minDist = 999;
// //     double currDist = 0.0;
// //     String predRes = "NOT RECOGNIZED";
// //     for (String label in data.keys) {
// //       currDist = euclideanDistance(data[label], currEmb!);
// //       if (currDist <= threshold && currDist < minDist) {
// //         minDist = currDist;
// //         predRes = label;
// //       }
// //     }
// //     print(minDist.toString() + " " + predRes);
// //     return predRes;
// //   }

// //   //close all resources
// //   @override
// //   void dispose() {
// //     controller?.dispose();
// //     faceDetector.close();
// //     super.dispose();
// //   }

// //   //face detection on a frame
// //   dynamic _scanResults;
// //   CameraImage? img;

// //   Future<dynamic> doFaceDetectionOnFrame() async {
// //     var frameImg = getInputImage();
// //     List<Face> faces = await faceDetector.processImage(frameImg);
// //     setState(() {
// //       _scanResults = faces;
// //       _isDetecting = false;
// //     });
// //   }
// //   // doFaceDetectionOnFrame() async {
// //   //   var frameImg = getInputImage();
// //   //   List<Face> faces = await faceDetector.processImage(frameImg);
// //   //   if (faces == null || faces.isEmpty) {
// //   //     // Handle the case where no faces are detected
// //   //     setState(() {
// //   //       _scanResults = [];
// //   //       _isDetecting = false;
// //   //     });
// //   //     return;
// //   //   }
// //   //   setState(() {
// //   //     _scanResults = faces;
// //   //     _isDetecting = false;
// //   //   });
// //   // }

// //   InputImage getInputImage() {
// //     final WriteBuffer allBytes = WriteBuffer();
// //     for (final Plane plane in img!.planes) {
// //       allBytes.putUint8List(plane.bytes);
// //     }
// //     final bytes = allBytes.done().buffer.asUint8List();
// //     final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
// //     final camera = description;
// //     final imageRotation =
// //         InputImageRotationValue.fromRawValue(camera.sensorOrientation);

// //     final inputImageFormat =
// //         InputImageFormatValue.fromRawValue(img!.format.raw);
// //     final planeData = img!.planes.map(
// //       (Plane plane) {
// //         return InputImagePlaneMetadata(
// //           bytesPerRow: plane.bytesPerRow,
// //           height: plane.height,
// //           width: plane.width,
// //         );
// //       },
// //     ).toList();

// //     final inputImageData = InputImageData(
// //       size: imageSize,
// //       imageRotation: imageRotation!,
// //       inputImageFormat: inputImageFormat!,
// //       planeData: planeData,
// //     );

// //     final inputImage =
// //         InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

// //     return inputImage;
// //   }

// //   //Show rectangles around detected faces
// //   // Widget buildResult() {
// //   //   if (_scanResults == null ||
// //   //       controller == null ||
// //   //       !controller.value.isInitialized) {
// //   //     return Text('');
// //   //   }

// //   //   final Size imageSize = Size(
// //   //     controller.value.previewSize!.height,
// //   //     controller.value.previewSize!.width,
// //   //   );
// //   //   CustomPainter painter =
// //   //       FaceDetectorPainter(imageSize, _scanResults, camDirec);
// //   //   return CustomPaint(
// //   //     painter: painter,
// //   //   );
// //   // }
// //   void _handleTap(TapDownDetails details, Size imageSize) {
// //     double scaleX = size.width / imageSize.width;
// //     double scaleY = size.height / imageSize.height;
// //     double x = details.localPosition.dx / scaleX;
// //     double y = details.localPosition.dy / scaleY;

// //     // Define a threshold for expanding the bounding box
// //     double threshold = 10.0; // Adjust this value as needed

// //     // Find the face closest to the tap point
// //     Face? closestFace;
// //     double closestDistance = double.infinity;

// //     for (Face face in _scanResults) {
// //       // Expand the bounding box
// //       Rect expandedBoundingBox = face.boundingBox.inflate(threshold);

// //       // Calculate the distance from the tap point to the center of the bounding box
// //       double distance = (expandedBoundingBox.center - Offset(x, y)).distance;

// //       // Update the closest face if necessary
// //       if (distance < closestDistance) {
// //         closestDistance = distance;
// //         closestFace = face;
// //       }
// //     }

// //     if (closestFace != null) {
// //       // Navigate to the next screen
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => NextScreen()),
// //       );
// //     }
// //   }

// // //   Widget buildResult() {
// // //  if (_scanResults == null ||
// // //       controller == null ||
// // //       !controller.value.isInitialized) {
// // //     return Text('');
// // //  }

// // //  final Size imageSize = Size(
// // //     controller.value.previewSize!.height,
// // //     controller.value.previewSize!.width,
// // //  );
// // //  CustomPainter painter =
// // //       FaceDetectorPainter(imageSize, _scanResults, camDirec);

// // //  // Wrap the CustomPaint widget with a GestureDetector
// // //  return GestureDetector(
// // //     onTapDown: (TapDownDetails details) {
// // //       // Handle tap down event
// // //       _handleTap(details, imageSize);
// // //     },
// // //     child: CustomPaint(
// // //       painter: painter,
// // //     ),
// // //  );
// // // }
// //   Widget buildResult() {
// //     if (_scanResults == null ||
// //         controller == null ||
// //         !controller.value.isInitialized) {
// //       return Text('');
// //     }

// //     final Size imageSize = Size(
// //       controller.value.previewSize!.height,
// //       controller.value.previewSize!.width,
// //     );
// //     CustomPainter painter =
// //         FaceDetectorPainter(imageSize, _scanResults, camDirec);

// //     return GestureDetector(
// //       onTapDown: (TapDownDetails details) {
// //         _handleTap(details, imageSize);
// //       },
// //       child: CustomPaint(
// //         painter: painter,
// //       ),
// //     );
// //   }

// //   //toggle camera direction
// //   void toggleCameraDirection() async {
// //     if (camDirec == CameraLensDirection.back) {
// //       camDirec = CameraLensDirection.front;
// //       description = cameras[1];
// //     } else {
// //       camDirec = CameraLensDirection.back;
// //       description = cameras[0];
// //     }
// //     await controller.stopImageStream();
// //     setState(() {
// //       controller;
// //     });

// //     initializeCamera();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     List<Widget> stackChildren = [];
// //     size = MediaQuery.of(context).size;
// //     if (controller != null) {
// //       stackChildren.add(
// //         Positioned(
// //           top: 0.0,
// //           left: 0.0,
// //           width: size.width,
// //           height: size.height - 250,
// //           child: Container(
// //             child: (controller.value.isInitialized)
// //                 ? AspectRatio(
// //                     aspectRatio: controller.value.aspectRatio,
// //                     child: CameraPreview(controller),
// //                   )
// //                 : Container(),
// //           ),
// //         ),
// //       );
// //       stackChildren.add(
// //         Positioned(
// //             top: 0.0,
// //             left: 0.0,
// //             width: size.width,
// //             height: size.height - 250,
// //             child: buildResult()),
// //       );
// //     }

// //     stackChildren.add(Positioned(
// //       top: size.height - 200,
// //       left: 0,
// //       width: size.width,
// //       height: 250,
// //       child: Container(
// //         color: Colors.white,
// //         child: Center(
// //           child: Container(
// //             margin: const EdgeInsets.only(bottom: 40),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     IconButton(
// //                       icon: const Icon(
// //                         Icons.cached,
// //                         color: Colors.black,
// //                       ),
// //                       iconSize: 50,
// //                       color: Colors.black,
// //                       onPressed: () {
// //                         toggleCameraDirection();
// //                       },
// //                     )
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     ));

// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: Container(
// //           margin: const EdgeInsets.only(top: 0),
// //           color: Colors.white,
// //           child: Stack(
// //             children: stackChildren,
// //           )),
// //     );
// //   }
// // }

// // // class FaceDetectorPainter extends CustomPainter {
// // //   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

// // //   final Size absoluteImageSize;
// // //   final List<Face> faces;
// // //   CameraLensDirection camDire2;

// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     final double scaleX = size.width / absoluteImageSize.width;
// // //     final double scaleY = size.height / absoluteImageSize.height;

// // //     final Paint paint = Paint()
// // //       ..style = PaintingStyle.stroke
// // //       ..strokeWidth = 2.0
// // //       ..color = Colors.red;

// // //     for (Face face in faces) {
// // //       canvas.drawRect(
// // //         Rect.fromLTRB(
// // //           camDire2 == CameraLensDirection.front
// // //               ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
// // //               : face.boundingBox.left * scaleX,
// // //           face.boundingBox.top * scaleY,
// // //           camDire2 == CameraLensDirection.front
// // //               ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
// // //               : face.boundingBox.right * scaleX,
// // //           face.boundingBox.bottom * scaleY,
// // //         ),
// // //         paint,
// // //       );
// // //     }
// // //     Paint p2 = Paint();
// // //     p2.color = Colors.green;
// // //     p2.style = PaintingStyle.stroke;
// // //     p2.strokeWidth = 5;

// // //     for (Face face in faces) {
// // //       Map<FaceContourType, FaceContour?> con = face.contours;
// // //       List<Offset> offsetPoints = <Offset>[];
// // //       con.forEach((key, value) {
// // //         if (value != null) {
// // //           List<Point<int>>? points = value.points;
// // //           for (Point p in points) {
// // //             Offset offset = Offset(
// // //                 camDire2 == CameraLensDirection.front
// // //                     ? (absoluteImageSize.width - p.x.toDouble()) * scaleX
// // //                     : p.x.toDouble() * scaleX,
// // //                 p.y.toDouble() * scaleY);
// // //             offsetPoints.add(offset);
// // //           }
// // //           canvas.drawPoints(PointMode.points, offsetPoints, p2);
// // //         }
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
// // //     return oldDelegate.absoluteImageSize != absoluteImageSize ||
// // //         oldDelegate.faces != faces;
// // //   }
// // // }
// // class FaceDetectorPainter extends CustomPainter {
// //   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

// //   final Size absoluteImageSize;
// //   final List<Face> faces;
// //   CameraLensDirection camDire2;

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final double scaleX = size.width / absoluteImageSize.width;
// //     final double scaleY = size.height / absoluteImageSize.height;

// //     final Paint paint = Paint()
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 2.0
// //       ..color = Colors.red;

// //     for (Face face in faces) {
// //       canvas.drawRect(
// //         Rect.fromLTRB(
// //           camDire2 == CameraLensDirection.front
// //               ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
// //               : face.boundingBox.left * scaleX,
// //           face.boundingBox.top * scaleY,
// //           camDire2 == CameraLensDirection.front
// //               ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
// //               : face.boundingBox.right * scaleX,
// //           face.boundingBox.bottom * scaleY,
// //         ),
// //         paint,
// //       );
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
// //     return oldDelegate.absoluteImageSize != absoluteImageSize ||
// //         oldDelegate.faces != faces;
// //   }
// // }

// class _RealTimeFaceDetectionState extends State<RealTimeFaceDetection> {
//   List? _predictedData;
//   double threshold = 1.0;
//   dynamic data = {};
//   dynamic controller;
//   tfl.Interpreter? interpreter;
//   bool _isDetecting = false;
//   dynamic faceDetector;
//   Directory? _savedFacesDir;
//   late Size size;
//   File? jsonFile;
//   bool _faceFound = false;
//   late List<Face> faces;
//   late CameraDescription description = cameras[1];
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     loadModel().then((_) {
//       print(
//           "hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii modellllllllllllllllllllllllllllllllllllllll");
//     });
//   }

//   Future loadModel() async {
//     try {
//       this.interpreter =
//           await tfl.Interpreter.fromAsset('mobilefacenet.tflite');

//       print(
//           '**********\n Loaded successfully model mobilefacenet.tflite \n*********\n');
//     } catch (e) {
//       print('Failed to load model.');
//       print(e);
//     }
//   }

//   //code to initialize the camera feed
//   initializeCamera() async {
//     //initialize detector
//     await loadModel();
//     final options =
//         FaceDetectorOptions(enableContours: false, enableLandmarks: false);
//     faceDetector = FaceDetector(options: options);

//     controller = CameraController(description, ResolutionPreset.high);
//     await controller.initialize();
//     if (!mounted) {
//       return;
//     }

//     _savedFacesDir = await getApplicationDocumentsDirectory();
//     String _fullPathSavedFaces = _savedFacesDir!.path + '/savedFaces.json';
//     jsonFile = File(_fullPathSavedFaces);

//     if (jsonFile!.existsSync()) {
//       data = json.decode(jsonFile!.readAsStringSync());
//       print('Saved faces from memory: ' + data.toString());
//     }
//     // Multimap<String, Face> finalResults = Multimap<String, Face>();
//     controller.startImageStream((image) {
//       print('STREAMINGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
//       if (!_isDetecting) {
//         _isDetecting = true;
//         img = image;
//         doFaceDetectionOnFrame().then((dynamic result) {
//           if (result.length == 0) {
//             _faceFound = false;
//           } else {
//             _faceFound = true;
//             Face _face;
//             imglib.Image convertedImage = _convertCameraImage(image, camDirec);

//             for (_face in result) {
//               double x, y, w, h;
//               x = (_face.boundingBox.left - 10);
//               y = (_face.boundingBox.top - 10);
//               w = (_face.boundingBox.width + 10);
//               h = (_face.boundingBox.height + 10);
//               imglib.Image croppedImage = imglib.copyCrop(
//                   convertedImage, x.round(), y.round(), w.round(), h.round());
//               croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
//               // Assuming _recognizeFace is defined elsewhere and returns a result
//               String res = _recognizeFace(croppedImage);
//               print(
//                   "Matched Name************************************************************************************************: $res");
//               // finalResults.add(res, _face);
//             }
//             setState(() {
//               _scanResults = faces;
//             });
//           }
//           _isDetecting = false;
//         }).catchError((error) {
//           // Handle any errors that occur during face detection
//           print("Error during face detection: $error");
//           _isDetecting = false;
//         });
//       }
//     });
//   }

//   imglib.Image _convertCameraImage(
//       CameraImage image, CameraLensDirection _dir) {
//     print("CALLING CONVERT CAMERAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
//     int width = image.width;
//     int height = image.height;
//     // imglib -> Image package from https://pub.dartlang.org/packages/image
//     var img = imglib.Image(width, height); // Create Image buffer
//     const int hexFF = 0xFF000000;
//     final int uvyButtonStride = image.planes[1].bytesPerRow;
//     final int uvPixelStride = image.planes[1].bytesPerPixel!;
//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final int uvIndex =
//             uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
//         final int index = y * width + x;
//         final yp = image.planes[0].bytes[index];
//         final up = image.planes[1].bytes[uvIndex];
//         final vp = image.planes[2].bytes[uvIndex];
//         // Calculate pixel color
//         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
//             .round()
//             .clamp(0, 255);
//         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
//         // color: 0x FF  FF  FF  FF
//         //           A   B   G   R
//         img.data[index] = hexFF | (b << 16) | (g << 8) | r;
//       }
//     }
//     var img1 = (_dir == CameraLensDirection.front)
//         ? imglib.copyRotate(img, -90)
//         : imglib.copyRotate(img, 90);
//     return img1;
//   }

//   String _recognizeFace(imglib.Image img) {
//     print("Embeddingssssssssssssssssssssss--------------");
//     List input = imageToByteListFloat32(img, 112, 128, 128);
//     input = input.reshape([1, 112, 112, 3]);
//     List output = List.generate(1, (index) => List.filled(192, 0));
//     if (interpreter == null) {
//       throw Exception('Interpreter is not initialized.');
//     }
//     interpreter?.run(input, output);
//     output = output.reshape([192]);
//     _predictedData = List.from(output);
//     print(_predictedData);
//     return _compareExistSavedFaces(_predictedData).toUpperCase();
//   }

//   String _compareExistSavedFaces(List? currEmb) {
//     if (data == null || data.length == 0) return "No Face saved";
//     double minDist = 999;
//     double currDist = 0.0;
//     String predRes = "NOT RECOGNIZED";
//     for (String label in data.keys) {
//       currDist = euclideanDistance(data[label], currEmb!);
//       if (currDist <= threshold && currDist < minDist) {
//         minDist = currDist;
//         predRes = label;
//       }
//     }
//     print(minDist.toString() + " " + predRes);
//     return predRes;
//   }

//   //close all resources
//   @override
//   void dispose() {
//     controller?.dispose();
//     faceDetector.close();
//     super.dispose();
//   }

//   //face detection on a frame
//   dynamic _scanResults;
//   CameraImage? img;

//   Future<dynamic> doFaceDetectionOnFrame() async {
//     var frameImg = getInputImage();
//     List<Face> faces = await faceDetector.processImage(frameImg);
//     setState(() {
//       _scanResults = faces;
//       _isDetecting = false;
//     });
//     return faces; // Return the detected faces
//   }

//   // doFaceDetectionOnFrame() async {
//   //   var frameImg = getInputImage();
//   //   List<Face> faces = await faceDetector.processImage(frameImg);
//   //   if (faces == null || faces.isEmpty) {
//   //     // Handle the case where no faces are detected
//   //     setState(() {
//   //       _scanResults = [];
//   //       _isDetecting = false;
//   //     });
//   //     return;
//   //   }
//   //   setState(() {
//   //     _scanResults = faces;
//   //     _isDetecting = false;
//   //   });
//   // }

//   InputImage getInputImage() {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in img!.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//     final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
//     final camera = description;
//     final imageRotation =
//         InputImageRotationValue.fromRawValue(camera.sensorOrientation);

//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(img!.format.raw);
//     final planeData = img!.planes.map(
//       (Plane plane) {
//         return InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       },
//     ).toList();

//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation!,
//       inputImageFormat: inputImageFormat!,
//       planeData: planeData,
//     );

//     final inputImage =
//         InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

//     return inputImage;
//   }

//   //Show rectangles around detected faces
//   // Widget buildResult() {
//   //   if (_scanResults == null ||
//   //       controller == null ||
//   //       !controller.value.isInitialized) {
//   //     return Text('');
//   //   }

//   //   final Size imageSize = Size(
//   //     controller.value.previewSize!.height,
//   //     controller.value.previewSize!.width,
//   //   );
//   //   CustomPainter painter =
//   //       FaceDetectorPainter(imageSize, _scanResults, camDirec);
//   //   return CustomPaint(
//   //     painter: painter,
//   //   );
//   // }
//   void _handleTap(TapDownDetails details, Size imageSize) {
//     double scaleX = size.width / imageSize.width;
//     double scaleY = size.height / imageSize.height;
//     double x = details.localPosition.dx / scaleX;
//     double y = details.localPosition.dy / scaleY;

//     // Define a threshold for expanding the bounding box
//     double threshold = 10.0; // Adjust this value as needed

//     // Find the face closest to the tap point
//     Face? closestFace;
//     double closestDistance = double.infinity;

//     for (Face face in _scanResults) {
//       // Expand the bounding box
//       Rect expandedBoundingBox = face.boundingBox.inflate(threshold);

//       // Calculate the distance from the tap point to the center of the bounding box
//       double distance = (expandedBoundingBox.center - Offset(x, y)).distance;

//       // Update the closest face if necessary
//       if (distance < closestDistance) {
//         closestDistance = distance;
//         closestFace = face;
//       }
//     }

//     if (closestFace != null) {
//       // Navigate to the next screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => NextScreen()),
//       );
//     }
//   }

// //   Widget buildResult() {
// //  if (_scanResults == null ||
// //       controller == null ||
// //       !controller.value.isInitialized) {
// //     return Text('');
// //  }

// //  final Size imageSize = Size(
// //     controller.value.previewSize!.height,
// //     controller.value.previewSize!.width,
// //  );
// //  CustomPainter painter =
// //       FaceDetectorPainter(imageSize, _scanResults, camDirec);

// //  // Wrap the CustomPaint widget with a GestureDetector
// //  return GestureDetector(
// //     onTapDown: (TapDownDetails details) {
// //       // Handle tap down event
// //       _handleTap(details, imageSize);
// //     },
// //     child: CustomPaint(
// //       painter: painter,
// //     ),
// //  );
// // }
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller.value.isInitialized) {
//       return Text('');
//     }

//     final Size imageSize = Size(
//       controller.value.previewSize!.height,
//       controller.value.previewSize!.width,
//     );
//     CustomPainter painter =
//         FaceDetectorPainter(imageSize, _scanResults, camDirec);

//     return GestureDetector(
//       onTapDown: (TapDownDetails details) {
//         _handleTap(details, imageSize);
//       },
//       child: CustomPaint(
//         painter: painter,
//       ),
//     );
//   }

//   //toggle camera direction
//   void toggleCameraDirection() async {
//     if (camDirec == CameraLensDirection.back) {
//       camDirec = CameraLensDirection.front;
//       description = cameras[1];
//     } else {
//       camDirec = CameraLensDirection.back;
//       description = cameras[0];
//     }
//     await controller.stopImageStream();
//     setState(() {
//       controller;
//     });

//     initializeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stackChildren = [];
//     size = MediaQuery.of(context).size;
//     if (controller != null) {
//       stackChildren.add(
//         Positioned(
//           top: 0.0,
//           left: 0.0,
//           width: size.width,
//           height: size.height - 250,
//           child: Container(
//             child: (controller.value.isInitialized)
//                 ? AspectRatio(
//                     aspectRatio: controller.value.aspectRatio,
//                     child: CameraPreview(controller),
//                   )
//                 : Container(),
//           ),
//         ),
//       );
//       stackChildren.add(
//         Positioned(
//             top: 0.0,
//             left: 0.0,
//             width: size.width,
//             height: size.height - 250,
//             child: buildResult()),
//       );
//     }

//     stackChildren.add(Positioned(
//       top: size.height - 200,
//       left: 0,
//       width: size.width,
//       height: 250,
//       child: Container(
//         color: Colors.white,
//         child: Center(
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.cached,
//                         color: Colors.black,
//                       ),
//                       iconSize: 50,
//                       color: Colors.black,
//                       onPressed: () {
//                         toggleCameraDirection();
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//           margin: const EdgeInsets.only(top: 0),
//           color: Colors.white,
//           child: Stack(
//             children: stackChildren,
//           )),
//     );
//   }
// }

// // ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'utils.dart';
import 'package:path_provider/path_provider.dart';
import 'nextscreen.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'main.dart';

class RealTimeFaceDetection extends StatefulWidget {
  const RealTimeFaceDetection({super.key});

  @override
  State<RealTimeFaceDetection> createState() => _RealTimeFaceDetectionState();
}

class _RealTimeFaceDetectionState extends State<RealTimeFaceDetection> {
  List? _predictedData;
  double threshold = 1.0;
  dynamic data = {};
  dynamic controller;
  tfl.Interpreter? interpreter;
  bool _isDetecting = false;
  dynamic faceDetector;
  Directory? _savedFacesDir;
  late Size size;
  File? jsonFile;
  bool _faceFound = false;
  late List<Face> faces;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel().then((_) {
      print(
          "hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii modellllllllllllllllllllllllllllllllllllllll");
    });
  }

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

  //code to initialize the camera feed
  initializeCamera() async {
    //initialize detector
    await loadModel();
    final options =
        FaceDetectorOptions(enableContours: false, enableLandmarks: false);
    faceDetector = FaceDetector(options: options);

    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize();
    if (!mounted) {
      return;
    }

    _savedFacesDir = await getApplicationDocumentsDirectory();
    String _fullPathSavedFaces = _savedFacesDir!.path + '/savedFaces.json';
    jsonFile = File(_fullPathSavedFaces);

    if (jsonFile!.existsSync()) {
      data = json.decode(jsonFile!.readAsStringSync());
      print('Saved faces from memory: ' + data.toString());
    }
    // dynamic finalResults = Multimap<String, Face>();
    controller.startImageStream((image) {
      print('STREAMINGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
      if (!_isDetecting) {
        _isDetecting = true;
        img = image;
        doFaceDetectionOnFrame().then((dynamic result) {
          if (result.length == 0) {
            _faceFound = false;
          } else {
            _faceFound = true;
            Face _face;
            imglib.Image convertedImage = _convertCameraImage(image, camDirec);

            for (_face in result) {
              double x, y, w, h;
              x = (_face.boundingBox.left - 10);
              y = (_face.boundingBox.top - 10);
              w = (_face.boundingBox.width + 10);
              h = (_face.boundingBox.height + 10);
              imglib.Image croppedImage = imglib.copyCrop(
                  convertedImage, x.round(), y.round(), w.round(), h.round());
              croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
              // Assuming _recognizeFace is defined elsewhere and returns a result
              String res = _recognizeFace(croppedImage);
              print(
                  "Matched Name************************************************************************************************: $res");
              // finalResults.add(res, _face);
            }
            setState(() {
              _scanResults = faces;
            });
          }
          _isDetecting = false;
        }).catchError((error) {
          // Handle any errors that occur during face detection
          print("Error during face detection: $error");
          _isDetecting = false;
        });
      }
    });
  }

  imglib.Image _convertCameraImage(
      CameraImage image, CameraLensDirection _dir) {
    print("CALLING CONVERT CAMERAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    int width = image.width;
    int height = image.height;
    // imglib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer
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

  String _recognizeFace(imglib.Image img) {
    print("Embeddingssssssssssssssssssssss--------------");
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    if (interpreter == null) {
      throw Exception('Interpreter is not initialized.');
    }
    interpreter?.run(input, output);
    output = output.reshape([192]);
    _predictedData = List.from(output);
    print(_predictedData);
    return _compareExistSavedFaces(_predictedData).toUpperCase();
  }

  String _compareExistSavedFaces(List? currEmb) {
    if (data == null || data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb!);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
      }
    }
    print(minDist.toString() + " " + predRes);
    return predRes;
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

  Future<dynamic> doFaceDetectionOnFrame() async {
    var frameImg = getInputImage();
    List<Face> faces = await faceDetector.processImage(frameImg);
    setState(() {
      _scanResults = faces;
      _isDetecting = false;
    });
    return faces; // Return the detected faces
  }

  // doFaceDetectionOnFrame() async {
  //   var frameImg = getInputImage();
  //   List<Face> faces = await faceDetector.processImage(frameImg);
  //   if (faces == null || faces.isEmpty) {
  //     // Handle the case where no faces are detected
  //     setState(() {
  //       _scanResults = [];
  //       _isDetecting = false;
  //     });
  //     return;
  //   }
  //   setState(() {
  //     _scanResults = faces;
  //     _isDetecting = false;
  //   });
  // }

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
    final planeData = img!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  //Show rectangles around detected faces
  // Widget buildResult() {
  //   if (_scanResults == null ||
  //       controller == null ||
  //       !controller.value.isInitialized) {
  //     return Text('');
  //   }

  //   final Size imageSize = Size(
  //     controller.value.previewSize!.height,
  //     controller.value.previewSize!.width,
  //   );
  //   CustomPainter painter =
  //       FaceDetectorPainter(imageSize, _scanResults, camDirec);
  //   return CustomPaint(
  //     painter: painter,
  //   );
  // }
  void _handleTap(TapDownDetails details, Size imageSize) {
    double scaleX = size.width / imageSize.width;
    double scaleY = size.height / imageSize.height;
    double x = details.localPosition.dx / scaleX;
    double y = details.localPosition.dy / scaleY;

    // Define a threshold for expanding the bounding box
    double threshold = 10.0; // Adjust this value as needed

    // Find the face closest to the tap point
    Face? closestFace;
    double closestDistance = double.infinity;

    for (Face face in _scanResults) {
      // Expand the bounding box
      Rect expandedBoundingBox = face.boundingBox.inflate(threshold);

      // Calculate the distance from the tap point to the center of the bounding box
      double distance = (expandedBoundingBox.center - Offset(x, y)).distance;

      // Update the closest face if necessary
      if (distance < closestDistance) {
        closestDistance = distance;
        closestFace = face;
      }
    }

    if (closestFace != null) {
      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NextScreen()),
      );
    }
  }

//   Widget buildResult() {
//  if (_scanResults == null ||
//       controller == null ||
//       !controller.value.isInitialized) {
//     return Text('');
//  }

//  final Size imageSize = Size(
//     controller.value.previewSize!.height,
//     controller.value.previewSize!.width,
//  );
//  CustomPainter painter =
//       FaceDetectorPainter(imageSize, _scanResults, camDirec);

//  // Wrap the CustomPaint widget with a GestureDetector
//  return GestureDetector(
//     onTapDown: (TapDownDetails details) {
//       // Handle tap down event
//       _handleTap(details, imageSize);
//     },
//     child: CustomPaint(
//       painter: painter,
//     ),
//  );
// }
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

    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _handleTap(details, imageSize);
      },
      child: CustomPaint(
        painter: painter,
      ),
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
      top: size.height - 200,
      left: 0,
      width: size.width,
      height: 250,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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

// class FaceDetectorPainter extends CustomPainter {
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

//   final Size absoluteImageSize;
//   final List<Face> faces;
//   CameraLensDirection camDire2;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;

//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.red;

//     for (Face face in faces) {
//       canvas.drawRect(
//         Rect.fromLTRB(
//           camDire2 == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
//               : face.boundingBox.left * scaleX,
//           face.boundingBox.top * scaleY,
//           camDire2 == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
//               : face.boundingBox.right * scaleX,
//           face.boundingBox.bottom * scaleY,
//         ),
//         paint,
//       );
//     }
//     Paint p2 = Paint();
//     p2.color = Colors.green;
//     p2.style = PaintingStyle.stroke;
//     p2.strokeWidth = 5;

//     for (Face face in faces) {
//       Map<FaceContourType, FaceContour?> con = face.contours;
//       List<Offset> offsetPoints = <Offset>[];
//       con.forEach((key, value) {
//         if (value != null) {
//           List<Point<int>>? points = value.points;
//           for (Point p in points) {
//             Offset offset = Offset(
//                 camDire2 == CameraLensDirection.front
//                     ? (absoluteImageSize.width - p.x.toDouble()) * scaleX
//                     : p.x.toDouble() * scaleX,
//                 p.y.toDouble() * scaleY);
//             offsetPoints.add(offset);
//           }
//           canvas.drawPoints(PointMode.points, offsetPoints, p2);
//         }
//       });
//     }
//   }

//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
//     return oldDelegate.absoluteImageSize != absoluteImageSize ||
//         oldDelegate.faces != faces;
//   }
// }
class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

  final Size absoluteImageSize;
  final List<Face> faces;
  CameraLensDirection camDire2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (Face face in faces) {
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
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
