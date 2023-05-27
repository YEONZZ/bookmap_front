import 'dart:convert';

import 'package:bookmap/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:flutter/rendering.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:http/http.dart' as http;
import 'api_key.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //플러터 코어 엔진 초기화 - 파이어베이스 (비동기 방식)
  //await, async도 비동기 방식에 관한 것
  await Firebase.initializeApp();
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
    return Authentication();
    //Authentication은 인증 기능 구현을 위한 위젯
  }
}

class Authentication extends StatelessWidget {
  Authentication({Key? key}) : super(key: key);

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
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.only(top: 150),

            child: SignInScreen(
              //headerMaxExtent: double.infinity,
              showAuthActionSwitch: false,
              providerConfigs: const[
                GoogleProviderConfiguration(clientId: '103491580015438144329'),
              ],
              headerBuilder: (context, constraints, _) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    //lib\src\auth\screens\internal\responsive_page.dart 에 크기 조절하는 부분있음.
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
        else {
          return FutureBuilder(
            future: _postData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return MyApp();
            },
          );
        }
      },
    );
  }
}

Future<String> _postData() async {
  final _authentication = firebaseauth.FirebaseAuth.instance;
  final googleClientId = '1046810346715-4vq5b2ilab5hbilok0lsbfqug4eemaab.apps.googleusercontent.com';
  final callbackUrlScheme = 'com.googleusercontent.apps.1046810346715-4vq5b2ilab5hbilok0lsbfqug4eemaab';

  // final url = Uri.https('www.googleapis.com', '/o/oauth2/v2/auth', {
  //   'response_type': 'code',
  //   'client_id': googleClientId,
  //   'redirect_uri': '$callbackUrlScheme:/',
  //   'scope': 'email',
  // });

  var response = await http.post(Uri.parse(logApiKey + '/oauth/jwt/google'),
      headers: <String, String>{
        'client_id': googleClientId,
        'redirect_uri': '$callbackUrlScheme:/',
        'grant_type': 'authorization_code',
        'Content-Type': 'application/json',
        'charset' : 'utf-8',
        "email": '${_authentication.currentUser?.email}',
        "provider": 'google.com',
        "providerId": '${_authentication.currentUser?.uid}',
        "picture": '${_authentication.currentUser?.photoURL}'
      },
      body: jsonEncode({
        "getEmail": '${_authentication.currentUser?.email}',
        "getProvider": 'google.com',
        "getProviderId": '${_authentication.currentUser?.uid}',
        "getPicture": '${_authentication.currentUser?.photoURL}'
      })
  );
  return response.body;
}


// Future<String> join([String separator = ""]) async{
//   final _authentication = firebaseauth.FirebaseAuth.instance;
//   var userdata= {
//     _authentication.currentUser?.displayName,
//     _authentication.currentUser?.uid,
//     _authentication.currentUser?.photoURL,
//   };
//   return await userdata.toList().join(separator);
// }