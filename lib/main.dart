import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

   var buttonName = ['출석체크', '조퇴/외출/결석', '도시락 신청', 'Daily Test', '주간 영어 모의고사 신청', '모의고사 신청', '상담 신청'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        label: Text('익명 편지', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
        icon: Icon(Icons.outgoing_mail, color: Colors.white, size: 30,),
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
              Text('김OO',style: style.barText),
              Container(
                  child: IconButton(icon: Image.asset('assets/alert.png', color: Colors.white, width: 25), onPressed: null)
              ),
            ],
          ),
        ),
        
        
        body: Container(
          padding: EdgeInsets.all(30),
          color: Color(0xffefefef),
          child: (
            ListView.builder(
                itemCount: buttonName.length,
                itemBuilder: (c, i){
                    return ListTile(
                      title: Container(
                       margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                       height: 50,
                       child: ElevatedButton(
                       onPressed: (){},
                        child: Text(buttonName[i], style: style.normalText,),
                      ),
                    ),
                  );
                }
            )
          ),
        ),
    );
  }
}

