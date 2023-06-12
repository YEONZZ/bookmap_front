import 'package:flutter/material.dart';

class HelpTerms extends StatelessWidget {
  const HelpTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HelpTerms(),
    );
  }
}

class _HelpTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('서비스 이용 약관',
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