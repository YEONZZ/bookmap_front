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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("OO님의 서재"),
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
          Text("전체"),
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
