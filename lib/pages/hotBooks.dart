import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_key.dart';
import 'dart:convert';
import '../design/color.dart';

class HotBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HotBooks(),
    );
  }

}

class _HotBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'TOP 10',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List books = snapshot.data ?? [];
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> book = books[index] as Map<String, dynamic>;
                //print(books); //정보 찍어보기
                var img = book['image'];
                var title = book['title'];
                var author = book['author'];
                return GestureDetector(
                  onTap: () {
                    //눌렀을 때 옵션
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: appcolor.shade50,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.network(
                                img,
                                width: 90,
                                height: 120,
                                fit: BoxFit.fitHeight),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Text(
                                    author,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w100)),
                                Padding(padding: EdgeInsets.only(top: 15)),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                );
              },
            );
          }  else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();}
        },
      ),
    ), onWillPop: () async {
      Navigator.pop(context);
      return false; // true를 반환하면 기본 뒤로 가기 동작 수행, false를 반환하면 뒤로 가기 동작 무시
    });

  }
}

Future<List<Map<String, dynamic>>> _fetchData() async {
  http.Client client = http.Client();

  final response = await client.get(Uri.parse(tmdbApiKey + '/mostbooks'));
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  //print(data);
  List<dynamic> listData = data;
  List<Map<String, dynamic>> mappedData = listData.map((item) => item as Map<String, dynamic>).toList();

  return mappedData;
}