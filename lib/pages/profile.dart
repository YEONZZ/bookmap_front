import 'package:bookmap/pages/help_notice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:bookmap/design/color.dart';
import 'package:bookmap/routes/profile_routes.dart';
import 'package:http/io_client.dart';

import 'dart:convert';
import '../api_key.dart';
import '../login.dart';
import 'help_complain.dart';
import 'help_terms.dart';

class Profile extends StatelessWidget {
  const Profile(token, {super.key});

  @override
  Widget build(BuildContext context) {
    //final _authentication = firebaseauth.FirebaseAuth.instance;
    return MaterialApp(
      routes: RoutesProfile.routesProfile,
      debugShowCheckedModeBanner: false,
      home: MyStatelessWidget(),
    );
  }
}

// scroll view 구현을 위한 수정 (4-28)
class MyStatelessWidget extends StatelessWidget{
  MyStatelessWidget({Key? key}) : super(key: key);
  final _authentication = firebaseauth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('마이페이지',
          style: TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Color(0xFF7FAD7F),
              ),
              onPressed: (){
                _authentication.signOut();
                Navigator.of(context).pushNamed(RoutesProfile.logout);
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<Map<String, dynamic>> dataList = snapshot.data!;
              print(dataList);
              var status;
              var readBooks;

              dynamic datas = [];


              for( var data in dataList){
                dynamic getData = data;
                status = getData['status'];
                readBooks = getData['readBooksCount'];
                datas.add(getData['profileMemoResponseDtos']);
              }

              var memoContent1 = "";
              var memoTitle1 = "";
              var memoContent2 = "";
              var memoTitle2 = "";
              print(datas[0].length);
              if (datas.length > 0 && datas[0].length >= 1 && datas[0][0].containsKey('title')) {
                memoTitle1 = datas[0][0]['title'];
                memoContent1 = datas[0][0]['content'];
              }
              if (datas.length > 0 && datas[0].length > 1 && datas[0][1].containsKey('title')) {
                memoTitle2 = datas[0][1]['title'];
                memoContent2 = datas[0][1]['content'];
              }
              print(memoContent1);
              print(memoTitle1);
              print(memoContent2);
              print(memoTitle2);


              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 25, left:25),
                              child: Text('${_authentication.currentUser?.displayName}',
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,)),),
                            Padding(
                                padding: EdgeInsets.only(left: 25, top: 10, bottom: 5),
                                child: Text('$status', style: TextStyle(color: Colors.black54, fontSize: 12),))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top:10)),
                            CircleAvatar(
                              radius: 25,
                              child: Image.network('${_authentication.currentUser?.photoURL}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(padding: EdgeInsets.only(top: 5)),
                  //독서기록 버튼2
                  Row(children: [
                    const Padding(padding: EdgeInsets.only(left: 25)),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed(RoutesProfile.edit);
                          },
                          style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black26),
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.white),
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text('프로필 편집', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),),
                              Padding(padding: EdgeInsets.only(top: 5))],)),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 25)),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed(RoutesProfile.calendar);
                          },
                          style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black26),
                                borderRadius: BorderRadius.all(Radius.circular(10)),),
                              backgroundColor: Colors.white),
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('완독', style: TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.bold),),
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  Text('$readBooks', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 5))],)),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 25)),
                  ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('※ 완독 수는 월별로 초기화됩니다.',
                      style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 11),
                      textAlign: TextAlign.left,),
                  ),
                  //독서노트 모아보기
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                    child: Column(
                        children: [
                          Row(children: [
                            const Expanded(flex: 10,
                                child: Text('독서 노트 모아보기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)),
                            Expanded(flex: 1, child: IconButton(onPressed:(){}, icon: const Icon(Icons.add))) ],),
                          if(memoContent1 != "" || memoTitle1 != "")
                          Card(
                              color: appcolor,
                              margin: EdgeInsets.all(0),
                              child: SizedBox(
                                child: ListTile(title: Text("$memoContent1", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                  subtitle: Text('$memoTitle1',style: TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
                                  mouseCursor: MouseCursor.uncontrolled,
                                ),)),
                          if(memoContent2 != "" || memoTitle2 != "")
                          Card(
                              color: appcolor,
                              margin: EdgeInsets.only(top:5),
                              child: SizedBox(
                                child: ListTile(title: Text("$memoTitle2", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                  subtitle: Text("$memoTitle2",style: TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
                                  mouseCursor: MouseCursor.uncontrolled,
                                ),))
            ]
                    ),
                  ),
                  const Divider(
                    indent: 25,
                    endIndent: 25,
                    height: 5,
                    color: Colors.black26,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                      alignment: Alignment.centerLeft,
                      child: const Text('도움말', style: TextStyle(fontSize: 15, color: Colors.black38, fontWeight: FontWeight.bold),)),

                  Container(
                    padding: const EdgeInsets.only(left: 19, right: 19, top: 10),
                    width: double.infinity,
                    child: TextButton(onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpComplain()),
                      );
                    },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text('문의', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 19, right: 19),
                    width: double.infinity,
                    child: TextButton(onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpNotice()),
                      );
                    },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text('공지사항', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 19, right: 19),
                    width: double.infinity,
                    child: TextButton(onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpTerms()),
                      );
                    },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text('서비스 이용 약관', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              );
            }else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _fetchData() async {

  final httpClient = IOClient();
  final userResponse = await httpClient.get(
      Uri.parse('$logApiKey/profile'), //수정 필요
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });

  var userinform = jsonDecode(utf8.decode(userResponse.bodyBytes));
  // final response = await client.get(Uri.parse(tmdbApiKey + '/main/4'));
  // var data = jsonDecode(utf8.decode(response.bodyBytes));

  List<Map<String, dynamic>> listData = [userinform]; // data를 리스트로 감싸기

  return listData;
}
