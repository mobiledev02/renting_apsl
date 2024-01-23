// ignore_for_file: require_trailing_commas, prefer_if_elements_to_conditional_expressions

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart' as lazyLoad;
import 'package:renting_app_mobile/cards/no_profile_review_card.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';

import '../../controller/lend_controller.dart';
import '../../widgets/review_card.dart';
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

class MyReviewsScreen extends GetView<LendController> {
  MyReviewsScreen({Key? key}) {
    controller.loadingLenderProfile.value = true;
    try {
      controller.getLenderProfile(
          getContext, Get.find<AuthController>().getUserInfo.id);
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
        title: 'My Reviews',
      ),
      body: SafeArea(
        child: GetBuilder<LendController>(
          builder: (context) {
            return lazyLoad.LazyLoadScrollView(
              // scrollOffset: 500,
              onEndOfPage: () async {
                try {
                  //      await controller.fetchMyRequest(context: getContext);
                } catch (e) {
                  showAlert(context: getContext, message: e);
                } finally {}
              },
              child: Column(
                children: [
                  controller.loadingLenderProfile.value
                      ? Expanded(child: Spinner())
                      :



             (controller.lenderProfile.value!.reviews != null &&
            controller.lenderProfile.value!.reviews!.isNotEmpty)
                          ?

             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 18.0),
               child: ListView.builder(
                   shrinkWrap: true,
                   itemCount: controller.lenderProfile.value!.reviews!.length,
                   itemBuilder: (context, index) {
                     return NoProfileReviewCard(
                       review: controller.lenderProfile.value!.reviews![index],
                     );
                   }),
             )


                 :

             Expanded(
                              child: EmptyScreenUi(
                                imgUrl: ImgName.emptylendingImage,
                                width: 200,
                                height: 132.5,
                                title: StaticString.whoops,
                                description: StaticString.lookLikeTheresNoData,
                              ),
                            )

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
              // await controller.fetchMyRequest(
              //     context: context, date: formatter.format(date), onTap: true);
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
}
