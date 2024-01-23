import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/models/user_model.dart';

import 'package:renting_app_mobile/widgets/retner_returning_item_dialog.dart';

import '../utils/date_time_util.dart';
import '../widgets/item_renting_diaog.dart';
import '/constants/img_font_color_string.dart';
import '/controller/auth_controller.dart';
import '../models/message_model.dart';
import '../utils/custom_enum.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_text.dart';

class MessageCard extends GetView<AuthController> {
  final String receiverName;
  final String receiverProfileUrl;
  final UserInfoModel? lenderInfo;
  final UserInfoModel? renterInfo;
  final String chatRoomId;
  final MessageModel messageModel;
  final bool aboveMessageIsReceivers;

  MessageCard({
    Key? key,
    this.lenderInfo,
    this.renterInfo,
    this.receiverName = "",
    this.receiverProfileUrl = "",
    this.chatRoomId = "",
    required this.messageModel,
    this.aboveMessageIsReceivers = false,
  }) : super(key: key);

  final String currentUserIdAsString =
      Get.find<AuthController>().getUserInfo.id;

  @override
  Widget build(BuildContext context) {
    // debugPrint('chat room in message card ${chatRoomId}');
    debugPrint('message type ${messageModel.messageType}');
    switch (messageModel.messageType) {
      // Message Type File
      case MessageType.File:
        // return PDFCardUI(
        //   messageModel: messageModel,
        //   receiverName: receiverName,
        //   receiverProfileUrl: receiverProfileUrl,
        // );
        break;

      // Message Type Image
      case MessageType.Image:
        return ImageUi(
          messageModel: messageModel,
          receiverName: receiverName,
          receiverProfileUrl: receiverProfileUrl,
          currentUserIdAsString: currentUserIdAsString,
        );
        break;

      // Simple text messages
      case MessageType.Text:
        return MessageTag(
          currentUserIdAsString: currentUserIdAsString,
          messageModel: messageModel,
          receiverName: receiverName,
          receiverProfileUrl: receiverProfileUrl,
          aboveMessageIsReceivers: aboveMessageIsReceivers,
        );
        break;

      case MessageType.ItemRequest:
        return MessageTagItemRequest(
          currentUserIdAsString: currentUserIdAsString,
          messageModel: messageModel,
          roomId: chatRoomId,
          lender: lenderInfo,
          renter: renterInfo,
          receiverName: receiverName,
          receiverProfileUrl: receiverProfileUrl,
        );

      case MessageType.DateUpdate:
        return MessageTagDateUpdate(
          currentUserIdAsString: currentUserIdAsString,
          messageModel: messageModel,
          roomId: chatRoomId,
          lender: lenderInfo,
          renter: renterInfo,
          receiverName: receiverName,
          receiverProfileUrl: receiverProfileUrl,
        );

      case MessageType.AdminB:
        return MessageTagAdmin(
          currentUserIdAsString: currentUserIdAsString,
          messageModel: messageModel,
          roomId: chatRoomId,
          receiverName: receiverName,
          receiverProfileUrl: receiverProfileUrl,
        );

      case MessageType.AdminS:
        if (messageModel.adminDirect == currentUserIdAsString) {
          return MessageTagAdmin(
            currentUserIdAsString: currentUserIdAsString,
            messageModel: messageModel,
            roomId: chatRoomId,
            lender: lenderInfo,
            renter: renterInfo,
            receiverName: receiverName,
            receiverProfileUrl: receiverProfileUrl,
          );
        } else {
          return const SizedBox();
        }
      // Simple text messages
      default:
        MessageTag(
          currentUserIdAsString: currentUserIdAsString,
          messageModel: messageModel,
          receiverName: receiverName,
          receiverProfileUrl: receiverProfileUrl,
        );
        break;
    }

    return Container();
  }
}

class MessageTag extends GetView<AuthController> {
  final MessageModel messageModel;
  final String currentUserIdAsString;
  final String receiverName;
  final String receiverProfileUrl;
  final bool aboveMessageIsReceivers;

  const MessageTag({
    required this.messageModel,
    this.receiverName = "",
    this.receiverProfileUrl = "",
    this.aboveMessageIsReceivers = false,
    required this.currentUserIdAsString,
  });

  Color get cardBackgroundColor => currentUserIdAsString == messageModel.toSend
      ? custBlack102339.withOpacity(0.1)
      : custBlack102339;

  Color get messageTextColor => currentUserIdAsString == messageModel.toSend
      ? custBlack102339
      : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: messageModel.toSend == currentUserIdAsString
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ProfileAvtarForChat(
            showImage: messageModel.toSend == currentUserIdAsString,
            messageModel: messageModel,
            currentUserIdAsString: currentUserIdAsString,
            receiverName: receiverName,
            receiverProfileUrl: receiverProfileUrl,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: aboveMessageIsReceivers ? 22 : 14),
                decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(6)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: CustomText(
                  txtTitle: messageModel.message,
                  align: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: messageTextColor),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomText(
                  txtTitle: "     ${messageModel.getFormattedTime}",
                  align: TextAlign.right,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: custGreyA2A3A4,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ProfileAvtarForChat(
            showImage: messageModel.toSend != currentUserIdAsString,
            messageModel: messageModel,
            currentUserIdAsString: currentUserIdAsString,
            receiverName: receiverName,
            receiverProfileUrl: controller.getUserInfo.profileImage,
          ),
        ),
      ],
    );
  }
}

class MessageTagAdmin extends GetView<AuthController> {
  final MessageModel messageModel;
  final String currentUserIdAsString;
  final String receiverName;
  final String receiverProfileUrl;
  final String roomId;
  final UserInfoModel? lender;
  final UserInfoModel? renter;

  final bool aboveMessageIsReceivers;

  const MessageTagAdmin({
    required this.messageModel,
    this.receiverName = "",
    required this.roomId,
    this.lender,
    this.renter,
    this.receiverProfileUrl = "",
    this.aboveMessageIsReceivers = false,
    required this.currentUserIdAsString,
  });

  Color get cardBackgroundColor => custBlack102339.withOpacity(0.1);

  Color get messageTextColor => custBlack102339;

  @override
  Widget build(BuildContext context) {
    debugPrint('renter submission chat room id ${roomId}');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CustImage(
            height: 34,
            width: 34,
            cornerRadius: 100,
            imgURL: 'assets/images/logo_avatar.png',
            backgroundColor: custMaterialPrimaryColor.withOpacity(0.2),
            boxfit: BoxFit.cover,
            // errorImage: ImgName.noUser,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //TODO: apply correct logic
              //   if (messageModel.renterId == currentUserIdAsString)
              if (messageModel.renterId ==
                      Get.find<AuthController>().getUserInfo.id &&
                  messageModel.specialText != null &&
                  messageModel.specialText!.contains('here to answer.'))
                Container(
                  margin:
                      EdgeInsets.only(top: aboveMessageIsReceivers ? 22 : 14),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    children: [
                      CustomText(
                        txtTitle: messageModel.message,
                        align: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: messageTextColor),
                      ),
                      Visibility(
                        visible: messageModel.specialText != null,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                if (lender != null && context.mounted) {
                                  final notSubmitted =
                                      await Get.find<ItemController>()
                                          .alreadySubmittedRenterReturn(
                                              context, roomId);
                                  if (notSubmitted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          RenterReturningItemDialog(
                                        messageModel: messageModel,
                                        lenderModel: lender!,
                                        roomId: roomId,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: CustomText(
                                txtTitle: messageModel.specialText,
                                align: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else if (messageModel.renterId ==
                  Get.find<AuthController>().getUserInfo.id)
                Container(
                  margin:
                      EdgeInsets.only(top: aboveMessageIsReceivers ? 22 : 14),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    children: [
                      CustomText(
                        txtTitle: messageModel.message,
                        align: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: messageTextColor),
                      ),
                      Visibility(
                        visible: messageModel.specialText != null,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                if (lender != null && context.mounted) {
                                  bool notSubmitted =
                                      await Get.find<ItemController>()
                                          .alreadySubmittedRenter(
                                              context, roomId);
                                  if (notSubmitted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ItemRentingDialog(
                                        messageModel: messageModel,
                                        lenderModel: lender!,
                                        roomId: roomId,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: CustomText(
                                txtTitle: messageModel.specialText,
                                align: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  margin:
                      EdgeInsets.only(top: aboveMessageIsReceivers ? 22 : 14),
                  decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(6)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    children: [
                      CustomText(
                        txtTitle: messageModel.message,
                        align: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: messageTextColor),
                      ),
                      // Visibility(
                      //   visible: messageModel.specialText != null,
                      //   child: Column(
                      //     children: [
                      //       const SizedBox(
                      //         height: 5,
                      //       ),
                      //       InkWell(
                      //         onTap: () async {
                      //           bool notSubmitted =
                      //               await Get.find<ItemController>()
                      //                   .alreadySubmitted(context, roomId);
                      //           if (notSubmitted) {
                      //             showDialog(
                      //                 context: context,
                      //                 builder: (context) => ItemReturnDialog(
                      //                       roomId: roomId,
                      //                       renter: renter,
                      //                       messageModel: messageModel,
                      //                     ));
                      //           }
                      //         },
                      //         child: CustomText(
                      //           txtTitle: messageModel.specialText,
                      //           align: TextAlign.left,
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .bodyLarge
                      //               ?.copyWith(color: primaryColor),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 4,
              ),
              CustomText(
                txtTitle: "     " + messageModel.getFormattedTime,
                align: TextAlign.right,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: custGreyA2A3A4,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        const SizedBox(
          width: 100,
        ),
      ],
    );
  }
}

class MessageTagItemRequest extends GetView<AuthController> {
  final MessageModel messageModel;
  final String currentUserIdAsString;
  final String receiverName;
  final String receiverProfileUrl;
  final String roomId;
  final UserInfoModel? lender;
  final UserInfoModel? renter;

  final bool aboveMessageIsReceivers;

  const MessageTagItemRequest({
    required this.messageModel,
    this.receiverName = "",
    required this.roomId,
    this.lender,
    this.renter,
    this.receiverProfileUrl = "",
    this.aboveMessageIsReceivers = false,
    required this.currentUserIdAsString,
  });

  Color get cardBackgroundColor => custBlack102339.withOpacity(0.1);

  Color get messageTextColor => custBlack102339;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: messageModel.toSend == currentUserIdAsString
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ProfileAvtarForChat(
            showImage: messageModel.toSend == currentUserIdAsString,
            messageModel: messageModel,
            currentUserIdAsString: currentUserIdAsString,
            receiverName: receiverName,
            receiverProfileUrl: receiverProfileUrl,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: aboveMessageIsReceivers ? 22 : 14),
                decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(6)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: CustomText(
                  txtTitle:
                      '''Hello I would like to rent your item from ${formatDateDDMMYYYY(messageModel.startDate?.toLocal())} at ${formatTimeHM(messageModel.startDate?.toLocal())} - ${formatDateDDMMYYYY(messageModel.endDate?.toLocal())} at ${formatTimeHM(messageModel.endDate?.toLocal())}''',
                  align: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: messageTextColor),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomText(
                  txtTitle: "     ${messageModel.getFormattedTime}",
                  align: TextAlign.right,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: custGreyA2A3A4,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ProfileAvtarForChat(
            showImage: messageModel.toSend != currentUserIdAsString,
            messageModel: messageModel,
            currentUserIdAsString: currentUserIdAsString,
            receiverName: receiverName,
            receiverProfileUrl: controller.getUserInfo.profileImage,
          ),
        ),
      ],
    );
  }
}

class MessageTagDateUpdate extends GetView<AuthController> {
  final MessageModel messageModel;
  final String currentUserIdAsString;
  final String receiverName;
  final String receiverProfileUrl;
  final String roomId;
  final UserInfoModel? lender;
  final UserInfoModel? renter;

  final bool aboveMessageIsReceivers;

  const MessageTagDateUpdate({
    required this.messageModel,
    this.receiverName = "",
    required this.roomId,
    this.lender,
    this.renter,
    this.receiverProfileUrl = "",
    this.aboveMessageIsReceivers = false,
    required this.currentUserIdAsString,
  });

  Color get cardBackgroundColor => custBlack102339.withOpacity(0.1);

  Color get messageTextColor => custBlack102339;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: messageModel.toSend == currentUserIdAsString
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ProfileAvtarForChat(
            showImage: messageModel.toSend == currentUserIdAsString,
            messageModel: messageModel,
            currentUserIdAsString: currentUserIdAsString,
            receiverName: receiverName,
            receiverProfileUrl: receiverProfileUrl,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: aboveMessageIsReceivers ? 22 : 14),
                decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(6)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: CustomText(
                  txtTitle:
                      '''Requested date has been updated to ${formatDateDDMMYYYY(messageModel.startDate?.toLocal())} at ${formatTimeHM(messageModel.startDate?.toLocal())} - ${formatDateDDMMYYYY(messageModel.endDate?.toLocal())} at ${formatTimeHM(messageModel.endDate?.toLocal())}''',
                  align: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: messageTextColor),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomText(
                  txtTitle: "     ${messageModel.getFormattedTime}",
                  align: TextAlign.right,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: custGreyA2A3A4,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ProfileAvtarForChat(
            showImage: messageModel.toSend != currentUserIdAsString,
            messageModel: messageModel,
            currentUserIdAsString: currentUserIdAsString,
            receiverName: receiverName,
            receiverProfileUrl: controller.getUserInfo.profileImage,
          ),
        ),
      ],
    );
  }
}

// class PDFCardUI extends StatelessWidget {
//   final String lableText;
//   final MessageModel messageModel;
//   final String currentUserIdAsString;
//   final Function(bool) showLoader;
//   String receiverName;
//   final String receiverProfileUrl;
//   PDFCardUI(
//       {Key key,
//       this.lableText = "",
//       @required this.messageModel,
//       this.showLoader,
//       this.receiverName,
//       this.receiverProfileUrl,
//       @required this.currentUserIdAsString})
//       : super(key: key);

//   final LoadingIndicatorNotifier _loadingIndicatorNotifier =
//       LoadingIndicatorNotifier();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: messageModel.toSend == currentUserIdAsString
//           ? MainAxisAlignment.start
//           : MainAxisAlignment.end,
//       children: [
//         ProfileAvtarForChat(
//           messageModel: messageModel,
//           currentUserIdAsString: currentUserIdAsString,
//           receiverName: receiverName,
//           receiverProfileUrl: receiverProfileUrl,
//         ),
//         SizedBox(
//           width: 8,
//         ),
//         InkWell(
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           onTap: () async {
//             if (_loadingIndicatorNotifier.statusNotifier.value ==
//                 LoadingStatus.Show) return;
//             // Open PDF..
//             if (messageModel.docUrl.isNotEmpty) {
//               _loadingIndicatorNotifier.show();
//               PDFDocument doc = await PDFDocument.fromURL(messageModel.docUrl);
//               _loadingIndicatorNotifier.hide();
//               if (doc != null) {
//                 await Navigator.of(context).push(
//                   MaterialPageRoute(
//                     fullscreenDialog: true,
//                     builder: (ctx) => PDFViewerScreen(
//                       doc: doc,
//                       title: messageModel.message ?? "",
//                       url: messageModel.docUrl,
//                     ),
//                   ),
//                 );
//               }
//             }
//           },
//           child: Container(
//             height: 80,
//             width: 250,
//             padding: EdgeInsets.all(8),
//             alignment: Alignment.centerRight,
//             margin: EdgeInsets.only(
//                 top: messageModel.curveTopBorder ? 16 : 4,
//                 left: messageModel.toSend == currentUserIdAsString ? 0 : 70,
//                 right: messageModel.toSend == currentUserIdAsString ? 70 : 0),
//             decoration: messageModel.toSend == currentUserIdAsString
//                 ? BoxDecoration(
//                     color: custColorDivider,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       width: 1,
//                       color: custColorLightgrey.withOpacity(
//                         0.5,
//                       ),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         offset: Offset(0, 9),
//                         color: custColorBoxShadow.withOpacity(0.24),
//                         blurRadius: 25,
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   )
//                 : BoxDecoration(
//                     color: custMaterialBlue,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         offset: Offset(0, 9),
//                         color: custColorBoxShadow.withOpacity(0.24),
//                         blurRadius: 25,
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ),
//             child: Padding(
//               padding: const EdgeInsets.all(6.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 60,
//                     width: 40,
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(
//                         color: messageModel.toSend == currentUserIdAsString
//                             ? Colors.red
//                             : custColorScafoldBg,
//                         width: 2,
//                       ),
//                     ),
//                     child: Image.asset(
//                       ImgName.pdf,
//                       color: Colors.red,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           txtTitle: messageModel.docName,
//                           align: TextAlign.start,
//                           txtSize: 16,
//                           txtColor: messageModel.toSend == currentUserIdAsString
//                               ? Colors.black
//                               : Colors.white,
//                           txtFontWeight: FontWeight.w700,
//                           maxLine: 1,
//                           textOverflow: TextOverflow.ellipsis,
//                         ),
//                         CustomText(
//                           txtTitle: messageModel.docSize,
//                           align: TextAlign.start,
//                           txtSize: 12,
//                           txtColor: messageModel.toSend == currentUserIdAsString
//                               ? Colors.black
//                               : Colors.white.withOpacity(0.8),
//                           txtFontWeight: FontWeight.w500,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 20.0),
//                       child: LoadingIndicatorWithNotifier(
//                         indicatorType: LoadingIndicatorType.Spinner,
//                         customLoadingIndicator: Container(
//                           height: 30,
//                           width: 30,
//                           margin: EdgeInsets.only(right: 20, bottom: 20),
//                           alignment: Alignment.centerRight,
//                           child: SpinKitCircle(
//                             color: messageModel.toSend == currentUserIdAsString
//                                 ? Colors.black
//                                 : Colors.white.withOpacity(0.8),
//                             size: 30,
//                           ),
//                         ),
//                         loadingStatusNotifier:
//                             _loadingIndicatorNotifier.statusNotifier,
//                         child: Container(
//                           height: 0,
//                           width: 0,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ImageUi extends StatelessWidget {
  final String receiverName;
  final MessageModel messageModel;
  final String currentUserIdAsString;
  final String receiverProfileUrl;

  const ImageUi(
      {required this.messageModel,
      this.receiverName = "",
      this.receiverProfileUrl = "",
      required this.currentUserIdAsString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: messageModel.toSend == currentUserIdAsString
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ProfileAvtarForChat(
              showImage: messageModel.toSend == currentUserIdAsString,
              messageModel: messageModel,
              currentUserIdAsString: currentUserIdAsString,
              receiverName: receiverName,
              receiverProfileUrl: receiverProfileUrl,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        insetPadding: const EdgeInsets.all(0),
                        backgroundColor: Colors.black,
                        child: Stack(
                          children: [
                            CustImage(
                              zoomablePhoto: true,
                              // heroTag: "ChatImage",
                              boxfit: BoxFit.contain,
                              cornerRadius: 16,
                              //Distributor Profile Image
                              imgURL: messageModel.docUrl,
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
                      ));
            },
            child: CustImage(
              height: 160,
              width: 180,
              // heroTag: "ChatImage",
              boxfit: BoxFit.cover,
              backgroundColor: custMaterialPrimaryColor.withOpacity(0.2),
              cornerRadius: 16,
              //Distributor Profile Image
              imgURL: messageModel.docUrl,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ProfileAvtarForChat(
              showImage: messageModel.toSend != currentUserIdAsString,
              messageModel: messageModel,
              currentUserIdAsString: currentUserIdAsString,
              receiverName: receiverName,
              receiverProfileUrl:
                  Get.find<AuthController>().getUserInfo.profileImage,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAvtarForChat extends StatelessWidget {
  final MessageModel messageModel;
  final String currentUserIdAsString;
  final String receiverName;
  final String receiverProfileUrl;
  final bool showImage;

  const ProfileAvtarForChat(
      {required this.messageModel,
      this.receiverName = "",
      this.receiverProfileUrl = "",
      this.showImage = false,
      required this.currentUserIdAsString});

  @override
  Widget build(BuildContext context) {
    return showImage
        ? Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: custMaterialPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 2),
                  color: custBlack102339.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: CustImage(
              height: 34,
              width: 34,
              cornerRadius: 100,
              imgURL: receiverProfileUrl,
              backgroundColor: custMaterialPrimaryColor.withOpacity(0.2),
              boxfit: BoxFit.cover,
              errorImage: ImgName.noUser,

              // placeholderTitle: receiverName,
            ),
          )
        : SizedBox(
            width: 80,
          );
  }
}
