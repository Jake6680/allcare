import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../style.dart' as style;
import './dialogWidget.dart' as diawiget;

final firestoreLunch = FirebaseFirestore.instance;
RefreshController _refreshController = RefreshController(initialRefresh: false);

class LunchHistory extends StatefulWidget {
  const LunchHistory({Key? key, this.checkHistoryUid}) : super(key: key);
  final checkHistoryUid;

  @override
  State<LunchHistory> createState() => _LunchHistoryState();
}

class _LunchHistoryState extends State<LunchHistory> {
  int lunchMonthCount = 0;

  setLunchMonthCount(count){
    setState(() {
      lunchMonthCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('이용 내역'),actions: [Center(child: Text('총합 : $lunchMonthCount개', style: style.normalTextgrey,)),SizedBox(width: 10,)]),
      body: LunchHistoryBody( checkHistoryUid : widget.checkHistoryUid, setLunchMonthCount : setLunchMonthCount),
    );
  }
}

class LunchHistoryBody extends StatefulWidget {
  const LunchHistoryBody({Key? key, this.checkHistoryUid, this.setLunchMonthCount}) : super(key: key);
  final checkHistoryUid;
  final setLunchMonthCount;

  @override
  State<LunchHistoryBody> createState() => _LunchHistoryBodyState();
}

class _LunchHistoryBodyState extends State<LunchHistoryBody> {
  List<int> lunchDate = [];
  bool errorlevel1 = false;
  bool errorlevel2 = false;

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      lunchDate.clear();
      errorlevel1 = false;
    });
    try {
      await firestoreLunch.collection('lunch/History/${widget.checkHistoryUid}').get().then((QuerySnapshot lunchData){for (var lunchGetData in lunchData.docs) {
        setState(() {
          lunchDate.add(lunchGetData['date']);
        });
      }});
    } catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
      setState(() {
        errorlevel1 = true;
      });
    }
    if (errorlevel1 == false) {
      setState(() {
        lunchDate.sort((a, b) => b.compareTo(a));
        widget.setLunchMonthCount(lunchDate.length);
      });
    }
    _refreshController.refreshCompleted();
  }

  firestoreHistoryGetDate() async{
    setState(() {
      lunchDate.clear();
      errorlevel2 = false;
    });
    try {
      await firestoreLunch.collection('lunch/History/${widget.checkHistoryUid}').get().then((QuerySnapshot lunchData){for (var lunchGetData in lunchData.docs) {
        setState(() {
          lunchDate.add(lunchGetData['date']);
        });
      }});
    } catch(e){
      Future((){diawiget.showSnackBar(context, '알수없는 오류');});
      setState(() {
        errorlevel2 = true;
      });
    }
    if (errorlevel2 == false) {
      setState(() {
        lunchDate.sort((a, b) => b.compareTo(a));
        widget.setLunchMonthCount(lunchDate.length);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    firestoreHistoryGetDate();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropMaterialHeader(backgroundColor: Color(0xff0B01A2)),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(itemCount: lunchDate.length, itemBuilder: (c, i) {
          return ListTile(
            title: Column(
              children: [
                Container(
                    height: 60,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 1,color: Colors.grey)),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 23,
                          padding: EdgeInsets.all(3),
                          color: Colors.grey.withOpacity(0.3),
                          width: double.infinity,
                          child: Text('${lunchDate[i].toString().substring(0,4)}-${lunchDate[i].toString().substring(4,6)}-${lunchDate[i].toString().substring(6,8)}',style: style.dateWeekBody,),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(int.parse(lunchDate[i].toString().substring(8,9)) == 0 ? '점심' : '저녁',style: style.dateWeekHead,),
                              Text('신청완료',style: style.speakerText,)
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
        );}),
    );
  }
}

