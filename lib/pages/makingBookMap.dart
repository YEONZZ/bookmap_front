import 'package:flutter/material.dart';
import '../design/color.dart';
import 'editingBookMap.dart';

class MakingBookMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          home: _MakingBookMap(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: appcolor,
      ),
    );
  }
}

class _MakingBookMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => makingBookMap();
}

class makingBookMap extends State<_MakingBookMap>{
  final TextEditingController _mapTitleEditingController = TextEditingController();
  final TextEditingController _mapStatusEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('북맵 생성 페이지',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
              child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    autofocus : true,
                    style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                    cursorColor: appcolor,
                    textInputAction: TextInputAction.next,
                    controller: _mapTitleEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: appcolor.shade900)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: appcolor.shade600)
                      ),
                      suffixIcon: GestureDetector(
                        child: const Icon(
                          Icons.cancel,
                          color: appcolor,
                          size: 20,
                        ),
                        onTap: () => _mapTitleEditingController.clear(),
                      ),
                      labelText: '북맵 이름',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: '북맵 이름',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                    cursorColor: appcolor,
                    textInputAction: TextInputAction.done,
                    controller: _mapStatusEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: appcolor.shade600)
                      ),
                      suffixIcon: GestureDetector(
                        child: const Icon(
                          Icons.cancel,
                          color: appcolor,
                          size: 20,
                        ),
                        onTap: () => _mapStatusEditingController.clear(),
                      ),
                      labelText: '북맵 소개글',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: '북맵 소개글',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                    ),
                  )
              ),
            ),
            Padding(
                padding: EdgeInsets.all(50),
                child: Center(
                    child: TextButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditingBookMap())
                      );
                    },
                      child: Text('저장',
                        style: TextStyle(color: Colors.white, fontSize: 13),),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(appcolor.shade600)),)
                )
            )
          ],
        ),
      ),
    );
  }

}