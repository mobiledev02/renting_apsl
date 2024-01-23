// ignore_for_file: prefer_const_constructors, prefer_final_fields

import '../constants/img_font_color_string.dart';

import '../constants/text_style_decoration.dart';
import 'package:flutter/material.dart';

class TextFieldDecoration {
  static BorderRadius get textBorderRadius => BorderRadius.circular(10.0);

  static Color get borderColor => custBlack102339.withOpacity(0.1);

  static Color get underLineBorderColor => Colors.transparent;

  static double get borderWidth => 1;

  // Outline border...
  static InputDecorationTheme get getOutLineInputDecoration =>
      InputDecorationTheme(
        filled: true,
        errorMaxLines: 2,
        hintStyle: TextStyleDecoration.hintTextStyle,
        labelStyle: TextStyleDecoration.labelTextStyle,
        errorStyle: const TextStyle(
          fontFamily: TextStyleDecoration.fontFamily,
          color: Colors.red,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        focusedErrorBorder: _focusedErrorBorder,
        errorBorder: _errorBorder,
        focusedBorder: _focusedBorder,
        border: _border,
        fillColor: custWhiteFFFFFF,
        enabledBorder: _enabledBorder,
        disabledBorder: _disabledBorder,
        contentPadding: EdgeInsets.symmetric(
          vertical: 18.0,
          horizontal: 20.0,
        ),
      );

  static OutlineInputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor,
      width: borderWidth,
    ),
  );

  static OutlineInputBorder _enabledBorder = OutlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: borderColor,
      width: borderWidth,
    ),
  );

  static OutlineInputBorder _disabledBorder = OutlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: borderColor,
      width: borderWidth,
    ),
  );

  static OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: borderColor,
      width: borderWidth,
    ),
  );

  static OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: Colors.red,
      width: borderWidth,
    ),
  );

  static OutlineInputBorder _focusedErrorBorder = OutlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: Colors.red,
      width: borderWidth,
    ),
  );

  // UnderLine border...
  static InputDecorationTheme get getUnderLineInputDecoration =>
      InputDecorationTheme(
        filled: true,
        errorMaxLines: 2,
        fillColor: Colors.transparent,
        focusColor: Colors.transparent,
        hintStyle: TextStyleDecoration.hintTextStyle,
        labelStyle: TextStyleDecoration.labelTextStyle,
        errorStyle: TextStyle(
          fontFamily: TextStyleDecoration.fontFamily,
          color: Colors.red,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        focusedErrorBorder: _underLineFocusedErrorBorder,
        errorBorder: _underLineErrorBorder,
        focusedBorder: _underLineFocusedBorder,
        border: _underLineBorder,
        enabledBorder: _underLineEnabledBorder,
        disabledBorder: _underLineDisabledBorder,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
      );

  static UnderlineInputBorder _underLineBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: underLineBorderColor,
      width: borderWidth,
    ),
  );

  static UnderlineInputBorder _underLineEnabledBorder = UnderlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: underLineBorderColor,
      width: borderWidth,
    ),
  );

  static UnderlineInputBorder _underLineDisabledBorder = UnderlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: underLineBorderColor,
      width: borderWidth,
    ),
  );

  static UnderlineInputBorder _underLineFocusedBorder = UnderlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: underLineBorderColor,
      width: borderWidth,
    ),
  );

  static UnderlineInputBorder _underLineErrorBorder = UnderlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: Colors.red,
      width: borderWidth,
    ),
  );

  static UnderlineInputBorder _underLineFocusedErrorBorder =
      UnderlineInputBorder(
    borderRadius: textBorderRadius,
    borderSide: BorderSide(
      color: Colors.red,
      width: borderWidth,
    ),
  );
}
