import 'package:bookmap/pages/profile.dart';
import 'package:bookmap/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:bookmap/design/color.dart';

class SearchDetailPage extends StatelessWidget {
  final dynamic data;

  const SearchDetailPage({Key? key, required this.data})
      : super(key: key); //Search()값 전달받음
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.light, primarySwatch: appcolor),
        debugShowCheckedModeBanner: false,
        home: SearchDetail(data: data),
    );
  }
}

class SearchDetail extends StatelessWidget {
  final dynamic data;

  const SearchDetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            data!['title'].toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: Icon(Icons.person_rounded))
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push (
              context,
              MaterialPageRoute(builder: (context) => Search()),
            );
            return false;
            },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  color: const Color(0x7FD8D8D8),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1 / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.network(
                          data!['thumbnail'],
                          fit: BoxFit.contain,
                          width: 200,
                          height: 200,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '저자 : ${data!['authors'].join(', ')}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container( //날짜 컨테이너
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: 30,
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 10,
                          child: Text('시작일로부터 OO일째 읽고 있어요!',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ),
                      Text('수정',
                          style: TextStyle(fontSize: 15, color: Colors.black)
                      ),
                    ],
                  ),
                ),
                Container( //그래프 컨테이너
                  height: 40,
                  child: Row(
                    children: [
                      Text('그래프 들어갈 공간')
                    ],
                  ),
                ),
                Container( //북맵 알려주는 컨테이너
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 30,
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 10,
                          child: Text('이 책은 OO 북맵에 담긴 책이에요.',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ),
                      Text('더보기',
                          style: TextStyle(fontSize: 15, color: Colors.black)
                      ),
                    ],
                  ),
                ),
                Container(
                  color: const Color(0x7FD8D8D8),
                  height:  150,
                  child: Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 10),
                          color: Colors.orange,
                          width: 80,
                          height: 100,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          color: Colors.blue,
                          width: 80,
                          height: 100,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          color: Colors.red,
                          width: 80,
                          height: 100,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 15),
                          color: Colors.grey,
                          width: 80,
                          height: 100,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      //여기에 bottom Tabbar 추가할것
    );
  }
}
