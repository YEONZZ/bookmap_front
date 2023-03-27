import 'package:flutter/material.dart';

void main() {
  runApp(MyProfile());
}

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: Padding(
          padding: EdgeInsets.all(80),
          child: Text("data"),
        ),
      ),
    );
  }
}
