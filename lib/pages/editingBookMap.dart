import 'package:flutter/material.dart';
import '../design/color.dart';

class EditingBookMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _EditingBookMap(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: appcolor,
      ),
    );
  }
}


class _EditingBookMap extends StatelessWidget{
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _sentencesEditingController = TextEditingController();
  final TextEditingController _keywordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                //decoration: BoxDecoration(),
                color: Colors.orange.shade200,
                width: double.infinity,
                height: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
                      controller: _titleEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.black87)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black87)
                        ),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onTap: () => _titleEditingController.clear(),
                        ),
                        labelText: '북맵 제목',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: '여행가고 싶은 곳들',
                        hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    TextField(
                      maxLines: 2,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
                      controller: _sentencesEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.black87)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black87)
                        ),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onTap: () => _sentencesEditingController.clear(),
                        ),
                        labelText: '북맵 소개글',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: '가고 싶은 여행지에 대한 책들을 담은 북맵\n제주도, 이탈리아, 아프리카 등등',
                        hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    TextField(style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
                      controller: _keywordEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.black87)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black87)
                        ),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onTap: () => _keywordEditingController.clear(),
                        ),
                        labelText: '키워드',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: '#키워드1 #키워드2 #키워드3',
                        hintStyle: TextStyle(color: Colors.black38, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Expanded(
                    flex: 3,
                    child: OutlinedButton(onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: const  EdgeInsets.fromLTRB(100,0,100,0),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  child: const Text('도서', style: TextStyle(fontSize: 14, color: Colors.black),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('메모', style: TextStyle(fontSize: 14, color: Colors.black),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },child: Text('추가',
                      style: TextStyle(fontSize: 14, color: Colors.black87),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),),
                  ),
                  Expanded(
                    flex: 1,
                      child: Padding(padding: EdgeInsets.all(10))),
                  Expanded(
                    flex: 3,
                    child: OutlinedButton(onPressed: (){},
                        child: Text('저장', style: TextStyle(fontSize: 14, color: Colors.black87)),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white))),
                  ),
                  Padding(padding: EdgeInsets.all(10))
                ],
              ),
              const Divider(
                height: 5,
                color: Colors.black54,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(2),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3839015/38390159619.20230502161943.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3243830/32438307676.20230425164231.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('images/plus_button.png', height: 130),
                    ),],
                ),
              ),
              const Divider(
                height: 3,
                color: Colors.black54,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange.shade50),
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_downward, size: 100),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('여행에 대한 책들을 읽다보니 제주도 여행을 가고 싶어졌어요.\n제주도에는 어떤 것들이 있을까?', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 3,
                color: Colors.black54,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(2),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3957069/39570696618.20230502162053.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3249189/32491898723.20221019101316.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3244498/32444983037.20221227202842.jpg?type=w300',
                          height: 130),
                    ),],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange.shade50),
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_downward, size: 100),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('아프리카도 가보고 싶어!', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(2),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3246667/32466672176.20221229074149.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3247677/32476772841.20230404163321.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3250508/32505089028.20221229071802.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3250610/32506106882.20221229070913.jpg?type=w300',
                          height: 130),
                    )],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange.shade50),
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_downward, size: 100),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('유럽도 가보고 싶어!\n이탈리아는 어떨까?', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(2),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3818761/38187614626.20230404162233.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3548320/35483200620.20230404163640.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3300228/33002289620.20230321162025.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3246710/32467101207.20221229074604.jpg?type=w300',
                          height: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network('https://shopping-phinf.pstatic.net/main_3250515/32505158692.20220527055317.jpg?type=w300',
                          height: 130),
                    )],
                ),
              ),

            ],
          )
      ),
    );
  }

}