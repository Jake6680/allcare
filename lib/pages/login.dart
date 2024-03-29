import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../style.dart' as style;
import 'package:allcare/pages/register.dart';

final authLogin = FirebaseAuth.instance;


class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
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
      if(auth.currentUser?.uid == null){
        var content = await SharedPreferences.getInstance();
        var userID = content.getString('userID');
        var userPW = content.getString('userPW');
        if (userID != null && userPW != null) {
          try {
            await authLogin.signInWithEmailAndPassword(
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
      }else{
            setState(() {
              loginDataed == true;
            });
      }

      if (loginDataed == true) {
        Future((){
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
      body: LoginBody(),
    );
  }
}


class LoginBody extends StatefulWidget {
  const LoginBody({Key? key, this.loginLoading}) : super(key: key);
  final loginLoading;

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String textFieldID = '';
  String textFieldPW = '';

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
          LoginWidget( getlonginID : getlonginID ),
          PWWidget( getlonginPW : getlonginPW ),
          LoginButton( textFieldID: textFieldID , textFieldPW: textFieldPW) ,
          BottomTextButton(),
        ],
      ),
    );
  }
}


///////////////////////////////////////////////////////////////////////////////////


class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key, this.getlonginID}) : super(key: key);
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



class PWWidget extends StatelessWidget {
  const PWWidget({Key? key, this.getlonginPW}) : super(key: key);
  final getlonginPW;

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



class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, this.textFieldID, this.textFieldPW}) : super(key: key);
  final textFieldID;
  final textFieldPW;


  @override
  Widget build(BuildContext context) {
   late bool errorLevel;

    setUserContent(userID, userPW) async{
      var content = await SharedPreferences.getInstance();
      content.setString('userID', userID);
      content.setString('userPW', userPW);
    }

    void showSnackBar(BuildContext context, result) {
      final snackBar = SnackBar(
        duration: Duration(milliseconds: 1000),
        content: Text(result, textAlign: TextAlign.center, style: style.normalText),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        width: result.length < 5 ? 100 : result.length < 10 ? 200 : result.length < 15 ? 350 : 400,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
      height: 57,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: ()async{
          errorLevel = false;
          if (textFieldID == ''){
            showSnackBar(context, '아이디를 입력해주세요!');
          }else if (textFieldPW == ''){
            showSnackBar(context, '비밀번호를 입력해주세요!');
          }else{
            var toEmailID = '${textFieldID + '@studyallcare.com'}';
            try {
              await authLogin.signInWithEmailAndPassword(
                  email: toEmailID,
                  password: textFieldPW
              );
            } on FirebaseAuthException catch (e) {
              errorLevel = true;
              if (e.code == 'network-request-failed') {
                showSnackBar(context, '네트워크 연결 상태 확인 후 다시 시도해주세요.');
              }else if (e.code == 'user-not-found') {
                showSnackBar(context, '사용자가 존재하지 않습니다.');
              } else if (e.code == 'wrong-password') {
                showSnackBar(context, '비밀번호를 확인하세요');
              } else if (e.code == 'invalid-email') {
                showSnackBar(context, '아이디을 확인하세요.');
              }
            }
            if (errorLevel != true) {
              Future((){
                setUserContent(toEmailID, textFieldPW);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              });
            }
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


class BottomTextButton extends StatelessWidget {
  const BottomTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Text('회원가입'),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (c) => RegisterUI() ));
            },
        ),
        Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text('/')
        ),
        GestureDetector(
          child: Text('비밀번호 찾기'),
          onTap: (){showDialog(context: context, builder: (context) => FailDialog( failContent : '원장 또는 총무에게 문의해주세요.' ));},
        ),
      ],
    );
  }
}






