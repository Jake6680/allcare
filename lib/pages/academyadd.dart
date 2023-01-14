import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';

import './dialogWidget.dart' as diawiget;
import '../style.dart' as style;

class AcademyAdd extends StatelessWidget {
  const AcademyAdd({Key? key, this.fireDataSeat}) : super(key: key);
  final fireDataSeat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('고정 외출 등록'),),
        body: AcademyWidget( fireDataSeat : fireDataSeat)
    );
  }
}


class AcademyWidget extends StatefulWidget {
  const AcademyWidget({Key? key, this.fireDataSeat}) : super(key: key);
  final fireDataSeat;

  @override
  State<AcademyWidget> createState() => _AcademyWidgetState();
}

class _AcademyWidgetState extends State<AcademyWidget> {
  final values = List.filled(7, false);
  late TextEditingController _academycontroller1;
  late TextEditingController _academycontroller2;
  String _valueAcademy1 = '10:00';
  String _valueAcademy2 = '12:00';
  String acbecauseText = '';
  bool valuesBoolCheck = false;
  List<String> valuesDateList = [];
  int valuesCount = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _academycontroller1 = TextEditingController(text: '10:00');
      _academycontroller2 = TextEditingController(text: '12:00');
    });
  }
  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('사유', style: style.normalTextDark,),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 4,blurRadius: 7, offset: Offset(0, 3))]
                  ),
                  child: TextField(
                    minLines: 3,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: '내용',
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20),),
                      ),
                    ),
                    onChanged: (text){
                      setState(() {
                        acbecauseText = text;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30,),
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
                            values[index] = !values[index];
                          });
                        },
                        values: values,
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
                    Flexible(
                      fit: FlexFit.tight,
                      child: DateTimePicker(
                          decoration: InputDecoration(icon: Icon(Icons.access_time, color: Colors.grey), labelText: '나가는 시간',labelStyle: style.dropDownBoxText,contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                          type: DateTimePickerType.time,
                          controller: _academycontroller1,
                          //initialValue: _initialValue,
                          // firstDate: DateTime.now(),
                          icon: Icon(Icons.access_time),
                          style: style.dateSelecter,
                          //use24HourFormat: false,
                          locale: Locale('ko', 'KR'),
                          onChanged: (val) => setState(() => _valueAcademy1 = val)
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: DateTimePicker(
                          decoration: InputDecoration(fillColor: Colors.red ,icon: Icon(Icons.share_arrival_time_outlined, color: Colors.grey,size: 30,), labelText: '들어오는 시간',labelStyle: style.dropDownBoxText,contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                          type: DateTimePickerType.time,
                          controller: _academycontroller2,
                          //initialValue: _initialValue,
                          // firstDate: DateTime.now(),
                          icon: Icon(Icons.access_time),
                          style: style.dateSelecter,
                          //use24HourFormat: false,
                          locale: Locale('ko', 'KR'),
                          onChanged: (val) => setState(() => _valueAcademy2 = val)
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(height: 1,color: Colors.grey,),
                  ],
                ),
                SizedBox(height: 50,),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: ()async{
                    valuesDateList.clear();
                    for (int i = 1; i < 7; i++) {
                      if (values[i] == true){
                        setState(() {
                          valuesBoolCheck = true;
                          if (i == 1){
                            valuesDateList.add('월');
                            valuesCount++;
                          } else if (i == 2){
                            valuesDateList.add('화');
                            valuesCount++;
                          }else if (i == 3){
                            valuesDateList.add('수');
                            valuesCount++;
                          }else if (i == 4){
                            valuesDateList.add('목');
                            valuesCount++;
                          }else if (i == 5){
                            valuesDateList.add('금');
                            valuesCount++;
                          }else if (i == 6){
                            valuesDateList.add('토');
                            valuesCount++;
                          }
                        });
                      }
                    }
                    if (values[0] == true){
                      setState(() {
                      valuesDateList.add('일');
                      valuesCount++;
                    });}
                    if (acbecauseText == ''){
                      showDialog(context: context, builder: (context) => diawiget.FailDialog(failContent: '내용을 입력해주세요.'));
                    }else if ( int.parse(_valueAcademy1.toString().substring(0, 2)) > int.parse(_valueAcademy2.toString().substring(0, 2))){
                      showDialog(context: context, builder: (context) => diawiget.FailDialog(failContent: '시간을 다시 확인해주세요'));
                    }else if ( int.parse(_valueAcademy1.toString().substring(0, 2)) == int.parse(_valueAcademy2.toString().substring(0, 2)) && int.parse(_valueAcademy1.toString().substring(3, 5)) >= int.parse(_valueAcademy2.toString().substring(3, 5))){
                      showDialog(context: context, builder: (context) => diawiget.FailDialog(failContent: '시간을 다시 확인해주세요'));
                    }else if (valuesDateList.isEmpty){
                      showDialog(context: context, builder: (context) => diawiget.FailDialog(failContent: '요일을 선택해주세요.'));
                    }else{
                      showDialog(context: context, builder: (context) => AcCheckDialog( valuesCount : valuesCount, valuesDateList: valuesDateList, valueAcademy1 : _valueAcademy1, valueAcademy2 : _valueAcademy2, acbecauseText : acbecauseText, fireDataSeat : widget.fireDataSeat));
                    }
                  }, child: Text('등록',style: style.normalText,)),
                )
              ],
            ),
        ),
      ]
    );
  }
}

class AcCheckDialog extends StatefulWidget {
  const AcCheckDialog({Key? key, this.valuesCount, this.valuesDateList, this.acbecauseText, this.valueAcademy1, this.valueAcademy2, this.fireDataSeat}) : super(key: key);
  final valuesDateList;
  final valueAcademy1;
  final valueAcademy2;
  final acbecauseText;
  final fireDataSeat;
  final valuesCount;

  @override
  State<AcCheckDialog> createState() => _AcCheckDialogState();
}

class _AcCheckDialogState extends State<AcCheckDialog> {
  bool acsendErrorLevel = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.valuesDateList.toString(), style: style.normalTextDark),
            Text('${widget.valueAcademy1} ~ ${widget.valueAcademy2}', style: style.normalTextDark),
            Text('등록 하시겠습니까?', style: style.normalTextDark),
          ]),
      shape: style.dialogCheckButton,
      actions: [
        ElevatedButton(onPressed: () async{
          try{
            final acnewPostKey = FirebaseDatabase.instance.ref().child('attendance/${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}').push().key;
            final acref = FirebaseDatabase.instance.ref('/attendance').child('${widget.fireDataSeat['place']}/${widget.fireDataSeat['number']}/$acnewPostKey');
            await acref.set({
              'type' : 'Academy',
              'reason' : widget.acbecauseText,
              'date' : widget.valuesDateList,
              'dateCount' : widget.valuesCount,
              'start': widget.valueAcademy1,
              'end': widget.valueAcademy2,
            });
          }catch(e) {
            Navigator.pop(context);
            diawiget.showSnackBar(context, '알수없는 오류');
            setState(() {
              acsendErrorLevel = true;
            });
          }
          if (acsendErrorLevel != true){
            Future((){
              diawiget.showSnackBar(context, '등록 완료');
              Navigator.popUntil(context, ModalRoute.withName('/academy'));
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