import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../style.dart' as style;

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
class registerUI extends StatelessWidget {
  registerUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: registerBody(),
    );
  }
}


class registerBody extends StatefulWidget {
  registerBody({Key? key}) : super(key: key);

  @override
  State<registerBody> createState() => _registerBodyState();
}

class _registerBodyState extends State<registerBody> {
  TextEditingController registerID = TextEditingController();
  var viewList = ['아이디', '비밀번호', '비밀번호확인','이름', '전화번호', '자리번호', '학업', '확인 코드', '버튼'];
  var textLoginMap = {};
  var textLoginID; var textLoginPW; var textLoginName; var textLoginTelephon; var textLoginSeat; var textLoginKind; var textLoginCode;

  sendDataWidge(a, b){
    setState(() {
      textLoginMap[a] = b;
    });
  }

  getfirebaseinit () async{
      var textLoginCode2 = await firestore.collection('Code').doc('vDZIUx9gIRsZcJJy9Dku').get();
      if (textLoginCode2['code'].isEmpty){
        print('오류');
      }
      setState(() {
        textLoginCode = textLoginCode2['code'];
      });
  }

  @override
  void initState() {
    super.initState();
    getfirebaseinit();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(centerTitle:true, title: Text('회원가입'), ),
        SliverFixedExtentList(
          itemExtent: 90.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            if (viewList[index] == '전화번호'){
              return registerTelephonWidget( viewList : viewList[index], sendDataWidge : sendDataWidge );
            }else if(viewList[index] == '자리번호'){
              return registerSeatWidget( viewList : viewList[index], sendDataWidge : sendDataWidge );
            }else if(viewList[index] == '학업') {
              return registerKindWidget( viewList : viewList[index], sendDataWidge : sendDataWidge );
            }else if (viewList[index] == '버튼'){
              return registerSignUpButton( textLoginCode : textLoginCode, textLoginMap : textLoginMap );
            }else {
            return registerNoneWidget( viewList : viewList[index], sendDataWidge : sendDataWidge );
            }
          },childCount: viewList.length
          ),)
      ],
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class registerNoneWidget extends StatelessWidget {
  const registerNoneWidget({Key? key, this.viewList, this.sendDataWidge}) : super(key: key);
  final viewList;
  final sendDataWidge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(viewList, style: style.registerNormalText,),
              Text('*',style: style.registerRedText,),
            ],
          ),
          TextField(
              obscureText: viewList == '비밀번호' || viewList == '비밀번호확인' ? true : false,
              textInputAction: viewList == '확인코드' ? TextInputAction.done : TextInputAction.next,
            onChanged: (text){
                if (viewList != '비밀번호확인') {
                  sendDataWidge(viewList, text);
                }
            },
          )
        ],
      ),
    );
  }
}


class registerTelephonWidget extends StatefulWidget {
  registerTelephonWidget({Key? key, this.viewList, this.sendDataWidge}) : super(key: key);
  final viewList;
  final sendDataWidge;

  @override
  State<registerTelephonWidget> createState() => _registerTelephonWidgetState();
}

class _registerTelephonWidgetState extends State<registerTelephonWidget> {
  var textValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.viewList, style: style.registerNormalText,),
              Text('*',style: style.registerRedText,)
            ],
          ),
          TextField(
            maxLength: 11,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                hintText: '010-1234-5678',
                counterText: "",
                suffix: Text("${textValue ?? '0'} / 11")
            ),
            onChanged: (text){
              widget.sendDataWidge(widget.viewList, text);
              setState(() {
                textValue = text.length;
                if (text.length == 11){FocusScope.of(context).nextFocus();}
              });
            },
          ),
        ],
      ),
    );
  }
}

class registerSeatWidget extends StatefulWidget {
  registerSeatWidget({Key? key, this.viewList, this.sendDataWidge}) : super(key: key);
  final viewList;
  final sendDataWidge;

  @override
  State<registerSeatWidget> createState() => _registerSeatWidgetState();
}

class _registerSeatWidgetState extends State<registerSeatWidget> {
  List<String> dropdownList2 = ['1관', '2관'];

  var selectedDropdown2;

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.viewList, style: style.registerNormalText,),
            Text('*',style: style.registerRedText,),
            Container(
              decoration: style.registerDropBoxboder,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: DropdownButton(
                style: style.dropDownBoxText,
                value: selectedDropdown2,
                items: dropdownList2.map((String item) {
                  return DropdownMenuItem<String>(
                    child: Text('$item'),
                    value: item,
                  );
                }).toList(),
                onChanged: (dynamic value) {
                    widget.sendDataWidge(widget.viewList, value);
                    setState((){
                      selectedDropdown2 = value;
                    FocusScope.of(context).nextFocus();
                    });
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: TextField(
                    maxLength: 2,
                    textInputAction: TextInputAction.next,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: style.dropDownBoxText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText:'',
                    ),
                    onChanged: (text){
                      if (text.length == 2){FocusScope.of(context).nextFocus();}else{
                        widget.sendDataWidge('${widget.viewList+'_seat'}', text);
                      }
                    },
                  ),
                ),
                Text('번', style: style.dropDownBoxText,),
              ],
            ),
          ],
        ),
      );
  }
}


class registerKindWidget extends StatefulWidget {
  registerKindWidget({Key? key, this.viewList, this.sendDataWidge}) : super(key: key);
  final viewList;
  final sendDataWidge;

  @override
  State<registerKindWidget> createState() => _registerKindWidgetState();
}

class _registerKindWidgetState extends State<registerKindWidget> {
  List<String> dropdownList = ['고등부', '재수', '공시'];

  var selectedDropdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.viewList, style: style.registerNormalText,),
          Text('*',style: style.registerRedText,),
          Container(
            decoration: style.registerDropBoxboder,
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: DropdownButton(
              style: style.dropDownBoxText,
              value: selectedDropdown,
              items: dropdownList.map((String item) {
                return DropdownMenuItem<String>(
                  child: Text('$item'),
                  value: item,
                );
              }).toList(),
              onChanged: (dynamic value) {
                widget.sendDataWidge(widget.viewList, value);
                setState(() {
                  selectedDropdown = value;
                  FocusScope.of(context).nextFocus();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


class registerSignUpButton extends StatefulWidget {
  registerSignUpButton({Key? key, this.textLoginCode, this.textLoginMap}) : super(key: key);
  final textLoginCode;
  final textLoginMap;

  @override
  State<registerSignUpButton> createState() => _registerSignUpButtonState();
}

class _registerSignUpButtonState extends State<registerSignUpButton> {
  void showSnackBar(BuildContext context, result) {
    if (result != '다시확인해주세요.'){
      final snackBar = SnackBar(
        content: Text(result, textAlign: TextAlign.center, style: style.normalText),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        width: 100,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else {
      final snackBar = SnackBar(
        content: Text(result, textAlign: TextAlign.center, style: style.normalText),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        width: 200,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var toEmail = '${widget.textLoginMap['아이디']}@studyallcare.com';
    final toNewMap = {
      'uid' : 'Text',
      'name': widget.textLoginMap['이름'],
      'telephone': widget.textLoginMap['전화번호'],
      'Seat': {widget.textLoginMap['자리번호'],widget.textLoginMap['자리번호_seat']},
      'job' : widget.textLoginMap['학업'],
      'parent' : 'Not required'
    };
    bool errorCheck = false;
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async{
          if (widget.textLoginCode != widget.textLoginMap['확인 코드'] || widget.textLoginCode == null){
            showDialog(context: context, builder: (context) => failDialog() );
            } else{
            if (widget.textLoginMap['학업'] == '고등부'){
              showDialog(context: context, builder: (context) => parentDialog(textLoginMap : widget.textLoginMap) );
            }else{
              try {
                await auth.createUserWithEmailAndPassword(
                  email: toEmail,
                  password: widget.textLoginMap['비밀번호'],
                );
                await firestore.collection('product').add(toNewMap);
              } catch (e) {
                showSnackBar(context, '다시확인해주세요.');
                setState(() {
                  errorCheck = true;
                });
              }
                if (errorCheck != true) {
                  Future(() {
                    showSnackBar(context, '성공');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  });
                }
                else{
                  Future((){Navigator.pop(context);});
                }
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text('가입 하기',style: style.normalText),
      ),
    );
  }
}

class failDialog extends StatelessWidget {
  const failDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('확인코드가 일치하지않습니다.', style: style.normalTextDark),
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

class parentDialog extends StatefulWidget {
  const parentDialog({Key? key, this.textLoginMap}) : super(key: key);
  final textLoginMap;

  @override
  State<parentDialog> createState() => _parentDialogState();
}

class _parentDialogState extends State<parentDialog> {
  var textValue;
  bool errorCheck = false;

  void showSnackBar(BuildContext context, result) {
    if (result != '다시확인해주세요.'){
    final snackBar = SnackBar(
      content: Text(result, textAlign: TextAlign.center, style: style.normalText),
      backgroundColor: Colors.black.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: 100,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else {
      final snackBar = SnackBar(
        content: Text(result, textAlign: TextAlign.center, style: style.normalText),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        width: 200,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var toEmail = '${widget.textLoginMap['아이디']}@studyallcare.com';
    return AlertDialog(
      title: Text('보호자 전화번호', style: style.normalTextDark),
      shape: style.dialogCheckButton,
      content: TextField(
        maxLength: 11,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            hintText: '010-1234-5678',
            counterText: "",
            suffix: Text("${textValue ?? '0'} / 11")
        ),
        onChanged: (text){
          setState(() {
            textValue = text.length;
            if (text.length == 11){FocusScope.of(context).nextFocus();}
          });
        },
      ),

      actions: [
        ElevatedButton(
          onPressed: () async{
            try {
              var result = await auth.createUserWithEmailAndPassword(
                email: toEmail,
                password: widget.textLoginMap['비밀번호'],
              );
            } catch (e) {
              showSnackBar(context, '다시확인해주세요.');
              setState(() {
                errorCheck = true;
              });
            }
            if (errorCheck != true){
              Future(() {
                showSnackBar(context, '성공');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              });
            }else{
              Future((){Navigator.pop(context);});
            }
          },
          style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
          child: Text('완료', style: style.dialogCheckText),
        ),
        ElevatedButton(
          onPressed: () {Navigator.pop(context);},
          style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
          child: Text('취소', style: style.dialogCheckText),
        )
      ],
    );
  }
}








