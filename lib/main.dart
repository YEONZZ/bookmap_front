import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'pages/home.dart';
import 'pages/library.dart';
import 'pages/bookmap.dart';
import 'pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //사용자의 로그인 및 로그아웃을 기억하고, 그에 따른 변화를 다루는 위젯
      stream: firebaseauth.FirebaseAuth.instance.authStateChanges(),
      //snapshot: stream의 결과물, 스트림빌더에게 사용하도록 지정해주는 데이터
      builder: (context, snapshot){
        if(!snapshot.hasData){
          //로그인을 하지 않은 경우
          return Login();
        }
        else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: _title,
            home: MyStatefulWidget(),
          );
        }
      },
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Home(), Library(), BookMap(), Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library_sharp, color: Colors.white),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white),
            label: 'BookMap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, color: Colors.white),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF8BBD95),
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
