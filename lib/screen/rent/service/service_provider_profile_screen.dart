import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import '../../../models/service_provider_profile_model.dart';
import '../../../widgets/custom_row_image.dart';
import '../../../widgets/rich_text.dart';
import '/constants/img_font_color_string.dart';
import '/main.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_text.dart';
import '/widgets/spinner.dart';
import '../../../controller/auth_controller.dart';

class ServiceProviderProfileScreen extends GetView<ItemController> {
  ServiceProviderProfileScreen({Key? key}) {
    init();
  }

//!------------------------------Variable-------------------

  RxBool loadingProfileDetail = true.obs;

  RxBool apiCall = true.obs;

  ServiceProviderProfileModel? serviceProviderProfileModel;

  Future<void> init() async {
    try {
      if (!apiCall.value) return;

      serviceProviderProfileModel =
          await controller.fetchServiceProvidersDetail(Get.arguments);
    } catch (e) {
      showAlert(context: getContext, message: e);
    } finally {
      loadingProfileDetail.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.profile,
        bgColor: primaryColor,
        titleColor: custWhiteFFFFFF,
        backButtonColor: Colors.white,
        leadingChild: InkWell(
          onTap: () {
            Get.back();
          },
          child: CustImage(
            imgURL: ImgName.whiteBackArrow,
            height: 32,
            width: 32,
          ),
        ),
      ),
      body: GetBuilder<AuthController>(
        builder: (auth) {
          return Obx(() {
            return loadingProfileDetail.value
                ? Spinner()
                : serviceProviderProfileModel == null
                    ? Center(
                        child: CustomText(
                          txtTitle: "No Profile Detail Found",
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: _buildStackAndEdit(context),
                      );
          });
        },
      ),
    );
  }

  ///Background , Profile Image An Edit button
  Widget _buildStackAndEdit(BuildContext context) {
    return Stack(
      children: [
        _buildTopBackgroundColor(),

        //Profile Image

        _buildProfileInformation(context),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// User Image
              _buildUserImage(),

              const SizedBox(
                width: 23,
              ),
              _buildUserProfileAndPriceRow(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfileAndPriceRow(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          bottom: 5,
        ),
        child: Row(
          children: [
            Spacer(),
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
              txtTitle: serviceProviderProfileModel?.getDoneJob,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: custBlack102339,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            CustomText(
              txtTitle: serviceProviderProfileModel?.getAverageRating,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: custBlack102339,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            CustomRichText(
              title: "#\$${serviceProviderProfileModel?.price ?? ""}",
              normalTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                    color: custBlack102339,
                    fontWeight: FontWeight.w600,
                  ),
              fancyTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                    color: custMaterialPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: _buildUserInformation(context),
    );
  }

  Widget _buildTopBackgroundColor() {
    return Container(
      height: 100,
      width: double.infinity,
      color: primaryColor,
    );
  }

  /// User Image
  Widget _buildUserImage() {
    return

        /// User Image
        CustImage(
      imgURL: serviceProviderProfileModel?.userProfileImage ?? "",
      width: 80,
      height: 80,
      cornerRadius: 20,
      errorImage: ImgName.profileImage,
      // backgroundColor: Colors.grey.withOpacity(0.5),
    );
  }

  ///User Info
  Widget _buildUserInformation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: custWhiteFFFFFF,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.00),
          topRight: Radius.circular(20.00),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 56,
          ),

          /// User Name
          CustomText(
            txtTitle: serviceProviderProfileModel?.name,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 10,
          ),

          //User Email
          Visibility(
            visible: serviceProviderProfileModel?.userEmail.isNotEmpty ?? false,
            child: CustomText(
              txtTitle: serviceProviderProfileModel?.userEmail,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: cust87919C,
                  ),
            ),
          ),
          Visibility(
            visible: serviceProviderProfileModel?.userEmail.isNotEmpty ?? false,
            child: const SizedBox(
              height: 16,
            ),
          ),

          /// location
          Visibility(
            visible:
                serviceProviderProfileModel?.userAddress.isNotEmpty ?? false,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: serviceProviderProfileModel?.userAddress,
              // txtTitle: userInfo.location,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Visibility(
            visible:
                serviceProviderProfileModel?.userAddress.isNotEmpty ?? false,
            child: const SizedBox(
              height: 30,
            ),
          ),

          /// About me text
          Visibility(
            visible: serviceProviderProfileModel?.userInfo.isNotEmpty ?? false,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: StaticString.aboutMe,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: serviceProviderProfileModel?.userInfo.isNotEmpty ?? false,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// About me
          Visibility(
            visible: serviceProviderProfileModel?.userInfo.isNotEmpty ?? false,
            child: CustomText(
              txtTitle: serviceProviderProfileModel?.userInfo,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: serviceProviderProfileModel?.userInfo.isNotEmpty ?? false,
            child: const SizedBox(
              height: 24,
            ),
          ),
          CustImage(
            imgURL: ImgName.divider,
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: serviceProviderProfileModel?.name.isNotEmpty ?? false,
                child: CustomText(
                  textOverflow: TextOverflow.ellipsis,
                  txtTitle: StaticString.serviceName + " ",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Visibility(
                visible: serviceProviderProfileModel?.name.isNotEmpty ?? false,
                child: CustomText(
                  textOverflow: TextOverflow.ellipsis,
                  txtTitle: serviceProviderProfileModel?.name,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: custBlack102339WithOpacity,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: serviceProviderProfileModel?.images?.isNotEmpty ?? false,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: StaticString.serviceImages,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: serviceProviderProfileModel?.images?.isNotEmpty ?? false,
            child: const SizedBox(
              height: 14,
            ),
          ),
          Visibility(
            visible: serviceProviderProfileModel?.images?.isNotEmpty ?? false,
            child: CustomRowImage(
              image1: serviceProviderProfileModel?.getProductsFirstImage,
              image2: serviceProviderProfileModel?.getProductsSecondImage,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 34,
              horizontal: 50,
            ),
            child: _buildHireButton(),
          ),
        ],
      ),
    );
  }

  // rent button
  Widget _buildHireButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 44),
        shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
        elevation: 10,
      ),
      onPressed: _hireButtonAction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustImage(
            imgURL: ImgName.whiteUser,
            height: 14,
            boxfit: BoxFit.contain,
          ),
          const SizedBox(
            width: 6,
          ),
          CustomText(
            txtTitle: StaticString.hire,
            style: Theme.of(getContext).textTheme.bodyText2?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          )
        ],
      ),
    );
  }

  //!---------------------- Helper Function ----------------------------

  //!-----------------------Button Action -------------------------

  void _hireButtonAction() {
    apiCall.value = false;
    Get.toNamed(
      "ServiceDetailScreen",
      arguments: serviceProviderProfileModel?.id,
    );
  }
}
