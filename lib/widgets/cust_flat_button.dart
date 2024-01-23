import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';

import '../constants/img_font_color_string.dart';
import '../main.dart';
import 'custom_text.dart';

class CustomFlatButton extends StatelessWidget {
  final String buttonTitle;
  final Color? buttonColor;
  final Function() onPressed;
  final bool loadingIndicator;
  final Color? shadowColor;
  final double buttonHeight;
  final double? buttonWidth;
  final bool hideShadow;
  final Color? loaderAndTextColor;
  final TextStyle? textStyle;
  final double radius;
  final BorderSide? borderSide;
  final Widget? child;

  const CustomFlatButton({
    this.buttonTitle = "Button Text",
    required this.onPressed,
    this.buttonColor = custMaterialPrimaryColor,
    this.loadingIndicator = false,
    this.shadowColor,
    this.buttonHeight = 48,
    this.buttonWidth,
    this.hideShadow = false,
    this.loaderAndTextColor,
    this.borderSide,
    this.textStyle,
    this.radius = 10.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: hideShadow
          ? null
          : BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? custACACAC).withOpacity(
              0.2,
            ),
            offset: const Offset(0, 6),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: borderSide == null
                  ? const BorderSide(color: Colors.transparent, width: 0)
                  : (borderSide ??
                  const BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  )),
            ),
          ),
          elevation: hideShadow ? MaterialStateProperty.all<double>(0) : null,
        ),
        onPressed: loadingIndicator ? () {} : onPressed,
        child: loadingIndicator
            ? SizedBox(
          height: 30,
          width: 30,
          child: Spinner(
            progressColor: (loaderAndTextColor ?? Colors.white),
          ),
        )
            : child ??
            CustomText(
              txtTitle: buttonTitle,
              align: TextAlign.center,
              style: textStyle ??
                  Theme.of(getContext).textTheme.bodyText1?.copyWith(
                    color: (loaderAndTextColor ?? Colors.white),
                    fontWeight: FontWeight.w600,
                  ),
            ),
      ),
    );
  }
}