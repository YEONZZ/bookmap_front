import 'package:bookmap/pages/library.dart';
import 'package:bookmap/pages/search_detail.dart';
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
  static List? data;
  int page = 1;
  final FocusNode _focusNode = FocusNode();

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
        page++;
        getJSONData();
      }
    });
  }
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, //탭수
        child: Scaffold(
            resizeToAvoidBottomInset: false, // 키보드 위 여백 없애기
            appBar: AppBar(
              backgroundColor: appcolor,
              title: TextField(
                focusNode: _focusNode,
                controller: _editingController,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: '검색어를 입력하세요.'),
                textInputAction: TextInputAction.search,
                onEditingComplete: () async {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isLoading = true;
                  });
                  page = 1;
                  data!.clear();
                  await getJSONData();

                  setState(() {
                    _isLoading = false;
                  });
                },
                onChanged: (text) {
                  setState(() {});
                },
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [Tab(text: '도서'), Tab(text: '북맵')],
              ),
              actions: <Widget>[
                _editingController!.text.isEmpty ?
                IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _editingController!.clear();
                          setState(() {});
                        },
                      ),
              ],
            ),
            body: _isLoading ? LoadingIndicator() //로딩중이 아닐때
            : GestureDetector(
              onTap: () {
                _focusNode.unfocus(); //화면 터치시 키보드 내림
              },
              child: FocusScope(
                  child: TabBarView(
                children: [
                  Center(
                    child: data!.length == 0
                        ? Text(
                            '데이터가 존재하지 않습니다.\n검색해주세요',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push (
                                    context,
                                    MaterialPageRoute(builder: (context) => SearchDetailPage(data: data![index])),
                                  );
                                },
                                child: Card(
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Image.network(data![index]['thumbnail'],
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.contain,
                                            errorBuilder: (
                                            BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Padding(
                                            padding: const EdgeInsets.all(30),
                                            child: const Text('이미지없음', textAlign: TextAlign.center),
                                          );
                                        } // 대체 이미지를 반환
                                            ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              width: MediaQuery.of(context).size.width - 150,
                                              child: Text(
                                                data![index]['title'].toString(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                           Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                width: MediaQuery.of(context).size.width - 150,
                                                child: Text(
                                                    '저자 : ${data![index]['authors'].join(', ')}',
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center)),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 20),
                                              width: MediaQuery.of(context).size.width - 150,
                                              child: Text(
                                                  data![index]['contents'].toString(),
                                                  style: TextStyle(fontSize: 14),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ],
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.start,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: data!.length,
                            controller: _scrollController,
                          ),
                  ),
                  Center(
                    child: Text('북맵검색결과'),
                  )
                ],
              )),
            )));
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

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
