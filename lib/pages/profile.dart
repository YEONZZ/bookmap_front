import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:bookmap/design/color.dart';
import 'package:bookmap/routes/profile_routes.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
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
        child: Column(
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
                      const Padding(
                          padding: EdgeInsets.only(left: 25, top: 10, bottom: 15),
                          child: Text('상태메시지-db작업 필요', style: TextStyle(color: Colors.black, fontSize: 12),))
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: 23,
                    child: Image.network('${_authentication.currentUser?.photoURL}',),
                  ),
                ),
              ],
            ),

            //Body: 편집 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(left: 25)),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(RoutesProfile.edit);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(appcolor.shade50),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: appcolor.shade50)
                            )),),
                      child: const Text("프로필 편집", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),)),),
                const Expanded(flex: 1,child: Padding(padding: EdgeInsets.only(left: 10)),),

                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(RoutesProfile.setting);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(appcolor.shade50),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: appcolor.shade50))),),
                      child: const Text("앱 설정", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),)),),
                const Padding(padding: EdgeInsets.only(left: 25)),],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            //독서기록 버튼2
            Row(children: [
              const Padding(padding: EdgeInsets.only(left: 25)),
              Expanded(flex: 1,
                  child: TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed(RoutesProfile.calendar);
                    },
                    style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),),
                        backgroundColor: Colors.white),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('완독', style: TextStyle(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('2', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 5))],),)),
              Expanded(flex: 1,
                child: TextButton(onPressed: (){},
                    style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black26), borderRadius: BorderRadius.all(Radius.circular(0))),
                        backgroundColor: Colors.white),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('페이지',
                          style: TextStyle(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('138', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 5))],)),),
              Expanded(flex: 1,
                child: TextButton(onPressed: (){},
                    style: TextButton.styleFrom(backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black26), borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),)),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('일', style: TextStyle(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('3', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 5))],)),),
              const Padding(padding: EdgeInsets.only(right: 25)),
            ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
              alignment: Alignment.centerLeft,
              child: const Text('최근 1개월동안의 독서기록 요약입니다.',
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
                    const Card(
                        color: appcolor,
                        margin: EdgeInsets.all(0),
                        child: SizedBox(
                          child: ListTile(title: Text('책 메모의 초기 n글자 출력', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            subtitle: Text('*책이름 을 읽고',style: TextStyle(fontSize: 11),),
                            mouseCursor: MouseCursor.uncontrolled,
                          ),)),
                    const Card(
                        color: appcolor,
                        margin: EdgeInsets.only(top:5),
                        child: SizedBox(
                          child: ListTile(title: Text('책 메모의 초기 n글자 출력', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            subtitle: Text('*책이름 을 읽고',style: TextStyle(fontSize: 11),),
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
              padding: const EdgeInsets.only(left: 19, right: 19, top: 5),
              width: double.infinity,
              child: TextButton(onPressed:(){},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('문의', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 19, right: 19),
              width: double.infinity,
              child: TextButton(onPressed:(){},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('공지사항', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 19, right: 19),
              width: double.infinity,
              child: TextButton(onPressed:(){},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('서비스 이용 약관', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );

  }
}
