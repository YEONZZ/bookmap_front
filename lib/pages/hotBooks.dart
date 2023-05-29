import 'package:flutter/material.dart';

class HotBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HotBooks(),
    );
  }

}

class _HotBooks extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('TOP 10',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
    );
  }

}