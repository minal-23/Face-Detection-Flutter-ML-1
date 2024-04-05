import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  // Add a named parameter for the key
  const NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('You tapped on a face!'),
      ),
    );
  }
}
