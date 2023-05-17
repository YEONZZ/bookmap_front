import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../design/color.dart';

class MyCalendar extends StatelessWidget{
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _MyCalendar()
    );
  }
}

class _MyCalendar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('독서기록 요약',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Calendar(),
            SumUp(),
          ],
        ),
      ),
    );
  }

}
class Calendar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Calendar();
  }
}

class _Calendar extends State<Calendar>{

  @override
  Widget build(BuildContext context) {
    return TableCalendar(focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2023,1,1),
      lastDay: DateTime.utc(2023,12,31),
      //locale: 'ko_KR',
      //daysOfWeekHeight: 30,
      calendarStyle: CalendarStyle(
          markerDecoration: BoxDecoration(color: appcolor.shade600, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Colors.transparent,
          shape: BoxShape.circle, border: Border.all(color: appcolor.shade600, width: 1.5),)
      , todayTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      availableGestures: AvailableGestures.none,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      eventLoader: (day){
      if(day.day%15==0){
        return['hi'];
      }
      else
        return[];
      },
    );
  }
}

class SumUp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: appcolor.shade50,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            children: [
              Image.network('https://shopping-phinf.pstatic.net/main_3830325/38303250623.20230509165417.jpg?type=w300',
                  height: 100,
                  fit: BoxFit.fitHeight),
              Padding(padding: EdgeInsets.only(left:15),),
              Image.network('https://shopping-phinf.pstatic.net/main_3246631/32466315260.20230131162954.jpg?type=w300',
                  height: 100,
                  fit: BoxFit.fitHeight)
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(5)),
        const Divider(
          indent: 15,
          endIndent: 15,
          height: 5,
          color: Colors.black26,
        ),
        Padding(
          padding: EdgeInsets.only(top:10, left: 20),
          child: Text('독서량', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 11),),),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          width: double.infinity,
          child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('완독 권 수  ', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    const Text('2권', style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
      ],
    );
  }
  
}