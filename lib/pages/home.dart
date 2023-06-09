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
      'https://shopping-phinf.pstatic.net/main_3839015/38390159619.20230502161943.jpg?type=w300', fit: BoxFit.fitWidth),
  Image.network(
      'https://shopping-phinf.pstatic.net/main_3250610/32506106882.20221229070913.jpg?type=w300', fit: BoxFit.fitWidth),
  Image.network(
      'https://shopping-phinf.pstatic.net/main_3250515/32505158692.20220527055317.jpg?type=w300', fit: BoxFit.fitWidth),
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
                      builder: (context) => Search(),
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
                            List<Map<String, dynamic>> imageUrl = snapshot.data!;
                            return Row(
                              children: imageUrl.map((data) {
                                dynamic img = data;
                                List<dynamic> homeDatas = img['bookImageDto'];
                                int num = homeDatas.length;
                                return Row(
                                  children: homeDatas.sublist(0, num).map((homeData) {
                                    return Container(
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SearchDetailGetPage(homeData: homeData),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          homeData['image'],
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
                child: CarouselSlider(
                  options: CarouselOptions(height: 150.0, autoPlay: true),
                  items: imageList.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: image,
                          ),
                        );
                      },
                    );
                  }).toList(),
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
                padding: const EdgeInsets.only(left: 12, right: 12, top:0),
                child: Container(
                  decoration: BoxDecoration(
                    color: appcolor.shade50,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.39,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                                'https://shopping-phinf.pstatic.net/main_3731353/37313533623.20230516164633.jpg?type=w300',
                                width: 90,
                                height: 120,
                                fit: BoxFit.fitHeight),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text("세이노의 가르침", style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
                                Text("세이노", style: TextStyle(color: Colors.black38, fontSize: 12, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal),),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                                'https://shopping-phinf.pstatic.net/main_3867415/38674154646.20230502162404.jpg?type=w300',
                                width: 90,
                                height: 120,
                                fit: BoxFit.fitHeight),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text("사장학개론", style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
                                Text("김승호", style: TextStyle(color: Colors.black38, fontSize: 12, fontStyle: FontStyle.normal, fontWeight: FontWeight.normal),),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                    ],
                  ),
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
  //
  // if (kDebugMode) {
  //   print('확인!!!!:$token');
  // }
  var usertest = jsonDecode(utf8.decode(userResponse.bodyBytes));
  // final response = await client.get(Uri.parse(tmdbApiKey + '/main/4'));
  // var data = jsonDecode(utf8.decode(response.bodyBytes));

  List<Map<String, dynamic>> listData = [usertest]; // data를 리스트로 감싸기

  return listData;
}

