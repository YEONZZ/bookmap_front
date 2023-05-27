import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'editingBookMap.dart';

class BookmapEx extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _BookmapEx(),
    );
  }
}

class _BookmapEx extends StatelessWidget{
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
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('가고 싶은 여행지에 대한 책들을 담은 북맵\n제주도, 이탈리아, 아프리카 등등',
                  style: TextStyle(fontSize: 13,color: Colors.black54),
                  textAlign: TextAlign.right,),
                  Text('여행가고 싶은 곳들', style: TextStyle(fontSize: 25, color: Colors.black),
                  textAlign: TextAlign.right,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditingBookMap())
                  );
                }, child: Text('EDIT',
                style: TextStyle(fontSize: 14, color: Colors.black87, decoration: TextDecoration.underline),))
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