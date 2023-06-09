import 'dart:convert';

import 'package:bookmap/api_key.dart';
import 'package:bookmap/pages/scrapDetail.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../login.dart';
import 'makingBookMap.dart';
import 'myBookmapDetail.dart';
import 'search.dart';
import 'package:bookmap/design/color.dart';

void main() {
  runApp(BookMap(token));
}

class BookMap extends StatelessWidget {
  static const String _title = 'BookMap Page';
  const BookMap(token, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: appcolor,
      ),
      initialRoute: '/',
      routes: {'/': (context) => BookMapList(),
        '/search': (context) => Search(),
        '/new':(context) => MakingBookMap()
      });}}

class BookMapList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookMapList();
}

class _BookMapList extends State<BookMapList> {
  final _authentication = firebaseauth.FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${_authentication.currentUser?.displayName}님의 북맵',
            style: const TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,)),
            actions: <Widget>[
              IconButton(onPressed: (){
                Navigator.of(context).pushNamed('/new');
                }, icon: Icon(Icons.add))],
            bottom: TabBar(
              tabs: [
                Tab(text: "마이 북맵"),
                Tab(text: "스크랩"),
              ],
            ),
          ),
        body: TabBarView(
          children: [
            MyBookmap(),
            Scrap()
            ],
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/search');},
            child: Icon(Icons.search),
        )
        )
    );
  }
}


class MyBookmap extends StatelessWidget{
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyMapData(),
    );}}

class MyMapData extends StatefulWidget {
  const MyMapData({super.key});

  @override
  State<StatefulWidget> createState() => _MyMapData();
}

class _MyMapData extends State<MyMapData>{
  ScrollController? _scrollController;
  List? data;
  int page = 1;

  @override
  void initState(){
    super.initState();
    data = List.empty(growable: true);
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if(_scrollController!.offset >=
      _scrollController!.position.maxScrollExtent &&
      !_scrollController!.position.outOfRange){
        if (kDebugMode) {
          print('end');
        }
        page ++;
        //getJSONData(); 과 같이 데이터를 불러오는 것
    }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<dynamic>>(
              future: _getbookmap(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  List myBookmaps = snapshot.data!;
                  //print(myBookmaps.length);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: myBookmaps[0].length,
                    itemBuilder: (context, index){
                      //print(index);
                      var myBookmap = myBookmaps[0][index];
                      var mapId = myBookmap['bookMapId'];
                      var title = myBookmap['bookMapTitle'];
                      if(title == null){
                        title = '';
                      }
                      //print("확인!!!!!!!!! $title");
                      var content = myBookmap['bookMapContent'];
                      if(content == null){
                        content = '';
                      }
                      var bookmapimg = myBookmap['bookMapImage'];
                      if (bookmapimg == null){
                        bookmapimg = 'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.ssfshop.com%2Fcmd%2FLB_500x660%2Fsrc%2Fhttp%3A%2Fimg.ssfshop.com%2Fgoods%2FHMBR%2F19%2F04%2F08%2FGM0019040873391_7_ORGINL.jpg&type=sc960_832';
                      }
                      var keyword = myBookmap['hashTag'];
                      var share = myBookmap['share'];
                      return GestureDetector(
                        onTap:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => myMapDetail(myBookmap),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appcolor.shade50,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              children: <Widget>[
                                Image.network(bookmapimg,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.fitWidth),
                                Padding(padding: EdgeInsets.only(right: 10)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                        textAlign: TextAlign.start),
                                    const Text(''),
                                    Text(content, textAlign: TextAlign.start, style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.w100))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                else if (snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                }
                else{
                  return CircularProgressIndicator();
                }
              },
            )
        ));
  }
}

class Scrap extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScrapList(),
    );
  }
}

class ScrapList extends StatelessWidget{
  ScrapList({Key? key}) : super(key: key);
  Widget build(BuildContext context){
    return  Container(
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
              child: FutureBuilder<List<dynamic>>(
                future: _getScrap(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    List myBookmaps = snapshot.data!;
                    //print(myBookmaps.length);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: myBookmaps[0].length,
                      itemBuilder: (context, index){
                        var myBookmap = myBookmaps[0][index];
                        var mapId = myBookmap['bookMapId'];
                        var title = myBookmap['bookMapTitle'];
                        //print("확인!!!!!!!!! $title");
                        var content = myBookmap['bookMapContent'];
                        var bookmapimg = myBookmap['bookMapImage'];
                        if (bookmapimg == null){
                          bookmapimg = 'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.ssfshop.com%2Fcmd%2FLB_500x660%2Fsrc%2Fhttp%3A%2Fimg.ssfshop.com%2Fgoods%2FHMBR%2F19%2F04%2F08%2FGM0019040873391_7_ORGINL.jpg&type=sc960_832';
                        }
                        var keyword = myBookmap['hashTag'];
                        var share = myBookmap['share'];
                        return GestureDetector(
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScrapDetail(myBookmap),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: appcolor.shade50,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Image.network(bookmapimg,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fitWidth),
                                  Padding(padding: EdgeInsets.only(right: 10)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                          textAlign: TextAlign.start),
                                      const Text(''),
                                      Text(content, textAlign: TextAlign.start, style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.w100))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else if (snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },
              )
          ),
    );
  }
}

Future<List<dynamic>> _getbookmap() async {
  final httpClient = IOClient();
  final bookmapResponse = await httpClient.get(
      Uri.parse('$bookmapKey/bookmap/1'),
      //headers: <String, String>{
      //  'Authorization': 'Bearer $token'
      //}
      );

  var bookmapTest = jsonDecode(utf8.decode(bookmapResponse.bodyBytes));

  if (kDebugMode) {
    print(bookmapTest);
  }

  List<dynamic> listData = [bookmapTest]; // data를 리스트로 감싸기

  return listData;
}

Future<List<dynamic>> _getScrap() async {

  final httpClient = IOClient();
  final bookmapResponse = await httpClient.get(
    Uri.parse('$bookmapKey/bookmap/scrap/1'),
    //headers: <String, String>{
    //  'Authorization': 'Bearer $token'
    //}
  );

  var bookmapTest = jsonDecode(utf8.decode(bookmapResponse.bodyBytes));

  if (kDebugMode) {
    print(bookmapTest);
  }

  List<dynamic> listData = [bookmapTest]; // data를 리스트로 감싸기

  return listData;
}