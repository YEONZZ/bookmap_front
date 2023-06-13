import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HelpComplain extends StatelessWidget {
  const HelpComplain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HelpComplain(),
    );
  }
}

class _HelpComplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('문의',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 23, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("어떤 점이 궁금하신가요?", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.all(10),),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black38),
                  borderRadius: BorderRadius.circular(10)
                ),
               padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("도서", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.all(5)),
                  Text("도서에 관련된 궁금한 점을 물어주세요", style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),),
                  Padding(padding: EdgeInsets.all(10),),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Text("예시", style: TextStyle(fontSize: 12, color: Colors.black38),),
                        decoration: BoxDecoration(
                            color: Colors.white,
                        borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      Text("도서의 업데이트 기간이 궁금해요", style: TextStyle(fontSize: 12, color: Colors.black38))
                    ],
                  ),
                    Padding(padding: EdgeInsets.all(5),),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text("예시", style: TextStyle(fontSize: 12, color: Colors.black38),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        Text("도서 추가 요청이 가능한지 궁금해요", style: TextStyle(fontSize: 12, color: Colors.black38))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("북맵", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.all(5)),
                    Text("북맵에 관련된 궁금한 점을 물어주세요", style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),),
                    Padding(padding: EdgeInsets.all(10),),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text("예시", style: TextStyle(fontSize: 12, color: Colors.black38),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        Text("북맵 사용법이 궁금해요", style: TextStyle(fontSize: 12, color: Colors.black38))
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(5),),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text("예시", style: TextStyle(fontSize: 12, color: Colors.black38),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        Text("북맵 정보를 pdf로 저장할 수 있나요?", style: TextStyle(fontSize: 12, color: Colors.black38))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("기타", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.all(5)),
                    Text("북맵 서비스에 대해 궁금한 점을 물어주세요", style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),),
                    Padding(padding: EdgeInsets.all(10),),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text("예시", style: TextStyle(fontSize: 12, color: Colors.black38),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        Text("인기 도서 산정 방식에 대해 궁금해요", style: TextStyle(fontSize: 12, color: Colors.black38))
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(5),),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text("예시", style: TextStyle(fontSize: 12, color: Colors.black38),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        Text("비회원도 사용이 가능한가요?", style: TextStyle(fontSize: 12, color: Colors.black38))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
