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
          children: [
            Padding(padding: EdgeInsets.all(1)),
            Container(
              padding: EdgeInsets.all(20),
              width: double.maxFinite,
              height: 70,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("서비스 이용약관 개정 안내", style: TextStyle(color: Colors.black, fontSize: 13),),
                Text("2023-05-23 13:13", style: TextStyle(color: Colors.black26, fontSize: 11),)],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: double.maxFinite,
              height: 70,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("북맵 서비스 이용 안내", style: TextStyle(color: Colors.black, fontSize: 13),),
                  Text("2023-04-19 18:10", style: TextStyle(color: Colors.black26, fontSize: 11),)],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: double.maxFinite,
              height: 70,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("서비스 이용약관 개정 안내", style: TextStyle(color: Colors.black, fontSize: 13),),
                  Text("2023-03-21 07:19", style: TextStyle(color: Colors.black26, fontSize: 11),)],
              ),
            )
          ],
        ),
      ),
    );
  }

}