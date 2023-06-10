import 'package:flutter/material.dart';

class HelpNotice extends StatelessWidget {
  HelpNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _HelpNotice(),
    );
  }
}

class _HelpNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('공지사항',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        ),
      ),
    );
  }

}