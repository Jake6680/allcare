import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../style.dart' as style;

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class RegisterUI extends StatelessWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    void showSnackBar(BuildContext context, result) {
        final snackBar = SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text(result, textAlign: TextAlign.center, style: style.normalText),
          backgroundColor: Colors.black.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
          width: result == '전화번호를 입력해주세요.' ? 300 : result == '다시확인해주세요.' ? 200 : result == '성공' ? 100 : 200,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      body: RegisterBody( showSnackBar: showSnackBar ),
    );
  }
}


class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key, this.showSnackBar}) : super(key: key);
  final showSnackBar;

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  TextEditingController registerID = TextEditingController();
  var viewList = ['아이디', '비밀번호', '비밀번호 확인', '이름', '전화번호', '자리번호', '학업', '확인 코드', '버튼'];
  var textLoginMap = {};
  var textLoginCode;
  var fireDataID = [];
  var textFiedlState = {};
  bool errorLevel = false;

  getTextLoginMap(name){
      return textLoginMap[name];
  }

  sendDataWidge(name, content, boolState){
    setState(() {
      if (name == '자리번호'){
        if (content == '1관'){
          textLoginMap[name] = '1';
        } else{
          textLoginMap[name] = '2';
        }
      }else{
        textLoginMap[name] = content;
      }
      textFiedlState[name] = boolState;
    });
  }

  sendTextState(boolState){
    setState(() {
      textFiedlState['비밀번호 확인'] = boolState;
    });
  }

  getfirebaseinit () async{
    try {
      var result = await firestore.collection('contact').get();
      for (var doc in result.docs){
        setState(() {
          fireDataID.add(doc['ID']);
        });
      }
      var textLoginCode2 = await firestore.collection('Code').doc('codeID').get();
      setState(() {
        textLoginCode = textLoginCode2['code'];
      });
    }catch(e){
      setState(() {
        widget.showSnackBar(context, '알수없는오류');
        errorLevel = true;
      });
    }
    if (errorLevel == true) {
      Future((){
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(centerTitle:true, title: Text('회원가입'), ),
        SliverFixedExtentList(
          itemExtent: 90.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (viewList[index] == '아이디'){
            return RegisterIDWidget( fireDataID : fireDataID, sendDataWidge : sendDataWidge );
            }else if (viewList[index] == '전화번호'){
              return RegisterTelephonWidget( sendDataWidge : sendDataWidge );
            }else if(viewList[index] == '자리번호'){
              return RegisterSeatWidget( sendDataWidge : sendDataWidge );
            }else if(viewList[index] == '학업') {
              return RegisterKindWidget( sendDataWidge : sendDataWidge );
            }else if (viewList[index] == '버튼'){
              return RegisterSignUpButton( textLoginCode : textLoginCode, textLoginMap : textLoginMap, showSnackBar : widget.showSnackBar, textFiedlState: textFiedlState );
            }else {
            return RegisterNoneWidget( viewList : viewList[index], sendDataWidge : sendDataWidge, getTextLoginMap : getTextLoginMap, sendTextState : sendTextState );
            }
          },childCount: viewList.length
          ),)
      ],
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////




class RegisterIDWidget extends StatefulWidget {
  const RegisterIDWidget({Key? key, this.fireDataID, this.sendDataWidge}) : super(key: key);
  final fireDataID;
  final sendDataWidge;
  
  @override
  State<RegisterIDWidget> createState() => _RegisterIDWidgetState();
}

class _RegisterIDWidgetState extends State<RegisterIDWidget> {
  bool overlapCheckBox = false;
  bool checkID = false;

  var textFieldID;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('아이디', style: style.registerNormalText,),
              Text('*', style: style.registerRedText,),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: TextField(
                  decoration: InputDecoration(
                    suffix: Icon(overlapCheckBox == true ? Icons.cancel : Icons.check, color: overlapCheckBox == true ? Colors.red : Colors.green, size: checkID == false ? 0 : 20,)
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (text){
                    setState(() {
                      textFieldID = text;
                      checkID = false;
                      overlapCheckBox = false;
                      widget.sendDataWidge('ID', textFieldID, false);
                    });
                  },
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: ElevatedButton(onPressed: (){
                    if (textFieldID == null){
                      showDialog(context: context, builder: (context) => FailDialog(failContent : '아이디를 입력해주세요.'));
                    } else{
                      for(var textFieldIDCheck in widget.fireDataID){
                        if (textFieldID == textFieldIDCheck){
                          setState(() {
                            overlapCheckBox = true;
                          });
                        }
                      }
                      setState(() {
                        checkID = true;
                      });
                      if (overlapCheckBox == false){
                        widget.sendDataWidge('ID', textFieldID, true);
                        showDialog(context: context, builder: (context) => FailDialog(failContent : '사용가능한 아이디입니다.'));
                        Future((){FocusScope.of(context).nextFocus();});
                      }else{
                        showDialog(context: context, builder: (context) => FailDialog(failContent : '이미 사용중인 아이디입니다.'));
                      }
                    }
                  }, child: Text('중복 체크', style: style.suffixElevatedButton))
              )
            ],
          )
        ],
      ),
    );
  }
}



class RegisterNoneWidget extends StatefulWidget {
  const RegisterNoneWidget({Key? key, this.viewList, this.sendDataWidge, this.getTextLoginMap, this.sendTextState}) : super(key: key);
  final viewList;
  final sendDataWidge;
  final getTextLoginMap;
  final sendTextState;

  @override
  State<RegisterNoneWidget> createState() => _RegisterNoneWidgetState();
}

class _RegisterNoneWidgetState extends State<RegisterNoneWidget> {
  var errorMessage = '';
  var checkBox = {};

  errorCheckFuction(viewList, content, check){
    setState(() {
      errorMessage = content;
      checkBox = {viewList : check};
    });
  }

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
              Text('*', style: style.registerRedText,),
              Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(errorMessage, style: style.registerRedText2)
              )
            ],
          ),
          TextField(
            decoration: InputDecoration(
                suffix: Icon(checkBox[widget.viewList] == false ? Icons.cancel : Icons.check,color: checkBox[widget.viewList] == false ? Colors.red : Colors.green, size: checkBox[widget.viewList] == null ? 0 : 20,)
            ),
              obscureText: widget.viewList == '비밀번호' || widget.viewList == '비밀번호 확인' ? true : false,
              textInputAction: widget.viewList == '확인코드' ? TextInputAction.done : TextInputAction.next,
            onChanged: (text){
                if (widget.viewList != '비밀번호 확인') {
                  if (widget.viewList == '비밀번호') {
                    if (text.length < 6) {
                      widget.sendDataWidge(widget.viewList, text, false);
                      errorCheckFuction(
                          widget.viewList, '비밀번호는 6자(영문 기준) 이상이어야 합니다.', false);
                    } else {
                      widget.sendDataWidge(widget.viewList, text, true);
                      errorCheckFuction(widget.viewList, '', true);
                    }
                  } else if (widget.viewList == '확인 코드') {
                    widget.sendDataWidge(widget.viewList, text, true);
                    errorCheckFuction(widget.viewList, '', null);
                  } else {
                    widget.sendDataWidge(widget.viewList, text, true);
                    errorCheckFuction(widget.viewList, '', true);
                  }
                }else {
                  if (widget.getTextLoginMap('비밀번호') != text) {
                    widget.sendTextState(false);
                    errorCheckFuction(widget.viewList, '비밀번호가 일치하지않습니다.', false);
                  } else{
                    widget.sendTextState(true);
                    errorCheckFuction(widget.viewList, '', true);
                  }
                }
            },
          )
        ],
      ),
    );
  }
}


class RegisterTelephonWidget extends StatefulWidget {
  const RegisterTelephonWidget({Key? key, this.sendDataWidge}) : super(key: key);
  final sendDataWidge;

  @override
  State<RegisterTelephonWidget> createState() => _RegisterTelephonWidgetState();
}

class _RegisterTelephonWidgetState extends State<RegisterTelephonWidget> {
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
              Text('전화번호', style: style.registerNormalText,),
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
                suffix: textValue == 11 ? Icon(Icons.check,color: Colors.green, size: 20,) : Text("${textValue ?? '0'} / 11")
            ),
            onChanged: (text){
              if (text.length < 9){
                widget.sendDataWidge('전화번호', text, false);
              }else {
                widget.sendDataWidge('전화번호', text, true);
              }
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

class RegisterSeatWidget extends StatefulWidget {
  const RegisterSeatWidget({Key? key, this.sendDataWidge}) : super(key: key);
  final sendDataWidge;

  @override
  State<RegisterSeatWidget> createState() => _RegisterSeatWidgetState();
}

class _RegisterSeatWidgetState extends State<RegisterSeatWidget> {
  List<String> dropdownList2 = ['1관', '2관'];

  var selectedDropdown2;

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('자리번호', style: style.registerNormalText,),
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
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                    widget.sendDataWidge('자리번호', value, true);
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
                      widget.sendDataWidge('자리번호_seat', text, true);
                      if (text.length == 2){ FocusScope.of(context).nextFocus(); }
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


class RegisterKindWidget extends StatefulWidget {
  const RegisterKindWidget({Key? key, this.sendDataWidge}) : super(key: key);
  final sendDataWidge;

  @override
  State<RegisterKindWidget> createState() => _RegisterKindWidgetState();
}

class _RegisterKindWidgetState extends State<RegisterKindWidget> {
  List<String> dropdownList = ['고등부', '재수', '공시'];

  var selectedDropdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('학업', style: style.registerNormalText,),
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
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (dynamic value) {
                widget.sendDataWidge('학업', value, true);
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


class RegisterSignUpButton extends StatefulWidget {
  const RegisterSignUpButton({Key? key, this.textLoginCode, this.textLoginMap, this.showSnackBar, this.textFiedlState}) : super(key: key);
  final textLoginCode;
  final textLoginMap;
  final showSnackBar;
  final textFiedlState;

  @override
  State<RegisterSignUpButton> createState() => _RegisterSignUpButtonState();
}

class _RegisterSignUpButtonState extends State<RegisterSignUpButton> {

  @override
  Widget build(BuildContext context) {
    String toEmail = '${widget.textLoginMap['ID']}@studyallcare.com';
    Map<String, dynamic> toNewMap = {
      'pw' : widget.textLoginMap['비밀번호'],
      'uid' : 'Error',
      'name': widget.textLoginMap['이름'],
      'telephone': widget.textLoginMap['전화번호'],
      'seat': {'place' : widget.textLoginMap['자리번호'],'number' : widget.textLoginMap['자리번호_seat']},
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
            showDialog(context: context, builder: (context) => FailDialog( failContent : '확인코드가 일치하지않습니다.' ) );
            }else {
              if( widget.textLoginMap['ID'] == null || widget.textFiedlState['ID'] == false){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '아이디 중복 체크를 해주세요.' ) );
              }else if( widget.textLoginMap['비밀번호'] == null || widget.textFiedlState['비밀번호'] == false){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '비밀번호를 제대로 입력해주세요.' ) );
              }else if( widget.textFiedlState['비밀번호 확인'] == false || widget.textFiedlState['비밀번호 확인'] == null){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '비밀번호 확인란에 비밀번호를 똑같이 입력해주세요.' ) );
              }else if( widget.textLoginMap['이름'] == '' || widget.textLoginMap['이름'] == null || widget.textFiedlState['이름'] == false){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '이름을 제대로 입력해주세요.' ) );
              }else if( widget.textLoginMap['전화번호'] == null || widget.textFiedlState['전화번호'] == false){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '전화번호를 제대로 입력해주세요.' ) );
              }else if( widget.textLoginMap['자리번호'] == null ){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '자리번호를 선택해주세요.' ) );
              }else if( widget.textLoginMap['자리번호_seat'] == '' || widget.textLoginMap['자리번호_seat'] == null || widget.textFiedlState['자리번호_seat'] == false){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '자리번호를 제대로 입력해주세요.' ) );
              }else if( widget.textLoginMap['학업'] == null){
                showDialog(context: context, builder: (context) => FailDialog( failContent : '학업을 선택해주세요.' ) );
              }else if (widget.textLoginMap['학업'] == '고등부' || widget.textLoginMap['학업'] == '재수'){  //고등학생or 재수 일시 부모님 전화번호 입력
              showDialog(context: context, builder: (context) => ParentDialog( textLoginTelePhone: widget.textLoginMap['전화번호'] , textLoginMap : widget.textLoginMap, showSnackBar : widget.showSnackBar, toNewMap : toNewMap) );
            }else{  //아닐시 그냥 회원가입 시도!
              try {
                var result = await auth.createUserWithEmailAndPassword(
                  email: toEmail,
                  password: widget.textLoginMap['비밀번호'],
                );
                setState(() {
                  toNewMap['uid'] = result.user!.uid;
                });
                await firestore.collection('customer').add(toNewMap);
                await firestore.collection('contact').add({'ID' : widget.textLoginMap['ID']});
              } catch (e) {
                widget.showSnackBar(context, '다시확인해주세요.');
                setState(() {
                  errorCheck = true;
                });
              }
              if (errorCheck != true) {
                Future(() {
                  widget.showSnackBar(context, '성공');
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  });
              }else{
                Future((){Navigator.pop(context);});
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


class ParentDialog extends StatefulWidget {
  const ParentDialog({Key? key, this.textLoginMap, this.showSnackBar, this.toNewMap, this.textLoginTelePhone}) : super(key: key);
  final textLoginTelePhone;
  final showSnackBar;
  final textLoginMap;
  final toNewMap;

  @override
  State<ParentDialog> createState() => _ParentDialogState();
}

class _ParentDialogState extends State<ParentDialog> {
  var textValue;
  String parentContact = '';
  bool errorCheck = false;

  @override
  Widget build(BuildContext context) {
    var toEmail = '${widget.textLoginMap['ID']}@studyallcare.com';
    return AlertDialog(
      title: Text(widget.textLoginMap['학업'] == '재수' ? '보호자 전화번호(선택사항)' : '보호자 전화번호', style: style.normalTextDark),
      shape: style.dialogCheckButton,
      content: TextField(
        maxLength: 11,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            hintText: '010-1234-5678',
            counterText: "",
            suffix: textValue == 11 ? Icon(Icons.check,color: Colors.green, size: 20,) : Text("${textValue ?? '0'} / 11")
        ),
        onChanged: (text){
          setState(() {
            parentContact = text;
            textValue = text.length;
          });
        },
      ),

      actions: [
        ElevatedButton(
          onPressed: () async{
            if (parentContact == widget.textLoginTelePhone){
              widget.showSnackBar(context, '부모님 전화번호를 입력해주세요.');
            }else if (widget.textLoginMap['학업'] == '재수'){
                try {
                  var result = await auth.createUserWithEmailAndPassword(
                    email: toEmail,
                    password: widget.textLoginMap['비밀번호'],
                  );
                  setState(() {
                    if (parentContact != '') {
                      widget.toNewMap['parent'] = parentContact;
                    }
                    widget.toNewMap['uid'] = result.user!.uid;
                  });
                  await firestore.collection('customer').add(widget.toNewMap);
                  await firestore.collection('contact').add({'ID' : widget.textLoginMap['ID']});
                } catch (e) {
                  widget.showSnackBar(context, '다시확인해주세요.');
                  setState(() {
                    errorCheck = true;
                  });
                }
                if (errorCheck != true) {
                  Future(() {
                    widget.showSnackBar(context, '성공');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  });
                } else {
                  Future(() {
                    Navigator.pop(context);
                  });
                }
            }else if (parentContact == '' || parentContact.length < 9){
              widget.showSnackBar(context, '전화번호를 입력해주세요.');
            }else {
              try {
                var result = await auth.createUserWithEmailAndPassword(
                  email: toEmail,
                  password: widget.textLoginMap['비밀번호'],
                );
                setState(() {
                  widget.toNewMap['parent'] = parentContact;
                  widget.toNewMap['uid'] = result.user!.uid;
                });
                await firestore.collection('customer').add(widget.toNewMap);
                await firestore.collection('contact').add({'ID' : widget.textLoginMap['ID']});
              } catch (e) {
                widget.showSnackBar(context, '다시확인해주세요.');
                setState(() {
                  errorCheck = true;
                });
              }
              if (errorCheck != true) {
                Future(() {
                  widget.showSnackBar(context, '성공');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                });
              } else {
                Future(() {
                  Navigator.pop(context);
                });
              }
            }
          },
          style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
          child: Text('완료', style: style.dialogCheckText),
        ),
        ElevatedButton(
          onPressed: () {Navigator.pop(context);},
          style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
          child: Text(parentContact == '' ? '넘어가기' : '취소', style: style.dialogCheckText),
        )
      ],
    );
  }
}

class FailDialog extends StatelessWidget {
  const FailDialog({Key? key, this.failContent}) : super(key: key);
  final failContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(failContent, style: style.normalTextDark),
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








