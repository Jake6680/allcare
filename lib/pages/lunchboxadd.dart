import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../style.dart' as style;
import './dialogWidget.dart' as diawiget;

final firestoreLunch = FirebaseFirestore.instance;

class LunchAddUI extends StatefulWidget {
  const LunchAddUI({Key? key, this.fireDataSeat, this.checkLunchAddUid}) : super(key: key);
  final checkLunchAddUid;
  final fireDataSeat;

  @override
  State<LunchAddUI> createState() => _LunchAddUIState();
}

class _LunchAddUIState extends State<LunchAddUI> {
  final lunchvalues = List.filled(7, false);
  final List<bool> _selectedDate = <bool>[false, false];
  List<String> lunchvaluesDateList = [];
  List<String> lunchvaluesDateList2 = [];
  int lunchvaluesCount = 0;
  bool errorlevel2 = false;
  bool widgetReload = false;
  var dinnerDeadLine;
  var lunchDeadLine;

  fireDeadlineGet() async{
    try {
      var result = await firestoreLunch.collection('Code').doc('lunchboxDeadline').get();
      setState(() {
        lunchDeadLine = result['lunch'];
        dinnerDeadLine = result['dinner'];
      });
    } catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
      setState(() {
        errorlevel2 = true;
      });
    }
    if (errorlevel2 == false){
      setState(() {
        widgetReload = true;
      });
    }
  }

  widgetLunchCheck(context){
      if (int.parse(DateTime.now().toString().substring(11,13)) > int.parse(lunchDeadLine.toString().substring(0,2))){
        return null;
      }else if (int.parse(DateTime.now().toString().substring(11,13)) == int.parse(lunchDeadLine.toString().substring(0,2)) && int.parse(DateTime.now().toString().substring(14,16)) > int.parse(lunchDeadLine.toString().substring(3,5))) {
        return null;
      } else{
        return () {
          if (int.parse(DateTime.now().toString().substring(11, 13)) > int.parse(lunchDeadLine.toString().substring(0, 2))) {
            showDialog(context: context, builder: (context) => diawiget.FailDialog( failContent : '신청이 마감되었습니다.'));
          } else if (int.parse(DateTime.now().toString().substring(11, 13)) == int.parse(lunchDeadLine.toString().substring(0, 2)) && int.parse(DateTime.now().toString().substring(14, 16)) > int.parse(lunchDeadLine.toString().substring(3, 5))) {
            showDialog(context: context, builder: (context) => diawiget.FailDialog( failContent : '신청이 마감되었습니다.'));
          } else{
            showDialog(context: context, builder: (context) => CheckDialog(fireDataSeat : widget.fireDataSeat , boxTimes : '점심', checkLunchAddUid : widget.checkLunchAddUid, clearMessage : '금일 점심을 신청하시겠습까?' , lunchType : 'reservation', lunchDeadLineM : lunchDeadLine.toString().substring(3, 5), lunchDeadLineT : lunchDeadLine.toString().substring(0, 2)));
          }
        };
      }
  }

  widgetDinnerCheck(context){
    if (int.parse(DateTime.now().toString().substring(11,13)) >= int.parse(dinnerDeadLine.toString().substring(0,2))){
      return null;
    } else{
      return (){
        if (int.parse(DateTime.now().toString().substring(11,13)) >= int.parse(dinnerDeadLine.toString().substring(0,2))){
          showDialog(context: context, builder: (context) => diawiget.FailDialog( failContent : '신청이 마감되었습니다.'));
        } else{
          showDialog(context: context, builder: (context) => CheckDialog(fireDataSeat : widget.fireDataSeat , boxTimes : '저녁', checkLunchAddUid : widget.checkLunchAddUid, clearMessage : '금일 저녁을 신청하시겠습까?' , lunchType : 'reservation', dinnerDeadLine2 : dinnerDeadLine.toString().substring(0,2)));
        }
      };
    }
  }

  @override
  void initState() {
    super.initState();
    fireDeadlineGet();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('도시락 신청'),),
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          slivers: [
            const SliverPersistentHeader(
                pinned: true, delegate: TabBarDelegate()),
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                children: [
                    Column(
                          children: [
                            SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.fromBorderSide(BorderSide(width: 1,color: Colors.grey)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 5.0,
                                    offset: Offset(0, 10), // changes position of shadow
                                  ),
                                ],
                              ),
                                child: Column(
                                  children: [
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff003458),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: widgetReload == false ? null : widgetLunchCheck(context),
                                      child: Text('금일 점심 신청', style: style.normalText,),
                                    ),
                                  ),
                                    SizedBox(height: 10,),
                                    Text('오전 9시 30분 이후 신청불가능',style: style.dateSelecterFix,),
                                  ],)
                            ),
                            SizedBox(height: 25,),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.fromBorderSide(BorderSide(width: 1,color: Colors.grey)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 10), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff8977AD),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        onPressed: widgetReload == false ? null : widgetDinnerCheck(context),
                                        child: Text('금일 저녁 신청', style: style.normalText,),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('오후 2시 이후 신청불가능',style: style.dateSelecterFix,),
                                  ],)
                            ),
                          ],
                        ),
                  ListView(children: [
                    Container(

                    ),
                  ],
                  ),
                  ListView(children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 15, 30, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.date_range_outlined, color: Colors.grey,size: 25,),
                              SizedBox(width: 1,),
                              Text('요일',style: style.dateSelectTextgrey,),
                              SizedBox(width: 10,),
                              Flexible(
                                fit: FlexFit.tight,
                                child: WeekdaySelector(
                                  onChanged: (int day) {
                                    setState(() {
                                      final index = day % 7;
                                      lunchvalues[index] = !lunchvalues[index];
                                    });
                                  },
                                  values: lunchvalues,
                                  shortWeekdays: ['일','월','화','수','목','금','토'],
                                  selectedElevation: 5,
                                  elevation: 1,
                                  disabledElevation: 0,
                                  selectedFillColor: Colors.indigo,
                                  textStyle: style.dateSelectText,
                                  selectedTextStyle: style.dateSelectTextOn,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Icon(Icons.timelapse, color: Colors.grey,size: 25,),
                              SizedBox(width: 1,),
                              Text('시간',style: style.dateSelectTextgrey,),
                              SizedBox(width: 10,),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Center(
                                  child: ToggleButtons(
                                      direction: Axis.horizontal,
                                      onPressed: (int index) {
                                        // All buttons are selectable.
                                        setState(() {
                                          _selectedDate[index] = !_selectedDate[index];
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      selectedBorderColor: Colors.indigo[200],
                                      selectedColor: Colors.white,
                                      fillColor: Colors.indigo,

                                      textStyle: style.dropDownBoxText,
                                      constraints: const BoxConstraints(
                                        minHeight: 40.0,
                                        minWidth: 120.0,
                                      ),
                                      isSelected: _selectedDate,
                                      children: [Text('점심'), Text('저녁')],
                                    ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(onPressed: (){
                              lunchvaluesDateList2.clear();
                              lunchvaluesDateList.clear();
                              for (int i = 1; i < 7; i++) {
                                if (lunchvalues[i] == true){
                                  setState(() {
                                    if (i == 1){
                                      lunchvaluesDateList.add('월');
                                      lunchvaluesCount++;
                                    } else if (i == 2){
                                      lunchvaluesDateList.add('화');
                                      lunchvaluesCount++;
                                    }else if (i == 3){
                                      lunchvaluesDateList.add('수');
                                      lunchvaluesCount++;
                                    }else if (i == 4){
                                      lunchvaluesDateList.add('목');
                                      lunchvaluesCount++;
                                    }else if (i == 5){
                                      lunchvaluesDateList.add('금');
                                      lunchvaluesCount++;
                                    }else if (i == 6){
                                      lunchvaluesDateList.add('토');
                                      lunchvaluesCount++;
                                    }
                                  });
                                }
                              }
                              if (lunchvalues[0] == true){
                                setState(() {
                                  lunchvaluesDateList.add('일');
                                  lunchvaluesCount++;
                                });
                              }
                              if (lunchvaluesDateList.isEmpty){
                                showDialog(context: context, builder: (context) => diawiget.FailDialog(failContent: '신청 요일을 선택해주세요.'));
                              } else if (_selectedDate[0] == false && _selectedDate[1] == false){
                                showDialog(context: context, builder: (context) => diawiget.FailDialog(failContent: '신청 시간을 선택해주세요.'));
                              }else {
                                if (_selectedDate[0] == true){lunchvaluesDateList2.add('점심');}
                                if (_selectedDate[1] == true){lunchvaluesDateList2.add('저녁');}
                                showDialog(context: context, builder: (context) => CheckDialog( checkLunchAddUid : widget.checkLunchAddUid, lunchvaluesDateList2 : lunchvaluesDateList2, lunchvaluesDateList : lunchvaluesDateList, lunchType : 'pin', fireDataSeat : widget.fireDataSeat, clearMessage : lunchvaluesDateList, clearMessage2 : lunchvaluesDateList2, clearMessage3 : '고정 신청을 하시겠습니까?'));
                              }
                            }, child: Text('등록', style: style.normalText,)),
                          ),
                          SizedBox(height: 10,),
                          Text('공휴일, 도시락 휴무 날은 자동으로 이용내역에 추가되지 않습니다.', style: style.textFieldLabel)
                        ],
                      ),
                    ),
                  ],)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  const TabBarDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Text(
                "금일 신청", style: style.dropDownBoxText,
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Text(
                "예약 신청", style: style.dropDownBoxText,
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Text(
                "고정 신청", style: style.dropDownBoxText,
              ),
            ),
          ),
        ],
        indicatorWeight: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}


class CheckDialog extends StatefulWidget {
  const CheckDialog({Key? key, this.lunchDeadLineT, this.lunchDeadLineM ,this.boxTimes, this.dinnerDeadLine2, this.checkLunchAddUid, this.clearMessage3, this.lunchvaluesDateList2, this.lunchvaluesDateList, this.fireDataSeat , this.clearMessage, this.clearMessage2, this.lunchType}) : super(key: key);
  final boxTimes;
  final lunchType;
  final fireDataSeat;
  final clearMessage;
  final clearMessage2;
  final clearMessage3;
  final lunchDeadLineM;
  final lunchDeadLineT;
  final dinnerDeadLine2;
  final checkLunchAddUid;
  final lunchvaluesDateList;
  final lunchvaluesDateList2;




  @override
  State<CheckDialog> createState() => _CheckDialogState();
}

class _CheckDialogState extends State<CheckDialog> {
  bool sendErrorLevel2 = false;


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.clearMessage.toString(),
                style: style.normalTextDark),
            Text(widget.clearMessage2.toString(),
                style: widget.clearMessage2 == null ? TextStyle(fontSize: 0)  : style.normalTextDark),
            Text(widget.clearMessage3.toString(),
                style: widget.clearMessage3 == null ? TextStyle(fontSize: 0)  : style.normalTextDark),
          ]),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () async{
          if (widget.lunchType == 'reservation'){
            if (widget.dinnerDeadLine2 != null && int.parse(DateTime.now().toString().substring(11,13)) >= int.parse(widget.dinnerDeadLine2)){
              diawiget.showSnackBar(context, '신청이 마감되었습니다.');
              Navigator.pop(context);
            } else if (widget.lunchDeadLineT != null && int.parse(DateTime.now().toString().substring(11,13)) > int.parse(widget.lunchDeadLineT)){
              diawiget.showSnackBar(context, '신청이 마감되었습니다.');
              Navigator.pop(context);
            } else if (widget.lunchDeadLineT != null && int.parse(DateTime.now().toString().substring(11,13)) == int.parse(widget.lunchDeadLineT) && int.parse(DateTime.now().toString().substring(14, 16)) > int.parse(widget.lunchDeadLineM)){
              diawiget.showSnackBar(context, '신청이 마감되었습니다.');
              Navigator.pop(context);
            } else{
              try{
                final newPostKey = FirebaseDatabase.instance.ref().child('attendance/${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}/lunch').push().key;
                final lunchref = FirebaseDatabase.instance.ref('/attendance').child('${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}/lunch/$newPostKey');
                if (widget.lunchType == 'reservation'){
                  await lunchref.set({
                    'type' : widget.lunchType,
                    'date' : widget.dinnerDeadLine2 != null ? DateTime.now().toString().substring(0,10) : DateTime.now().toString().substring(0,10),
                    'times' : widget.boxTimes,
                    'uid' : widget.checkLunchAddUid,
                  });
                }
              }catch(e) {
                Navigator.pop(context);
                diawiget.showSnackBar(context, '알수없는 오류');
                setState(() {
                  sendErrorLevel2 = true;
                });
              }
              if (sendErrorLevel2 != true){
                Future((){
                  diawiget.showSnackBar(context,'등록 완료');
                  Navigator.popUntil(context, ModalRoute.withName('/lunch'));
                });
              }
            }
          }else {
            try{
              final newPostKey = FirebaseDatabase.instance.ref().child('attendance/${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}/lunch').push().key;
              final lunchref = FirebaseDatabase.instance.ref('/attendance').child('${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}/lunch/$newPostKey');
              if (widget.lunchType == 'pin'){
                await lunchref.set({
                  'type' : widget.lunchType,
                  'date' : widget.lunchvaluesDateList,
                  'times' : widget.lunchvaluesDateList2,
                  'uid' : widget.checkLunchAddUid,
                });
              }
            }catch(e) {
              Navigator.pop(context);
              diawiget.showSnackBar(context, '알수없는 오류');
              setState(() {
                sendErrorLevel2 = true;
              });
            }
            if (sendErrorLevel2 != true){
              Future((){
                diawiget.showSnackBar(context,'등록 완료');
                Navigator.popUntil(context, ModalRoute.withName('/lunch'));
              });
            }
          }
        },
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
            child: Text('확인', style: style.dialogCheckText)
        ),
        ElevatedButton(onPressed: () {Navigator.pop(context);},
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton ),
            child: Text('취소', style: style.dialogCheckText)
        )
      ],
    );
  }
}

