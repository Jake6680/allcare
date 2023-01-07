import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style.dart' as style;



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


class checkLetter extends StatelessWidget {
  const checkLetter({Key? key}) : super(key: key);

  removeUserContent() async {
    var content = await SharedPreferences.getInstance();
    content.remove('letterContent');
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('성공', textAlign: TextAlign.center, style: style.normalText),
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
        style: style.normalTextDark),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () {
          removeUserContent();
          showSnackBar(context);
          Navigator.popUntil(context, ModalRoute.withName("/"));
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