import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import './leave.dart';
import '../style.dart' as style;

RefreshController _refreshController = RefreshController(initialRefresh: false);

class LeaveUI extends StatefulWidget {
  const LeaveUI({Key? key, this.fireDataSeat}) : super(key: key);
  final fireDataSeat;

  @override
  State<LeaveUI> createState() => _LeaveUIState();
}

class _LeaveUIState extends State<LeaveUI> {

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 500));
    _refreshController.refreshCompleted();
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

      appBar: AppBar(centerTitle: true,title: Text('설정된 목록'),),

      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(backgroundColor: Color(0xff0B01A2)),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Text('ㅎㅇ'),
      ),
    );
  }
}
