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

final barText = TextStyle(color:Color(0xffffffff), fontWeight: FontWeight.w500);
final normalText = TextStyle(color:Color(0xffffffff), fontSize: 20, fontWeight: FontWeight.w600 );
final normalTextDark = TextStyle(color:Color(0xff000000), fontSize: 20, fontWeight: FontWeight.w600 );
final floatingText = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
final letterMainText = TextStyle( fontSize: 18, fontWeight: FontWeight.w400 );
final dialogCheckButton = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
final dialogCheckText = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
final dropDownBoxText = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black);
final speakerText = TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold);
final noticeIconText = TextStyle(fontSize: 10,fontWeight: FontWeight.w600);