import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import '../login.dart';
import 'package:bookmap/design/color.dart';

bool isOnPush = false;

class Setting extends StatefulWidget{
  Setting({super.key});

  @override
  State<StatefulWidget> createState() {
    return AppSetting();
  }
}

class AppSetting extends State<Setting>{
  final _authentication = firebaseauth.FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppSetting',
      theme: ThemeData(
        primaryColor: appcolor
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('앱 설정',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage())
                  );
                }
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top:20, left: 20),
                child: Text('알림', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),),),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top:20, left: 20),
                        child: Text('푸쉬 알림', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13)),
                      )),
                  Expanded(child: Switch(value: isOnPush,
                    activeColor: appcolor.shade600,
                    onChanged: (value) {
                    setState(() {
                      isOnPush = value;
                    });
                    }
                    ,))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top:20, left: 20),
                        child: Text('소리', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13)),
                      )),
                  Expanded(child: Switch(value: isOnPush,
                    activeColor: appcolor.shade600,
                    onChanged: (value) {
                      setState(() {
                        isOnPush = value;
                      });
                    }
                    ,))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top:20, left: 20),
                        child: Text('진동', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13)),
                      )),
                  Expanded(child: Switch(value: isOnPush,
                    activeColor: appcolor.shade600,
                    onChanged: (value) {
                      setState(() {
                        isOnPush = value;
                      });
                    }
                    ,))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: const Divider(
                  height: 5,
                  color: Colors.black26,
                ),
              ),
              Padding(padding: EdgeInsets.only(top:10, left: 20),
                child: Text('개인/보안', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),),),
              Container(
                padding: const EdgeInsets.only(left: 13, right: 13, top: 5),
                width: double.infinity,
                child: TextButton(onPressed:(){},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const Text('기기 연결 관리', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13),
                      ),
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(left: 13, right: 13, top: 5),
                width: double.infinity,
                child: TextButton(onPressed:(){},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('화면 잠금', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          const Text('사용 안 함/PIN', style: TextStyle(fontSize: 11, color: Colors.black38, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
              ),],
          ),
        ),
      )
    );
  }

}