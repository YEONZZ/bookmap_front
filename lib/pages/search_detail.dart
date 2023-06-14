import 'dart:convert';
import 'package:bookmap/main.dart';
import 'package:bookmap/pages/search_detail_get.dart';
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
DateTime readingStartDate = DateTime.now(); // 읽고 있는 책 시작일 변수
double starValue = 3;
int readingPage = 0;
int readTotalPage = 0;
int readingTotalPage = 0;
int memoReadingPage = 0;
String memoContent = '';


class SearchDetailPage extends StatefulWidget {
  final dynamic searchData; //카카오 책 검색 후 받아오는 데이터
  SearchDetailPage({this.searchData});

  @override
  _SearchDetailPage createState() => _SearchDetailPage(searchData: searchData);
}

class _SearchDetailPage extends State<SearchDetailPage> {
  final dynamic searchData;
  _SearchDetailPage({this.searchData});
  dynamic searchIsbn;
  final currentDate = DateTime.now();
  final example = DateTime(2023, 05, 02);
  var diff = const Duration(days: 0);
  //diff = currentDate.difference(example);

  @override
  void initState() {
    super.initState();
    searchIsbn = searchData['isbn'];
    // print(searchData);
    // print(searchData['title']);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light, primarySwatch: appcolor),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              '${searchData['title']}',
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
                  if (value == 1) { //책 저장 버튼 터치
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
                                                    String result = await _postData(selectedScreen, searchIsbn);
                                                    if(result.isNotEmpty) { //post성공시
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
                                                                  // 책 저장후 searchDetailGetPage로 이동
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (BuildContext context) => MyApp(token), //임시로 이동
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text('확인', style: TextStyle(color: appcolor.shade700),),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {print('post실패');}
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
                                      child: BookScreen(selectedScreen: selectedScreen,),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }  else if ( value == 2 ){  // 메모 저장 버튼 터치
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('알림'),
                          content: Text('도서 저장 후 메모를 추가해주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: Text('확인',style: TextStyle(color: appcolor.shade700),),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem(value: 1, child: Text('책 저장'),),
                  PopupMenuDivider(),
                  PopupMenuItem(value: 2, child: Text('메모 추가')),
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
                          searchData['image'],
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
                          '${searchData['author']}',
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
                Container( //북맵 알려주는 컨테이너
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, ),
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
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${searchData['description']}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,),
                                      ),
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
                                            child: Text('${searchData['publisher']}',))
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
                                            child: Text('${searchData['publishedDay']}',))
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
                                        margin: EdgeInsets.only(left: 10, bottom: 10),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('${searchData['isbn']}',))
                                    ),
                                  ],
                                ),
                              ),
                              //여기까지 책정보 탭
                              //여기서부터 나의메모 탭
                              Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '도서 저장 후 메모를 추가해주세요.',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
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
        ),
      ),
    );
  }


  Future<String> _postData(String selectedScreen, String searchIsbn) async {
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
          Uri.parse(tmdbApiKey + '/book/save?isbn=' + '${searchIsbn}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
        );
        print('확인용: ${response.body}');
        return response.body;
      } else if (selectedScreen == '읽는중인') {
        bookState = '읽는중인';

        print('상태: $bookState');
        print('총페이지수: ${readTotalPage}');
        print('읽은페이지: ${readingPage}');
        print('시작일: ${readingStartDate}');

        final bodyData = {
          'bookState': bookState,
          'totalPage': readTotalPage.toString(),
          'readingPage': readingPage,
          'startDate': DateFormat('yyyy-MM-dd').format(readingStartDate),
        };

        final response = await http.post(
          Uri.parse(tmdbApiKey + '/book/save?isbn=' + '${searchIsbn}'),
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
          Uri.parse(tmdbApiKey + '/book/save?isbn=' + '${searchIsbn}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
        );
        print('확인용: ${response.body}');
        return response.body;
      }

      return ''; // 선택한 상태가 없을 경우 빈 문자열 반환
    } catch (e) {
      return 'Error: $e';
    }
  }

} //SearchDetail 끝

class BookScreen extends StatefulWidget {
  final String selectedScreen;

  BookScreen({
    required this.selectedScreen,
  });

  @override
  BookScreenState createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> {
  void initState() {
    super.initState();
    selectedStartDate = DateTime.now(); // 읽은 책 시작일
    selectedEndDate = DateTime.now(); // 읽은 책 종료일
    readingStartDate = DateTime.now(); // 읽고 있는 책 시작일 변수
    starValue = 3.0;
    readingPage = 0;
    readTotalPage = 0;
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
                            '${selectedStartDate.year}-${selectedStartDate.month}-${selectedStartDate.day}',
                            style: TextStyle(color: Colors.black, fontSize: 16,),
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
                            '${selectedEndDate.year}-${selectedEndDate.month}-${selectedEndDate.day}',
                            style: TextStyle(color: Colors.black, fontSize: 16,),
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
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
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
          Container( // 페이지 수 컨테이너
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
                            hintText: '0',
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
          Container( //독서량 컨테이너
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16.3),
                        width: 150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0',
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
                                    selectedDate: readingStartDate,
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
                                        readingStartDate = value;
                                        print('시작일: $readingStartDate');
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
                          '${readingStartDate.year}-${readingStartDate.month}-${readingStartDate.day}',
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


