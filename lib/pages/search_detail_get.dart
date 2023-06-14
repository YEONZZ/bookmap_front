import 'dart:convert';
import 'package:bookmap/main.dart';
import 'package:flutter/material.dart';
import 'package:bookmap/design/color.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:http/http.dart' as http;
import '../api_key.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';

import '../login.dart';

//초깃값 변수
DateTime selectedStartDate = DateTime.now(); // 읽은 책 시작일
DateTime selectedEndDate = DateTime.now(); // 읽은 책 종료일
double starValue = 3.0;
int readingPage = 0;
int readTotalPage = 0;
int memoReadingPage = 0;
String memoContent = '';

class SearchDetailGetPage extends StatefulWidget {
  final dynamic homeIsbn; // 메인화면에서 대표 4권 isbn
  SearchDetailGetPage({this.homeIsbn});

  @override
  _SearchDetailGetPageState createState() => _SearchDetailGetPageState(homeIsbn: homeIsbn);
}

class _SearchDetailGetPageState extends State<SearchDetailGetPage> {
  final dynamic homeIsbn;
  _SearchDetailGetPageState({this.homeIsbn});
  Future<Map<String, dynamic>>? homeDataFuture;



  @override
  void initState() {
    super.initState();
    homeDataFuture = _fetchData(); // 데이터 가져오는 Future 함수 호출
  }

  @override
  Widget build(BuildContext context) {
    //print(homeData);
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light, primarySwatch: appcolor),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: FutureBuilder(
          future: homeDataFuture,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            } else if (snapshot.hasError){
              return Text('Error');
            } else{
              final homeData = snapshot.data as Map<String, dynamic>;
              // homeData['startDate']와 현재 날짜 사이의 차이 계산
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text(
                    '${homeData['bookResponseDto']['title']}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    ),
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    PopupMenuButton(
                      icon: Icon(Icons.add_box, color: appcolor.shade600,),
                      onSelected: (value) {
                        if (value == 1) { //책 수정 버튼 터치
                          var selectedScreen = '';
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 0.9,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    '어떤 책인가요?',
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await _postData(selectedScreen, homeIsbn);
                                                          print('post 성공');
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('저장'),
                                                                  content: Text('저장 되었습니다.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        // 화면을 다시 로드합니다.
                                                                        Navigator.pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (BuildContext context) => MyApp(token), //추후 업데이트 할 것
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Text('확인', style: TextStyle(color: appcolor.shade700),),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                        },
                                                        child: Text(
                                                          '저장',
                                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appcolor.shade700),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //상단부
                                          Container(
                                            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 5),
                                                    width: 80,
                                                    height: 100,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedScreen = '읽은';
                                                          print('상태: $selectedScreen');
                                                        });
                                                      },
                                                      style: TextButton.styleFrom(
                                                        shape: const RoundedRectangleBorder(
                                                          side: BorderSide(color: Colors.black26),
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      child: Container(
                                                        child:
                                                        Text(
                                                          '읽은 책',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    //margin: EdgeInsets.only(left:5, right: 5),
                                                    width: 80,
                                                    height: 100,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedScreen = '읽는중인';
                                                          print('상태: $selectedScreen');
                                                        });
                                                      },
                                                      style: TextButton.styleFrom(
                                                        shape: const RoundedRectangleBorder(
                                                          side: BorderSide(color: Colors.black26),
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      child: Container(
                                                        child: Text(
                                                          '읽고 있는 책',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    width: 80,
                                                    height: 100,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedScreen = '읽고싶은';
                                                          print('상태: $selectedScreen');
                                                        });
                                                      },
                                                      style: TextButton.styleFrom(
                                                        shape: const RoundedRectangleBorder(
                                                          side: BorderSide(color: Colors.black26),
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      child: Container(
                                                        child: Text(
                                                          '읽고 싶은 책',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container( //버튼별로 선택한 화면 출력
                                            margin: EdgeInsets.only(top: 10),
                                            child: BookScreen(selectedScreen: selectedScreen, homeData: homeData),
                                            //BookScreen(selectedScreen: selectedScreen,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else if (value == 2) {
                          deleteBook(context, homeIsbn);

                        } else { //메모 저장 버튼 터치
                          showPerformanceDialog(context, homeIsbn);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem(value: 1, child: Text('수정'),),
                        PopupMenuDivider(),
                        PopupMenuItem(value: 2, child: Text('삭제')),
                        PopupMenuDivider(),
                        PopupMenuItem(value: 3, child: Text('메모 추가')),
                      ],
                    )
                    //책 분류 버튼
                  ],
                ),
                body: SingleChildScrollView(
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
                                homeData['bookResponseDto']['image'],
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
                                '${homeData['bookResponseDto']['author']}',
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
                      _buildBookWidgets(homeData),
                      Container( //북맵 알려주는 컨테이너
                        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
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
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
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
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        //color: Colors.orange,
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: appcolor.shade700, //외곽선,
                                width: 1.0,
                              ),
                            )
                        ),
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [Tab(text: '책 정보'), Tab(text: '나의 메모')],
                              indicator: BoxDecoration(
                                color: appcolor,
                                // border: Border(
                                //   bottom: BorderSide(
                                //     color: appcolor.shade700, //외곽선,
                                //     width: 1.0,
                                //   ),
                                // )
                              ),
                              unselectedLabelColor: Colors.black,
                            ),
                            Expanded(
                              child: TabBarView(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 5),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('줄거리',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontStyle: FontStyle.normal,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10, right: 10,bottom: 10),
                                            child: Text(
                                              '${homeData['bookResponseDto']['description']}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 5),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('출판사',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontStyle: FontStyle.normal,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 10),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '${homeData['bookResponseDto']['publisher']}',
                                                  )
                                              )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 5),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('출판일',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontStyle: FontStyle.normal,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 10),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '${homeData['bookResponseDto']['publishedDay']}',
                                                  )
                                              )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 5),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('ISBN',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontStyle: FontStyle.normal,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 10, bottom: 5),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '${homeData['bookResponseDto']['isbn']}',
                                                  )
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    //여기까지 책정보 탭
                                    //여기서부터 나의메모 탭
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          _buildMemoListView(homeData),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBookWidgets(Map<String, dynamic> homeData) {
    if (homeData['bookState'] == '읽는중인') {
      DateTime startDate = DateFormat("yyyy-MM-dd").parse(homeData['startDate']);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(startDate);
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5),
            height: 30,
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Text(
                    '시작일: ${homeData['startDate']}로부터 ${difference.inDays}일째 읽고 있어요!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  '수정',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10, right: 10),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 20,
              animation: false,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: double.parse('0.${homeData['readingPercentage']}'),
              center: Text("${homeData['readingPercentage']}%"),
              barRadius: const Radius.circular(16),
              progressColor: appcolor,
              backgroundColor: Color(0x7FD8D8D8),
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildMemoListView(Map<String, dynamic> homeData) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: homeData['bookMemoResponseDtos'].length,
        itemBuilder: (BuildContext context, index) {
          String dateTimeString = homeData['bookMemoResponseDtos'][index]['saved'];
          DateTime dateTime = DateTime.parse(dateTimeString);

          String memoId = homeData['bookMemoResponseDtos'][index]['id'].toString();
          print("메모 아이디: $memoId");

          int year = dateTime.year;
          int month = dateTime.month;
          int day = dateTime.day;
          int hour = dateTime.hour;
          int minute = dateTime.minute;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: appcolor.shade50,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (){
                              memoUpdate(context, homeData['bookMemoResponseDtos'][index]['content'],
                                  homeData['bookMemoResponseDtos'][index]['page'], memoId);
                            },
                            child: Text(
                                '수정',
                              style: TextStyle(color: appcolor.shade700),
                            )
                        ),
                        TextButton(
                            onPressed: (){
                              deleteMemo(context, memoId, homeIsbn);
                            },
                            child: Text(
                                '삭제',
                              style: TextStyle(color: appcolor.shade700),
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${homeData['bookMemoResponseDtos'][index]['content']}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            '${homeData['bookMemoResponseDtos'][index]['page']} 페이지',
                            style: TextStyle(
                                color: appcolor.shade800, fontSize: 12),
                          ),
                        ),
                        Text(
                          '저장일: $year-$month-$day, $hour:$minute',
                          style: TextStyle(color: appcolor.shade800, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final data = await _getISBN(homeIsbn); // 데이터 가져오기
    return data;
  }

  Future<dynamic> showPerformanceDialog(BuildContext context, homeIsbn) async { //메모 추가 함수
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '메모 추가하기',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  maxLines: null, // 여러 줄 입력을 가능하게 합니다.
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(hintText: '메모'),
                  onChanged: (value) {
                    setState(() {
                      memoContent = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: '쪽수 입력'),
                          onChanged: (value) {
                            setState(() {
                              memoReadingPage = int.parse(value);
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: Text('쪽'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await savePerfomance(homeIsbn);
                print('메모 post 성공');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text('저장 되었습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // 화면을 다시 로드합니다.
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SearchDetailGetPage(homeIsbn: homeIsbn,),
                              ),
                            );
                          },
                          child: Text('확인', style: TextStyle(color: appcolor.shade700),),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> memoUpdate(BuildContext context, content, page, memoId) async { //메모 수정 함수
    var updateContent;
    var updatePage;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '메모 수정하기',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  maxLines: null, // 여러 줄 입력을 가능하게 합니다.
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(hintText: '$content'),
                  onChanged: (value) {
                    setState(() {
                      content = value;
                      updateContent = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: '$page'),
                          onChanged: (value) {
                            setState(() {
                              page = int.parse(value);
                              updatePage = int.parse(value);
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: Text('쪽'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () async {

                await updateMemo(context, updateContent, updatePage ,memoId);
                print('메모 수정post 성공');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text('저장 되었습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // 화면을 다시 로드합니다.
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SearchDetailGetPage(homeIsbn: homeIsbn,),
                              ),
                            );
                          },
                          child: Text('확인', style: TextStyle(color: appcolor.shade700),),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }



  Future savePerfomance(homeIsbn) async{ //메모 post
    final response = await http.post(
      Uri.parse(tmdbApiKey + '/bookmemo/save?isbn='+'${homeIsbn}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "content": memoContent,
        "page": memoReadingPage.toString(),
      }),
    );

    print('메모: $memoContent, 페이지: $memoReadingPage');
    // 응답을 가져옵니다.
    return response.body;
  }



  Future<String> _postData(String selectedScreen, String homeIsbn) async { //정보 업데이트 함수
    String bookState = '';

    try {
      if (selectedScreen == '읽은') {
        bookState = '읽은';

        print('상태: $bookState');
        print('시작일: ${selectedStartDate}');
        print('종료일: ${selectedEndDate}');
        print('별점: ${starValue}');
        print('총페이지수: ${readTotalPage}');

        final bodyData = {
          'bookState': bookState,
          'startDate': DateFormat('yyyy-MM-dd').format(selectedStartDate),
          'endDate': DateFormat('yyyy-MM-dd').format(selectedEndDate),
          'grade': starValue.toString(),
          'totalPage': readTotalPage.toString(),
        };

        final response = await http.post(
          Uri.parse(tmdbApiKey + '/book/changeall?isbn=' + '${homeIsbn}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
        );

        return response.body;
      } else if (selectedScreen == '읽는중인') {
        bookState = '읽는중인';

        print('상태: $bookState');
        print('총페이지수: ${readTotalPage}');
        print('읽은페이지: ${readingPage}');
        print('시작일: ${selectedStartDate}');

        final bodyData = {
          'bookState': bookState,
          'totalPage': readTotalPage.toString(),
          'readingPage': readingPage,
          'startDate': DateFormat('yyyy-MM-dd').format(selectedStartDate),
        };

        final response = await http.post(
          Uri.parse(tmdbApiKey + '/book/changeall?isbn=' + '${homeIsbn}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
        );
        print('확인용: ${response.body}');

        return response.body;
      } else if (selectedScreen == '읽고싶은') {
        bookState = '읽고싶은';
        print('상태: $bookState');

        final bodyData = {
          'bookState': bookState,
        };

        final response = await http.post(
          Uri.parse(tmdbApiKey + '/book/changeall?isbn=' + '${homeIsbn}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
        );

        return response.body;
      }

      return '선택한 상태 없음'; // 선택한 상태가 없을 경우
    } catch (e) {
      return 'Error: $e';
    }
  }

} // _SearchDetailGetPageState 클래스 끝




Future<Map<String, dynamic>> _getISBN(homeIsbn) async { //상세정보 가져오는 함수
  http.Client client = http.Client();
  final response = await client.get(Uri.parse(tmdbApiKey + '/book/detail?isbn='+'${homeIsbn}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  var homeData = jsonDecode(utf8.decode(response.bodyBytes));


  return homeData;
}

Future<void> deleteBook(BuildContext context, homeIsbn) async {
  http.Client client = http.Client();
  final response = await client.delete(Uri.parse(tmdbApiKey + '/book/delete?isbn='+'${homeIsbn}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  // 특정 작업 수행
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('삭제'),
        content: Text('삭제되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyApp(token),
                ),
              );
            },
            child: Text('확인', style: TextStyle(color: appcolor.shade700)),
          ),
        ],
      );
    },
  );
}


Future<void> updateMemo(BuildContext context, content, page, memoId) async {
  print(content);
  print(page);
  print(memoId);
  http.Client client = http.Client();
  final response = await client.post(Uri.parse(tmdbApiKey + '/bookmemo/update/$memoId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Content-Type 설정
      },
    body: jsonEncode({
      "content": content,
      "page": page,
    }));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('수정'),
        content: Text('수정되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyApp(token),
                ),
              );
            },
            child: Text('확인', style: TextStyle(color: appcolor.shade700)),
          ),
        ],
      );
    },
  );
}

Future<void> deleteMemo(BuildContext context, memoId, homeIsbn) async {
  print("함수내 $memoId");

  http.Client client = http.Client();
  final response = await client.delete(Uri.parse(tmdbApiKey + '/bookmemo/delete/$memoId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('삭제'),
        content: Text('삭제되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchDetailGetPage(homeIsbn: homeIsbn,),
                ),
              );
            },
            child: Text('확인', style: TextStyle(color: appcolor.shade700)),
          ),
        ],
      );
    },
  );
}

class BookScreen extends StatefulWidget {
  final String selectedScreen;
  final Map<String, dynamic> homeData;

  BookScreen({
    required this.selectedScreen, required this.homeData,
  });

  @override
  BookScreenState createState() => BookScreenState(homeData: homeData);
}

class BookScreenState extends State<BookScreen> {
  late Map<String, dynamic> homeData;
  BookScreenState({required this.homeData});
  void initState() {
    //print('확인: $homeData');
    super.initState();
    selectedStartDate = DateTime.now();
    selectedEndDate = DateTime.now();
    //읽은 변수
    if(homeData['startDate'] == null){
      selectedStartDate = DateTime.now();
    } else {
      String startDateString = homeData['startDate'];
      selectedStartDate = DateTime.parse(startDateString);
    }
    if(homeData['endDate'] == null){
      selectedEndDate = DateTime.now();
    } else {
      String endDateString = homeData['endDate'];
      selectedEndDate = DateTime.parse(endDateString);
    }

    starValue = 3.0;
    if(homeData['grade'] == null) {
      starValue = 3.0;
    } else {
      double starValueDouble = homeData['grade'];
      starValue = starValueDouble;
    }

    //readTotalPage = homeData['totalPage'];
    //readingPage = homeData['readingPage'];
    //readingTotalPage = homeData['totalPage'];
  }

  void onSaveButtonPressed(DateTime selectedDate, String dateType) {
    setState(() {
      if (dateType == 'start') {
        selectedStartDate = selectedDate;
        print('시작일: ${selectedStartDate}');
      } else if (dateType == 'end') {
        selectedEndDate = selectedDate;
        print('종료일: ${selectedEndDate}');
      }
      Navigator.pop(context);
    });
  }



  @override
  Widget build(BuildContext context) {
    // String startDateString = homeData['startDate'];
    // DateTime startDate = DateTime.parse(startDateString);
    if (widget.selectedScreen == '읽은') {
      return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '독서 기간',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container( //시작일 컨테이너
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: appcolor.shade900,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '시작일',
                        style: TextStyle(color: Colors.black, fontSize: 16,),
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: ScrollDatePicker(
                                      selectedDate: selectedStartDate,
                                      locale: Locale('ko'),
                                      scrollViewOptions: DatePickerScrollViewOptions(
                                        year: ScrollViewDetailOptions(
                                          label: '년',
                                          margin: const EdgeInsets.only(right: 8),
                                        ),
                                        month: ScrollViewDetailOptions(
                                          label: '월',
                                          margin: const EdgeInsets.only(right: 8),
                                        ),
                                        day: ScrollViewDetailOptions(
                                          label: '일',
                                        ),
                                      ),
                                      onDateTimeChanged: (DateTime value) {
                                        setState(() {
                                          selectedStartDate = value;
                                          print('시작일: $selectedStartDate');
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text(
                                              "취소",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              onSaveButtonPressed(selectedStartDate, 'start');
                                            },
                                            child: Text(
                                              "저장",
                                              style: TextStyle(color: appcolor.shade700),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                                '${DateFormat('yyyy-MM-dd').format(selectedStartDate)}',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container( //종료일 컨테이너
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: appcolor.shade900,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '종료일',
                        style: TextStyle(color: Colors.black, fontSize: 16,),
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: ScrollDatePicker(
                                      selectedDate: selectedEndDate,
                                      locale: Locale('ko'),
                                      scrollViewOptions: DatePickerScrollViewOptions(
                                        year: ScrollViewDetailOptions(
                                          label: '년',
                                          margin: const EdgeInsets.only(right: 8),
                                        ),
                                        month: ScrollViewDetailOptions(
                                          label: '월',
                                          margin: const EdgeInsets.only(right: 8),
                                        ),
                                        day: ScrollViewDetailOptions(
                                          label: '일',
                                        ),
                                      ),
                                      onDateTimeChanged: (DateTime value) {
                                        setState(() {
                                          selectedEndDate = value;
                                          print('종료일: $selectedEndDate');
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                "취소",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: TextButton(
                                              onPressed: () {
                                                onSaveButtonPressed(selectedEndDate, 'end');
                                              },
                                              child: Text(
                                                "저장",
                                                style: TextStyle(color: appcolor.shade700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                          '${DateFormat('yyyy-MM-dd').format(selectedEndDate)}',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ), //종료일 컨테이너 끝
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '총 페이지 수',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              height: 35,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: appcolor.shade900,
                  )
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '페이지 수',
                        style: TextStyle(color: Colors.black, fontSize: 16,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 16.3),
                          width: 150,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: homeData['totalPage'] != null ? '${homeData['totalPage']}' : '0',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 16,),
                            onChanged: (value) {
                              setState(() {
                                readTotalPage = int.parse(value);
                                print('총 페이지수: $readTotalPage');
                              });
                            },
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                            ' 쪽',
                            style: TextStyle(color: Colors.black, fontSize: 16,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container( //평점 컨테이너
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container( //텍스트 컨테이너
                      child: Text('평점을 남겨 주세요!',
                        style: TextStyle(color: Colors.black, fontSize: 16, ),
                      ),
                    ),
                  ), //평점 텍스트 끝
                  Container( //별 컨테이너
                    child: RatingStars(
                      value: starValue,
                      onValueChanged: (v){
                        setState(() {
                          starValue = v;
                          print('별점: $starValue');
                        });
                      },
                      starBuilder: (index, color) => Icon(
                        Icons.star,
                        color: color,
                        size: 35,
                      ),
                      starCount: 5,
                      starSize: 30, //별 사이 간격
                      valueLabelColor: const Color(0xff9b9b9b),
                      valueLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,),
                      valueLabelRadius: 10,
                      maxValue: 5,
                      starSpacing: 1,
                      maxValueVisibility: true,
                      valueLabelVisibility: true,
                      animationDuration: Duration(milliseconds: 1000),
                      valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                      valueLabelMargin: const EdgeInsets.only(right: 8),
                      starOffColor: const Color(0xffe7e8ea),
                      starColor: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (widget.selectedScreen == '읽는중인') {
      return Column(
        children: [
          Container( //총페이지 수 입력 컨테이너
            margin: EdgeInsets.only(left: 10, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '총 페이지 수',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: appcolor.shade900,
                )
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      '페이지 수',
                      style: TextStyle(color: Colors.black, fontSize: 16,),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16.3),
                        width: 150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText:  homeData['totalPage'] != null ? '${homeData['totalPage']}' : '0',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 16,),
                          onChanged: (value) {
                            setState(() {
                              readTotalPage = int.parse(value);
                              print('총 페이지수: $readTotalPage');
                            });
                          },
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          ' 쪽',
                          style: TextStyle(color: Colors.black, fontSize: 16,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '독서량',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: appcolor.shade900,
                )
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      '읽은 페이지',
                      style: TextStyle(color: Colors.black, fontSize: 16,),
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16.3),
                        width: 150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText:  homeData['readingPage'] != null ? '${homeData['readingPage']}' : '0',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 16,),
                          onChanged: (value) {
                            setState(() {
                              readingPage = int.parse(value);
                            });
                          },
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          ' 쪽',
                          style: TextStyle(color: Colors.black, fontSize: 16,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '독서 기간',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ),
          Container( //독서기간 컨테이너
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: appcolor.shade900,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      '시작일',
                      style: TextStyle(color: Colors.black, fontSize: 16,),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 250,
                                  child: ScrollDatePicker(
                                    selectedDate: selectedStartDate,
                                    locale: Locale('ko'),
                                    scrollViewOptions: DatePickerScrollViewOptions(
                                      year: ScrollViewDetailOptions(
                                        label: '년',
                                        margin: const EdgeInsets.only(right: 8),
                                      ),
                                      month: ScrollViewDetailOptions(
                                        label: '월',
                                        margin: const EdgeInsets.only(right: 8),
                                      ),
                                      day: ScrollViewDetailOptions(
                                        label: '일',
                                      ),
                                    ),
                                    onDateTimeChanged: (DateTime value) {
                                      setState(() {
                                        selectedStartDate = value;
                                        print('시작일: $selectedStartDate');
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text(
                                              "취소",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "저장",
                                              style: TextStyle(color: appcolor.shade700),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                        '${DateFormat('yyyy-MM-dd').format(selectedStartDate)}',
                          style: TextStyle(color: Colors.black, fontSize: 16,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (widget.selectedScreen == '읽고싶은') {
      return Container(
        margin: EdgeInsets.only(top: 70),
        child: Text(
          '읽고 싶은 책으로 저장할까요?',
          style: TextStyle(color: Colors.black, fontSize: 16,),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}