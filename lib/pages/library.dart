import 'dart:convert';
import 'package:bookmap/login.dart';
import 'package:bookmap/pages/search_detail_get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../api_key.dart';
import '../login.dart';
import 'search.dart';
import 'profile.dart';
import '../design/color.dart';

void main() {
  // 메인화면에서 대표 4권 선택시 출력됨
  runApp(Library(token));
}

class Library extends StatelessWidget {
  const Library(token, {super.key});

  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(brightness: Brightness.light, primarySwatch: appcolor),
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),
        '/search': (context) => Search(token),
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
  late Future<List<dynamic>> fetchData; // Declare the Future

  @override
  void initState() {
    super.initState();
    fetchData = _fetchData(); // Declare the Future
  }

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
            FutureBuilder<List<dynamic>>( //전체 탭
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List books = snapshot.data ?? [];
                  //print(books);
                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> book = books[index] as Map<String, dynamic>;
                      var img = book['image'];
                      var title = book['title'];
                      var author = book['author'];
                      var startDate = book['startDate'];
                      var endDate = book['endDate'];
                      var isbn = book['isbn'];
                      var grade = book['grade'];
                      var bookState = book['bookState'];
                      var readingPercentage = book['readingPercentage'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchDetailGetPage(homeIsbn: isbn,),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(left:10, right: 10, top: 10),
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
                                              fontWeight: FontWeight.w500)),
                                      Padding(padding: EdgeInsets.only(top: 15)),
                                      bookState == '읽은' && grade != null ?
                                      Container(
                                        child: Text(
                                          '⭐' * grade.toInt(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ) : Container(
                                       child: Text('저장상태: $bookState',
                                         style: TextStyle(
                                           color: Colors.black45,
                                           fontSize: 13,
                                           fontWeight: FontWeight.w400,
                                         ),),
                                      ),
                                      
                                      Padding(padding: EdgeInsets.only(top: 5)),
                                      Text(
                                          startDate != null ? '시작일: ${startDate}' : '',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400)),
                                      Padding(padding: EdgeInsets.only(top: 5)),
                                      Text(
                                          endDate != null ? '완독일: ${endDate}' : '',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400))
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
            FutureBuilder<List<dynamic>>(
              future: fetchData, // fetchData 변수를 사용하여 데이터 가져오기
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List books = snapshot.data ?? [];
                  // "읽은" 도서들만 추려내는 작업
                  List<Map<String, dynamic>> readBooks = [];
                  for (var book in books) {
                    var bookState = book['bookState'];
                    if (bookState == '읽은') {
                      readBooks.add(book);
                    }
                  }
                  return ListView.builder(
                    itemCount: readBooks.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> book = readBooks[index] as Map<String, dynamic>;
                      var img = book['image'];
                      var title = book['title'];
                      var author = book['author'];
                      var startDate = book['startDate'];
                      var endDate = book['endDate'];
                      var isbn = book['isbn'];
                      var grade = book['grade'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchDetailGetPage(homeIsbn: isbn),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left:10, right: 10, top: 10),
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
                                    fit: BoxFit.fitHeight,
                                  ),
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
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 5)),
                                      Text(
                                        author,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 15)),
                                      Text(
                                        '⭐' * grade.toInt(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 5)),
                                      Text(
                                        '시작일: $startDate, 완독일: $endDate',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.black54,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                  );

                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder<List<dynamic>>(
              future: fetchData, // fetchData 변수를 사용하여 데이터 가져오기
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List books = snapshot.data ?? [];
                  // "읽고 있는" 도서들만 추려내는 작업
                  List<Map<String, dynamic>> readBooks = [];
                  for (var book in books) {
                    var bookState = book['bookState'];
                    if (bookState == '읽는중인') {
                      readBooks.add(book);
                    }
                  }
                  return ListView.builder(
                    itemCount: readBooks.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> book = readBooks[index] as Map<String, dynamic>;
                      var img = book['image'];
                      var title = book['title'];
                      var author = book['author'];
                      var startDate = book['startDate'];
                      var isbn = book['isbn'];
                      var grade = book['grade'];
                      var readingPercentage = book['readingPercentage'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchDetailGetPage(homeIsbn: isbn),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left:10, right: 10, top: 10),
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
                                  fit: BoxFit.fitHeight,
                                ),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      author,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    LinearPercentIndicator(
                                      width: 230,
                                      lineHeight: 15.0,
                                      percent: 0.15,
                                      center: Text('$readingPercentage%'),
                                      barRadius: const Radius.circular(16),
                                      progressColor: appcolor.shade600,
                                      backgroundColor: Colors.white70,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      '시작일: $startDate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder<List<dynamic>>(
              future: fetchData, // fetchData 변수를 사용하여 데이터 가져오기
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List books = snapshot.data ?? [];
                  // "읽고싶은" 도서들만 추려내는 작업
                  List<Map<String, dynamic>> readBooks = [];
                  for (var book in books) {
                    var bookState = book['bookState'];
                    if (bookState == '읽고싶은') {
                      readBooks.add(book);
                    }
                  }
                  return ListView.builder(
                    itemCount: readBooks.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> book = readBooks[index] as Map<String, dynamic>;
                      var img = book['image'];
                      var title = book['title'];
                      var author = book['author'];
                      var isbn = book['isbn'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchDetailGetPage(homeIsbn: isbn),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left:10, right: 10, top: 10),
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
                                  fit: BoxFit.fitHeight,
                                ),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      author,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),

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

  final response = await client.get(Uri.parse(tmdbApiKey + '/bookshelf/allbooks'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  var data = jsonDecode(utf8.decode(response.bodyBytes));

  List<dynamic> listData = data;
  List<Map<String, dynamic>> mappedData = listData.map((item) => item as Map<String, dynamic>).toList();

  return mappedData;
}

