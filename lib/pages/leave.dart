import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_database/firebase_database.dart';

import '../style.dart' as style;
import './leavelist.dart';


class LeaveAddUI extends StatefulWidget {
  const LeaveAddUI({Key? key, this.fireDataSeat}) : super(key: key);
  final fireDataSeat;

  @override
  State<LeaveAddUI> createState() => _LeaveAddUIState();
}

class _LeaveAddUIState extends State<LeaveAddUI> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  String _valueChanged2 = '';
  var setStartDate;
  var setEndDate;
  var sendDialogContent;
  String becauseText1 = '';
  String becauseText2 = '';
  String becauseText3 = '';
  @override
  void initState() {
    super.initState();
    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _controller2 = TextEditingController(text: '$lsHour:$lsMinute');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('외출/조퇴/결석'),),
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          slivers: [
            const SliverPersistentHeader(
                pinned: true, delegate: TabBarDelegate()),
            SliverFillRemaining(
              // 탭바 뷰 내부에는 스크롤이 되는 위젯이 들어옴.
              hasScrollBody: true,
              child: TabBarView(
                children: [
                  ListView(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('사유', style: style.normalTextDark,),
                        SizedBox(height: 10,),
                        TextField(
                          minLines: 2,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: '내용',
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                          onChanged: (text){
                            setState(() {
                              becauseText1 = text;
                            });
                          },
                        ),
                        SizedBox(height: 30,),
                        Text('나가는 시간', style: style.normalTextDark,),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'yyyy년-MMM-d일',
                          controller: _controller1,
                          //initialValue: _initialValue,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          style: style.dateSelecter,
                          //use24HourFormat: false,
                          locale: Locale('ko', 'KR'),
                        ),
                        SizedBox(height: 30,),
                        Text('돌아오는 시간', style: style.normalTextDark,),
                        DateTimePicker(
                          type: DateTimePickerType.time,
                          controller: _controller2,
                          //initialValue: _initialValue,
                            // firstDate: DateTime.now(),
                            icon: Icon(Icons.access_time),
                          style: style.dateSelecter,
                          //use24HourFormat: false,
                          locale: Locale('ko', 'KR'),
                          onChanged: (val) => setState(() => _valueChanged2 = val)
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
                            if (becauseText1 == '') {
                              showDialog(context: context, builder: (context) => FailDialog(failContent : '사유를 입력해주세요.'));
                            }else if (_valueChanged2 == '' || int.parse(_valueChanged2.toString().substring(0, 2)) < int.parse(_controller1.text.toString().substring(11, 13)) || int.parse(_valueChanged2.toString().substring(3, 5)) < int.parse(_controller1.text.toString().substring(14, 16))) {
                              showDialog(context: context, builder: (context) => FailDialog(failContent : '돌아오는 시간을 제대로 설정해주세요.'));
                            }else if (int.parse(_valueChanged2.toString().substring(0, 2)) == int.parse(_controller1.text.toString().substring(11, 13)) && int.parse(_valueChanged2.toString().substring(3, 5)) == int.parse(_controller1.text.toString().substring(14, 16))){
                              showDialog(context: context, builder: (context) => FailDialog(failContent : '돌아오는 시간을 제대로 설정해주세요.'));
                            } else{
                              showDialog(context: context, builder: (context) => CheckDialog( fireDataSeat : widget.fireDataSeat, date : _controller1.text.toString().substring(0, 10), startDate : _controller1.text.toString().substring(11, 16), endDate : _valueChanged2, backHomeType : 'outing', becauseText : becauseText1, clearMessage : '${_controller1.text.toString().substring(5, 7)}월 ${_controller1.text.toString().substring(8, 10)}일 ${_controller1.text.toString().substring(11, 16)} ~ $_valueChanged2', clearMessage2 : '외출을 하시겠습니까?'));
                            }
                          }, child: Text('보내기', style: style.normalText,)),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  ],),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('사유', style: style.normalTextDark,),
                        SizedBox(height: 10,),
                        TextField(
                          minLines: 2,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: '내용',
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                          onChanged: (text){
                            setState(() {
                              becauseText2 = text;
                            });
                          },
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
                            if (becauseText2 == '') {
                              showDialog(context: context, builder: (context) => FailDialog(failContent : '사유를 입력해주세요.'));
                            } else{
                              showDialog(context: context, builder: (context) => CheckDialog( fireDataSeat : widget.fireDataSeat, backHomeType : 'leaveEarly', becauseText : becauseText2, clearMessage : '조퇴를 하시겠습니까?'));
                            }
                          }, child: Text('보내기', style: style.normalText,)),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  ListView(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('사유', style: style.normalTextDark,),
                        SizedBox(height: 10),
                        TextField(
                          minLines: 2,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: '내용',
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                          onChanged: (text){
                            setState(() {
                              becauseText3 = text;
                            });
                          },
                        ),SizedBox(height: 10,),
                        SfDateRangePicker(
                          minDate: DateTime.now(),
                          maxDate: DateTime(2100),
                          view: DateRangePickerView.month,
                          selectionMode: DateRangePickerSelectionMode.range,
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            setState(() {
                              if (args.value is PickerDateRange) {
                                setStartDate = args.value.startDate
                                    .toString()
                                    .substring(0, 10);

                                setEndDate = args.value.endDate != null
                                    ? args.value.endDate
                                    .toString()
                                    .substring(0, 10)
                                    : setStartDate;
                              }
                            });
                          },
                        ),
                        Text('*결석 시작 날짜를 선택 후 결석 범위를 지정할 수 있습니다.', style: style.registerRedText2,),
                        Text('*하루만 결석할 때는 당일 날짜만 선택해주세요.', style: style.registerRedText2,),
                        SizedBox(height: 10,),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
                            if (setStartDate == null){
                              showDialog(context: context, builder: (context) => FailDialog(failContent : '날짜를 선택해주세요.'));
                            } else if (becauseText3 == '') {
                              showDialog(context: context, builder: (context) => FailDialog(failContent : '사유를 입력해주세요.'));
                            } else{
                              showDialog(context: context, builder: (context) => CheckDialog( fireDataSeat : widget.fireDataSeat, endDate: setEndDate, startDate: setStartDate, backHomeType : 'absent', becauseText : becauseText3,clearMessage : '$setStartDate ~ $setEndDate', clearMessage2 : '결석을 하시겠습니까?'));
                            }
                          }, child: Text('보내기', style: style.normalText,)),
                        ),
                        SizedBox(height: 10,),
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
                "외출", style: style.dropDownBoxText,
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Text(
                "조퇴", style: style.dropDownBoxText,
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Text(
                "결석", style: style.dropDownBoxText,
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


class CheckDialog extends StatefulWidget {
  const CheckDialog({Key? key,this.fireDataSeat , this.backHomeType, this.becauseText , this.clearMessage, this.clearMessage2, this.date, this.startDate, this.endDate}) : super(key: key);
  final backHomeType;
  final fireDataSeat;
  final date;
  final startDate;
  final endDate;
  final becauseText;
  final clearMessage;
  final clearMessage2;


  @override
  State<CheckDialog> createState() => _CheckDialogState();
}

class _CheckDialogState extends State<CheckDialog> {
  bool sendErrorLevel = false;

  void showSnackBar(BuildContext context, content) {
    final snackBar = SnackBar(
      content: Text(content, textAlign: TextAlign.center, style: style.normalText),
      backgroundColor: Colors.black.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: content == '원장님에게 문자도 남겨주세요!' ? 300 : 140,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(widget.clearMessage ?? '',
            style: style.normalTextDark),
        Text(widget.clearMessage2 ?? '',
            style: style.normalTextDark),
      ]),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () async{
          try{
            final refa = FirebaseDatabase.instance.ref('/attendance').child('${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}/${widget.backHomeType}');
            if (widget.backHomeType == 'outing'){
              await refa.set({
                'reason' : widget.becauseText,
                'start': '${widget.date} ${widget.startDate}',
                'end': '${widget.date} ${widget.endDate}',
              });
            }else if (widget.backHomeType == 'absent') {
              await refa.set({
                'reason' : widget.becauseText,
                'start': widget.startDate,
                'end': widget.endDate,
              });
            } else{
              await refa.set({
                'reason' : widget.becauseText,
                'date' : DateTime.now().toString().substring(0, 16)
              });
            }
          }catch(e) {
            Navigator.pop(context);
            showSnackBar(context, '알수없는 오류');
            setState(() {
              sendErrorLevel = true;
            });
          }
          if (sendErrorLevel != true){
            Future((){
              showSnackBar(context, widget.backHomeType == 'leaveEarly' || widget.backHomeType == 'absent' ? '원장님에게 문자도 남겨주세요!' : '저장 완료');
              Navigator.pop(context);
            });
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

