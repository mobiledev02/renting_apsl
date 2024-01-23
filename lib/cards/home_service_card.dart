import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/screen/profile/lender_service_profile_screen.dart';
import 'package:renting_app_mobile/utils/dialog_utils.dart';
import '../constants/img_font_color_string.dart';
import '../controller/lend_controller.dart';
import '../screen/profile/lender_profile_screen.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/rich_text.dart';
import '../models/service_model.dart';
import '../widgets/custom_alert.dart';

class ServiceHomeCard extends StatelessWidget {
  final ServiceModel serviceModel;

  // final ItemDetailModel itemDetailModel;
  const ServiceHomeCard({
    Key? key,
    required this.serviceModel,
    //   required this.itemDetailModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Get.toNamed(
        //   "ServiceDetailScreen",
        //   arguments: serviceModel.id,
        // );
        if (serviceModel.id != null) {
          showLoadingDialog(context);
          await Get.find<LendController>()
              .fetchItemDetail(context: context, id: serviceModel.id!);
          Get.back();
          final service = Get.find<LendController>().itemDetail.value;
          if (service.lenderInfoModel != null) {
            Get.find<JobOfferController>()
                .checkSentOffer(context, service.id.toString());
            Get.find<LendController>().getLenderProfile(
                context, service.lenderInfoModel!.id.toString());
            Get.to(() => LenderServiceProfileScreen(
                  serviceDetail: service,
                ));
          }
        }
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shadowColor: custBlack102339.withOpacity(0.5),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileImage(),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildUseNameAndServiceNamePortion(context),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildPrizePortion(context),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              _buildInformation(context),
              const SizedBox(
                height: 6,
              ),
              _buildHireButtonAndSelectProfile(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHireButtonAndSelectProfile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          radius: 6,
          onPressed: () {},
          buttonHeight: 20,
          buttonWidth: 50,
          hideShadow: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustImage(
                imgURL: ImgName.whiteUser,
                height: 10,
                width: 14,
                cornerRadius: 10,
                boxfit: BoxFit.contain,
              ),
              const SizedBox(
                width: 2,
              ),
              CustomText(
                txtTitle: StaticString.hire,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 28,
          child: CustomText(
            onPressed: () async {
              if (serviceModel.id != null) {
                final _lendController = Get.find<LendController>();
                _lendController.getLenderProfile(
                    context, serviceModel.userId.toString());
                Get.to(() => LenderProfileScreen());
                // showDialog(
                //     context: context,
                //     builder: (context) =>
                //         Center(child: CircularProgressIndicator()));
                // ItemDetailModel? itemDetailModel =
                //     await Get.find<LendController>().fetchItemDetailForProfile(
                //         context: context, id: serviceModel.id!);
                //
                // Get.find<LendController>().getLenderProfile(
                //     context, itemDetailModel.lenderInfoModel!.id.toString());
                // Get.find<JobOfferController>()
                //     .checkSentOffer(context, itemDetailModel.id.toString());
                // Navigator.pop(context);
                // Get.to(() =>
                //     LenderServiceProfileScreen(serviceDetail: itemDetailModel));
              }
            },
            txtTitle: StaticString.seeProfile,
          ),
        )
      ],
    );
  }

  CustomText _buildInformation(BuildContext context) {
    return CustomText(
      txtTitle: serviceModel.userInfo,
      style: Theme.of(context).textTheme.caption?.copyWith(
            color: custBlack102339,
            fontWeight: FontWeight.w400,
          ),
    );
  }

  Widget _buildPrizePortion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomRichText(
          title: "#\$${serviceModel.price}",
          normalTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                color: custBlack102339,
                fontWeight: FontWeight.w600,
              ),
          fancyTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                color: custMaterialPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2.0, top: 2),
          child: Row(
            children: [
              CustImage(
                imgURL: ImgName.user,
                imgColor: custMaterialPrimaryColor,
                height: 15,
                width: 15,
              ),
              const SizedBox(
                width: 6,
              ),
              if (serviceModel.userStatus != null &&
                  (serviceModel.userStatus!.toLowerCase() == 'clear'
                  || serviceModel.userStatus!.toLowerCase() == 'jobsclear'))
                Tooltip(
                  showDuration: const Duration(seconds: 10),
                  triggerMode: TooltipTriggerMode.tap,
                  message: StaticString.verifiedText,
                  decoration: BoxDecoration(
                    color: custBlack102339,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 57),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 17.00,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 10,
                    color: custWhiteFFFFFF,
                    fontWeight: FontWeight.w700,
                  ),
                  child: CustomText(
                    txtTitle: 'Verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: primaryColor),
                  ),
                )
              else
                Tooltip(
                  showDuration: const Duration(seconds: 10),
                  triggerMode: TooltipTriggerMode.tap,
                  message: StaticString.notVerifiedText,
                  decoration: BoxDecoration(
                    color: custBlack102339,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 57),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 17.00,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 10,
                    color: custWhiteFFFFFF,
                    fontWeight: FontWeight.w700,
                  ),
                  child: CustomText(
                    txtTitle: 'Not Verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: custBlack102339WithOpacity),
                  ),
                ),
              // Visibility(
              //     visible: controller.getUserInfo.verified != null && controller.getUserInfo.verified!.toLowerCase() == 'clear',
              //
              //     child: CustomText(txtTitle: 'Verified', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),))
            ],
          ),
        ),
      ],
    );
  }

  Expanded _buildUseNameAndServiceNamePortion(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                txtTitle: serviceModel.userName,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: custBlack102339,
                      overflow: TextOverflow.ellipsis,
                    ),
                maxLine: 1,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          CustomText(
            txtTitle: serviceModel.name,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custBlack102339,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Row(
                children: [
                  CustImage(
                    imgURL: ImgName.tick,
                    imgColor: custMaterialPrimaryColor,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  CustomText(
                    txtTitle: serviceModel.getDoneJob,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: custBlack102339,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  CustImage(
                    imgURL: ImgName.tick,
                    imgColor: custMaterialPrimaryColor,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  CustomText(
                    txtTitle: serviceModel.getAverageRating,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: custBlack102339,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        zoomablePhotoDialogue(
          imageUrl: serviceModel.userProfileImage,
        );
      },
      child: CustImage(
        defaultImageWithDottedBorder: true,
        imgURL: serviceModel.userProfileImage,
        cornerRadius: 10,
        height: 42,
        width: 60,
      ),
    );
  }
}
