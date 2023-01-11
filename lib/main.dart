import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_overflow/animated_overflow.dart';
import 'package:flutter/cupertino.dart';
import 'notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:allcare/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import './pages/login.dart';
import './style.dart' as style;
import './pages/letter.dart';
import './pages/notice.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
      MaterialApp(
        theme: style.theme,
        initialRoute: '/',
        routes: {
          '/': (context) => loginUI(),
          '/home': (context) => MyApp(),
        },
      )
  );
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var buttonName = ['출석체크', '조퇴/외출/결석', '도시락 신청', 'English Test', '주간 영어 모의고사 신청', '모의고사 신청', '상담 신청'];
  var fireDataName; var fireDataAlertDetail; var fireDataAlertSwitch;

  void showSnackBar(BuildContext context, result) {
    final snackBar = SnackBar(
      content: Text(result, textAlign: TextAlign.center, style: style.normalText),
      backgroundColor: Colors.black.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: result == '알수없는 오류' ? 200 : 100,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  fireGet() async{
    try {
      await firestore.collection('customer').where('uid', isEqualTo: auth.currentUser?.uid).get().then((QuerySnapshot dcName){for (var docName in dcName.docs) {
      setState(() {
        fireDataName = docName['name'];
      });
      }});
      var result = await firestore.collection('Code').doc('alertID').get();
      setState(() {
        fireDataAlertSwitch = result['switch'];
        fireDataAlertDetail = result['content'];
      });
    }catch(e){
      showSnackBar(context, '알수없는 오류');
    }
  }

  @override
  void initState() {
    super.initState();
    initNotification();
    fireGet();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){return Future(() => true);},
      child: Scaffold(
        floatingActionButton:
        FloatingActionButton.extended(
          onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => letterUI(fireDataName : fireDataName) ));},
          label: Text('익명 편지', style: style.floatingText),
          icon: Icon(Icons.mail, color: Colors.white, size: 30),
          backgroundColor: Color(0xff0B01A2),
        ),

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image.asset('assets/Logo.png', width: 79),
                Text('올케어 관리형 독학관'),
              ],
            ),


            actions: [
                Text(fireDataName ?? 'Null',style: style.barText),
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
              itemBuilder: (c, i) {
                if (i == 0) {
                  return fireDataAlertSwitch == true ? noticeAlert(fireDataAlertDetail: fireDataAlertDetail) : Container();
                } else {
                  return ListTile(
                    title: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                      height: 57,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          buttonName[i - 1], style: style.normalText,),
                      ),
                    ),
                  );
                }
              }
          ),
        ),
      ),
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

class noticeAlert extends StatelessWidget {
  noticeAlert({Key? key, this.fireDataAlertDetail}) : super(key: key);
  var fireDataAlertDetail;

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
              child: GestureDetector(
                child: Text(
                  fireDataAlertDetail,
                  style: style.speakerText,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
                onTap: (){
                  showDialog(context: context, builder: (context) => alertDetailDialog(fireDataAlertDetail : fireDataAlertDetail));
                },
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

class alertDetailDialog extends StatelessWidget {
  const alertDetailDialog({Key? key, this.fireDataAlertDetail}) : super(key: key);
  final fireDataAlertDetail;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(fireDataAlertDetail, style: style.normalTextDark),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(
          onPressed: (){Navigator.pop(context);},
          style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
          child: Text('닫기', style: style.dialogCheckText),
        )
      ],
    );
  }
}





