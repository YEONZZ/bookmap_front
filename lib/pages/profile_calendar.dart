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
      firstDay: DateTime.utc(2023,5,1),
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
      if(day.day%10==0){
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
          color: appcolor.shade50,
          child: Row(
            children: [
              Image.network('https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MDFfNDkg%2FMDAxNjU5MzI3NDEzOTc5.Pq9p6L6WOE8sPiulrDGRhYAzyX7rXSFehaWNgSnIpgog.oXYs2_jkhSTSx5BIXA3Bw_TQSV65pUzQ9t7VwJKwRwUg.PNG.darks754%2F20220720_130458.png&type=sc960_832',
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill),
              Padding(padding: EdgeInsets.only(left:10),),
              Image.network('https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA2MDNfMTE3%2FMDAxNjU0MjEzOTU0MjM5.ZpVsQpWT6GyTDEhRTrFvFPn94_ehzw_nIyhuIkgRFIgg.kgBLPcRZFwZPIrpU_SxZd7udlJUq7DifwNK1WHdFf5Eg.JPEG.javida%2F92F90D0C-26EF-49B2-BA3D-87F4F53716F7.jpeg&type=sc960_832',
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill)
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
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('읽은 페이지 수  ', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  const Text('138p', style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('읽은 일 수  ', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  const Text('3일', style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
      ],
    );
  }
  
}