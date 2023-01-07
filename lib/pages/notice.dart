import 'package:flutter/material.dart';
import '../style.dart' as style;

class noticeUI extends StatelessWidget {
  const noticeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text('공지함'),
      ),

    );
  }
}