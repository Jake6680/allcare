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

var barText = TextStyle(color:Color(0xffffffff));

var normalText = TextStyle( fontSize: 20, fontWeight: FontWeight.w600 );