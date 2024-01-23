import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renting_app_mobile/main.dart';
import '../constants/img_font_color_string.dart';
import '../widgets/custom_text.dart';
import 'cust_image.dart';

Future<bool?> showAlert({
  @required BuildContext? context,
  String title = AlertMessageString.defaultErrorTitle,
  dynamic message = AlertMessageString.somethingWentWrong,
  void Function()? onRightAction,
  void Function()? onLeftAction,
  TextAlign contentAlign = TextAlign.center,
  String leftBttnTitle = StaticString.no,
  String rigthBttnTitle = StaticString.yes,
  String singleBtnTitle = StaticString.ok,
  bool signleBttnOnly = true,
  bool barrierDismissible = true,
  bool disableDefaultPop = false,
  bool showCustomContent = false,
  Widget? content,
  MainAxisAlignment buttonAlignmnet = MainAxisAlignment.end,
}) async {
  if (context == null) return false;

  if (message.toString().toLowerCase() == "bad file descriptor") return false;

  // if (message is AppException &&
  //     message.type == ExceptionType.UnAuthorised &&
  //     Provider.of<AuthProvider>(context, listen: false).isUserLoggedIn) {
  //   Provider.of<AuthProvider>(context, listen: false).cleanLocally(context);

  //   return Future.value(false);
  // }

  //Retry button...
  Widget retryButton(BuildContext ctx) => InkWell(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              CustomText(
                txtTitle: singleBtnTitle,
                style: Theme.of(ctx)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ],
          ),
        ),
        onTap: () {
          // if (message is AppException &&
          //     message.type == ExceptionType.UnAuthorised &&
          //     Provider.of<AuthProvider>(context, listen: false)
          //         .isUserLoggedIn) {
          //   Provider.of<AuthProvider>(context, listen: false)
          //       .authenticateServerSideUser(
          //           context: context,
          //           userInfo: UserInfoModel(
          //               authType: AuthType.Logout, profilePics: []));
          // }
          if (Navigator.of(ctx).canPop() && !disableDefaultPop) {
            Navigator.of(ctx).pop(true);
          }
          if (onRightAction == null) return;
          onRightAction();
        },
      );

  //Left Button...
  Widget leftButton(BuildContext ctx) => InkWell(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: CustomText(
            txtTitle: leftBttnTitle,
            style: Theme.of(ctx)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        onTap: () {
          if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop(true);
          if (onLeftAction == null) return;
          onLeftAction();
        },
      );

  //Right Bttn...
  Widget rightButton(BuildContext ctx) => InkWell(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: CustomText(
            txtTitle: rigthBttnTitle,
            style: Theme.of(ctx)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        onTap: () {
          if (Navigator.of(ctx).canPop() && !disableDefaultPop) {
            Navigator.of(ctx).pop(true);
          }
          if (onRightAction == null) return;
          onRightAction();
        },
      );

  // SetUp the AlertDialog
  AlertDialog alert(BuildContext ctx) => AlertDialog(
        backgroundColor: Colors.white,
        actionsPadding: const EdgeInsets.only(top: 10.0, right: 5.0),
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
        title: title.isEmpty
            ? Container()
            : CustomText(
                txtTitle: toBeginningOfSentenceCase(
                    message is AppException ? message.getTitle : title),
                align: TextAlign.center,
                style: Theme.of(ctx)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
              ),
        content: showCustomContent
            ? content
            : CustomText(
                align: contentAlign,
                txtTitle: message is AppException
                    ? message.getMessage
                    : (message?.toString() ??
                        AlertMessageString.somethingWentWrong),
                style: Theme.of(ctx)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Colors.black),
              ),
        actions: signleBttnOnly
            ? [
                Row(
                  mainAxisAlignment: buttonAlignmnet,
                  children: [
                    retryButton(ctx),
                  ],
                )
              ]
            : [
                Row(
                  mainAxisAlignment: buttonAlignmnet,
                  children: [
                    leftButton(ctx),
                    rightButton(ctx),
                  ],
                )
              ],
      );

  // show the dialog
  return showDialog<bool>(
    context: context,
    barrierDismissible:
        message is AppException && message.type == ExceptionType.UnAuthorised
            ? false
            : barrierDismissible,
    builder: alert,
  );
}

Future<bool?> permissionAlert(
    {required BuildContext context,
    String message = "Permission message not set yet!"}) {
  return showAlert(
      context: context,
      message: message,
      title: AlertMessageString.permissionDenied,
      signleBttnOnly: false,
      leftBttnTitle: "Settings",
      rigthBttnTitle: "Cancel",
      onLeftAction: () {
        openAppSettings();
      });
}

Future<bool?> zoomablePhotoDialogue({required String imageUrl}) async {
  return showDialog<bool>(
    context: getContext,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          CustImage(
            zoomablePhoto: true,
            // heroTag: "ChatImage",
            boxfit: BoxFit.cover,
            cornerRadius: 16,
            errorImage: ImgName.imagePlacheHolderImage,
            imgURL: imageUrl,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              mini: true,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
