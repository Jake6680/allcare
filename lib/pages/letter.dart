import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../style.dart' as style;

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;


class letterUI extends StatefulWidget {
  letterUI({Key? key, this.fireDataName}) : super(key: key);
  final fireDataName;

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
    getUserContent();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){ showDialog(context: context, builder: (context) => sendDialog(letterData : letterData.text, fireDataName : widget.fireDataName) );},
          label: Text('보내기', style: style.floatingText),
          icon: Icon(Icons.outgoing_mail, color: Colors.white, size: 30),
          backgroundColor: Color(0xff0B01A2),
        ),

        appBar: AppBar(
            centerTitle: true,
            title: Text('익명 편지쓰기')
        ),

        body:SizedBox(
          height: double.infinity,
          child: TextField(
            onChanged: (text){ setUserContent(text); },
            controller: letterData,
            maxLines: 35,
            minLines: 1,
            style: style.letterMainText,
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class sendDialog extends StatelessWidget {
  sendDialog({Key? key, this.letterData, this.fireDataName}) : super(key: key);
  final letterData;
  final fireDataName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ((){if (letterData == '') {
        return cancelLetter();
      }else{
        return checkLetter( letterData : letterData, fireDataName : fireDataName );
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
      title: Text('내용을 입력해주세요.', style: style.normalTextDark),
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


class checkLetter extends StatefulWidget {
  checkLetter({Key? key, this.letterData, this.fireDataName}) : super(key: key);
  final letterData;
  final fireDataName;

  @override
  State<checkLetter> createState() => _checkLetterState();
}

class _checkLetterState extends State<checkLetter> {
  bool sendErrorLevel = false;

  removeUserContent() async {
    var content = await SharedPreferences.getInstance();
    content.remove('letterContent');
  }

  void showSnackBar(BuildContext context, content) {
    final snackBar = SnackBar(
      content: Text(content, textAlign: TextAlign.center, style: style.normalText),
      backgroundColor: Colors.black.withOpacity(0.7),
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
        style: style.normalTextDark),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () async{
          try{
            await firestore.collection('letter').add({'name' : widget.fireDataName,'content' : widget.letterData, 'time' : DateTime.now()});
          }catch(e) {
            showSnackBar(context, '알수없는 오류');
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
            setState(() {
              sendErrorLevel = true;
            });
          }
          if (sendErrorLevel != true){
            Future((){
              removeUserContent();
              showSnackBar(context, '성공');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false);
            });
          }
        },
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
            child: Text('보내기', style: style.dialogCheckText)
        ),
        ElevatedButton(onPressed: () {Navigator.pop(context);},
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
            child: Text('취소', style: style.dialogCheckText)
        )
      ],
    );
  }
}