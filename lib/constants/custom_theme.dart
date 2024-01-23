// ignore_for_file: prefer_const_constructors, avoid_classes_with_only_static_members

import '../constants/text_style_decoration.dart';
import '../constants/textfield_decoration.dart';
import 'package:flutter/material.dart';
import 'img_font_color_string.dart';

class CustomAppTheme {
  static const Color bluePrimary = custBlack102339;
  static const Color blackPrimary = Colors.black;

  static ThemeData lightTheme = ThemeData(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: custBlack102339,
    ),

    // secondyColor: custBlack102339,
    brightness: Brightness.light,
    primarySwatch: custMaterialPrimaryColor,
    primaryColor: primaryColor,
    // accentColor: custMaterialPurple,
    textTheme: TextStyleDecoration.lightTheme,
    primaryTextTheme: TextStyleDecoration.lightTheme,
    backgroundColor: custWhiteFFFFFF,
    dividerColor: custE8E8E8,
    dividerTheme: DividerThemeData(
      color: custLightGreenEAF0FC,
      thickness: 1,
    ),
    unselectedWidgetColor: custDBDEE3,
    disabledColor: custWhiteFFFFFF,
    scaffoldBackgroundColor: custWhiteFFFFFF,
    inputDecorationTheme: TextFieldDecoration.getOutLineInputDecoration,
    fontFamily: CustomFont.metropolis,

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(130.0, 40.0),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: Colors.white, width: 3.0),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shadowColor:
            MaterialStateProperty.all<Color>(Color.fromRGBO(2, 149, 125, 0.4)),
        fixedSize: MaterialStateProperty.all(
          Size(250.0, 46.0),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        elevation: MaterialStateProperty.all<double>(10.0),
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
            side: BorderSide(
              color: primaryColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    ),
    tabBarTheme: TabBarTheme(
      // indicatorSize: TabBarIndicatorSize.label,

      unselectedLabelColor: custDDE7FA,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 13,
        fontFamily: CustomFont.redHatDisplay,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 13,
        fontFamily: CustomFont.redHatDisplay,
      ),
    ),
  );
}
