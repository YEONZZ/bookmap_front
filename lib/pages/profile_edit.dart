import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import '../login.dart';
import 'package:bookmap/design/color.dart';


class Edit extends StatelessWidget{
  const Edit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileEdit(),
    );
  }
}

class ProfileEdit extends StatelessWidget{
  final _authentication = firebaseauth.FirebaseAuth.instance;
  ProfileEdit({Key? key}) : super(key: key);
  final TextEditingController _nicknameEditingController = TextEditingController();
  final TextEditingController _statusEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('프로필 편집',
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
                    MaterialPageRoute(builder: (context) => Login())
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
            Padding(padding: EdgeInsets.all(10)),
            Center(
              child: CircleAvatar(
                radius: 45,
                child: Image.network('${_authentication.currentUser?.photoURL}',),
              )
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  autofocus : true,
                  style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                  cursorColor: appcolor,
                  textInputAction: TextInputAction.next,
                  controller: _nicknameEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: appcolor.shade900)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: appcolor.shade600)
                    ),
                    suffixIcon: GestureDetector(
                      child: const Icon(
                        Icons.cancel,
                        color: appcolor,
                        size: 20,
                      ),
                      onTap: () => _nicknameEditingController.clear(),
                    ),
                    labelText: '닉네임',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: '${_authentication.currentUser?.displayName}',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                    cursorColor: appcolor,
                    textInputAction: TextInputAction.done,
                    controller: _statusEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: appcolor.shade600)
                      ),
                      suffixIcon: GestureDetector(
                        child: const Icon(
                          Icons.cancel,
                          color: appcolor,
                          size: 20,
                        ),
                        onTap: () => _statusEditingController.clear(),
                      ),
                      labelText: '상태메시지',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: '상태메시지를 입력해주세요.',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(flex: 5,
                      child: Text('회원정보를 삭제하시겠어요?',
                        style: TextStyle(color: Colors.black38, fontSize: 10),)),
                Expanded(flex: 1,
                    child: TextButton(onPressed: (){},
                      style: ButtonStyle(alignment: Alignment.centerRight),
                      child: Text('회원 탈퇴',
                        style: TextStyle(color: Colors.black38, fontSize: 10),),))],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: TextButton(onPressed: (){
                  //사용자의 닉네임과 상태메세지 데이터를 변경하는 작업 필요
                },
                child: Text('저장',
                style: TextStyle(color: Colors.white, fontSize: 13),),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(appcolor.shade600)),)
              )
            )
          ],
        ),
      ),
    );
  }
}

