import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_key.dart';
import '../login.dart';
import 'search.dart';
import 'profile.dart';
import '../design/color.dart';

void main() {
  runApp(Library(token));
}

class Library extends StatelessWidget {
  static const String _title = 'Widget Example';
  const Library(token, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(brightness: Brightness.light, primarySwatch: appcolor),
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),
        '/search': (context) => Search(),
        '/profile': (context) => Profile(token)
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              )),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile');
                },
                icon: Icon(Icons.person_rounded))
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
            FutureBuilder<List<dynamic>>(
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
                      var startDate = book['startDate'];
                      var endDate = book['endDate'];
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
                                    Text('⭐⭐⭐⭐⭐',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w100)),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Text(
                                        '시작일: ${startDate}, 완독일: ${endDate}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w100))
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
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _fetchData() async {
  http.Client client = http.Client();

  final response = await client.get(Uri.parse(tmdbApiKey + '/bookshelf/allbooks/4'));
  var data = jsonDecode(utf8.decode(response.bodyBytes));

  List<dynamic> listData = data;
  List<Map<String, dynamic>> mappedData = listData.map((item) => item as Map<String, dynamic>).toList();

  return mappedData;
}

