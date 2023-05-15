import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutter/material.dart';
import 'search.dart';
import 'profile.dart';
void main() {
  runApp(Library());
}

const MaterialColor appcolor = MaterialColor(
  _appcolor,
  <int, Color>{
    50: Color(0xFFD9E8DA),
    100: Color(0xFFB9D7BB),
    200: Color(0xFFA2C9A3),
    300: Color(0xFF93B696),
    400: Color(0xFF85A485),
    500: Color(_appcolor),
    600: Color(0xFF8DC08D),
    700: Color(0xFF7FAD7F),
    800: Color(0xFF4E544F),
    900: Color(0xFF323632),
  },);
const int _appcolor = 0xFFB9D7BB;


class Library extends StatelessWidget {
  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: appcolor
      ),
      initialRoute: '/',
      routes: {'/': (context) => FirstPage(),
               '/search': (context) => Search(),
              '/profile':(context) => Profile()
      },
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  final _authentication = firebaseauth.FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("${_authentication.currentUser?.displayName}님의 서재",
              style: const TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,)),
          actions: <Widget>[
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed('/profile');
            }, icon: Icon(Icons.person_rounded))
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "전체"),
              Tab(text: "읽은 책"),
              Tab(text: "읽고있는 책"),
              Tab(text: "읽고싶은 책"),
            ],
          ),
        ),
      body: TabBarView(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  //눌렀을 때 옵션
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width-20,
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: appcolor.shade50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Image.network(
                            'https://search.pstatic.net/common/?src=https%3A%2F%2Fshopping-phinf.pstatic.net%2Fmain_3245601%2F32456019705.20230425164119.jpg&type=w276',
                            width: 90,
                            height: 120,
                            fit: BoxFit.fill),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('천개의 파랑', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start),
                            Text('지은이: 천선란 ', textAlign: TextAlign.start, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100)),
                            Text('⭐⭐⭐⭐⭐', textAlign: TextAlign.start, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100)),
                            Text('시작일: 2023-04-29 완독일: 2023-05-01', textAlign: TextAlign.start, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Text("읽은 책"),
          Text("읽고 있는 책"),
          Text("읽고싶은"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/search');
        },
        child: Icon(Icons.search),
      ),
      )
    );
  }
}
