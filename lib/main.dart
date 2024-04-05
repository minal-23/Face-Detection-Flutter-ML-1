// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:face_detection/camera.dart';
import 'package:face_detection/realtime.dart';
import 'package:face_detection/static.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Face look',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaticFaceDetection()));
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFADD8E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  'STATIC',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RealTimeFaceDetection()));
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFADD8E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  'REALTIME',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PickImage()));
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFADD8E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                displayUserData(); // Call the function without await

                // Navigate to the RealTimeFaceDetection screen
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFADD8E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Saved Face',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Inside your _MyHomePageState class, modify the GestureDetector for the 'Register' button
          ],
        ),
      ),
    );
  }

  Future<void> displayUserData() async {
    Map<String, dynamic> userData = await readUserDataFromJson();

    // Assuming you want to print the user data to the console
    userData.forEach((key, value) {
      print("User Name: $key");
      print("Embedding: $value");
    });
  }

  Future<Map<String, dynamic>> readUserDataFromJson() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File('$dir/savedFaces.json');

    // Check if the file exists
    if (!await file.exists()) {
      print("The file does not exist.");
      return {}; // Return an empty map if the file does not exist
    }

    // Read the file and parse the JSON content
    String fileContent = await file.readAsString();
    Map<String, dynamic> data = json.decode(fileContent);

    return data;
  }
}
