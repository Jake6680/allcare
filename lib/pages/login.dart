import 'package:allcare/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style.dart' as style;
import './register.dart';


class loginUI extends StatefulWidget {
  loginUI({Key? key}) : super(key: key);

  @override
  State<loginUI> createState() => _loginUIState();
}

class _loginUIState extends State<loginUI> {
  var logining = false;

  getUserImformation() async{
    var content = await SharedPreferences.getInstance();
    var userID = content.getString('userID');
    setState(() {
      if (userID != null) {
        var userPW = content.getString('userID');
        logining = true;
      }else{
        logining = false;
      }
    });
  }

  setUserContent(userID, userPW) async{
    var content = await SharedPreferences.getInstance();
    content.setString('userID', userID);
    content.setString('userPW', userPW);
  }


  @override
  void initState() {
    super.initState();
    getUserImformation();
    if (logining == true){
      Future(() {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Image.asset('assets/Logo.png', width: 80),
            Text('올케어 관리형 독학관'),
          ],
        ),
      ),

      body: loginBody(),

    );
  }
}


class loginBody extends StatefulWidget {
  const loginBody({Key? key}) : super(key: key);

  @override
  State<loginBody> createState() => _loginBodyState();
}

class _loginBodyState extends State<loginBody> {
  var fieldID = TextEditingController();
  var fieldPW = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('로그인', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 30 ),),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: TextField(
                textInputAction: TextInputAction.next,
                controller: fieldID, 
                style: style.letterMainText, 
                decoration: InputDecoration(
                  labelText: '아이디',
                  labelStyle: TextStyle( color: Colors.grey, fontWeight: FontWeight.w500 ),
                  enabledBorder: UnderlineInputBorder( borderSide: BorderSide(width: 2, color: Colors.black),),
                  focusedBorder: UnderlineInputBorder( borderSide: BorderSide(width: 2, color: Colors.black),),
              ),
            ),
          ),
          TextField(
              obscureText: true,
              controller: fieldPW,
              style: style.letterMainText,
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle( color: Colors.grey, fontWeight: FontWeight.w500 ),
                enabledBorder: UnderlineInputBorder( borderSide: BorderSide(width: 2, color: Colors.black),),
                focusedBorder: UnderlineInputBorder( borderSide: BorderSide(width: 2, color: Colors.black),),
              ),
            ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
            height: 57,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text('로그인',style: style.normalText),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text('회원가입'),
                onTap: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => registerUI() ));},
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text('/')
              ),
              GestureDetector(
                child: Text('비밀번호 찾기'),
                onTap: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => registerUI() ));},
              ),
            ],
          )
        ],
      ),
    );
  }
}
