import 'dart:convert';

import 'package:bookmap/pages/bookmap.dart';
import 'package:bookmap/pages/hotBooks.dart';
import 'package:bookmap/pages/search_detail_get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bookmap/pages/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../design/color.dart';
import 'package:bookmap/api_key.dart';
import '../login.dart';
import 'library.dart';

final imageList = [
  Image.network(
      'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.ssfshop.com%2Fcmd%2FLB_500x660%2Fsrc%2Fhttp%3A%2Fimg.ssfshop.com%2Fgoods%2FHMBR%2F19%2F04%2F08%2FGM0019040873391_7_ORGINL.jpg&type=sc960_832', fit: BoxFit.fitWidth),
  Image.network(
      'https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038%3Ftimestamp%3D20230128141840', fit: BoxFit.fitWidth),
];

void main() {
  http.Client client = http.Client();
  http.Client().close();
  runApp(Home(token));
}

class Home extends StatelessWidget {
  static const String _title = 'Home Page';
  const Home(token, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: appcolor,
      ),
      home: HomeStatelessWidget(),
    );
  }
}

class HomeStatelessWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Bookmap',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(token),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: TextField(
                        enabled: false,
                        cursorColor: appcolor.shade700,
                        keyboardType: TextInputType.text,
                        onChanged: (text){
                          //_streamSearch.add(text);
                        },
                        decoration: InputDecoration(
                          hintText: '책이름/저자/ISBN',
                          border: InputBorder.none,
                          icon: Padding(
                              padding: EdgeInsets.only(left: 13),
                              child: Icon(Icons.search, color: appcolor.shade700,)),
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Text('서재',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),)
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Library(token))
                          );
                        },
                        child: Text('더보기',
                            style: TextStyle(fontSize: 14, color: Colors.black38, decoration: TextDecoration.underline)
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: appcolor.shade50,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            //print('토큰: $token');
                            List<Map<String, dynamic>> dataList = snapshot.data!;
                            return Row(
                              children: dataList.map((data) {
                                dynamic getData = data;
                                List<dynamic> getHomeDatas = getData['bookImageDto'];
                                int num = getHomeDatas.length;
                                return Row(
                                  children: getHomeDatas.sublist(0, num).map((getHomeData) {
                                    return Container(
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      child: GestureDetector(
                                        onTap: () async{
                                          String homeIsbn = getHomeData['isbn'];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SearchDetailGetPage(homeIsbn: homeIsbn),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          getHomeData['image'],
                                          width: 90,
                                          height: 120,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                ),
              ),
              //북맵
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Text('북맵',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),)
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookMap(token))
                          );
                        },
                        child: Text('더보기',
                            style: TextStyle(fontSize: 14, color: Colors.black38, decoration: TextDecoration.underline)
                        )),
                  ],
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchData(), // Replace _fetchData with your own function to fetch the JSON data asynchronously
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> jsonData = snapshot.data!;
                  print(jsonData);
                  List<String> imageList = [];

                  for (var data in jsonData) {
                    dynamic getData = data;
                    List<dynamic> getHomeDatas = getData['bookMapResponseDtos'];
                    int num = getHomeDatas.length;
                    for (var getHomeData in getHomeDatas.sublist(0, num)) {
                      print(getHomeDatas);
                      if (getHomeData['bookMapImage'] != null) {
                        imageList.add(getHomeData['bookMapImage'] as String);
                      }else{
                        imageList.add('https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.ssfshop.com%2Fcmd%2FLB_500x660%2Fsrc%2Fhttp%3A%2Fimg.ssfshop.com%2Fgoods%2FHMBR%2F19%2F04%2F08%2FGM0019040873391_7_ORGINL.jpg&type=sc960_832');
                      }
                    }
                  }
                  print(imageList);
                  return CarouselSlider(
                    options: CarouselOptions(height: 150.0, autoPlay: true),
                    items: imageList.map((imageList) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(imageList, fit: BoxFit.fitWidth),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                }
              },
            ),
          ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 24),
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Text('다른 사용자들이 많이 읽은 도서',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),)
                    ),
                    TextButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HotBooks())
                      );
                    },
                      style: ButtonStyle(),
                      child: Text('더보기',
                          style: TextStyle(fontSize: 14, color: Colors.black38, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  padding: EdgeInsets.only(top:4, bottom: 5),
                  decoration: BoxDecoration(
                    color: appcolor.shade50,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Map<String, dynamic>> dataList = snapshot.data!;
                          return Column(
                            children: dataList.map((data) {
                              dynamic getData = data;
                              List<dynamic> getHomeDatas = getData['bookTopResponseDtos'];
                              int num  = getHomeDatas.length;
                              return Column(
                                children: getHomeDatas.sublist(0, num).map((getHomeData) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10,bottom:  5),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Image.network(
                                                getHomeData['image'],
                                                width: 90,
                                                height: 120,
                                                fit: BoxFit.fitHeight),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    getHomeData['title'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.start),
                                                Padding(padding: EdgeInsets.only(top: 5)),
                                                Text(
                                                    getHomeData['author'],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w100)),
                                                Padding(padding: EdgeInsets.only(top: 15)),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
            ],
          ),
        ),
      ),
    );
  }

}

Future<List<Map<String, dynamic>>> _fetchData() async {
  final httpClient = IOClient();
  final userResponse = await httpClient.get(
      Uri.parse('$logApiKey/main'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  var usertest = jsonDecode(utf8.decode(userResponse.bodyBytes));
  List<Map<String, dynamic>> listData = [usertest]; // data를 리스트로 감싸기
  return listData;
}