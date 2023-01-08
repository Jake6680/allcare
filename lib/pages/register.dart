import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../style.dart' as style;

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
  var viewList = ['아이디', '비밀번호', '비밀번호확인','이름', '전화번호', '자리번호', '학업', '확인코드', '버튼'];
  var textLoginID; var textLoginPW;var textLoginName; var textLoginTelephon; var textLoginSeat; var textLoginKind; var textLoginCode;

  getfirebaseinit () async{
    try{
      var textLoginCode = await firestore.collection('code').doc('vDZIUx9gIRsZcJJy9Dku').get();
      print(textLoginCode['code']);
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getfirebaseinit ();
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
              return registerTelephonWidget( viewList : viewList[index] );
            }else if(viewList[index] == '자리번호'){
              return registerSeatWidget( viewList : viewList[index] );
            }else if(viewList[index] == '학업') {
              return registerKindWidget( viewList : viewList[index] );
            }else if (viewList[index] == '버튼'){
              return registerSignUpButton();
            }else {
            return registerNoneWidget( viewList : viewList[index] );
            }
          },childCount: viewList.length
          ),)
      ],
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class registerNoneWidget extends StatelessWidget {
  const registerNoneWidget({Key? key, this.viewList}) : super(key: key);
  final viewList;

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
          )
        ],
      ),
    );
  }
}


class registerTelephonWidget extends StatefulWidget {
  registerTelephonWidget({Key? key, this.viewList}) : super(key: key);
  final viewList;

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

class registerSeatWidget extends StatelessWidget {
  registerSeatWidget({Key? key, this.viewList}) : super(key: key);
  final viewList;
  List<String> dropdownList2 = ['1관', '2관'];
  var selectedDropdown2;

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(viewList, style: style.registerNormalText,),
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
                    selectedDropdown2 = value;
                    FocusScope.of(context).nextFocus();
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
                      if (text.length == 2){FocusScope.of(context).nextFocus();}
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
  registerKindWidget({Key? key, this.viewList}) : super(key: key);
  final viewList;

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


class registerSignUpButton extends StatelessWidget {
  const registerSignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (){},
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








