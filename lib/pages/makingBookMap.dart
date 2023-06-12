import 'dart:convert';

import 'package:bookmap/pages/bookmap_example.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../api_key.dart';
import '../design/color.dart';
import '../login.dart';
import 'editingBookMap.dart';

String title = '';
String status = '';

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
                            child: TextButton(onPressed: () async {
                              title = _mapTitleEditingController.text;
                              status = _mapStatusEditingController.text;
                              dynamic mapId =  await _sendData();
                              print('맵아이디: $mapId');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditingBookMap(mapId)));

                              // FutureBuilder<String>(
                              // future: _sendData(),
                              // builder: (context, AsyncSnapshot<String> snapshot) {
                              //   dynamic mapId = _sendData();
                              //
                              //   if(snapshot.hasData){
                              //     print('확인!!!!!!!!!!!$mapId');
                              //     // Navigator.push(
                              //     // context,
                              //     // MaterialPageRoute(builder: (context) => EditingBookMap(mapId)));
                              //     return Text('맵아이디: $mapId');
                              //   }
                              //   else{
                              //     print('오류!!!!!!!!!!!$mapId');
                              //     return Text('오류');
                              //   }
                              // }
                              // );
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

Future<String> _sendData() async {
  //final authentication = firebaseauth.FirebaseAuth.instance;
  //const serverClientId = '1046810346715-4vq5b2ilab5hbilok0lsbfqug4eemaab.apps.googleusercontent.com';
  //const callbackUrlScheme = 'com.googleusercontent.apps.1046810346715-4vq5b2ilab5hbilok0lsbfqug4eemaab';
  final httpClient = IOClient();

  final response = await httpClient.post(
    Uri.parse('$bookmapKey/bookmap/save'), //수정 필요
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'Bearer $token',
     },
    body: jsonEncode({
      "bookMapTitle": title,
      "bookMapContent": status,
    }),
  );

  // 요청 완료 후 httpClient를 닫습니다.
  httpClient.close();
  if (response.statusCode == 200) {
    // 성공 적인 응답인 경우
    if (kDebugMode) {
      print('서버 응답 성공');
      print('헤더: ${response.headers}');
      print('반응: ${response.body}');
    }
    return response.body;
  } else { // 오류 응답인 경우
    if (kDebugMode) {
      print('서버 응답 오류');
      print('상태 코드: ${response.statusCode}');
      print('반응: ${response.body}'); //토큰, 추후 저장 필요
    }
    // 오류 처리를 수행하거나 적절한 메시지를 표시하는 등의 작업을 수행할 수 있습니다.
    throw Exception('서버 응답 오류 발생');
  }
}