import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../style.dart' as style;

final firestore = FirebaseFirestore.instance;
final info = NetworkInfo();

FirebaseDatabase database = FirebaseDatabase.instance;

class attendanceCheck extends StatefulWidget {
  const attendanceCheck({Key? key, this.fireDataSeat, this.buttonState}) : super(key: key);
  final fireDataSeat;
  final buttonState;

  @override
  State<attendanceCheck> createState() => _attendanceCheckState();
}

class _attendanceCheckState extends State<attendanceCheck> {
  bool sendErrorLevel = false;
  bool errorLevel = false;
  var fireDataWifi = [];
  bool overlapCheckBox = false;

  void showSnackBar(BuildContext context, content) {
    final snackBar = SnackBar(
      content: Text(content, textAlign: TextAlign.center, style: style.normalText),
      backgroundColor: Colors.black.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: content == '학원 와이파이를 연결해주세요.' ? 300 : 100,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getfirebaseinit () async{
    try {
      var result = await firestore.collection('wifiID').get();
      for (var doc in result.docs){
        setState(() {
          fireDataWifi.add(doc['wifi']);
        });
      }
    }catch(e){
      setState(() {
        showSnackBar(context, '알수없는오류');
        errorLevel = true;
      });
    }
    if (errorLevel == true) {
      Future((){
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getfirebaseinit();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.buttonState == 'attendance' ? '등원 하시겠습니까?' : '하원 하시겠습니까?',
          style: style.normalTextDark),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () async{
          var wifiIPv6 = await info.getWifiIPv6();
          for(var wifiCheck in fireDataWifi){
            if (wifiIPv6 == wifiCheck){
              setState(() {
                overlapCheckBox = true;
              });
            }
          }
          if (overlapCheckBox == false){
            Future((){
              showSnackBar(context, '학원 와이파이를 연결해주세요.');
              Navigator.pop(context);
            });
          }else{
            try{
              final ref = FirebaseDatabase.instance.ref(widget.fireDataSeat['place']).child('${widget.fireDataSeat['number']}번');
              await ref.set({
                'state': widget.buttonState
              });
            }catch(e) {
              Future((){
                showSnackBar(context, '알수없는 오류');
                Navigator.pop(context);
              });
              setState(() {
                sendErrorLevel = true;
              });
            }
            if (sendErrorLevel != true){
              Future((){
                showSnackBar(context, '성공');
                Navigator.pop(context);
              });
            };
          }

        },
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton, backgroundColor: widget.buttonState == 'attendance' ? Color(0xff0B01A2) : Colors.red ),
            child: Text(widget.buttonState == 'attendance' ? '등원 하기' : '하원 하기', style: style.dialogCheckText)
        ),
        ElevatedButton(onPressed: () {Navigator.pop(context);},
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
            child: Text('취소', style: style.dialogCheckText)
        )
      ],
    );
  }
}
