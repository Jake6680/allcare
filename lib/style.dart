import 'package:flutter/material.dart';



var theme = ThemeData(

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff0B01A2)
      )
  ),

  appBarTheme: AppBarTheme(
      color: Color(0xff0B01A2),
      titleTextStyle: TextStyle( fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white  )
  ),

);

var barText = TextStyle(color:Color(0xffffffff), fontWeight: FontWeight.w500);
var normalText = TextStyle(color:Color(0xffffffff), fontSize: 20, fontWeight: FontWeight.w600 );
var normalTextDark = TextStyle(color:Color(0xff000000), fontSize: 20, fontWeight: FontWeight.w600 );
var floatingText = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
var letterMainText = TextStyle( fontSize: 18, fontWeight: FontWeight.w400 );
var dialogCheckButton = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
var dialogCheckText = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
var speakerText = TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold);
var noticeIconText = TextStyle(fontSize: 10,fontWeight: FontWeight.w600);