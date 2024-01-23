import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/img_font_color_string.dart';
import '/widgets/expand_child.dart';

class CustFocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final Widget focusedChild;
  final double? menuItemExtent;
  final double? menuWidth;
  final double? menuHeight;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Function onFocusChildPressed;
  final Function()? onBackGroundTap;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final double menuItemHorizPadding;
  final bool expand;
  final EdgeInsetsGeometry focusChildPadding;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const CustFocusedMenuHolder(
      {Key? key,
      required this.child,
      required this.focusedChild,
      required this.onPressed,
      required this.onFocusChildPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.menuHeight,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false,
      this.onBackGroundTap,
      this.menuItemHorizPadding = 14.0,
      this.expand = true,
      this.focusChildPadding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  _CustFocusedMenuHolderState createState() => _CustFocusedMenuHolderState();
}

class _CustFocusedMenuHolderState extends State<CustFocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    if (mounted) {
      setState(() {
        this.childOffset = Offset(offset.dx, offset.dy);
        childSize = size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
      context,
      PageRouteBuilder(
          transitionDuration: widget.duration ?? Duration(milliseconds: 100),
          pageBuilder: (context, animation, secondaryAnimation) {
            animation = Tween(begin: 0.0, end: 1.0).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: CustFocusedMenuDetails(
                focusChild: widget.focusedChild,
                onFocusChildPressed: widget.onFocusChildPressed,
                onBackGroundTap: widget.onBackGroundTap,
                itemExtent: widget.menuItemExtent,
                menuBoxDecoration: widget.menuBoxDecoration,
                child: widget.child,
                childOffset: childOffset,
                childSize: childSize,
                menuItems: widget.menuItems,
                blurSize: widget.blurSize,
                menuWidth: widget.menuWidth,
                menuHight: widget.menuHeight,
                blurBackgroundColor: widget.blurBackgroundColor,
                animateMenu: widget.animateMenuItems ?? true,
                bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                menuOffset: widget.menuOffset ?? 0,
                menuItemHorizPadding: widget.menuItemHorizPadding,
                expand: widget.expand,
                focusChildPadding: widget.focusChildPadding,
              ),
            );
          },
          fullscreenDialog: true,
          opaque: false),
    );
  }
}

class CustFocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final Widget focusChild;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final double? menuHight;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final Function()? onBackGroundTap;
  final double menuItemHorizPadding;
  final Function onFocusChildPressed;
  final bool expand;
  final EdgeInsetsGeometry focusChildPadding;

  const CustFocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.focusChild,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      required this.menuHight,
      required this.bottomOffsetHeight,
      required this.onFocusChildPressed,
      this.onBackGroundTap,
      this.menuOffset,
      this.menuItemHorizPadding = 14.0,
      this.expand = true,
      this.focusChildPadding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = menuHight ?? size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    // final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
    //     ? childOffset.dx
    //     : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: onBackGroundTap,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                  child: Container(
                    color:
                        (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
                  ),
                )),
            Positioned(
              top: topOffset,
              left: 16,
              right: 16,
              // child: TweenAnimationBuilder(
              //   duration: Duration(milliseconds: 200),
              //   builder: (BuildContext context, dynamic value, Widget? child) {
              //     return Container(
              //       child: child,
              //       //Transform.scale(
              //       // scale: value,
              //       // alignment: Alignment.center,
              //     );
              //   },
              //   //!......................add expand child here....................
              //   tween: Tween(begin: 0.0, end: 1.0),
              child: ExpandChild(
                expand: expand,
                child: Padding(
                  padding: focusChildPadding,
                  child: Container(
                    // alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    width: maxMenuWidth,
                    height: menuItems.length == 1 ? 38 : menuHight,
                    decoration: menuBoxDecoration ??
                        const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 10,
                                spreadRadius: 1)
                          ],
                        ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      child: menuItems.length == 1
                          ? _buildSingleMenu(
                              0,
                              context,
                            )
                          : Scrollbar(
                              thumbVisibility: true,
                              // thickness: ,
                              //hoverThickness: 1,

                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: Colors.white,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: custF4F4F4,
                                    height: 1.0,
                                  ),
                                  itemCount: menuItems.length,
                                  padding: EdgeInsets.zero,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    FocusedMenuItem item = menuItems[index];
                                    Widget listItem = GestureDetector(
                                        onTap: () {
                                          // Navigator.pop(context);
                                          item.onPressed();
                                        },
                                        child: Container(
                                            //-----------------------------------------Item container--------------------
                                            alignment: Alignment.center,
                                            color: item.backgroundColor ??
                                                Colors.transparent,
                                            height: itemExtent ?? 50.0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                item.title,
                                                if (item.trailingIcon !=
                                                    null) ...[
                                                  item.trailingIcon!
                                                ]
                                              ],
                                            )));
                                    if (animateMenu) {
                                      return listItem;
                                      // TweenAnimationBuilder(
                                      //     builder: (context, dynamic value, child) {
                                      //       return Transform(
                                      //         transform:
                                      //             Matrix4.rotationX(1.5708 * value),
                                      //         alignment: Alignment.bottomCenter,
                                      //         child: child,
                                      //       );
                                      //     },
                                      //     tween: Tween(begin: 1.0, end: 0.0),
                                      //     duration:
                                      //         Duration(milliseconds: index * 200),
                                      //     child: listItem);
                                    } else {
                                      return listItem;
                                    }
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              // ),
            ),
            Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onFocusChildPressed();
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    width: childSize?.width,
                    height: childSize?.height,
                    child: focusChild,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleMenu(
    index,
    context,
  ) {
    FocusedMenuItem item = menuItems[0];
    Widget listItem = GestureDetector(
      onTap: () {
        // Navigator.pop(context);
        item.onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        color: item.backgroundColor ?? Colors.black,
        height: itemExtent ?? 50.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0.0, horizontal: menuItemHorizPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: item.title),
              if (item.trailingIcon != null) ...[item.trailingIcon!]
            ],
          ),
        ),
      ),
    );
    if (animateMenu) {
      return listItem;
      // TweenAnimationBuilder(
      //     builder: (context, dynamic value, child) {
      //       return Transform(
      //         transform: Matrix4.rotationX(1.5708 * value),
      //         alignment: Alignment.bottomCenter,
      //         child: child,
      //       );
      //     },
      //     tween: Tween(begin: 1.0, end: 0.0),
      //     duration: Duration(milliseconds: index * 200),
      //     child: listItem);
    } else {
      return listItem;
    }
  }
}

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Icon? trailingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      required this.title,
      this.trailingIcon,
      required this.onPressed});
}
