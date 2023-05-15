import 'package:bookmap/pages/profile.dart';
import 'package:bookmap/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:bookmap/design/color.dart';

class SearchDetailPage extends StatelessWidget {
  final dynamic data;

  const SearchDetailPage({Key? key, required this.data})
      : super(key: key); //Search()값 전달받음
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.light, primarySwatch: appcolor),
        debugShowCheckedModeBanner: false,
        home: SearchDetail(data: data),
    );
  }
}

class SearchDetail extends StatefulWidget {
  final dynamic data;
  const SearchDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchDetail();
}


class _SearchDetail extends State<SearchDetail> {
  late final dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    //print(data);
  }

  @override
  Widget build(BuildContext context) {
    if(data == null){
      return Center(child: Text('데이터 전송 오류'),);
    } else {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, data);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              data!['title'].toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(onPressed: (){
                
              }, icon: Icon(Icons.add_box, color: appcolor,)) //책 분류 버튼
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5),
                  color: const Color(0x7FD8D8D8),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1 / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.network(
                          data!['thumbnail'],
                          fit: BoxFit.contain,
                          width: 200,
                          height: 200,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '저자 : ${data!['authors'].join(', ')}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container( //날짜 컨테이너
                //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                //   width: MediaQuery.of(context).size.width,
                //   height:MediaQuery.of(context).size.height*0.05,
                //   child: Row(
                //     children: [
                //       const Expanded(
                //           flex: 10,
                //           child: Text('시작일로부터 OO일째 읽고 있어요!',
                //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                //       ),
                //       Text('수정',
                //           style: TextStyle(fontSize: 15, color: Colors.black)
                //       ),
                //     ],
                //   ),
                // ),
                // Container( //그래프 컨테이너
                //   width: MediaQuery.of(context).size.width,
                //   height:MediaQuery.of(context).size.height*0.05,
                //   child: Row(
                //     children: [
                //       Text('그래프 들어갈 공간')
                //     ],
                //   ),
                // ),
                Container( //북맵 알려주는 컨테이너
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  height:MediaQuery.of(context).size.height*0.05,
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 10,
                          child: Text('이 책은 SF 북맵에 담긴 책이에요.',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ),
                      Text('더보기',
                          style: TextStyle(fontSize: 15, color: Colors.black)
                      ),
                    ],
                  ),
                ),
                Container(
                  color: const Color(0x7FD8D8D8),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Image.network(
                              'https://search.pstatic.net/common/?src=https%3A%2F%2Fshopping-phinf.pstatic.net%2Fmain_3248032%2F32480322263.20230313182754.jpg&type=w216',
                              width: 90,
                              height: 120,
                              fit: BoxFit.fill),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Image.network(
                              'https://search.pstatic.net/common/?src=https%3A%2F%2Fshopping-phinf.pstatic.net%2Fmain_3247557%2F32475579086.20230328163141.jpg&type=w276',
                              width: 90,
                              height: 120,
                              fit: BoxFit.fill),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Image.network(
                              'https://search.pstatic.net/common/?src=https%3A%2F%2Fshopping-phinf.pstatic.net%2Fmain_3243634%2F32436342677.20230502162507.jpg&type=w276',
                              width: 90,
                              height: 120,
                              fit: BoxFit.fill),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Image.network(
                              'https://search.pstatic.net/common?type=f&size=210x296&quality=75&direct=true&src=https%3A%2F%2Fbookthumb-phinf.pstatic.net%2Fcover%2F211%2F561%2F21156169.jpg%3Ftype%3Dm200_290%26udate%3D20230317',
                              width: 90,
                              height: 120,
                              fit: BoxFit.fill),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //여기에 bottom Tabbar 추가할것
        ),
      );
    }
  }
}
