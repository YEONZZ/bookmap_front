import 'package:bookmap/pages/scrapDetail.dart';
import 'package:bookmap/pages/search_detail.dart';
import 'package:bookmap/pages/search_detail_get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import '../api_key.dart';
import '../design/color.dart';
import '../login.dart';
int check = 0;
class Search extends StatelessWidget {
  const Search(token, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  const HttpApp({super.key});

  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late TextEditingController? _editingController;
  ScrollController? _scrollController;
  static List? data;
  int page = 1;
  final FocusNode _focusNode = FocusNode();
  String? searchQuery;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();

    if (data == null) {
      data = new List.empty(growable: true);
    }
    //print(reData); //아직 아무것도 찍히지않음
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();
    _scrollController!.addListener(() {
      if(_tabController.index == 0){
        if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
            !_scrollController!.position.outOfRange) {
          page++;
          getJSONData();
        }
      }
      else{
        if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
            !_scrollController!.position.outOfRange) {
          page++;
          getBookMapData(_editingController);
        }
      }}
    );
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
              title: Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _editingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: searchQuery ?? '검색어를 입력하세요.',
                          border: InputBorder.none,
                          icon: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Icon(Icons.search, color: appcolor.shade700),
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        onEditingComplete: () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isLoading = true;
                          });
                          page = 1;
                          data!.clear();
                          await getJSONData();
                          //print('!!!?????');

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        onChanged: (text) {
                          setState(() {
                            searchQuery = text; // 검색어 업데이트
                            //print(searchQuery); //검색어 출력
                          });
                        },
                      ),
                    ),
                    if (searchQuery != null && searchQuery!.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: appcolor.shade700),
                        onPressed: () {
                          setState(() {
                            _editingController?.clear();
                            searchQuery = null;
                          });
                        },
                      ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: [Tab(text: '도서'), Tab(text: '북맵')],
                onTap: (index){
                  // switch (index){
                  //   case 0:
                  //     setState(() {
                  //       check = 0;
                  //     });
                  //     break;
                  //
                  //   case 1:
                  //     setState(() {
                  //       check = 1;
                  //     });
                  //     break;
                  // }
                },
              ),
            ),
            body: _isLoading
                ? LoadingIndicator() //로딩중이 아닐때
                : GestureDetector(
              onTap: () {
                _focusNode.unfocus(); //화면 터치시 키보드 내림
              },
              child: FocusScope(
                  child: TabBarView(
                    controller: _tabController,
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
                            String kakaoIsbn = data![index]['isbn'];
                            return GestureDetector(
                              onTap: () async {
                                var check = await trueFalse(kakaoIsbn);
                                //print('확인: $check');
                                if(check){
                                  //print('확인용');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchDetailGetPage(homeIsbn: kakaoIsbn,),
                                    ),
                                  );
                                } else {
                                  var searchData = await _fetchISBN(kakaoIsbn);
                                  //print('카카오isbn: ${kakaoIsbn}');
                                  //print('검색결과: ${searchData}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchDetailPage(searchData: searchData),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Image.network(
                                          data![index]['thumbnail'],
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.contain,
                                          errorBuilder: (BuildContext
                                          context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: const Text('이미지없음',
                                                  textAlign: TextAlign.center),
                                            );
                                          } // 대체 이미지를 반환
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(8),
                                            width:
                                            MediaQuery.of(context).size.width - 150,
                                            child: Text(
                                              data![index]['title'].toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(bottom: 8),
                                              width: MediaQuery.of(context).size.width - 150,
                                              child: Text(
                                                  '저자 : ${data![index]['authors'].join(', ')}',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 13),
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center)),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 20),
                                            width: MediaQuery.of(context).size.width - 150,
                                            child: Text(data![index]['contents'].toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black38),
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
                      BookMapSearchScreen(_editingController!)
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

class BookMapSearchScreen extends StatefulWidget{
  TextEditingController _editingController;
  BookMapSearchScreen(this._editingController, {super.key});

  @override
  State<StatefulWidget> createState() => _BookMapSearchScreen(_editingController);
}

class _BookMapSearchScreen extends State<BookMapSearchScreen>{
  String searchData = '';
  TextEditingController _editingController;

  _BookMapSearchScreen(this._editingController);
  ScrollController? _scrollController;
  late List<Map<String, dynamic>> data = getBookMapData(_editingController) as List<Map<String, dynamic>>;
  //late List<dynamic> data = [dataFuture].toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      child: FutureBuilder<List>(
        future: getBookMapData(_editingController),
        builder: (context, snapshot){
          if (snapshot.hasData){
            List Bookmap = snapshot.data!;
            return ListView.builder(
              //shrinkWrap: true,
              itemCount: Bookmap.length,
              itemBuilder: (context, index){
                var myBookmap = Bookmap[index];
                //var mapId = myBookmap;
                var title = myBookmap['bookMapTitle'];
                print("확인!!!!!!!!! $title");
                //var content = myBookmap['bookMapContent'];
                var bookmapimg = myBookmap['bookMapImage'];
                if (bookmapimg == null){
                  bookmapimg = 'https://search.pstatic.net/sunny/?src=http%3A%2F%2Fimg.ssfshop.com%2Fcmd%2FLB_500x660%2Fsrc%2Fhttp%3A%2Fimg.ssfshop.com%2Fgoods%2FHMBR%2F19%2F04%2F08%2FGM0019040873391_7_ORGINL.jpg&type=sc960_832';
                }
                //var keyword = myBookmap['hashTag'];
                var share = myBookmap['share'];
                if(share == true){
                  return GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrapDetail(myBookmap),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: appcolor.shade50,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.network(bookmapimg,
                                height: 80,
                                width: 80,
                                fit: BoxFit.fitWidth),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                    textAlign: TextAlign.start),
                                const Text(''),
                                //Text(content, textAlign: TextAlign.start, style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.w100))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }
          else if (snapshot.hasError){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '검색창에 북맵 이름 또는 키워드를 입력해주세요.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          else{
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  int check = 2;
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

Future<List> getBookMapData(editingController) async {
  //print("!!!!!!!!!!!!!!!!!!!${editingController.value}");
  final httpClient = IOClient();
  final bookmapResponse = await httpClient.get(
      Uri.parse('$bookmapKey/bookmap/search/${editingController!.value.text}'),
      headers: <String, String>{
        'Content-Type': 'application/json'
        //  'Authorization': 'Bearer $token'
      }
  );
  //print(response.body); // 검색 결과 로그창으로 확인

  List<dynamic> bookmaplist = jsonDecode(utf8.decode(bookmapResponse.bodyBytes));

  List arraylist = [bookmaplist];
  print(bookmaplist);
  return List<dynamic>.from(bookmaplist);
}

Future<Map<String, dynamic>> _fetchISBN(kakaoIsbn) async {
  http.Client client = http.Client();
  final response = await client.get(Uri.parse(tmdbApiKey + '/book/detail?isbn='+'${kakaoIsbn}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  print(token);
  var searchData = jsonDecode(utf8.decode(response.bodyBytes));

  return searchData;
}

Future<bool> trueFalse(kakaoIsbn) async {
  http.Client client = http.Client();
  final response = await client.get(Uri.parse(tmdbApiKey + '/book/savedornot?isbn='+'${kakaoIsbn}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  var data = jsonDecode(utf8.decode(response.bodyBytes));

  return data;
}