import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';

import '../constants/img_font_color_string.dart';

class CustomShortButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool? loadingIndicator;
  final Color backgroundColor;

  const CustomShortButton(
      {Key? key,
      this.loadingIndicator,
      required this.text,
      required this.onTap,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 130,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: custGrey,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed:
            loadingIndicator != null && loadingIndicator! ? () {} : onTap,
        child: loadingIndicator != null && loadingIndicator!
            ? SizedBox(
                height: 30,
                width: 30,
                child: Spinner(
                  progressColor: primaryColor ?? Colors.white,
                ),
              )
            : FittedBox(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
      ),
    );
  }
}
