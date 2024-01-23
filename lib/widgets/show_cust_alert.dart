import 'package:flutter/material.dart';
import '../constants/img_font_color_string.dart';
import '../widgets/custom_text.dart';
import 'cust_image.dart';

Future<bool?> showCustomAlert({
  required BuildContext? context,
  String status = "done",
  void Function()? onRightAction,
}) async {
  if (context == null) return false;

  //Retry button...
  Widget singleButton(BuildContext ctx) => InkWell(
        onTap: onRightAction,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 25,
          ),
          decoration: BoxDecoration(
              color: getPaymentStatusColor(status),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 6),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
              borderRadius: BorderRadius.circular(8)),
          child: CustomText(
            txtTitle: "OK",
            style: Theme.of(ctx).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
          ),
        ),
      );

  // SetUp the AlertDialog
  AlertDialog alert(BuildContext ctx) => AlertDialog(
        backgroundColor: Colors.white,
        actionsPadding: const EdgeInsets.only(
          top: 10.0,
          right: 5.0,
        ),
        contentPadding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
        ),
        titlePadding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          top: 20.0,
          bottom: 15.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CustImage(
                  imgURL: ImgName.getPaymentStatusImage(status),
                  boxfit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        content: CustomText(
          align: TextAlign.center,
          txtTitle: StaticString.getPaymentStatusMessages(status),
          style: Theme.of(ctx)
              .textTheme
              .bodyText2
              ?.copyWith(color: getPaymentStatusColor(status)),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              singleButton(ctx),
            ],
          )
        ],
      );

  // show the dialog
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: alert,
  );
}
