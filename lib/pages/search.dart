import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result = '';
  TextEditingController? _editingController;
  ScrollController? _scrollController;
  List? data;
  int page = 1;

  @override
  void initState() {
    super.initState();
    data = new List.empty(growable: true);
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
          _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        print('bottom');
        page++;
        getJSONData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요'),
        ),
        actions: <Widget>[
          IconButton(onPressed: (){
            page = 1;
            data!.clear();
            getJSONData();
          },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        child: Center(
          child: data!.length == 0
              ? Text(
            '데이터가 존재하지 않습니다.\n검색해주세요',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          )
              : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        data![index]['thumbnail'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width:
                            MediaQuery.of(context).size.width - 150,
                            child: Text(
                              data![index]['title'].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                              '저자 : ${data![index]['authors'].toString()}'),
                          Text(
                              '가격 : ${data![index]['sale_price'].toString()}'),
                          Text(
                              '판매중 : ${data![index]['status'].toString()}'),
                        ],
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                ),
              );
            },
            itemCount: data!.length,
            controller: _scrollController,
          ),
        ),
      ),
    );
  }

  Future<String> getJSONData() async {
    var url =
        'https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${_editingController!.value.text}';

    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": "KakaoAK 15143c9a4aee2d6700abc8ef957d0dc6"});

    //print(response.body); // 검색 결과 로그창으로 확인

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON['documents'];
      data!.addAll(result);
    });
    return response.body;
  }
}