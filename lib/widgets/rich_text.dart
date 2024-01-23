import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/custom_extension.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText(
      {this.title = "",
      this.normalTextStyle,
      this.fancyTextStyle,
      this.onTap,
      this.maxLines = 2});
  final String title;
  final void Function(String)? onTap;
  final TextStyle? fancyTextStyle;
  final TextStyle? normalTextStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return RichText(
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      softWrap: true,
      text: TextSpan(
        style: theme.bodyText2,
        children: title.processCaption(
          matcher: "#",
          normalTextStyle: normalTextStyle ?? theme.bodyText1,
          fancyTextStyle: fancyTextStyle ??
              theme.bodyText1?.copyWith(
                color: Theme.of(context).buttonTheme.colorScheme?.background,
              ),
          onTap: onTap ?? (text) {},
        ),
      ),
    );
  }
}
