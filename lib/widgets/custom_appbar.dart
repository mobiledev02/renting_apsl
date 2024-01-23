// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/common_widgets.dart';
import '/widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppbar({
    Key? key,
    required this.title,
    this.centerTitle = false,
    this.bgColor,
    this.titleColor,
    this.isBackButton = true,
    this.actions,
    this.leadingChild,
    this.backFunction,
    this.backButtonColor,
  }) : super(key: key);

  final String title;
  final Color? bgColor;
  final Color? titleColor;
  bool centerTitle;
  bool isBackButton;
  List<Widget>? actions;
  Function? backFunction;
  Widget? leadingChild;
  Color? backButtonColor;

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bgColor,
      toolbarHeight: 50,
      centerTitle: centerTitle,
      leading: isBackButton
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leadingChild ??
                    CustBackButton(
                      backFunction: backFunction,
                      backButtonColor: backButtonColor,
                    ),
              ],
            )
          : null,
      title: CustomText(
        txtTitle: title, // item Name
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: titleColor,
        ),
      ),
      actions: actions,
    );
  }
}
