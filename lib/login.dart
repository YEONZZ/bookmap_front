import 'dart:convert';
import 'package:bookmap/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutterfire_ui/auth.dart';
import 'api_key.dart';
import 'package:http/io_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool shouldUseFirestoreEmulator = false;
var token = null;

//230528 서버로 사용자 정보 보내려면 앱 시작할 때 main말고 login.dart로 실행하기
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //플러터 코어 엔진 초기화 - 파이어베이스 (비동기 방식)
  //await, async도 비동기 방식에 관한 것

  await Firebase.initializeApp(
      options: const FirebaseOptions
        (apiKey: 'AIzaSyCgaycqfp5RTa83bskUumkhWzgzVu6PGWY',
          appId: '1:205578501902:android:0e919009bf38aa23c2615f',
          messagingSenderId: '205578501902',
          projectId: 'fentarim-c479e')
  );
  if(shouldUseFirestoreEmulator){
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Authentication();
    //Authentication 인증 기능 구현을 위한 위젯
  }
}

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //사용자의 로그인 및 로그아웃을 기억하고, 그에 따른 변화를 다루는 위젯
      stream: firebaseauth.FirebaseAuth.instance.authStateChanges(),
      //snapshot: stream의 결과물, 스트림빌더에게 사용하도록 지정해주는 데이터
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //로그인을 하지 않은 경우
          return Container(
            color: const Color(0xFFFAFAFA),
            padding: const EdgeInsets.only(top: 150),

            child: SignInScreen(
              showAuthActionSwitch: false,
              providerConfigs: const[
                GoogleProviderConfiguration(clientId: '103491580015438144329'),
              ],
              headerBuilder: (context, constraints, _) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Image.asset(
                      'images/logo.png', fit: BoxFit.fitWidth,),
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('최초 로그인 시 북맵 회원가입이 진행됩니다.',
                      style: TextStyle(color: Colors.grey),)
                );
              },
            ),
          );
        }
        else { //로그인 시
          return FutureBuilder(
            future: _postData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // 오류 처리
                  return Text('오류 발생: ${snapshot.error}');
                } else {
                  // 성공적 으로 결과를 받은 경우
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => MyApp(token)));
                  return MyApp(token);
                }
              } else {
                // 아직 작업이 완료 되지 않은 경우 로딩 표시 등을 표시할 수 있음
                return const CircularProgressIndicator();
              }
            },
          );
        }
      },
    );
  }
}

Future<String> _postData() async {
  final authentication = firebaseauth.FirebaseAuth.instance;
  const serverClientId = '1046810346715-4vq5b2ilab5hbilok0lsbfqug4eemaab.apps.googleusercontent.com';
  const callbackUrlScheme = 'com.googleusercontent.apps.1046810346715-4vq5b2ilab5hbilok0lsbfqug4eemaab';
  final httpClient = IOClient(); // IOClient를 생성하여 캐시를 초기화합니다.

  final response = await httpClient.post(
    Uri.parse('$logApiKey/oauth/jwt/google'),
    headers: <String, String>{
      'serverClientId': serverClientId,
      'redirect_uri': '$callbackUrlScheme:/',
      'grant_type': 'authorization_code',
      'Content-Type': 'application/json',
      'charset': 'utf-8'
    },
    body: jsonEncode({
      "email": '${authentication.currentUser?.email}',
      "googleId": '${authentication.currentUser?.uid}',
      "picture": '${authentication.currentUser?.photoURL}',
      "name": '${authentication.currentUser?.displayName}'
    }),
  );

  // 요청 완료 후 httpClient를 닫습니다.
  httpClient.close();
  if (response.statusCode == 200) {
    // 성공 적인 응답인 경우
    if (kDebugMode) {
      print('서버 응답 성공');
      print('헤더: ${response.headers}');
      print('반응: ${response.body}');
    }

    final user = User(
        displayName: '${authentication.currentUser?.displayName}',
        email: '${authentication.currentUser?.email}',
        photoURL: '${authentication.currentUser?.photoURL}',
        uid: '${authentication.currentUser?.uid}',
        token: response.body
      );
     token = response.body.toString();
    FirebaseFirestore.instance
        .collection('users').doc('${authentication.currentUser?.uid}').set(user.toJason(), SetOptions(merge: true));

    return response.body;
  } else { // 오류 응답인 경우
    if (kDebugMode) {
      print('서버 응답 오류');
      print('상태 코드: ${response.statusCode}');
      print('반응: ${response.body}'); //토큰, 추후 저장 필요
    }
    // 오류 처리를 수행하거나 적절한 메시지를 표시하는 등의 작업을 수행할 수 있습니다.
    throw Exception('서버 응답 오류 발생');
  }
}

class User{
  User({
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.uid,
    required this.token
});

  User.fromJson(Map<String, Object?> json)
      : this(
      displayName: json['displayName']! as String,
      email: json['email']! as String,
      photoURL: json['photoURL']! as String,
      uid: json['uid']! as String,
      token: json['token']! as String
  );

  final String displayName;
  final String email;
  final String photoURL;
  final String uid;
  final String token;

  Map<String, Object?> toJason(){
    return{
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'uid': uid,
      'token': token
    };
  }
}