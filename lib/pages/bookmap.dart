import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutter/material.dart';
import 'search.dart';
import 'profile.dart';
import 'package:bookmap/design/color.dart';

void main() {
  runApp(BookMap());
}

class BookMap extends StatelessWidget {
  static const String _title = 'BookMap Page';

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
        '/profile':(context) => Profile()
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
                Navigator.of(context).pushNamed('/profile');
                }, icon: Icon(Icons.person_rounded))],
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
  State<StatefulWidget> createState() => _MyMapData();
}

class _MyMapData extends State<MyMapData>{
  String result = '';
  //TextEditingController? _editingController;
  ScrollController? _scrollController;
  List? data;
  int page = 1;

  void initState(){
    super.initState();
    data = new List.empty(growable: true);
    //_editingController = new TextEditingController();
    _scrollController = new ScrollController();
    _scrollController!.addListener(() {
      if(_scrollController!.offset >=
      _scrollController!.position.maxScrollExtent &&
      !_scrollController!.position.outOfRange){
        print('end');
        page ++;
        //getJSONData(); 과 같이 데이터를 불러오는 것
    }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: data!.length == 0
              ? Text('아직 저장된 북맵이 없습니다.')
              : ListView.builder(
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){},
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Image.network(data![index]['thumbnail'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain),
                      Column(
                        children: <Widget>[
                          Text('북맵 제목', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('북맵 소개글', style: TextStyle(fontSize: 11))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ),
      )
    );
  }

}

class Scrap extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SampleList(),
    );
  }
}

class SampleList extends StatelessWidget{
  SampleList({Key? key}) : super(key: key);
  Widget build(BuildContext context){
    return  Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      Text("클릭");
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: appcolor.shade50,
                      child: Row(
                        children: <Widget>[
                          Image.network('https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA2MDNfMTE3%2FMDAxNjU0MjEzOTU0MjM5.ZpVsQpWT6GyTDEhRTrFvFPn94_ehzw_nIyhuIkgRFIgg.kgBLPcRZFwZPIrpU_SxZd7udlJUq7DifwNK1WHdFf5Eg.JPEG.javida%2F92F90D0C-26EF-49B2-BA3D-87F4F53716F7.jpeg&type=sc960_832',
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('여행가고 싶은 곳들', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start),
                              Text(''),
                              Text('가고 싶은 여행지에 대한 책들을 담은 북맵\n이탈리아, 아프리카, 스위스 관련 책', textAlign: TextAlign.start, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w100))
                            ],
                          )
                        ],
                      ),
                    ),
                    ),
                  Padding(padding: EdgeInsets.only(top: 10),

                  ),
                  InkWell(
                    onTap: (){
                      Text("클릭");
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: appcolor.shade50,
                      child: Row(
                        children: <Widget>[
                          Image.network('https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MDFfNDkg%2FMDAxNjU5MzI3NDEzOTc5.Pq9p6L6WOE8sPiulrDGRhYAzyX7rXSFehaWNgSnIpgog.oXYs2_jkhSTSx5BIXA3Bw_TQSV65pUzQ9t7VwJKwRwUg.PNG.darks754%2F20220720_130458.png&type=sc960_832',
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('CS 공부', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start),
                              Text(''),
                              Text('CS 관련 도서\n이산수학, 선형대수, 알고리즘, 인공지능', textAlign: TextAlign.start, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w100))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}