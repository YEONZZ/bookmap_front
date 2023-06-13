import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../api_key.dart';
import 'editingBookMap.dart';

class ScrapDetail extends StatelessWidget{
  var myBookmap;
  ScrapDetail(this.myBookmap, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _BookmapEx(myBookmap),
    );
  }
}

class _BookmapEx extends StatelessWidget{
  var myBookmap;
  _BookmapEx(this.myBookmap, {super.key});

  @override
  Widget build(BuildContext context) {
    //print(myBookmap);
    var mapId = myBookmap['bookMapId'];
    var title = myBookmap['bookMapTitle'];
    //print("확인!!!!!!!!! $title");
    var content = myBookmap['bookMapContent'];
    var bookmapimg = myBookmap['bookMapImage'];
    if (bookmapimg == null){
      bookmapimg = 'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.ssfshop.com%2Fcmd%2FLB_500x660%2Fsrc%2Fhttp%3A%2Fimg.ssfshop.com%2Fgoods%2FHMBR%2F19%2F04%2F08%2FGM0019040873391_7_ORGINL.jpg&type=sc960_832';
    }
    var keyword = myBookmap['hashTag'];
    var share = myBookmap['share'];

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 35, right: 15, left: 15, bottom: 15),
                //decoration: BoxDecoration(),
                color: Color(0xfff5eedc),
                width: double.infinity,
                height: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(keyword.toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.deepPurple),),
                    Padding(padding: EdgeInsets.all(2)),
                    Text(content.toString(),
                      style: TextStyle(fontSize: 13,color: Colors.black54),
                      textAlign: TextAlign.right,),
                    Padding(padding: EdgeInsets.all(2)),
                    Text(title.toString(), style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,),
                  ],
                ),
              ),
              const Divider(
                height: 5,
                color: Colors.black54,
              ),
              FutureBuilder<List<dynamic>>(
                future: _getMapDetail(mapId),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    List<dynamic> myMapDetail = snapshot.data!;
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: myMapDetail[0]['bookMapIndex'].length,
                      itemBuilder: (context, index) {
                        var detailContents = myMapDetail[0]['bookMapIndex'][index];
                        var detailType = detailContents['type'];
                        var detailBooks = detailContents['map'];
                        var detailMemo = detailContents['memo'];

                        if(detailMemo == null){
                          int num = detailBooks.length;
                          List<String> books = [];
                          for (int i = 0; i < num ; i++){
                            books.add(detailBooks[i]['image']);
                          }
                          print(books);
                          return GestureDetector(
                              onTap:(){
                              },
                              child: Container(
                                height: 150,
                                child: ListView.builder(
                                    itemCount: books.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context1, index1){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(books[index1],
                                            height: 130),
                                      );
                                    }),
                              )
                          );
                        }
                        else{
                          print('memo$detailMemo');
                          return Container(
                            decoration: BoxDecoration(color: Color(0xfff5eedc),),
                            height: 130,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.arrow_downward, size: 100),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(detailMemo, style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          );
                        }
                      }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                      (crossAxisCount: 1,
                        childAspectRatio: 3),
                    );
                  }
                  else if (snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        )
    );
  }
}


Future<List<dynamic>> _getMapDetail(mapId) async {
  //print(mapId);
  final httpClient = IOClient();
  final mapDetailResponse = await httpClient.get(
    Uri.parse('$bookmapKey/bookmap/view/$mapId'),
  );

  var mapDetailTest = jsonDecode(utf8.decode(mapDetailResponse.bodyBytes));
  //print(mapDetailTest);
  //log(mapDetailTest);

  dynamic listData = [mapDetailTest]; // data를 리스트로 감싸기

  return listData;
}