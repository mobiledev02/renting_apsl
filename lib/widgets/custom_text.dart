import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? txtTitle;
  final TextStyle? style;
  final TextAlign? align;
  final Alignment? btnTextAlignment;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final void Function()? onPressed;

  const CustomText(
      {this.txtTitle,
      this.style,
      this.align = TextAlign.start,
      this.maxLine,
      this.textOverflow,
      this.onPressed,
      this.btnTextAlignment});

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      txtTitle ?? "",
      style: style,
      softWrap: true,
      textAlign: align,
      maxLines: maxLine,
      overflow: textOverflow,
    );
    return onPressed == null
        ? textWidget
        : TextButton(
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            onPressed: onPressed,
            child: Align(
              alignment: btnTextAlignment ?? Alignment.center,
              child: textWidget,
            ),
          );
  }
}
