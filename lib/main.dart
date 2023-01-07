import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_overflow/animated_overflow.dart';
import 'package:flutter/cupertino.dart';
import 'notification.dart';

import './style.dart' as style;
import './pages/letter.dart';
import './pages/notice.dart';



void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   var buttonName = ['출석체크', '조퇴/외출/결석', '도시락 신청', 'Daily Test', '주간 영어 모의고사 신청', '모의고사 신청', '상담 신청'];

   @override
  void initState() {
    super.initState();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton:
        FloatingActionButton.extended(
          onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => letterUI() ));},
          label: Text('익명 편지', style: style.floatingText),
          icon: Icon(Icons.mail, color: Colors.white, size: 30),
          backgroundColor: Color(0xff0B01A2),
        ),

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            title: Row(
              children: [
                Image.asset('assets/Logo.png', width: 80),
                Text('올케어 관리형 독학관'),
              ],
            ),

            actions: [
              Column(children: [
                Text('김OO',style: style.barText),
                Text('수능',style: style.barText),
              ],),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications, size: 33,), onPressed: (){showNotification(); Navigator.push(context, CupertinoPageRoute(builder: (c) => noticeUI() ));}
                  ),
                  alertIconUI()
                ],
              ),
            ],

          ),
        ),

        body: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
          color: Color(0xffefefef),
          child: ListView.builder(
              itemCount: buttonName.length + 1,
              itemBuilder: (c, i){
                if (i == 0) return noticeAlert();
                return ListTile(
                  title: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                    height: 57,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text(buttonName[i - 1], style: style.normalText,),
                    ),
                  ),
                );
              }
              ),
        ),
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////


class noticeAlert extends StatelessWidget {
  const noticeAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
            width: 2,
            color: Color(0xffff0000)
          ),
            borderRadius: BorderRadius.circular(15),
            color: Color(0xffffffff)
        ),
        child: Row(
          children: [
            Container(margin: EdgeInsets.fromLTRB(7, 0, 5, 0) ,child: Image(image: AssetImage("assets/speaker.png"),width: 30,)),
            AnimatedOverflow(
              animatedOverflowDirection: AnimatedOverflowDirection.HORIZONTAL,
              maxWidth: _width / 1.5,
              padding: 0,
              speed: 70.0,
              child: Text(
                "긴급공지 쓰는곳... on/off 설정 가능!",
                style: style.speakerText,
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class alertIconUI extends StatelessWidget {
  const alertIconUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 5),
      child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffc32c37),
              border: Border.all(color: Color(0xff0B01A2), width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: Text('N', style: style.noticeIconText,),
            ),
          )
      ),
    );
  }
}





