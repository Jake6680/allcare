import 'package:allcare/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../style.dart' as style;

final info = NetworkInfo();

class loginUI extends StatefulWidget {
  loginUI({Key? key}) : super(key: key);

  @override
  State<loginUI> createState() => _loginUIState();
}

class _loginUIState extends State<loginUI> {
  bool loginDataed = false;
  bool fireLoginLevel = false;

  void showSnackBar(BuildContext context, result) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(result, textAlign: TextAlign.center, style: style.normalText),
      backgroundColor: Colors.black.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: 200,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getUserImformation() async{
    var content = await SharedPreferences.getInstance();
    var userID = content.getString('userID');
    var userPW = content.getString('userPW');
      if (userID != null && userPW != null) {
        try {
          await auth.signInWithEmailAndPassword(
              email: userID,
              password: userPW
          );
        } catch (e) {
          setState(() {
            fireLoginLevel = true;
          });
        }
        if (fireLoginLevel == true){
          setState(() {
            loginDataed = false;
          });
        }else {
          setState(() {
            loginDataed = true;
          });
        }
      }else{
        setState(() {
          loginDataed = false;
        });
      }
    if (loginDataed == true) {
      Future((){
        FlutterNativeSplash.remove();
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/home', (Route<dynamic> route) => false);
      });
    } else if (fireLoginLevel == true) {
      FlutterNativeSplash.remove();
      Future((){
        showSnackBar(context, '로그인 실패');
      });
    } else {
      FlutterNativeSplash.remove();
    }
  }

  getWifi() async{
    var wifiIPv6 = await info.getWifiIPv6();
  }

  @override
  void initState() {
    super.initState();
    getUserImformation();
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
  loginBody({Key? key, this.loginLoading}) : super(key: key);
  final loginLoading;

  @override
  State<loginBody> createState() => _loginBodyState();
}

class _loginBodyState extends State<loginBody> {
  var textFieldID;
  var textFieldPW;

  getlonginID(text){
    setState(() {
      textFieldID = text;
    });
  }
  getlonginPW(text){
    setState(() {
      textFieldPW = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('로그인', style: style.h1),
          loginWidget( getlonginID : getlonginID ),
          pwWidget( getlonginPW : getlonginPW ),
          loginButton( textFieldID: textFieldID , textFieldPW: textFieldPW) ,
          bottomTextButton(),
        ],
      ),
    );
  }
}


///////////////////////////////////////////////////////////////////////////////////


class loginWidget extends StatelessWidget {
  const loginWidget({Key? key, this.getlonginID}) : super(key: key);
  final getlonginID;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: TextField(
        textInputAction: TextInputAction.next,
        style: style.letterMainText,
        decoration: InputDecoration(
          labelText: '아이디',
          labelStyle: style.textFieldLabel,
          enabledBorder: style.loginTextField,
          focusedBorder: style.loginTextField,
        ),
        onChanged: (text){
          getlonginID(text);
        },
      ),
    );
  }
}



class pwWidget extends StatelessWidget {
  pwWidget({Key? key, this.getlonginPW}) : super(key: key);
  final getlonginPW;
  bool errorLevel = false;


  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      style: style.letterMainText,
      decoration: InputDecoration(
        labelText: '비밀번호',
        labelStyle: style.textFieldLabel,
        enabledBorder: style.loginTextField,
        focusedBorder: style.loginTextField,
      ),
      onChanged: (text){
        getlonginPW(text);
      },
    );
  }
}



class loginButton extends StatelessWidget {
  const loginButton({Key? key, this.textFieldID, this.textFieldPW}) : super(key: key);
  final textFieldID;
  final textFieldPW;


  @override
  Widget build(BuildContext context) {
    bool errorLevel = false;

    setUserContent(userID, userPW) async{
      var content = await SharedPreferences.getInstance();
      content.setString('userID', userID);
      content.setString('userPW', userPW);
    }

    void showSnackBar(BuildContext context, result) {
      final snackBar = SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text(result, textAlign: TextAlign.center, style: style.normalText),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        width: result == '아이디 또는 비밀번호를 틀렸습니다.' ? 300 : 100,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
      height: 57,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: ()async{
          var toEmailID = '${textFieldID + '@studyallcare.com'}';
          try {
            await auth.signInWithEmailAndPassword(
                email: toEmailID,
                password: textFieldPW
            );
          } catch (e) {
            showSnackBar(context, '아이디 또는 비밀번호를 틀렸습니다.');
            errorLevel = true;
          }
          if (errorLevel != true) {
            Future((){
              setUserContent(toEmailID, textFieldPW);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text('로그인',style: style.normalText),
      ),
    );
  }
}


class bottomTextButton extends StatelessWidget {
  const bottomTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Text('회원가입'),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (c) => registerUI() ));
            },
        ),
        Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text('/')
        ),
        GestureDetector(
          child: Text('비밀번호 찾기'),
          onTap: (){showDialog(context: context, builder: (context) => failDialog());},
        ),
      ],
    );
  }
}


class failDialog extends StatelessWidget {
  const failDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('원장 또는 총무에게 문의해주세요.', style: style.normalTextDark),
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





