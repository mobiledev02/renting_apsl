// ignore_for_file: require_trailing_commas, prefer_if_elements_to_conditional_expressions

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart' as lazyLoad;

import '../../controller/auth_controller.dart';
import '../../widgets/spinner.dart';
import '/constants/img_font_color_string.dart';
import '/controller/request_controller.dart';
import '/widgets/custom_appbar.dart';
import '../../cards/request_card.dart';
import '../../main.dart';
import '../../models/request_model.dart';
import '../../widgets/calender_dialog.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/empty_screen_ui.dart';

class MyRequestScreen extends GetView<RequestController> {
  MyRequestScreen({Key? key}) {
    controller.lazyLoadingRequest.value = true;
    try {
      controller.fetchMyRequest(context: getContext, onTap: true);
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  //!--------------------------------------- variable ----------------------------------
  DateTime _selectedDate = DateTime.now();

  final DateFormat formatter = DateFormat("y-MM-d");

  // Future<void> _fetchRequest({required BuildContext context}) async {
  //   try {
  //     await controller.fetchMyRequest(context: getContext);
  //   } catch (e) {
  //     showAlert(context: context, message: e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _fetchRequest(context: context);
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.myRequest,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildCalenderIconButton(context),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<RequestController>(
          builder: (context) {
            return lazyLoad.LazyLoadScrollView(
              // scrollOffset: 500,
              onEndOfPage: () async {
                try {
                  await controller.fetchMyRequest(context: getContext);
                } catch (e) {
                  showAlert(context: getContext, message: e);
                } finally {}
              },
              child: Get.find<AuthController>().guest.value
                  ? const Center(child: Text('Sign in to see your requests'))
                  : Column(
                      children: [
                        controller.loadingRequest.value
                            ? Expanded(child: Spinner())
                            : controller.myRequestList.isEmpty
                                ? Expanded(
                                    child: EmptyScreenUi(
                                      imgUrl: ImgName.emptylendingImage,
                                      width: 200,
                                      height: 132.5,
                                      title: StaticString.whoops,
                                      description:
                                          StaticString.lookLikeTheresNoData,
                                    ),
                                  )
                                : Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        await controller.fetchMyRequest(
                                            context: getContext,
                                            forRefresh: true);
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 12,
                                              ),
                                              padding: const EdgeInsets.only(
                                                  top: 14,
                                                  left: 20.00,
                                                  right: 20.00),
                                              itemCount: controller
                                                  .myRequestList.length,
                                              itemBuilder: (context, index) {
                                                return RequestCard(
                                                  onTap: () => _requestCard(
                                                    requestModel: controller
                                                        .myRequestList[index],
                                                  ),
                                                  isDelete: true,
                                                  onDeleteTap: () => _delete(
                                                      id: controller
                                                              .myRequestList[
                                                                  index]
                                                              .id ??
                                                          0),
                                                  requestModel: controller
                                                      .myRequestList[index],
                                                );
                                              },
                                            ),
                                          ),
                                          controller.loadMyRequest.value
                                              ? Spinner()
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  //!------------------------------------ Widget -----------------------------------
  /// custom title
  Widget _buildTitleText({required String title}) {
    return CustomText(
      txtTitle: title,
      style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  ///Request Near You Text And Calender Button
  Widget _buildRequestNearYouTextAndCalenderButton(BuildContext context) {
    return Row(
      children: [
        _buildTitleText(title: StaticString.requestsNearYou),

        const Spacer(),

        /// Calender Icon Button
        _buildCalenderIconButton(context)
      ],
    );
  }

  /// Calender Icon Button
  Widget _buildCalenderIconButton(BuildContext context) {
    return customIconButton(
      icon: ImgName.calender,
      buttonHeight: 26,
      buttonWidth: 26,
      iconHeight: 12,
      iconWidth: 10.41,
      onTap: () => showCalender(
          context: context,
          selectedDay: _selectedDate,
          firstDate: DateTime(_selectedDate.year - 1),
          currentDate: _selectedDate,
          focusedDay: _selectedDate,
          setDateOnCallBack: (date) async {
            try {
              await controller.fetchMyRequest(
                  context: context, date: formatter.format(date), onTap: true);
              _selectedDate = date;
            } catch (e) {
              showAlert(context: context, message: e);
            }

            // controller.notifyRequestcontroller();
          }),
      bgColor: primaryColor.withOpacity(0.1),
    );

    // InkWell(
    //   onTap: () => showCalender(context: context, setDateOnCallBack: (date) {}),
    //   child: Container(
    //     height: 26,
    //     width: 26,
    //     decoration: BoxDecoration(
    //       color: primaryColor.withOpacity(0.1),
    //       borderRadius: BorderRadius.circular(25),
    //     ),

    //     /// calender image
    //     child: CustImage(
    //       imgURL: ImgName.calender,
    //       height: 12,
    //       width: 10.41,
    //     ),
    //   ),
    // );
  }

  //!--------------------------Button action--------------------------

  void _requestCard({required RequestModel requestModel}) {
    debugPrint(
        "***************************** request Card ***********************");
    Get.toNamed(
      "EndRequestScreen",
      arguments: requestModel,
    );
    // Get.to(const ViewRequestedItemScreen());
  }

  void _delete({required int id}) {
    showAlert(
        signleBttnOnly: false,
        context: getContext,
        title: "Delete Request",
        message: StaticString.requestDeleteAlertMsg,
        rigthBttnTitle: StaticString.delete,
        leftBttnTitle: StaticString.cancel,
        onRightAction: () async {
          try {
            await controller.deleteMyRequest(context: getContext, id: id);
          } catch (e) {
            showAlert(context: getContext, message: e);
          } finally {
            // await controller.fetchMyRequest(context: getContext, onTap: true);
          }
        });
    // Get.to(const ViewRequestedItemScreen());
  }
}
