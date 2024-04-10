// // import 'package:flutter/material.dart';
// // import 'package:face_detection/Database.dart'; // Import your DatabaseHelper class

// // class NextScreen extends StatelessWidget {
// //   final String name;

// //   NextScreen({required this.name});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Face Details'),
// //       ),
// //       body: FutureBuilder<List<Map<String, dynamic>>>(
// //         future: DatabaseHelper().queryRowByPayee(name),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (snapshot.hasData) {
// //             List<Map<String, dynamic>> rows = snapshot.data!;
// //             if (rows.isEmpty) {
// //               return Center(child: Text('No details found for $name'));
// //             } else {
// //               // Assuming you want to display the first row's details
// //               Map<String, dynamic> row = rows.first;
// //               return ListView(
// //                 children: <Widget>[
// //                   ListTile(
// //                     title: Text('Name: ${row[DatabaseHelper.columnPayee]}'),
// //                   ),
// //                   ListTile(
// //                     title: Text(
// //                         'Mobile Number: ${row[DatabaseHelper.columnMobileNum]}'),
// //                   ),
// //                   ListTile(
// //                     title:
// //                         Text('Email ID: ${row[DatabaseHelper.columnEmailId]}'),
// //                   ),
// //                   ListTile(
// //                     title: Text('UPI ID: ${row[DatabaseHelper.columnUpiId]}'),
// //                   ),
// //                 ],
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
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:face_detection/Database.dart'; // Import your DatabaseHelper class

// class NextScreen extends StatefulWidget {
//   final String name;

//   NextScreen({required this.name});

//   @override
//   _NextScreenState createState() => _NextScreenState();
// }

// class _NextScreenState extends State<NextScreen> {
//   late String amount;
//   late String note;
//   bool paymentSuccess = false;
//   late Map<String, dynamic> paymentDetails;

//   @override
//   void initState() {
//     super.initState();
//     amount = '';
//     note = '';
//     fetchPaymentDetails();
//   }

//   void fetchPaymentDetails() async {
//     List<Map<String, dynamic>> rows =
//         await DatabaseHelper().queryRowByPayee(widget.name);
//     if (rows.isNotEmpty) {
//       setState(() {
//         paymentDetails = rows.first;
//       });
//     }
//   }

//   void initiateUpiPayment() async {
//     String uri =
//         'upi://pay?pa=${paymentDetails[DatabaseHelper.columnUpiId]}&pn=${paymentDetails[DatabaseHelper.columnPayee]}&tr=$note&am=$amount&cu=INR';
//     try {
//       await launchUrl(Uri.parse(uri));
//       await Future.delayed(Duration(seconds: 10));
//       setState(() {
//         paymentSuccess = true;
//       });
//     } catch (e) {
//       print('Could not launch UPI app: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Make Payment'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: paymentSuccess
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green, size: 60),
//                   SizedBox(height: 20),
//                   Text(
//                     'Payment Successful',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),
//                   Text('To: ${paymentDetails[DatabaseHelper.columnPayee]}'),
//                   Text(
//                       'Banking id: ${paymentDetails[DatabaseHelper.columnUpiId]}'),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         paymentSuccess = false;
//                       });
//                     },
//                     child: Text('Pay Again'),
//                   ),
//                 ],
//               )
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(Icons.payment, color: Colors.blue, size: 60),
//                   SizedBox(height: 20),
//                   Text(
//                       'Paying to ${paymentDetails[DatabaseHelper.columnPayee]}'),
//                   Text(
//                       'Banking id: ${paymentDetails[DatabaseHelper.columnUpiId]}'),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Text(
//                         '₹',
//                         style: TextStyle(fontSize: 34),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           onChanged: (value) {
//                             setState(() {
//                               amount = value;
//                             });
//                           },
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             hintText: 'Enter Amount',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     onChanged: (value) {
//                       setState(() {
//                         note = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Enter Note',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: initiateUpiPayment,
//                     child: Text('Pay Now'),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:face_detection/Database.dart'; // Import your DatabaseHelper class

class NextScreen extends StatefulWidget {
  final String name;

  NextScreen({required this.name});

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  late String amount;
  late String note;
  bool paymentSuccess = false;
  Map<String, dynamic> paymentDetails = {}; // Initialize with an empty map

  @override
  void initState() {
    super.initState();
    amount = '';
    note = '';
    fetchPaymentDetails();
  }

  void fetchPaymentDetails() async {
    List<Map<String, dynamic>> rows =
        await DatabaseHelper().queryRowByPayee(widget.name);
    if (rows.isNotEmpty) {
      setState(() {
        paymentDetails = rows.first;
      });
    }
  }

  void initiateUpiPayment() async {
    // Check if paymentDetails is not null and contains the necessary keys before accessing them
    if (paymentDetails.isNotEmpty &&
        paymentDetails.containsKey(DatabaseHelper.columnUpiId) &&
        paymentDetails.containsKey(DatabaseHelper.columnPayee)) {
      String uri =
          'upi://pay?pa=${paymentDetails[DatabaseHelper.columnUpiId]}&pn=${paymentDetails[DatabaseHelper.columnPayee]}&tr=$note&am=$amount&cu=INR';
      try {
        await launchUrl(Uri.parse(uri));
        await Future.delayed(Duration(seconds: 10));
        setState(() {
          paymentSuccess = true;
        });
      } catch (e) {
        print('Could not launch UPI app: $e');
      }
    } else {
      print('Payment details not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: paymentSuccess
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 20),
                  Text(
                    'Payment Successful',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text('To: ${paymentDetails[DatabaseHelper.columnPayee]}'),
                  Text(
                      'Banking id: ${paymentDetails[DatabaseHelper.columnUpiId]}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        paymentSuccess = false;
                      });
                    },
                    child: Text('Pay Again'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.payment, color: Colors.blue, size: 60),
                  SizedBox(height: 20),
                  Text(
                      'Paying to ${paymentDetails.isNotEmpty ? paymentDetails[DatabaseHelper.columnPayee] : 'Loading...'}'),
                  Text(
                      'Banking id: ${paymentDetails.isNotEmpty ? paymentDetails[DatabaseHelper.columnUpiId] : 'Loading...'}'),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        '₹',
                        style: TextStyle(fontSize: 34),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              amount = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter Amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        note = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Note',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: initiateUpiPayment,
                    child: Text('Pay Now'),
                  ),
                ],
              ),
      ),
    );
  }
}
