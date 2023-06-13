import 'dart:convert';

import '../login.dart';
import 'package:http/http.dart' as http;
import 'package:bookmap/pages/search_in_bookmap.dart';
import 'myBookmapDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../api_key.dart';
import '../design/color.dart';


class EditingBookMap extends StatelessWidget {
  dynamic mapId;
  dynamic searchData;

  EditingBookMap(this.mapId, {this.searchData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _EditingBookMap(mapId, searchData: searchData),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: appcolor,
      ),
    );
  }
}


class _EditingBookMap extends StatefulWidget{
  var mapId;
  var searchData;
  _EditingBookMap(this.mapId, {this.searchData});

  @override
  State<StatefulWidget> createState() => _bookmapEdit(mapId, searchData: searchData);

}

class _bookmapEdit extends State<_EditingBookMap> {
  var mapId;
  var searchData;
  // var refreshKey = GlobalKey<RefreshIndicatorState>();

  _bookmapEdit(this.mapId, {this.searchData});

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _sentencesEditingController = TextEditingController();
  final TextEditingController _keywordEditingController = TextEditingController();
  bool open = true;
  bool close = false;
  late List<bool> isSelected;
  bool change = false;
  List<dynamic> newMapDetail = [];
  String title = "";
  String sentences = "";
  String keyword = "";

  @override
  void initState() {
    isSelected = [open, close];
    // refreshList();
  }

  // Future<Null> refreshList() async{
  //   refreshKey.currentState?.show(atTop: false);
  //   await Future.delayed(Duration(microseconds: 2));
  //   setState(() {
  //   });
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var myBookmap = await _getMapDetail(mapId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => myMapDetail(myBookmap[0])),
        );
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<dynamic>>(
              future: _getMapDetail(mapId),
              builder: (context, snapshot) {
                //print('확인용: $searchData');
                if (snapshot.hasData) {
                  List<dynamic> myBookMapDetail = [];
                  if (searchData != null){
                    myBookMapDetail = [searchData];
                  } else if (change == false) {
                    myBookMapDetail = snapshot.data!;
                  }
                  else {
                    myBookMapDetail = newMapDetail;
                  }
                  int num = myBookMapDetail[0]['hashTag'].length;
                  List<String> tags = [];
                  String tag = "";
                  if (num != 0) {
                    for (int i = 0; num > i; i++) {
                      tags.add(myBookMapDetail[0]['hashTag'][i]);
                    }
                    tag = tags.join(" ");
                  }
                  _titleEditingController.text =
                  myBookMapDetail[0]['bookMapTitle'];
                  _sentencesEditingController.text =
                  myBookMapDetail[0]['bookMapContent'];
                  _keywordEditingController.text = tag;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 15, right: 15, left: 15, bottom: 15),
                        //decoration: BoxDecoration(),
                        color: Color(0xfff5eedc),
                        width: double.infinity,
                        height: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(style: TextStyle(fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                              controller: _titleEditingController,
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.black87)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black87)
                                ),
                                suffixIcon: GestureDetector(
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.black38,
                                    size: 20,
                                  ),
                                  onTap: () => _titleEditingController.clear(),
                                ),
                                labelText: '북맵 제목',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                hintText: myBookMapDetail[0]['bookMapTitle'],
                                hintStyle: TextStyle(color: Colors.black38,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            TextField(
                              maxLines: 2,
                              style: TextStyle(fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                              controller: _sentencesEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.black87)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black87)
                                ),
                                suffixIcon: GestureDetector(
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.black38,
                                    size: 20,
                                  ),
                                  onTap: () =>
                                      _sentencesEditingController.clear(),
                                ),
                                labelText: '북맵 소개글',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                hintText: myBookMapDetail[0]['bookMapContent'],
                                hintStyle: TextStyle(color: Colors.black38,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            TextField(style: TextStyle(fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                              controller: _keywordEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.black87)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black87)
                                ),
                                suffixIcon: GestureDetector(
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.black38,
                                    size: 20,
                                  ),
                                  onTap: () =>
                                      _keywordEditingController.clear(),
                                ),
                                labelText: '키워드',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                hintText: tag,
                                hintStyle: TextStyle(color: Colors.black38,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            Expanded(
                                flex: 7,
                                child: Text('공개여부', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),)),
                            Expanded(
                              flex: 3,
                              child: ToggleButtons(
                                onPressed: toggleSelect,
                                isSelected: isSelected,
                                fillColor: appcolor.shade100,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('공개', style: TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('비공개', style: TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(5)),
                          Expanded(
                            flex: 3,
                            child: OutlinedButton(onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: const EdgeInsets.fromLTRB(
                                          100, 0, 100, 0),
                                      actionsAlignment: MainAxisAlignment
                                          .center,
                                      actions: [
                                        TextButton(
                                          child: const Text('도서',
                                            style: TextStyle(fontSize: 14,
                                                color: Colors.black),),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('메모',
                                            style: TextStyle(fontSize: 14,
                                                color: Colors.black),),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }, child: Text('추가',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white)),),
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(padding: EdgeInsets.all(5))),
                          Expanded(
                            flex: 3,
                            child: OutlinedButton(onPressed: () {
                              if (change) {
                                myBookMapDetail = newMapDetail;
                              }
                              String tag = _keywordEditingController.text;
                              myBookMapDetail[0]['bookMapTitle'] =
                                  _titleEditingController.text;
                              myBookMapDetail[0]['bookMapContent'] =
                                  _sentencesEditingController.text;
                              if (tag != "") {
                                myBookMapDetail[0]['hashTag'] =
                                List<dynamic>.from(tag.split(" "));
                              }
                              else {
                                myBookMapDetail[0]['hashTag'] = [];
                              }
                              myBookMapDetail[0]['share'] = isSelected[0];
                              _postMapDetail(mapId, myBookMapDetail[0]);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    myMapDetail(myBookMapDetail[0])),
                              );
                            },
                                child: Text('저장', style: TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white))),
                          ),
                          Padding(padding: EdgeInsets.all(5))
                        ],
                      ),
                      const Divider(
                        height: 5,
                        color: Colors.black54,
                      ),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: myBookMapDetail[0]['bookMapIndex'].length,
                        itemBuilder: (context, index) {
                          var detailContents = myBookMapDetail[0]['bookMapIndex'][index];
                          var detailType = detailContents['type'];
                          var detailBooks = detailContents['map'];
                          var detailMemo = detailContents['memo'];

                          if ("Book".compareTo(detailType) == 0) {
                            int num = detailBooks.length;
                            List<String> books = [];
                            for (int i = 0; i < num; i++) {
                              books.add(detailBooks[i]['image']);
                            }
                            if (num <= 3) {
                              books.add(
                                  'https://postfiles.pstatic.net/MjAyMzA2MDlfMTUz/MDAxNjg2MzA5MTk2Njc1.e0lBE1zzXGIZIg03GQ6c-J2E6ahezLFCWsZMZWpolYAg.nomA0xkMNBmkhgZ8q84XIbwer4nE9_KxtBojTb_vYTMg.PNG.odb1127/image.png?type=w773');
                            }
                            return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 150,
                                  child: ListView.builder(
                                      itemCount: books.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context1, index1) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  if (index1 != books.length - 1) {
                                                    detailBooks.removeAt(
                                                        index1);
                                                    newMapDetail =
                                                        myBookMapDetail;
                                                    change = true;
                                                  }
                                                });
                                                if (index1 == books.length - 1 && books.length != 5) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SearchInBookMap(index, myBookMapDetail[0])),
                                                  );
                                                }
                                              },
                                              child: Image.network(
                                                  books[index1],
                                                  height: 130),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                            );
                          }
                          else {
                            // print('memo$detailMemo');
                            return Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff5eedc),),
                              height: 130,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                        Icons.arrow_downward, size: 100),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(detailMemo,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                          (crossAxisCount: 1,
                            childAspectRatio: 3),
                      ),
                    ],
                  );
                }
                else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                else {
                  return CircularProgressIndicator();
                }
              },
            )
        ),
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      open = true;
      close = false;
    }
    else {
      open = false;
      close = true;
    }
    setState(() {
      isSelected = [open, close];
    });
  }

  void _postMapDetail(mapId, myBookMapDetail) async {
    final response = await http.post(
      Uri.parse('$bookmapKey/bookmap/update/$mapId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(myBookMapDetail),
    );
  }
}

Future<List<dynamic>> _getMapDetail(mapId) async {
  final httpClient = IOClient();
  final mapDetailResponse = await httpClient.get(
    Uri.parse('$bookmapKey/bookmap/view/$mapId'),
  );
  var mapDetailEdit = jsonDecode(utf8.decode(mapDetailResponse.bodyBytes));

  dynamic listData = [mapDetailEdit]; // data를 리스트로 감싸기

  return listData;
}



