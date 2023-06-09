import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../api_key.dart';
import '../design/color.dart';

class EditingBookMap extends StatelessWidget {
  var mapId;
  EditingBookMap(this.mapId, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _EditingBookMap(mapId),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: appcolor,
      ),
    );
  }
}


class _EditingBookMap extends StatefulWidget{
  var mapId;
  _EditingBookMap(this.mapId, {super.key});

  @override
  State<StatefulWidget> createState() => _bookmapEdit(mapId);

}

class _bookmapEdit extends State<_EditingBookMap>{
  var mapId;
  _bookmapEdit(this.mapId);
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _sentencesEditingController = TextEditingController();
  final TextEditingController _keywordEditingController = TextEditingController();
  bool open = true;
  bool close = false;
  late List<bool> isSelected;

  @override
  void initState(){
    isSelected = [open, close];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder<List<dynamic>>(
            future: _getMapDetail(mapId),
            builder: (context, snapshot){
              if (snapshot.hasData){
                List<dynamic> myMapDetail = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 35, right: 15, left: 15, bottom: 15),
                      //decoration: BoxDecoration(),
                      color: Colors.orange.shade200,
                      width: double.infinity,
                      height: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
                            controller: _titleEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.black87)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2, color: Colors.black87)
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
                              labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                              hintText: myMapDetail[0]['bookMapTitle'],
                              hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          TextField(
                            maxLines: 2,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
                            controller: _sentencesEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.black87)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2, color: Colors.black87)
                              ),
                              suffixIcon: GestureDetector(
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.black38,
                                  size: 20,
                                ),
                                onTap: () => _sentencesEditingController.clear(),
                              ),
                              labelText: '북맵 소개글',
                              labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                              hintText: myMapDetail[0]['bookMapContent'],
                              hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          TextField(style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
                            controller: _keywordEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.black87)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2, color: Colors.black87)
                              ),
                              suffixIcon: GestureDetector(
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.black38,
                                  size: 20,
                                ),
                                onTap: () => _keywordEditingController.clear(),
                              ),
                              labelText: '키워드',
                              labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                              hintText: '#키워드1 #키워드2 #키워드3',
                              hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
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
                              child: Text('공개여부', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),)),
                          Expanded(
                            flex:3,
                            child: ToggleButtons(
                              onPressed: toggleSelect,
                              isSelected: isSelected,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('공개', style: TextStyle(fontSize: 14, color: Colors.black87)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('비공개', style: TextStyle(fontSize: 14, color: Colors.black87)),
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
                                    insetPadding: const  EdgeInsets.fromLTRB(100,0,100,0),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      TextButton(
                                        child: const Text('도서', style: TextStyle(fontSize: 14, color: Colors.black),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('메모', style: TextStyle(fontSize: 14, color: Colors.black),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          },child: Text('추가',
                            style: TextStyle(fontSize: 14, color: Colors.black87),),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),),
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.all(5))),
                        Expanded(
                          flex: 3,
                          child: OutlinedButton(onPressed: (){},
                              child: Text('저장', style: TextStyle(fontSize: 14, color: Colors.black87)),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white))),
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
                          if(num<=3){
                            books.add('https://postfiles.pstatic.net/MjAyMzA2MDlfMTUz/MDAxNjg2MzA5MTk2Njc1.e0lBE1zzXGIZIg03GQ6c-J2E6ahezLFCWsZMZWpolYAg.nomA0xkMNBmkhgZ8q84XIbwer4nE9_KxtBojTb_vYTMg.PNG.odb1127/image.png?type=w773');
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
                                        child: GestureDetector(
                                          onTap: (){
                                            print('삭제 확인: ${detailBooks[index1]}');
                                            detailBooks.removeAt(index1);
                                            print('삭제 완료: ${detailBooks}');
                                          },
                                          child: Image.network(books[index1],
                                              height: 130),
                                        ),
                                      );
                                    }),
                              )
                          );
                        }
                        else{
                          print('memo$detailMemo');
                          return Container(
                            decoration: BoxDecoration(color: Colors.orange.shade50),
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
                    ),
                  ],
                );
              }
              else if (snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              else{
                return CircularProgressIndicator();
              }
            },
          )
      ),
    );
  }

  void toggleSelect(value) {
    if(value == 0){
      open = true;
      close = false;
    }
    else{
      open = false;
      close = true;
    }
    setState(() {
      isSelected = [open, close];
    });
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