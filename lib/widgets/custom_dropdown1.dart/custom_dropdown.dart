import 'package:flutter/material.dart';
import '../../widgets/custom_dropdown1.dart/cust_focus_menu.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown(
      {Key? key,
      required this.child,
      required this.focusChild,
      required this.onTap,
      required this.onFocusedChildTap,
      required this.menuItems,
      required this.menuItemExtent,
      this.menuHeight,
      this.menuWidth,
      this.borderRadius,
      this.menuItemHorizPadding = 14.0,
      this.expand = true,
      this.openWithTap = true,
      this.focusChildPadding = const EdgeInsets.all(0)})
      : super(key: key);

  final Widget child;
  final Widget focusChild;
  final List<FocusedMenuItem> menuItems;
  final void Function() onTap;
  final void Function() onFocusedChildTap;
  final double menuItemHorizPadding;
  final double? menuHeight;

  final double menuItemExtent;
  final double? menuWidth;
  final BorderRadiusGeometry? borderRadius;
  final bool expand;
  final bool openWithTap;
  final EdgeInsetsGeometry focusChildPadding;

  @override
  Widget build(BuildContext context) {
    return CustFocusedMenuHolder(
      focusChildPadding: focusChildPadding,
      menuWidth: menuWidth,
      blurSize: 0.0,
      menuItemExtent: menuItemExtent,
      menuBoxDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: borderRadius ??
              BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
          border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.08))),
      blurBackgroundColor: Colors.transparent,
      openWithTap: openWithTap,
      menuOffset: 13,
      animateMenuItems: false,
      bottomOffsetHeight: 80.0,
      onBackGroundTap: () => Navigator.of(context).pop(),
      menuItems: menuItems,
      onPressed: onTap,
      child: child,
      focusedChild: focusChild,
      menuItemHorizPadding: menuItemHorizPadding,
      menuHeight: menuHeight,
      onFocusChildPressed: onFocusedChildTap,
      expand: expand,
    );
  }
}
