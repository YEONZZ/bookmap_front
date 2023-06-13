import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:table_calendar/table_calendar.dart';
import '../api_key.dart';
import '../design/color.dart';
import '../login.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar(token, {Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  List<DateTime> endDate = [];
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _fetchData(selectedDate.year).then((dataList) {
      endDate.clear();
      for (var data in dataList) {
        String date = data['endDate'];
        endDate.add(DateTime.parse(date));
      }
      print("endDate $endDate");
      setState(() {});
    });
  }

  //...

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              '독서기록 요약',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchData(selectedDate.year),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                List<Map<String, dynamic>> dataList = snapshot.data!;
                print(dataList);


                for (var data in dataList) {
                  List<dynamic> bookPersonalMonthResponseDto = data['bookPersonalMonthResponseDto'];
                  for (var bookData in bookPersonalMonthResponseDto) {
                    String? endDateStr = bookData['endDate'];
                    if (endDateStr != null) {
                      DateTime endDateValue = DateTime.parse(endDateStr);
                      endDate.add(endDateValue);
                    }
                  }
                }

                print("endDate: $endDate");
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Calendar(
                        endDate: endDate,
                        selectedDate: selectedDate,
                        onDaySelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                      SumUpState(selectedDate: selectedDate, dataList: dataList),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        )
    );
  }
}

class Calendar extends StatefulWidget {
  final List<DateTime> endDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const Calendar({
    required this.endDate,
    required this.selectedDate,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<DateTime> endDate;
  late DateTime currentPageStartDate;

  DateTime _getFirstDayOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  @override
  void initState() {
    super.initState();
    endDate = widget.endDate;
    currentPageStartDate = _getFirstDayOfMonth(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: widget.selectedDate,
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2023, 12, 31),
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: appcolor.shade600,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color:  appcolor.shade100, // 원하는 색상으로 변경
          shape: BoxShape.circle,
        ),
      ),

      onPageChanged: (focusedDay) {
        currentPageStartDate = _getFirstDayOfMonth(focusedDay);
        widget.onDaySelected(currentPageStartDate);
      },
      eventLoader: (day) {
        bool isDayInEndDate = false;
        for (var endDateItem in endDate) {
          if (endDateItem.year == day.year &&
              endDateItem.month == day.month &&
              endDateItem.day == day.day) {
            isDayInEndDate = true;
            break;
          }
        }
        if (isDayInEndDate) {
          return ['hi'];
        } else {
          return [];
        }
      },

    );

  }
}

class SumUpState extends StatefulWidget {
  final List<dynamic> dataList;
  final DateTime selectedDate;

  SumUpState({
    required this.dataList,
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  State<SumUpState> createState() => SumUp(selectedDate: selectedDate, dataList: dataList);
}

class SumUp extends State<SumUpState> {
  final List<dynamic> dataList;
  final DateTime selectedDate;

  SumUp({required this.selectedDate, required this.dataList});


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = dataList
        .expand((data) => data['bookPersonalMonthResponseDto'])
        .where((data) {
      DateTime endDate = DateTime.parse(data['endDate']);
      return endDate.month == selectedDate.month;
    }).toList().cast<Map<String, dynamic>>();

    List bookImages = filteredData.map((bookData) => bookData['image']).toList();
    print(bookImages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
          width: double.maxFinite,
          height: 140,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: bookImages.map((image) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: GestureDetector(
                    child: Image.network(
                      image,
                      width: 90,
                      height: 120,
                      fit: BoxFit.fitHeight,
                    ),
                    onTap: () {
                      // Define the action when a book image is tapped
                      // e.g., navigate to the book details page
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 20),
          child: Text(
            '독서량',
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Text(
                  '완독 권 수  ',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  bookImages.length.toString() + '권',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> _fetchData(int year) async {
  final httpClient = IOClient();
  final userResponse = await httpClient.get(
    Uri.parse('$logApiKey/summary?year=$year'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
  );

  if (userResponse.statusCode == 200) {
    var summary = jsonDecode(utf8.decode(userResponse.bodyBytes));
    List<Map<String, dynamic>> listData = [summary];
    return listData;
  } else {
    throw Exception('Failed to fetch data');
  }
}
