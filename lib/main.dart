import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'pages/home.dart';
import 'pages/library.dart';
import 'pages/bookmap.dart';
import 'pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions
        (apiKey: 'AIzaSyCgaycqfp5RTa83bskUumkhWzgzVu6PGWY',
          appId: '1:205578501902:android:0e919009bf38aa23c2615f',
          messagingSenderId: '205578501902',
          projectId: 'fentarim-c479e')
  );
  runApp(MyApp(token));
}

class MyApp extends StatelessWidget {
  const MyApp(token, {super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseauth.FirebaseAuth.instance.authStateChanges(),
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
  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Home(token), Library(token), BookMap(token), Profile(token)
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
