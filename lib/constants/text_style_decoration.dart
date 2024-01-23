// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../constants/img_font_color_string.dart';
import 'custom_theme.dart';

// overline : 10.0
// caption  : 12.0
// bodytext1: 14.0
// bodytext2: 16.0
// headline1: 18.0
// headline2: 20.0
// headline3: 22.0
// headline4: 24.0
// headline5: 26.0
// headline6: 28.0

class TextStyleDecoration {
  // App Default font...
  static const String fontFamily = CustomFont.metropolis;

  // Get Text theme...
  static TextTheme get lightTheme => TextTheme(
        overline: _overline,
        // 10.0
        caption: _caption,
        // 12.0
        bodyText1: _body1,
        // 14.0
        bodyText2: _body2,
        // 16.0
        headline1: _headline1,
        // 18.0
        headline2: _headline2,
        // 20.0
        headline3: _headline3,
        // 22.0
        headline4: _headline4,
        // 24.0
        headline5: _headline5,
        // 26.0
        headline6: _headline6,
        // 28.0
        subtitle1: _subTitle,
        // 14.0 this is also used when no style is given to textfield..
        subtitle2: _subHeadline,
        // 16.0
        button: _button, // 14.0
        // headlineMedium: appBarTitle,
      );

  static final _overline = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static final _caption = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle _body1 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static final _body2 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  static final font12semiBold = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
  );

  static final appBarTitle = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static final _headline1 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline2 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline3 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline4 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline5 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline6 = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 28.0,
    fontWeight: FontWeight.w500,
  );

  static final _subTitle = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final _subHeadline = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  static final _button = TextStyle(
    fontFamily: fontFamily,
    color: custBlack102339,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get hintTextStyle => TextStyle(
        fontSize: 14,
        fontFamily: CustomFont.metropolis,
        fontWeight: FontWeight.w500,
        color: custBlack102339.withOpacity(0.5),
      );

  static TextStyle get labelTextStyle => TextStyle(
        color: custBlack102339WithOpacity,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      );
}

class TextStyleBlackDecoration {
  // App Default font...
  static const String fontFamily = CustomFont.metropolis;

  // Get Text theme...
  static TextTheme get lightTheme => TextTheme(
        overline: _overline,
        // 10.0
        caption: _caption,
        // 12.0
        bodyText1: _body1,
        // 14.0
        bodyText2: _body2,
        // 16.0
        headline1: _headline1,
        // 18.0
        headline2: _headline2,
        // 20.0
        headline3: _headline3,
        // 22.0
        headline4: _headline4,
        // 24.0
        headline5: _headline5,
        // 26.0
        headline6: _headline6,
        // 28.0
        subtitle1: _subTitle,
        // 14.0 this is also used when no style is given to textfield..
        subtitle2: _subHeadline,
        // 16.0
        button: _button, // 14.0
      );

  static final _overline = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static final _caption = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle _body1 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static final _body2 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline1 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline2 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline3 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline4 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline5 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
  );

  static final _headline6 = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 28.0,
    fontWeight: FontWeight.w500,
  );

  static final _subTitle = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static final _subHeadline = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  static final _button = TextStyle(
    fontFamily: fontFamily,
    color: CustomAppTheme.blackPrimary,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get hintTextStyle => TextStyle(
        color: cust838485,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelTextStyle => TextStyle(
        color: cust343C54,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );
}
