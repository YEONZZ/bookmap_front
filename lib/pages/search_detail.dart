import 'package:bookmap/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:bookmap/design/color.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

class SearchDetail extends StatefulWidget {
  final dynamic data;
  const SearchDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchDetail();
}


class _SearchDetail extends State<SearchDetail> {
  late final dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    //print(data);
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final example = DateTime(2023, 05, 02);
    var diff = const Duration(days: 0);
    diff = currentDate.difference(example);

    if (data == null) {
      return Center(child: Text('데이터 전송 오류'),);
    } else {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, data);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                data!['title'].toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                ),
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(onPressed: () {},
                    icon: Icon(Icons.add_box, color: appcolor.shade600,))
                //책 분류 버튼
              ],
            ),
            body: WillPopScope(
              onWillPop: () async {
                Navigator.push(
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 1 / 3,
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
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress
                                        .expectedTotalBytes != null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 13),
                            child: Text(
                              '${data!['authors'].join(', ')}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container( //날짜 컨테이너
                      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 10,
                              child: Text('2023.05.02 로부터 ${diff.inDays
                                  .toString()}일째 읽고 있어요!',
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),)
                          ),
                          Text('수정',
                              style: TextStyle(fontSize: 14, color: Colors
                                  .black38, decoration: TextDecoration
                                  .underline)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: new LinearPercentIndicator(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 20,
                        animation: false,
                        lineHeight: 20.0,
                        animationDuration: 2000,
                        percent: 0.15,
                        center: Text("15.0%"),
                        barRadius: const Radius.circular(16),
                        progressColor: appcolor,
                        backgroundColor: Color(0x7FD8D8D8),
                      ),
                    ),
                    Container( //북맵 알려주는 컨테이너
                      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                      height: 30,
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 10,
                              child: Text('이 책은 "여행가고 싶은 곳들"에 담긴 책이에요.',
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),)
                          ),
                          Text('더보기',
                              style: TextStyle(fontSize: 14, color: Colors
                                  .black38, decoration: TextDecoration
                                  .underline)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        color: const Color(0x7FD8D8D8),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Image.network(
                                    'https://shopping-phinf.pstatic.net/main_3839015/38390159619.20230502161943.jpg?type=w300',
                                    width: 90,
                                    height: 120,
                                    fit: BoxFit.fill),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Image.network(
                                    'https://shopping-phinf.pstatic.net/main_3249189/32491898723.20221019101316.jpg?type=w300',
                                    width: 90,
                                    height: 120,
                                    fit: BoxFit.fill),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Image.network(
                                    'https://shopping-phinf.pstatic.net/main_3246667/32466672176.20221229074149.jpg?type=w300',
                                    width: 90,
                                    height: 120,
                                    fit: BoxFit.fill),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Image.network(
                                    'https://shopping-phinf.pstatic.net/main_3818761/38187614626.20230404162233.jpg?type=w300',
                                    width: 90,
                                    height: 120,
                                    fit: BoxFit.fill),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }
  }}
