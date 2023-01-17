import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './lunchboxadd.dart';
import './lunchhistory.dart';
import './dialogWidget.dart' as diawiget;
import '../style.dart' as style;


final authMain = FirebaseAuth.instance;
final firestore2 = FirebaseFirestore.instance;
RefreshController _refreshController = RefreshController(initialRefresh: false);


class LunchUI extends StatefulWidget {
  const LunchUI({Key? key}) : super(key: key);


  @override
  State<LunchUI> createState() => _LunchUIState();
}

class _LunchUIState extends State<LunchUI> {
  Map fireListData = {};
  int itemTotalCount = 0;
  List<String> listViewReservationLunch = [];
  List<String> listViewPinLunch = [];
  List<String> listViewTotalLunch = [];
  Map<String, dynamic> fireDataSeat = {};
  List<String> reservtionCander = [];
  List<String> pinCander = [];

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final refGet = FirebaseDatabase.instance.ref('/lunch').child('${fireDataSeat['place']}/${fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          itemTotalCount = 0;
          listViewReservationLunch.clear();
          listViewPinLunch.clear();
          listViewTotalLunch.clear();
          reservtionCander.clear();
          pinCander.clear();
          fireListData = (snapshot.value as dynamic);
          for (String leaveEarlyA in fireListData.keys){
            if (fireListData[leaveEarlyA]['uid'] == authMain.currentUser?.uid){
              if (fireListData[leaveEarlyA]['type'] == 'reservation'){
                listViewReservationLunch.add(leaveEarlyA);
                itemTotalCount++;
              }else if (fireListData[leaveEarlyA]['type'] == 'pin'){
                listViewPinLunch.add(leaveEarlyA);
                itemTotalCount++;
              }
            }
          }
          listViewReservationLunch.sort();
          for (String bb in listViewPinLunch){listViewTotalLunch.add(bb);}
          for (String bb in listViewReservationLunch){listViewTotalLunch.add(bb);}
          for (int i = 0; i < listViewPinLunch.length; i++){
            for (int ic = 0; ic < fireListData[listViewPinLunch[i]]['date'].length; ic++){
              if (fireListData[listViewPinLunch[i]]['times'].length == 2){
                pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}0');
                pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}1');
              }else{
                pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}${fireListData[listViewPinLunch[i]]['times'][0] == '저녁' ? 1 : 0}');
              }
            }
          }
          for (int i = 0; i < listViewReservationLunch.length; i++){
            reservtionCander.add('${fireListData[listViewReservationLunch[i]]['date']}${fireListData[listViewReservationLunch[i]]['times'] == '점심' ? 0 : 1}');
          }
        });
      }else{
        setState(() {
          itemTotalCount = 0;
          listViewReservationLunch.clear();
          listViewPinLunch.clear();
          listViewTotalLunch.clear();
          reservtionCander.clear();
        });
      }
    }catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
    }
    _refreshController.refreshCompleted();
  }

  lunchBackRefresh() async{
    try {
      final refGet = FirebaseDatabase.instance.ref('/lunch').child('${fireDataSeat['place']}/${fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          itemTotalCount = 0;
          listViewReservationLunch.clear();
          listViewPinLunch.clear();
          listViewTotalLunch.clear();
          reservtionCander.clear();
          pinCander.clear();
          fireListData = (snapshot.value as dynamic);
          for (String leaveEarlyA in fireListData.keys){
            if (fireListData[leaveEarlyA]['uid'] == authMain.currentUser?.uid){
              if (fireListData[leaveEarlyA]['type'] == 'reservation'){
                listViewReservationLunch.add(leaveEarlyA);
                itemTotalCount++;
              }else if (fireListData[leaveEarlyA]['type'] == 'pin'){
                listViewPinLunch.add(leaveEarlyA);
                itemTotalCount++;
              }
            }
          }
          listViewReservationLunch.sort();
          for (String bb in listViewPinLunch){listViewTotalLunch.add(bb);}
          for (String bb in listViewReservationLunch){listViewTotalLunch.add(bb);}
          for (int i = 0; i < listViewPinLunch.length; i++){
            for (int ic = 0; ic < fireListData[listViewPinLunch[i]]['date'].length; ic++){
              if (fireListData[listViewPinLunch[i]]['times'].length == 2){
                pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}0');
                pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}1');
              }else{
                pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}${fireListData[listViewPinLunch[i]]['times'][0] == '저녁' ? 1 : 0}');
              }
            }
          }
          for (int i = 0; i < listViewReservationLunch.length; i++){
            reservtionCander.add('${fireListData[listViewReservationLunch[i]]['date']}${fireListData[listViewReservationLunch[i]]['times'] == '점심' ? 0 : 1}');
          }
        });
      }else{
        setState(() {
          itemTotalCount = 0;
          listViewReservationLunch.clear();
          listViewPinLunch.clear();
          listViewTotalLunch.clear();
          reservtionCander.clear();
        });
      }
    }catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
    }
  }

  fireGetList() async{
    try {
      await firestore2.collection('customer').where('uid', isEqualTo: authMain.currentUser?.uid).get().then((QuerySnapshot dcName){for (var docName in dcName.docs) {
        setState(() {
          fireDataSeat = docName['seat'];
        });
      }});
      final refGet = FirebaseDatabase.instance.ref('/lunch').child('${fireDataSeat['place']}/${fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
            itemTotalCount = 0;
            listViewReservationLunch.clear();
            listViewPinLunch.clear();
            listViewTotalLunch.clear();
            reservtionCander.clear();
            pinCander.clear();
          fireListData = (snapshot.value as dynamic);
          for (String leaveEarlyA in fireListData.keys){
            if (fireListData[leaveEarlyA]['uid'] == authMain.currentUser?.uid){
              if (fireListData[leaveEarlyA]['type'] == 'reservation'){
                listViewReservationLunch.add(leaveEarlyA);
                itemTotalCount++;
              }else if (fireListData[leaveEarlyA]['type'] == 'pin'){
                listViewPinLunch.add(leaveEarlyA);
                itemTotalCount++;
              }
            }
          }
          listViewReservationLunch.sort();
            for (String bb in listViewPinLunch){listViewTotalLunch.add(bb);}
          for (String bb in listViewReservationLunch){listViewTotalLunch.add(bb);}
            for (int i = 0; i < listViewPinLunch.length; i++){
              for (int ic = 0; ic < fireListData[listViewPinLunch[i]]['date'].length; ic++){
                if (fireListData[listViewPinLunch[i]]['times'].length == 2){
                  pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}0');
                  pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}1');
                }else{
                  pinCander.add('${fireListData[listViewPinLunch[i]]['date'][ic]}${fireListData[listViewPinLunch[i]]['times'][0] == '저녁' ? 1 : 0}');
                }
              }
            }
          for (int i = 0; i < listViewReservationLunch.length; i++){
            reservtionCander.add('${fireListData[listViewReservationLunch[i]]['date']}${fireListData[listViewReservationLunch[i]]['times'] == '점심' ? 0 : 1}');
          }
        });
      }else{
        setState(() {
          itemTotalCount = 0;
          listViewReservationLunch.clear();
          listViewPinLunch.clear();
          listViewTotalLunch.clear();
          reservtionCander.clear();
        });
      }
    }catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
    }
  }


  @override
  void initState() {
    super.initState();
    fireGetList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      FloatingActionButton(
        onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => LunchHistory( checkHistoryUid  : authMain.currentUser?.uid) ));},
        backgroundColor: Color(0xff0B01A2),
        child: Icon(Icons.view_timeline, color: Colors.white, size: 30),
      ),

      appBar: AppBar(
        centerTitle: true,title: Text('신청 목록'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (c) => LunchAddUI( pinCander : pinCander, reservtionCander : reservtionCander , fireDataSeat : fireDataSeat, checkLunchAddUid  : authMain.currentUser?.uid) )).then((value) {lunchBackRefresh();});
            },
            icon : Icon(Icons.add, color: Colors.white, size: 30),
          ),],
      ),

      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(backgroundColor: Color(0xff0B01A2)),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: itemTotalCount == 0 ? LunchNoneData() : ListView.builder(itemBuilder: (c, i) => LunchData( itemTotalCount : itemTotalCount, countWidget : i,fireListData : fireListData, fireDataSeat : fireDataSeat, listViewTotalLunch : listViewTotalLunch, onRefresh : _onRefresh), itemCount: itemTotalCount),
      ),
    );
  }
}

class LunchNoneData extends StatelessWidget {
  const LunchNoneData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      Text('등록된 신청이 없습니다.', style: style.dateSelecterFix,),SizedBox(height: 5,),
      Text('우측 상단 + 버튼을 눌러 도시락을 신청하실 수 있습니다.', style: style.dateSelecter,),SizedBox(height: 5,),
      Text('또는 화면을 밑으로 당겨서 새로고침해주세요.', style: style.dateSelecterFix,)
    ],),);
  }
}


class LunchData extends StatefulWidget {
  const LunchData({Key? key, this.itemTotalCount, this.fireListData, this.countWidget, this.fireDataSeat, this.listViewTotalLunch, this.onRefresh}) : super(key: key);
  final listViewTotalLunch;
  final fireListData;
  final countWidget;
  final fireDataSeat;
  final onRefresh;
  final itemTotalCount;

  @override
  State<LunchData> createState() => _LunchDataState();
}

class _LunchDataState extends State<LunchData> {

  @override
  Widget build(BuildContext context) {
    if (widget.fireListData[widget.listViewTotalLunch[widget.countWidget]]['type'] == 'pin'){
      return ListTile(
        dense:true,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
          ),
          height: 90,
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.push_pin,color: Colors.black,)
                  ],
                ),
              ),
              Flexible(fit: FlexFit.tight, flex: 7 ,child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.black, size: 20,),
                    SizedBox(width: 4,),
                    Text(widget.fireListData[widget.listViewTotalLunch[widget.countWidget]]['date'].toString(), style: style.dialogCheckTextBlack,),
                  ],
                ),
                SizedBox(height: 6,),
                Row(children: [
                  Icon(Icons.timelapse_outlined,size: 20, color: Colors.black,),
                  SizedBox(width: 4,),
                  Text(
                    '${widget.fireListData[widget.listViewTotalLunch[widget.countWidget]]['times']}',
                    style: style.listVeiwhirghitTextBlack,),
                ],),
              ],)),
              SizedBox(width: 10,),
              Flexible(fit: FlexFit.tight ,child: SizedBox(child: Center(child: IconButton(onPressed: () {
                showDialog(context: context, builder: (context) => LunchRemoveAnswer( listViewTotalLunch : widget.listViewTotalLunch, countWidget : widget.countWidget, fireDataSeat : widget.fireDataSeat, onRefresh : widget.onRefresh ));
              },
                icon: Icon(Icons.delete, color: Colors.black, size: 30,),)),))
            ],
          ),
        ),
      );
    }else{
      return ListTile(
        title: Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, widget.countWidget + 1 == widget.itemTotalCount ? 50 : 0),
          padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
          decoration: BoxDecoration(
              color: Color(0xffffffff),
              gradient: LinearGradient(colors: [ Color(0xffffffff), Color(0xffffffff).withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 4,blurRadius: 3, offset: Offset(0, 3))]
          ),
          height: 80,
          child: Row(
            children: [
              Flexible(fit: FlexFit.tight, flex: 7 ,child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.black, size: 20,),
                    SizedBox(width: 4,),
                    Text(widget.fireListData[widget.listViewTotalLunch[widget.countWidget]]['date'].toString(), style: style.dialogCheckTextBlack,),
                  ],
                ),
                SizedBox(height: 6,),
                Row(children: [
                  Icon(Icons.timelapse_outlined,size: 20, color: Colors.black,),
                  SizedBox(width: 4,),
                  Text(
                    '${widget.fireListData[widget.listViewTotalLunch[widget.countWidget]]['times']}',
                    style: style.listVeiwhirghitTextBlack,),
                ],),
              ],)),
              SizedBox(width: 10,),
              Flexible(fit: FlexFit.tight ,child: SizedBox(child: Center(child: IconButton(onPressed: () {
                showDialog(context: context, builder: (context) => LunchRemoveAnswer( listViewTotalLunch : widget.listViewTotalLunch, countWidget : widget.countWidget, fireDataSeat : widget.fireDataSeat, onRefresh : widget.onRefresh ));
              },
                icon: Icon(Icons.delete, color: Colors.black, size: 30,),)),)),
            ],
          ),
        ),
      );
    }
  }
}

class LunchRemoveAnswer extends StatefulWidget {
  const LunchRemoveAnswer({Key? key, this.countWidget, this.listViewTotalLunch, this.fireDataSeat, this.onRefresh}) : super(key: key);
  final countWidget;
  final listViewTotalLunch;
  final fireDataSeat;
  final onRefresh;

  @override
  State<LunchRemoveAnswer> createState() => _LunchRemoveAnswerState();
}

class _LunchRemoveAnswerState extends State<LunchRemoveAnswer> {
  bool removeError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('정말로 일정을 삭제하시겠습니까?',
          style: style.normalTextDark),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () async{
          try {
            final refGet = FirebaseDatabase.instance.ref('/lunch').child('${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}');
            await refGet.child('${widget.listViewTotalLunch[widget.countWidget]}').remove();
          }catch(e){
            diawiget.showSnackBar(context, '알수없는 오류');
            Navigator.pop(context);
            setState(() {
              removeError = true;
            });
          }
          if ( removeError == false ){
            widget.onRefresh();
            Future((){
              diawiget.showSnackBar(context, '성공');
              Navigator.pop(context);
            });
          }
        },
            style: ElevatedButton.styleFrom( shape: style.dialogCheckButton),
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



