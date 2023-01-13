import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_database/firebase_database.dart';

import './leave.dart';
import './dialogWidget.dart' as diawiget;
import '../style.dart' as style;

RefreshController _refreshController = RefreshController(initialRefresh: false);

class LeaveUI extends StatefulWidget {
  const LeaveUI({Key? key, this.fireDataSeat}) : super(key: key);
  final fireDataSeat;

  @override
  State<LeaveUI> createState() => _LeaveUIState();
}

class _LeaveUIState extends State<LeaveUI> {
  Map fireListData = {};

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final refGet = FirebaseDatabase.instance.ref().child('attendance/${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          fireListData = (snapshot.value as dynamic);
        });
      }
    }catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
    }
    _refreshController.refreshCompleted();
  }
  fireGetList() async{
    try {
      final refGet = FirebaseDatabase.instance.ref().child('attendance/${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}');
      final snapshot = await refGet.get();
      if (snapshot.exists) {
        setState(() {
          fireListData = (snapshot.value as dynamic);
        });
      }
    }catch(e){
      diawiget.showSnackBar(context, '알수없는 오류');
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
        onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (c) => LeaveAddUI(fireDataSeat : widget.fireDataSeat) ));},
        backgroundColor: Color(0xff0B01A2),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),

      appBar: AppBar(centerTitle: true,title: Text('목록'),),

      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(backgroundColor: Color(0xff0B01A2)),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: fireListData.isEmpty ? OALNoneData() : fireListData.length == 1 ? OALNoneData() : ListView.builder(itemBuilder: (c, i) => OALListData(fireListData : fireListData), itemCount: fireListData.length - 1),
      ),
    );
  }
}

class OALNoneData extends StatelessWidget {
  const OALNoneData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('등록된 일정이 없습니다.', style: style.dateSelecterFix,),SizedBox(height: 5,),Text('화면을 밑으로 당겨서 새로고침해주세요.', style: style.dateSelecterFix,)],),);
  }
}


class OALListData extends StatelessWidget {
  const OALListData({Key? key, this.fireListData}) : super(key: key);
  final fireListData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Container(
          margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.8),spreadRadius: 4,blurRadius: 3, offset: Offset(0, 3))]),
          height: 110,
          child: Row(
            children: [
              Flexible(fit: FlexFit.tight, flex: 7 ,child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('결석', style: style.dialogCheckText,),
                SizedBox(height: 10,),
                Row(children: [
                  Icon(Icons.calendar_month,size: 20,),
                  SizedBox(width: 4,),
                  Text('2022-1-13', style: style.listVeiwhirghitText,),
                ],),
                SizedBox(height: 3,),
                Row(children: [
                  Icon(Icons.text_fields),
                  SizedBox(width: 4,),
                  Flexible(fit: FlexFit.tight ,child: Text('배아파서dddddddddddddsdadasddasdasdasddddd', overflow: TextOverflow.fade, softWrap: false, style: style.described,))
                ],),
              ],)),
              SizedBox(width: 10,),
              Flexible(fit: FlexFit.tight ,child: SizedBox(child: Center(child: IconButton(onPressed: (){},icon: Icon(Icons.delete, color: Colors.red, size: 30,),)),))
            ],
          ),
        ),
    );
  }
}


