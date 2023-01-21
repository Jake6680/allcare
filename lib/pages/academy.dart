import 'package:allcare/controller/loading_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controller/loading_controller.dart';
import './academyadd.dart';
import './dialogWidget.dart' as diawiget;
import '../style.dart' as style;


final authMain = FirebaseAuth.instance;
final firestore2 = FirebaseFirestore.instance;

RefreshController _refreshController = RefreshController(initialRefresh: false);

class AcademyUI extends StatefulWidget {
  const AcademyUI({Key? key}) : super(key: key);

  @override
  State<AcademyUI> createState() => _AcademyUIState();
}

class _AcademyUIState extends State<AcademyUI> {
  Map fireListData = {};
  Map<String, dynamic> fireDataSeat = {};
  int itemTotalCount = 0;
  List<String> listViewAcademy = [];
  late bool _acisLoading;

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final refGet = FirebaseDatabase.instance.ref().child('attendance/${fireDataSeat['place']}/${fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          itemTotalCount = 0;
          listViewAcademy.clear();
          fireListData = (snapshot.value as dynamic);
          for (String leaveEarlyA in fireListData.keys){
            if (leaveEarlyA != 'state'){
              if (fireListData[leaveEarlyA]['type'] == 'Academy'){
                listViewAcademy.add(leaveEarlyA);
                itemTotalCount++;
              }
            }
          }
        });
      }
    } catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
    }
    _refreshController.refreshCompleted();
  }

  acbackRefresh() async{
    IsLoadingControlleracademy.to.isLoading = true;
    try {
      final refGet = FirebaseDatabase.instance.ref().child('attendance/${fireDataSeat['place']}/${fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          itemTotalCount = 0;
          listViewAcademy.clear();
          fireListData = (snapshot.value as dynamic);
          for (String leaveEarlyA in fireListData.keys){
            if (leaveEarlyA != 'state'){
              if (fireListData[leaveEarlyA]['type'] == 'Academy'){
                listViewAcademy.add(leaveEarlyA);
                itemTotalCount++;
              }
            }
          }
        });
      }
      IsLoadingControlleracademy.to.isLoading = false;
    } catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
      IsLoadingControlleracademy.to.isLoading = false;
    }
  }


  fireGetList() async{
    try {
      await firestore2.collection('customer').where('uid', isEqualTo: authMain.currentUser?.uid).get().then((QuerySnapshot dcName){for (var docName in dcName.docs) {
        setState(() {
          fireDataSeat = docName['seat'];
        });
      }});
      final refGet = FirebaseDatabase.instance.ref().child('attendance/${fireDataSeat['place']}/${fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          itemTotalCount = 0;
          listViewAcademy.clear();
          fireListData = (snapshot.value as dynamic);
          for (String leaveEarlyA in fireListData.keys){
            if (leaveEarlyA != 'state'){
              if (fireListData[leaveEarlyA]['type'] == 'Academy'){
                listViewAcademy.add(leaveEarlyA);
                itemTotalCount++;
              }
            }
          }
        });
      }
    }catch(e){
      diawiget.showSnackBar(context, '알수없는 오류');
    }
    setState(() {
      _acisLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    _acisLoading = true;
    fireGetList();
  }


  @override
  Widget build(BuildContext context) {
    Get.put(IsLoadingControlleracademy());
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,title: Text('설정 목록'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (c) => AcademyAdd(fireDataSeat : fireDataSeat) )).then((value) {acbackRefresh();});
              },
            icon : Icon(Icons.add, color: Colors.white, size: 30),
          ),],
      ),

      body: _acisLoading ? const Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator(color: Color(0xff0B01A2),)),)
        :Stack(
          children: [
            SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(backgroundColor: Color(0xff0B01A2)),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: itemTotalCount == 0 ? AcademyNoneData() : ListView.builder(itemBuilder: (c, i) => AcademyData(countWidget : i,fireListData : fireListData, fireDataSeat : fireDataSeat, listViewAcdemy : listViewAcademy, onRefresh : _onRefresh), itemCount: itemTotalCount),
            ),
            Obx(
                  () => Offstage(
                offstage: !IsLoadingControlleracademy.to.isLoading,
                child: Stack(children: const <Widget>[
                  Opacity(
                    opacity: 0.5,
                    child: ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                  Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0B01A2))),
                  ),
                ]),
              ),
            ),
          ],
        ),
    );
  }
}

class AcademyNoneData extends StatelessWidget {
  const AcademyNoneData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      Text('등록된 일정이 없습니다.', style: style.dateSelecterFix,),SizedBox(height: 5,),
      Text('우측 상단 + 버튼을 눌러 일정을 등록하실 수 있습니다.', style: style.dateSelecter,),SizedBox(height: 5,),
      Text('또는 화면을 밑으로 당겨서 새로고침해주세요.', style: style.dateSelecterFix,)
    ],),);
  }
}


class AcademyData extends StatefulWidget {
  const AcademyData({Key? key, this.fireListData, this.countWidget, this.fireDataSeat, this.listViewAcdemy, this.onRefresh}) : super(key: key);
  final listViewAcdemy;
  final fireListData;
  final countWidget;
  final fireDataSeat;
  final onRefresh;

  @override
  State<AcademyData> createState() => _AcademyDataState();
}

class _AcademyDataState extends State<AcademyData> {


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xff0099A4),
            gradient: LinearGradient(colors: [ Color(0xff0099A4).withRed((widget.countWidget + 1) * 41), Color(0xff0099A4).withRed((widget.countWidget + 1) * 41).withOpacity(0.7)]),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: Color(0xff0099A4).withRed((widget.countWidget + 1) * 41).withOpacity(0.3),spreadRadius: 4,blurRadius: 3, offset: Offset(0, 3))]
        ),
        height: 110,
        child: Row(
          children: [
            Flexible(fit: FlexFit.tight, flex: 7 ,child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.fireListData[widget.listViewAcdemy[widget.countWidget]]['reason'], style: style.dialogCheckTextWhite,),
              SizedBox(height: 6,),
              Row(children: [
                Icon(Icons.date_range,size: 20, color: Colors.white,),
                SizedBox(width: 4,),
                Text(
                  '${widget.fireListData[widget.listViewAcdemy[widget.countWidget]]['date']}',
                  style: style.listVeiwhirghitText,),
              ],),
              SizedBox(height: 6,),
              Row(children: [
                Icon(Icons.timelapse_outlined,size: 20, color: Colors.white,),
                SizedBox(width: 4,),
                Text(
                 '${widget.fireListData[widget.listViewAcdemy[widget.countWidget]]['start']} ~ ${widget.fireListData[widget.listViewAcdemy[widget.countWidget]]['end'].toString()}',
                  style: style.listVeiwhirghitText,),
              ],),
            ],)),
            SizedBox(width: 10,),
            Flexible(fit: FlexFit.tight ,child: SizedBox(child: Center(child: IconButton(onPressed: () {
              showDialog(context: context, builder: (context) => AcRemoveAnswer( listViewTotal : widget.listViewAcdemy, countWidget : widget.countWidget, fireDataSeat : widget.fireDataSeat, onRefresh : widget.onRefresh ));
            }, icon: Icon(Icons.delete, color: Colors.white, size: 30,),)),))
          ],
        ),
      ),
    );
  }
}

class AcRemoveAnswer extends StatefulWidget {
  const AcRemoveAnswer({Key? key, this.countWidget, this.listViewTotal, this.fireDataSeat, this.onRefresh}) : super(key: key);
  final countWidget;
  final listViewTotal;
  final fireDataSeat;
  final onRefresh;

  @override
  State<AcRemoveAnswer> createState() => _AcRemoveAnswerState();
}

class _AcRemoveAnswerState extends State<AcRemoveAnswer> {
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
            final refGet = FirebaseDatabase.instance.ref().child('attendance/${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}');
            await refGet.child('${widget.listViewTotal[widget.countWidget]}').remove();
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



