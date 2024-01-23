// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:http/http.dart';
import 'package:renting_app_mobile/screen/rent/item/item_detail_screen.dart';
import 'package:renting_app_mobile/screen/request/request_item_screen.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';

import '/constants/img_font_color_string.dart';
import '/controller/notification_controller.dart';
import '/models/notification_model.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_alert.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_text.dart';
import '/widgets/spinner.dart';
import '../../main.dart';
import '../../widgets/empty_screen_ui.dart';

class NotificationScreen extends GetView<NotificationController> {
  NotificationScreen({Key? key}) {
    try {
      controller.fetchNotification(context: getContext);
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.notifications, //notifications
        centerTitle: true,
        actions: [
          CustomText(
            txtTitle: StaticString.clear,
            onPressed: _clear,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return controller.loadingNotification.value
              ? Spinner()
              : controller.notificationList.isEmpty
                  ? EmptyScreenUi(
                      imgUrl: ImgName.emptylendingImage,
                      width: 200,
                      height: 132.5,
                      title: StaticString.whoops,
                      description: StaticString.lookLikeTheresNoData,
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: custBlack102339.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          try {
                            controller.fetchNotification(context: getContext);
                          } catch (e) {
                            showAlert(context: getContext, message: e);
                          }
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: controller.notificationList.length,
                          itemBuilder: (context, index) =>
                              _buildNotifiationCard(
                            context: context,
                            notificationModel:
                                controller.notificationList[index],
                          ),
                        ),
                      ),
                    );
        }),
      ),
    );
  }

//!----------------------------------- Widget ----------------------------------
  /// NotificationCard
  Widget _buildNotifiationCard({
    required BuildContext context,
    required NotificationModel notificationModel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SwipeActionCell(
          // backgroundColor: Colors.red,
          key: Key(notificationModel.id.toString()),
          trailingActions: [
            SwipeAction(
              color: Colors.red,
              //Delete image button
              content: CustImage(
                height: 20,
                width: 16,
                imgURL: ImgName.trashCan,
              ),
              onTap: (_) {
                _deleteNotification(id: notificationModel.id ?? 0);
              },
            ),
          ],
          child: InkWell(
            onTap: () =>
                _notificationOnTap(notificationModel: notificationModel),
            child: Container(
              decoration: BoxDecoration(
                color: custWhiteFFFFFF,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustImage(
                    height: 26,
                    width: 26,
                    imgURL: notificationModel.icon,
                    spinnerWidth: 20,
                    spinnerHeight: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          txtTitle: notificationModel.title,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,

                          /// title
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          txtTitle: notificationModel.message, // Decription
                          style: Theme.of(context).textTheme.overline?.copyWith(
                                height: 1.4,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: custBlack102339WithOpacity,
                              ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          txtTitle: notificationModel.getDate, // Date
                          style: Theme.of(context).textTheme.overline?.copyWith(
                                height: 1.4,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    txtTitle: notificationModel.getTime, // Time
                    style: Theme.of(context).textTheme.overline?.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //!----------------------------------------- Button Function -------------------------------
  ///  Notification on tap
  void _notificationOnTap({required NotificationModel notificationModel}) {
    debugPrint(
        "*********************************  Notification on tap ***************************");
    if (notificationModel.requestId != null) {
      Get.toNamed("ChatListScreen");
    } else if (notificationModel.itemServiceId != null) {
      notificationModel.type == ItemOrService.item
          ? Get.toNamed(
              "ChatListScreen"
            )
          : Get.toNamed("ChatListScreen"
            );
    } else if (notificationModel.itemServiceRentsId != null) {
        Get.toNamed("ChatListScreen");
    }
  }

  /// delete Dialog
  void _deleteNotification({required int id}) async {
    debugPrint(
        "********************************* Delete Notification ***************************");
    await showAlert(
      signleBttnOnly: false,
      context: getContext,
      title: StaticString.confirm,
      message: StaticString.notificationDeleteAlertMsg,
      leftBttnTitle: StaticString.cancel,
      rigthBttnTitle: StaticString.delete,
      onRightAction: () async {
        try {
          await controller.deleteNotification(context: getContext, id: id);
        } catch (e) {
          showAlert(context: getContext, message: e);
        } finally {
          // await itemController.fetchMyItems(
          //   context: context,
          //   onTap: true,
          // );
          // Get.back();
        }
      },
    );
  }

  void _clear() async {
    debugPrint(
        "*********************************** Clear Notification *******************************");
    await showAlert(
      signleBttnOnly: false,
      context: getContext,
      title: StaticString.confirm,
      message: StaticString.notificationDeleteAllAlertMsg,
      leftBttnTitle: StaticString.cancel,
      rigthBttnTitle: StaticString.delete,
      onRightAction: () async {
        try {
          await controller.deleteAllNotification(context: getContext);
        } catch (e) {
          showAlert(context: getContext, message: e);
        } finally {
          // await itemController.fetchMyItems(
          //   context: context,
          //   onTap: true,
          // );
          // Get.back();
        }
      },
    );
  }
}
