import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../api_key.dart';
import 'dart:convert';
import '../design/color.dart';
import '../login.dart';

class MemoGet extends StatelessWidget {
  const MemoGet(token, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _MemoGet(),
    );
  }
}

class _MemoGet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '메모 모아보기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> memos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> memo = memos[index];
                var content = memo['content'];
                var title = memo['title'];
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row( // Add Row
                    children: <Widget>[
                      Expanded( // Add Expanded
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Card(
                              color: appcolor.shade100,
                              margin: EdgeInsets.only(top: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: ListTile(
                                  title: SingleChildScrollView(
                                    child: Text(
                                      "$content",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  subtitle: SingleChildScrollView(
                                    child: Text(
                                      "$title",
                                      style: TextStyle(fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  mouseCursor: SystemMouseCursors.click,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    )
    , onWillPop: () async {
      Navigator.pop(context);
      return false; // true를 반환하면 기본 뒤로 가기 동작 수행, false를 반환하면 뒤로 가기 동작 무시
    });

  }
}

Future<List<Map<String, dynamic>>> _fetchData() async {
  http.Client client = http.Client();

  final response =
  await client.get(Uri.parse(tmdbApiKey + '/bookmemo/all'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  //print(data);
  List<dynamic> listData = data;
  List<Map<String, dynamic>> mappedData =
  listData.map((item) => item as Map<String, dynamic>).toList();

  return mappedData;
}

