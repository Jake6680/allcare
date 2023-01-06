import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_overflow/animated_overflow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'notification.dart';

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
      // Container(
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: Colors.teal,
          //     width: 3,
          //   ),
          //   borderRadius: BorderRadius.all(
          //   Radius.circular(30)
          //   ),
          // ),
          // child:
        FloatingActionButton.extended(
          onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => letterUI() ));},
          label: Text('익명 편지', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
          icon: Icon(Icons.mail, color: Colors.white, size: 30,),
          backgroundColor: Color(0xff0B01A2),

        ),
      // ),


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
                    icon: Icon(Icons.notifications, size: 35,), onPressed: (){showNotification(); Navigator.push(context, CupertinoPageRoute(builder: (c) => noticeUI() ));}
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
//#################################################################################################

class noticeUI extends StatelessWidget {
  const noticeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('공지함', style: style.normalText),
      ),
    );
  }
}



class letterUI extends StatefulWidget {
  letterUI({Key? key}) : super(key: key);

  @override
  State<letterUI> createState() => _letterUIState();
}

class _letterUIState extends State<letterUI> {
  var letterData = TextEditingController();

  setUserContent(text) async{
    var content = await SharedPreferences.getInstance();
    content.setString('letterContent', text);
  }

  getUserContent() async{
    var content = await SharedPreferences.getInstance();
    var letterContented = content.getString('letterContent');
    if (letterContented != null) {
      setState(() {
        letterData.text = letterContented;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      getUserContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){ showDialog(context: context, builder: (context) => sendDialog(letterData : letterData.text) );},
          label: Text('보내기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
          icon: Icon(Icons.outgoing_mail, color: Colors.white, size: 30,),
          backgroundColor: Color(0xff0B01A2),
        ),

      appBar: AppBar(centerTitle: true, title: Text('익명 편지쓰기')),
      body:SizedBox(
        height: double.infinity,
        child: TextField(
          onChanged: (text){ setUserContent(text); },
          controller: letterData,
          maxLines: 35,
          minLines: 1,
          style: TextStyle( fontSize: 18, fontWeight: FontWeight.w400 ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15),
            border: InputBorder.none,
            hintText: '내용',
          ),
        ),
      )
    );
  }
}

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
            width: 3,
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
              speed: 50.0,
              child: Text("긴급공지 쓰는곳... on/off 설정 가능! 일껄요?",
                style: const TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
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


//####################################################################################################


class sendDialog extends StatelessWidget {
  sendDialog({Key? key, this.letterData}) : super(key: key);

  final letterData;

  @override
  Widget build(BuildContext context) {
      return SizedBox(
          child: ((){if (letterData == '') {
              return cancelLetter();
            }else{
              return checkLetter();
          }
          })(),
      );
  }
}


class cancelLetter extends StatelessWidget {
  const cancelLetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('내용을 입력해주세요.', style: TextStyle( fontSize: 20, fontWeight: FontWeight.w600),),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      actions: [
        ElevatedButton(
          onPressed: (){Navigator.pop(context);},
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),),
          child: Text('닫기', style: style.normalText),
        )
      ],
    );
  }
}


class checkLetter extends StatelessWidget {
  const checkLetter({Key? key}) : super(key: key);

  removeUserContent() async {
    var content = await SharedPreferences.getInstance();
    content.remove('letterContent');
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('성공', textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w600),),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: 100,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('원장님에게만 익명으로 보내드립니다.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      actions: [
        ElevatedButton(onPressed: () {
          removeUserContent();
          showSnackBar(context);
          Navigator.popUntil(context, ModalRoute.withName("/"));
        },
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),),
            child: Text('보내기',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
        },
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),),
            child: Text('취소',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)))
      ],
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
              child: Text(
                'N',
                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),
              ),
            ),
          )
      ),
    );
  }
}





