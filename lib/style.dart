import 'package:flutter/material.dart';



ThemeData theme = ThemeData(

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

const barText = TextStyle(color:Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 14);
const barText2 = TextStyle(color:Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 15);
const normalText = TextStyle(color:Color(0xffffffff), fontSize: 20, fontWeight: FontWeight.w600 );
const normalTextgrey = TextStyle(color:Colors.grey, fontSize: 17, fontWeight: FontWeight.w600 );
const normalTextDark = TextStyle(color:Color(0xff000000), fontSize: 20, fontWeight: FontWeight.w600 );
const normalTextRed = TextStyle(color:Colors.red, fontSize: 20, fontWeight: FontWeight.w600 );
const floatingText = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
const letterMainText = TextStyle( fontSize: 18, fontWeight: FontWeight.w400 );
const dialogCheckButton = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
const dialogCheckText = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
const dialogCheckTextWhite = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);
const dialogCheckTextBlack = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black);
const dropDownBoxText = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black);
const dropDownBoxText2 = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
const dropDownBoxTextgrey = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey);
const dateSelecter = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
const dateSelecterFix = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey);
const speakerText = TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold);
const described = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey);
const noticeIconText = TextStyle(fontSize: 10,fontWeight: FontWeight.w600);
const dateSelectText = TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Colors.black);
const dateSelectTextgrey = TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Colors.grey);
const dateSelectTextOn = TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Colors.white);
const h1 = TextStyle( fontWeight: FontWeight.bold, fontSize: 30 );
const loginTextField = UnderlineInputBorder( borderSide: BorderSide(width: 2, color: Colors.black));
const textFieldLabel = TextStyle( color: Colors.grey, fontWeight: FontWeight.w500 );
const registerNormalText = TextStyle(fontWeight: FontWeight.bold);
const registerRedText = TextStyle(color: Colors.red);
const registerRedText2 = TextStyle(color: Colors.red, fontWeight: FontWeight.w500);
final registerDropBoxboder = BoxDecoration(border: Border.all(width: 1, color: Colors.black));
const suffixElevatedButton = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const listVeiwhirghitTextBlack = TextStyle(fontSize: 17,color: Colors.black, fontWeight: FontWeight.w600);
const listVeiwhirghitText = TextStyle(fontSize: 17,color: Colors.white, fontWeight: FontWeight.w600);
const dateWeekHead = TextStyle(fontSize: 18,color: Colors.black, fontWeight: FontWeight.w600);
const dateWeekBody = TextStyle(fontSize: 14,color: Colors.black, fontWeight: FontWeight.w400);