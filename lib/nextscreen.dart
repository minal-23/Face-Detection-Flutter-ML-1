import 'package:flutter/material.dart';
import 'package:face_detection/Database.dart'; // Import your DatabaseHelper class

class NextScreen extends StatelessWidget {
  final String name;

  NextScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Details'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().queryRowByPayee(name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> rows = snapshot.data!;
            if (rows.isEmpty) {
              return Center(child: Text('No details found for $name'));
            } else {
              // Assuming you want to display the first row's details
              Map<String, dynamic> row = rows.first;
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Name: ${row[DatabaseHelper.columnPayee]}'),
                  ),
                  ListTile(
                    title: Text(
                        'Mobile Number: ${row[DatabaseHelper.columnMobileNum]}'),
                  ),
                  ListTile(
                    title:
                        Text('Email ID: ${row[DatabaseHelper.columnEmailId]}'),
                  ),
                  ListTile(
                    title: Text('UPI ID: ${row[DatabaseHelper.columnUpiId]}'),
                  ),
                ],
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
