// // // // ignore_for_file: prefer_const_constructors
// // // import 'dart:io';
// // // import 'dart:convert';
// // // import 'package:camera/camera.dart';
// // // import 'package:face_detection/Database.dart';
// // // import 'package:face_detection/realtime.dart';
// // // import 'package:face_detection/register.dart';
// // // import 'package:flutter/material.dart';

// // // import 'package:path_provider/path_provider.dart';

// // // late List<CameraDescription> cameras;
// // // var _databaseHelper = DatabaseHelper();
// // // Future<void> main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await _databaseHelper.init();
// // //   print("DATABASE  INITIALIZED");
// // //   cameras = await availableCameras();

// // //   runApp(MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       theme: ThemeData(
// // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// // //         useMaterial3: true,
// // //       ),
// // //       home: const MyHomePage(),
// // //     );
// // //   }
// // // }

// // // class MyHomePage extends StatefulWidget {
// // //   const MyHomePage({super.key});

// // //   @override
// // //   State<MyHomePage> createState() => _MyHomePageState();
// // // }

// // // class _MyHomePageState extends State<MyHomePage> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       appBar: AppBar(
// // //           backgroundColor: Colors.white,
// // //           title: const Text(
// // //             'Face look',
// // //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // //           ),
// // //           centerTitle: true),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             SizedBox(
// // //               width: 20,
// // //             ),
// // //             GestureDetector(
// // //               onTap: () {
// // //                 Navigator.push(context,
// // //                     MaterialPageRoute(builder: (context) => RegisterFace()));
// // //               },
// // //               child: Container(
// // //                 height: 50,
// // //                 width: 200,
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFFADD8E6),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Center(
// // //                     child: Text(
// // //                   'register',
// // //                   style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 30,
// // //                       fontWeight: FontWeight.bold),
// // //                 )),
// // //               ),
// // //             ),
// // //             SizedBox(
// // //               width: 20,
// // //             ),
// // //             GestureDetector(
// // //               onTap: () {
// // //                 Navigator.push(
// // //                     context,
// // //                     MaterialPageRoute(
// // //                         builder: (context) => RealTimeFaceDetection()));
// // //               },
// // //               child: Container(
// // //                 height: 50,
// // //                 width: 200,
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFFADD8E6),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Center(
// // //                     child: Text(
// // //                   'REALTIME',
// // //                   style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 30,
// // //                       fontWeight: FontWeight.bold),
// // //                 )),
// // //               ),
// // //             ),
// // //             GestureDetector(
// // //               onTap: () async {
// // //                 // Define the path to the JSON file
// // //                 final tempDir = await getApplicationDocumentsDirectory();
// // //                 final String _embPath = tempDir.path + '/save.json';
// // //                 final jsonFile = File(_embPath);

// // //                 // Check if the file exists
// // //                 if (jsonFile.existsSync()) {
// // //                   // Read the file
// // //                   final data = json.decode(jsonFile.readAsStringSync());

// // //                   // Extract the keys (names) from the data
// // //                   final names = data.keys.toList();

// // //                   // Convert the list of names to a single string with each name on a new line
// // //                   final namesText = names.join('\n');

// // //                   // Show a dialog with the names
// // //                   showDialog(
// // //                     context: context,
// // //                     builder: (BuildContext context) {
// // //                       return AlertDialog(
// // //                         title: Text('Saved Names'),
// // //                         content: SingleChildScrollView(
// // //                           child: ListBody(
// // //                             children: <Widget>[
// // //                               Text(namesText),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                         actions: <Widget>[
// // //                           TextButton(
// // //                             child: Text('Close'),
// // //                             onPressed: () {
// // //                               Navigator.of(context).pop();
// // //                             },
// // //                           ),
// // //                         ],
// // //                       );
// // //                     },
// // //                   );
// // //                 } else {
// // //                   // Show a message if the file does not exist
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('No saved data found.')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Container(
// // //                 height: 50,
// // //                 width: 200,
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFFADD8E6),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Center(
// // //                   child: Text(
// // //                     'saved data',
// // //                     style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 30,
// // //                         fontWeight: FontWeight.bold),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             GestureDetector(
// // //               onTap: () async {
// // //                 // Ensure this function is marked as async
// // //                 final rowsDeleted =
// // //                     await _databaseHelper.deleteAllRows(); // Use await here
// // //                 print(
// // //                     'Deleted $rowsDeleted rows'); // This should now print the correct number of deleted rows
// // //               },
// // //               child: Container(
// // //                 height: 50,
// // //                 width: 200,
// // //                 decoration: BoxDecoration(
// // //                   color: Color(0xFFADD8E6),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Center(
// // //                     child: Text(
// // //                   'DELETE DATA',
// // //                   style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 30,
// // //                       fontWeight: FontWeight.bold),
// // //                 )),
// // //               ),
// // //             ),

// // //             // Inside your _MyHomePageState class, modify the GestureDetector for the 'Register' button
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Future<void> displayUserData() async {
// // //     Map<String, dynamic> userData = await readUserDataFromJson();

// // //     // Assuming you want to print the user data to the console
// // //     userData.forEach((key, value) {
// // //       print("User Name: $key");
// // //       print("Embedding: $value");
// // //     });
// // //   }

// // //   Future<Map<String, dynamic>> readUserDataFromJson() async {
// // //     final String dir = (await getApplicationDocumentsDirectory()).path;
// // //     final File file = File('$dir/savedFaces.json');

// // //     // Check if the file exists
// // //     if (!await file.exists()) {
// // //       print("The file does not exist.");
// // //       return {}; // Return an empty map if the file does not exist
// // //     }

// // //     // Read the file and parse the JSON content
// // //     String fileContent = await file.readAsString();
// // //     Map<String, dynamic> data = json.decode(fileContent);

// // //     return data;
// // //   }
// // // }
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:camera/camera.dart';
// // import 'package:face_detection/Database.dart';
// // import 'package:face_detection/realtime.dart';
// // import 'package:face_detection/register.dart';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';

// // late List<CameraDescription> cameras;
// // var _databaseHelper = DatabaseHelper();

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await _databaseHelper.init();
// //   print("DATABASE INITIALIZED");
// //   cameras = await availableCameras();
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const MyHomePage(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({Key? key}) : super(key: key);

// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         title: const Text(
// //           'Face look',
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => DatabaseView()),
// //               );
// //             },
// //             icon: Icon(Icons.settings),
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             SizedBox(width: 20),
// //             GestureDetector(
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => RegisterFace()),
// //                 );
// //               },
// //               child: Container(
// //                 height: 50,
// //                 width: 200,
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFFADD8E6),
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: Center(
// //                   child: Text(
// //                     'Register',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 30,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(width: 20),
// //             GestureDetector(
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                       builder: (context) => RealTimeFaceDetection()),
// //                 );
// //               },
// //               child: Container(
// //                 height: 50,
// //                 width: 200,
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFFADD8E6),
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: Center(
// //                   child: Text(
// //                     'Pay',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 30,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class DatabaseView extends StatefulWidget {
// //   const DatabaseView({Key? key}) : super(key: key);

// //   @override
// //   _DatabaseViewState createState() => _DatabaseViewState();
// // }

// // class _DatabaseViewState extends State<DatabaseView> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Database'),
// //         centerTitle: true,
// //       ),
// //       body: FutureBuilder<List<Map<String, dynamic>>>(
// //         future: _databaseHelper.queryAllRows(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (snapshot.hasData) {
// //             List<Map<String, dynamic>> rows = snapshot.data!;
// //             if (rows.isEmpty) {
// //               return Center(child: Text('No data available'));
// //             } else {
// //               return ListView.builder(
// //                 itemCount: rows.length,
// //                 itemBuilder: (context, index) {
// //                   Map<String, dynamic> row = rows[index];
// //                   return ListTile(
// //                     title: Text('Payee: ${row[DatabaseHelper.columnPayee]}'),
// //                     subtitle:
// //                         Text('UPI ID: ${row[DatabaseHelper.columnUpiId]}'),
// //                   );
// //                 },
// //               );
// //             }
// //           } else {
// //             return Center(child: Text('No data available'));
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'dart:convert';
// import 'package:camera/camera.dart';
// import 'package:face_detection/Database.dart';
// import 'package:face_detection/realtime.dart';
// import 'package:face_detection/register.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// late List<CameraDescription> cameras;
// var _databaseHelper = DatabaseHelper();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _databaseHelper.init();
//   print("DATABASE INITIALIZED");
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Face look',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DatabaseView()),
//               );
//             },
//             icon: Icon(Icons.settings),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(width: 20),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterFace()),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFADD8E6),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Register',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 20),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => RealTimeFaceDetection()),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFADD8E6),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Pay',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DatabaseView extends StatefulWidget {
//   const DatabaseView({Key? key}) : super(key: key);

//   @override
//   _DatabaseViewState createState() => _DatabaseViewState();
// }

// class _DatabaseViewState extends State<DatabaseView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Database'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _databaseHelper.queryAllRows(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             List<Map<String, dynamic>> rows = snapshot.data!;
//             if (rows.isEmpty) {
//               return Center(child: Text('No data available'));
//             } else {
//               return ListView.builder(
//                 itemCount: rows.length,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> row = rows[index];
//                   return ListTile(
//                     title: Text('Payee: ${row[DatabaseHelper.columnPayee]}'),
//                     subtitle:
//                         Text('UPI ID: ${row[DatabaseHelper.columnUpiId]}'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         // Add code to delete the row from the database
//                         _databaseHelper.deleteRow(row['id']);
//                         setState(() {
//                           // Reload the UI after deletion
//                         });
//                       },
//                     ),
//                   );
//                 },
//               );
//             }
//           } else {
//             return Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:face_detection/Database.dart';
import 'package:face_detection/realtime.dart';
import 'package:face_detection/register.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:face_detection/config/theme.dart';

late List<CameraDescription> cameras;
var _databaseHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _databaseHelper.init();
  print("DATABASE INITIALIZED");
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 3, 3),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 35, 35),
        title: const Text(
          'FacePay',
          style: TextStyle(
              color: Color.fromARGB(255, 245, 244, 244),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DatabaseView()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Adjusted to height
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildGestureDetector(
                label: 'Register',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterFace()),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Adjusted to height
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildGestureDetector(
                label: 'Pay',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RealTimeFaceDetection()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureDetector(
      {required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 7, 21, 25),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class DatabaseView extends StatefulWidget {
  const DatabaseView({Key? key}) : super(key: key);

  @override
  _DatabaseViewState createState() => _DatabaseViewState();
}

class _DatabaseViewState extends State<DatabaseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHelper.queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> rows = snapshot.data!;
            if (rows.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> row = rows[index];
                  return ListTile(
                    title: Text('Payee: ${row[DatabaseHelper.columnPayee]}'),
                    subtitle:
                        Text('UPI ID: ${row[DatabaseHelper.columnUpiId]}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Add code to delete the row from the database
                        _databaseHelper.deleteRow(row['id']);
                        setState(() {
                          // Reload the UI after deletion
                        });
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
