import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style.dart' as style;

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
  var registerID = TextEditingController();
  var registerPW = TextEditingController();
  var registerPW2 = TextEditingController();
  var registerName = TextEditingController();
  var registerTelephone = TextEditingController();
  var registerSeat = TextEditingController();
  var registerKind = TextEditingController();
  var fixCode = TextEditingController();
  String textValue = "";
  var viewList = ['이름','아이디', '비밀번호', '비밀번호확인', '전화번호', '자리번호', '학업', '확인코드', '버튼'];
  List<String> dropdownList = ['고등부', '재수', '공시'];
  List<String> dropdownList2 = ['1관', '2관'];
  var selectedDropdown;
  var selectedDropdown2;



  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(centerTitle:true, title: Text('회원가입'), ),
        SliverFixedExtentList(
          itemExtent: 90.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            if (viewList[index] == '버튼'){
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
            }else if(viewList[index] == '학업') {
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('*',style: TextStyle(color: Colors.red),),
                        Container(
                          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
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
            }else if(viewList[index] == '자리번호'){
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(viewList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('*',style: TextStyle(color: Colors.red),),
                          Container(
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
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
                                  setState(() {
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
                                    controller: registerSeat,
                                    keyboardType: TextInputType.number,
                                    onChanged: (text){
                                      setState(() {
                                        if (text.length == 2){FocusScope.of(context).nextFocus();}
                                      });
                                    },
                                    decoration: InputDecoration(
                                      counterText:'',
                                    ),
                                  ),
                                ),
                                Text('번', style: style.dropDownBoxText,),
                              ],
                            ),
                        ],
                    ),
              );
            }else if (viewList[index] == '전화번호'){
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(viewList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('*',style: TextStyle(color: Colors.red),)
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
                            suffix: Text("${textValue.length} / 11")
                        ),
                      onChanged: (text){
                        setState(() {
                          textValue = text;
                          if (textValue.length == 11){FocusScope.of(context).nextFocus();}
                        });
                      },
                      ),
                  ],
                ),
              );
            }else if (viewList[index] == '확인코드'){
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(viewList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('*',style: TextStyle(color: Colors.red),)
                      ],
                    ),
                    TextField(
                        textInputAction: TextInputAction.done
                    )
                  ],
                ),
              );
            }else if (viewList[index] == '비밀번호' || viewList[index] == '비밀번호확인'){
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(viewList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('*',style: TextStyle(color: Colors.red),)
                      ],
                    ),
                    TextField(
                        obscureText: true,
                        textInputAction: TextInputAction.next
                    )
                  ],
                ),
              );
            }else{
            return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(viewList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('*',style: TextStyle(color: Colors.red),)
                    ],
                  ),
                  TextField(
                      textInputAction: TextInputAction.next
                  )
                ],
              ),
            );
            }
          },childCount: viewList.length
          ),)
      ],
    );
  }
}





