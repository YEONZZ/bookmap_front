import 'package:bookmap/pages/editingBookMap.dart';
import 'package:bookmap/pages/search_detail.dart';
import 'package:bookmap/pages/search_detail_get.dart';
import 'package:flutter/foundation.dart';
import '../login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import '../api_key.dart';
import '../design/color.dart';
import 'bookmap_example.dart';

int check = 0;
class SearchInBookMap extends StatelessWidget {
  int mapIndex;
  dynamic myBookmap;
  SearchInBookMap(this.mapIndex, this.myBookmap);

  // final mapId;
  // const SearchInBookMap(this.mapId, {super.key});
  //Search({required this.screens});
  //final List<Widget> screens;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HttpAppSB(this.mapIndex, this.myBookmap),
    );
  }
}

class HttpAppSB extends StatefulWidget {
  var mapIndex;
  var myBookmap;
  HttpAppSB(this.mapIndex, this.myBookmap);
  @override
  State<StatefulWidget> createState() => _HttpAppSB(mapIndex, myBookmap);
}

class _HttpAppSB extends State<HttpAppSB> with SingleTickerProviderStateMixin{
  var mapIndex;
  var myBookmap;
  late TabController _tabController;
  late TextEditingController? _editingController;
  ScrollController? _scrollController;
  static List? data;
  int page = 1;
  final FocusNode _focusNode = FocusNode();
  String? searchQuery;
  late bool have;

  _HttpAppSB(this.mapIndex, this.myBookmap);

  @override
  void initState() {
    _tabController = TabController(
      length: 1,
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
        }
      }}
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1, //탭수
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
              // bottom: TabBar(
              //   controller: _tabController,
              //   indicatorColor: Colors.white,
              //   tabs: [Tab(text: '도서'), Tab(text: '북맵')],
              //   onTap: (index){
              //     switch (index){
              //       case 0:
              //         setState(() {
              //           check = 0;
              //         });
              //         break;
              //
              //       case 1:
              //         setState(() {
              //           check = 1;
              //         });
              //         break;
              //     }
              //   },
              // ),
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
                                var searchData = await _fetchISBN(kakaoIsbn);
                                var isbn = searchData['isbn'].toString();
                                var image = searchData['image'].toString();
                                var mapId = myBookmap['bookMapId'];
                                for (dynamic book in myBookmap['bookMapIndex'][mapIndex]['map']){
                                  if (isbn.compareTo(book['isbn'].toString()) == 0){
                                    have = true;
                                    break;
                                  }
                                  else
                                    have = false;
                                }
                                myBookmap['bookMapIndex'][mapIndex]['map'].add(
                                    {"id" : null,
                                    "isbn" : isbn,
                                    "image" : image});
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) => EditingBookMap(mapId, searchData: myBookmap,)))
                                    .then((value) => setState(() {}));
                                //print('카카오isbn: ${kakaoIsbn}');
                                //print('검색결과: ${searchData}');
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
                      // BookMapSearchScreen(_editingController!)
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
  Future<String> _postExtra(mapId, myBookMapDetail) async {
    final response = await http.post(
      Uri.parse('$bookmapKey/bookmap/extra/save/$mapId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(myBookMapDetail),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    else
      throw Exception(" 오류 ");
  }
}

// class BookMapSearchScreen extends StatefulWidget{
//   TextEditingController editingController;
//   BookMapSearchScreen(this.editingController, {super.key});
//
//   @override
//   State<StatefulWidget> createState() => _BookMapSearchScreen();
// }

// class _BookMapSearchScreen extends State<BookMapSearchScreen>{
//   String searchData = '';
//   List data = [];
//   ScrollController? _scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: data!.length == 0
//           ? Text(
//         '데이터가 존재하지 않습니다.\n북맵 제목 또는 키워드를 검색해주세요.',
//         style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
//         textAlign: TextAlign.center,
//       )
//           : ListView.builder(
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () async {
//               // final searchResult = await Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //       builder: (context) =>
//               //           SearchDetailPage( //북맵 상세 페이지에 대한 dart를 만들고 이로 변경해야한다.
//               //               data: data![index])),
//               // );
//
//               // setState(() {
//               //   searchData = searchResult; //SearchDetailPage값 가져오기
//               // }
//               // );
//             },
//             child: Card(
//               child: Container(
//                 child: Row(
//                   children: <Widget>[
//                     Image.network(
//                         data![index]['thumbnail'],
//                         height: 80, width: 80,
//                         fit: BoxFit.fitWidth,
//                         errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
//                           return Padding(
//                             padding: const EdgeInsets.all(30),
//                             child: const Text('No Image',
//                               textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 11),),
//                           );
//                         } // 대체 이미지를 반환
//                     ),
//                     Column(
//                       children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.all(8),
//                           width:
//                           MediaQuery.of(context).size.width - 80,
//                           child: Text(
//                             data![index]['title'].toString(),
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Container(
//                             margin: EdgeInsets.only(bottom: 8),
//                             width: MediaQuery.of(context).size.width - 80,
//                             child: Text(
//                                 '저자 : ${data![index]['authors'].join(', ')}',
//                                 style: TextStyle(
//                                     color: Colors.black45,
//                                     fontSize: 11),
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.center)),
//                         Container(
//                           margin: EdgeInsets.only(bottom: 20),
//                           width: MediaQuery.of(context).size.width - 150,
//                           child: Text(data![index]['contents'].toString(),
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.black38),
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                       ],
//                     )
//                   ],
//                   mainAxisAlignment: MainAxisAlignment.start,
//                 ),
//               ),
//             ),
//           );
//         },
//         itemCount: data!.length,
//         controller: _scrollController,
//       ),
//     );
//   }
// }

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


Future<Map<String, dynamic>> _fetchISBN(kakaoIsbn) async {
  http.Client client = http.Client();
  final response = await client.get(Uri.parse(tmdbApiKey + '/bookdetail/1?isbn='+'${kakaoIsbn}'));
  var searchData = jsonDecode(utf8.decode(response.bodyBytes));

  return searchData;
}

Future<bool> trueFalse(kakaoIsbn) async {
  http.Client client = http.Client();
  final response = await client.get(Uri.parse(tmdbApiKey + '/book/savedornot/1?isbn='+'${kakaoIsbn}'));
  var data = jsonDecode(utf8.decode(response.bodyBytes));

  return data;
}