import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/controller/end_request_controller.dart';
import '/controller/request_controller.dart';
import '/models/end_request_model.dart';
import '/models/request_model.dart';
import '/widgets/cust_button.dart';
import '/widgets/cust_image.dart';
import '/widgets/rich_text.dart';
import '../../constants/img_font_color_string.dart';
import '../../main.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class EndRequestScreen extends GetView<RequestController> {
  EndRequestScreen({Key? key}) : super(key: key);

  RequestModel requestModel = Get.arguments;
  final DateFormat formatter = DateFormat("MMMM d,y");

  @override
  Widget build(BuildContext context) {
    final EndRequestModel _endRequestData =
        Get.find<EndRequestController>().endRequestData;
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.endRequestItem,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 28,
              ),
              // //Images
              // CustomRowImage(
              //   image1: _endRequestData.image?[0],
              //   image2: _endRequestData.image?[1],
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              CustomText(
                txtTitle: requestModel.name,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(
                height: 14,
              ),

              /// Location Icon And Text
              _buildIconAndText(
                context: context,
                icon: ImgName.location,
                title: requestModel.city,
              ),
              const SizedBox(
                height: 15,
              ),

              /// Location Icon And Text
              _buildIconAndText(
                context: context,
                icon: ImgName.calender3,
                title: formatter.format(DateTime.parse(requestModel.needBy)),
              ),
              const SizedBox(
                height: 36,
              ),

              /// End Request Butoon
              _buildEndRequestButton(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

//!-----------------------Widget-----------------------------

  /// Icon With Text

  Widget _buildIconAndText(
      {required BuildContext context,
      required String icon,
      required String title}) {
    return Row(
      children: [
        CustImage(
          imgURL: icon,
          imgColor: primaryColor,
          height: 14,
        ),
        const SizedBox(
          width: 10,
        ),
        CustomText(
          txtTitle: title,
          style: Theme.of(context).textTheme.caption?.copyWith(
                color: custBlack102339.withOpacity(0.5),
              ),
        ),
      ],
    );
  }

  /// End Request Button
  Widget _buildEndRequestButton() {
    return Obx(() {
      return Center(
        child: CustomButton(
          loadingIndicator: controller.loadingRequest.value,
          buttonTitle: StaticString.endRequestItem,
          onPressed: () => _endRequest(id: requestModel.id ?? 0),
        ),
      );
    });
  }

  //!------------------------------ Button Action -----------------------------------
  void _endRequest({required int id}) {
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
            await controller.fetchMyRequest(context: getContext, onTap: true);
            Get.back();
          }
        });
    // Get.to(const ViewRequestedItemScreen());
  }
}
