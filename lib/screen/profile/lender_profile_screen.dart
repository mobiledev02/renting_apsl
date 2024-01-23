import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/lend_controller.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import '../../utils/location_util.dart';
import '../../widgets/review_card.dart';
import '/main.dart';
import '/screen/request/my_request_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/spinner.dart';
import '/constants/img_font_color_string.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_text.dart';
import '../../controller/auth_controller.dart';
import '../../controller/social_signin_controller.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';

// ItemDetailModel itemDetailModel = ItemDetailModel();

PickImageOption? _pickImageOption = PickImageOption.gallery;

class LenderProfileScreen extends GetView<LendController> {
  LenderProfileScreen({
    Key? key,
  }) : super(key: key) {}

//   @override
//   State<ViewProfileScreen> createState() => _ViewProfileScreenState();
// }

// class _ViewProfileScreenState extends State<ViewProfileScreen> {
//!------------------------------ Variable ------------------------------

  UserInfoModel _userInfo = UserInfoModel(
    authType: AuthType.UpdateProfile,
  );
  File? compressFile;
  Directory? directory;
  String? targetPath;
  final ValueNotifier _imageNotifier = ValueNotifier(true);
  final _paymentController = Get.find<PaymentController>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.profile,
        bgColor: primaryColor,
        backButtonColor: Colors.white,
        isBackButton: true,
        centerTitle: false,
        titleColor: custWhiteFFFFFF,
      ),
      body: GetBuilder<AuthController>(builder: (auth) {
        return Obx(() {
          return controller.loadingLenderProfile.value
              ? Spinner()
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: _buildStackAndEdit(context),
                );
        });
      }),
    );
  }

  ///Background , Profile Image An Edit button
  Widget _buildStackAndEdit(BuildContext context) {
    if (controller.lenderProfile.value != null) {
      
      return Stack(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: primaryColor,
          ),

          //Profile Image

          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: _buildUserInformation(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// User Image
                ValueListenableBuilder(
                    valueListenable: _imageNotifier,
                    builder: (context, val, child) => _buildUserImage()),

                const SizedBox(
                  width: 23,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const Center(child: Text('Error Occurred'));
    }
  }

  /// User Image
  Widget _buildUserImage() {
    return Obx(() {
      return Stack(
        children: [
          const SizedBox(
            height: 84,
            width: 84,
          ),

          /// User Image
          if (controller.loadingLenderProfile.value)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Spinner(),
            )
          else if (controller.lenderProfile.value != null)
            GestureDetector(
              onTap: () {
                zoomablePhotoDialogue(
                    imageUrl: controller.lenderProfile.value!.profileImage);
              },
              child: CustImage(
                imgURL: controller.lenderProfile.value!.profileImage,
                width: 80,
                height: 80,
                cornerRadius: 20,
                errorImage: ImgName.profileImage,
                // backgroundColor: Colors.grey.withOpacity(0.5),
              ),
            ),
        ],
      );
    });
  }

  /// total Balance
  // Widget _buildtotalBalance(BuildContext context) {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 16,
  //     ),
  //     height: 26,
  //     decoration: BoxDecoration(
  //       color: cust41AEF1.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(
  //         10,
  //       ),
  //     ),
  //     child: CustomText(
  //       txtTitle: "\$${controller.lenderProfile.value!.totalBalance}", //
  //       style: Theme.of(context).textTheme.caption?.copyWith(color: cust41AEF1),
  //     ),
  //   );
  // }

  /// Edit button
  Widget _buildEditButton(BuildContext context) {
    return GestureDetector(
      onTap: _editButton,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        height: 26,
        // width: 70,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          children: [
            /// edit icon
            CustImage(
              imgURL: ImgName.edit,
              width: 9.5,
              height: 10.0,
            ),
            const SizedBox(
              width: 4.5,
            ),

            /// Edit
            CustomText(
              txtTitle: StaticString.edit,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  /// User Info
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

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// User Name
                  CustomText(
                    txtTitle: controller.lenderProfile.value!.name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ///User Email
                  Visibility(
                    visible: controller.lenderProfile.value!.email.isNotEmpty,
                    child: CustomText(
                      txtTitle: controller.lenderProfile.value!.email,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: cust87919C,
                          ),
                    ),
                  ),
                  Visibility(
                    visible: controller.lenderProfile.value!.email.isNotEmpty,
                    child: const SizedBox(
                      height: 16,
                    ),
                  ),

                  /// location
                  // Visibility(
                  //   visible: controller.lenderProfile.value!.address.isNotEmpty,
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width / 2,
                  //     child: CustomText(
                  //       maxLine: 2,
                  //       textOverflow: TextOverflow.ellipsis,
                  //       txtTitle: controller.lenderProfile.value!.address,
                  //       // txtTitle: userInfo.location,
                  //       style: Theme.of(context).textTheme.caption?.copyWith(
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //     ),
                  //   ),
                  // ),
                  FutureBuilder<String>(
                    future: getLocalitySubLocality(controller.lenderProfile.value!.latitude, controller.lenderProfile.value!.longitude),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return CustomText(
                          maxLine: 2,
                          textOverflow: TextOverflow.ellipsis,
                          txtTitle: snapshot.data,
                          // txtTitle: userInfo.location,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: custBlack102339WithOpacity),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  Visibility(
                    visible: controller.lenderProfile.value!.address.isNotEmpty,
                    child: const SizedBox(
                      height: 20,
                    ),
                  ),
                  Row(
                    children: [
                      CustImage(
                        imgURL: ImgName.user,
                        imgColor: custMaterialPrimaryColor,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      if (controller.lenderProfile.value!.verified != null &&
                          (controller.lenderProfile.value!.verified!
                              .toLowerCase() ==
                              'clear' || controller.lenderProfile.value!.verified!
                              .toLowerCase() ==
                              'jobsclear')) CustomText(
                        txtTitle: 'Verified',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: primaryColor),
                      ) else CustomText(
                        txtTitle: 'Not Verified',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                            color: custBlack102339WithOpacity),
                      ),
                      // Visibility(
                      //     visible: controller.getUserInfo.verified != null && controller.getUserInfo.verified!.toLowerCase() == 'clear',
                      //
                      //     child: CustomText(txtTitle: 'Verified', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),))
                    ],
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
            ],
          ),

          /// About me text
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
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
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// About me
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: CustomText(
              txtTitle: controller.lenderProfile.value!.info,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: const SizedBox(
              height: 30,
            ),
          ),

          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: StaticString.reviews,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          if (controller.lenderProfile.value!.reviews != null &&
              controller.lenderProfile.value!.reviews!.isNotEmpty)
            ListView.builder(
                shrinkWrap: true,
                itemCount: controller.lenderProfile.value!.reviews!.length,
                itemBuilder: (context, index) {
                  return ReviewCard(
                    review: controller.lenderProfile.value!.reviews![index],
                  );
                })
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No reviews given',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  /// Hire button

  /// My Request And History Button
  Widget _buildMyRequestAndHistoryButton() {
    return Row(
      children: [
        // Payment Button
        Flexible(
          child: CustomButton(
            buttonTitle: StaticString.howToUseThisApp,
            onPressed: _howToUseThisApp,
            buttonColor: custMaterialPrimaryColor.withOpacity(0.08),
            loaderAndTextColor: custMaterialPrimaryColor,
            hideShadow: true,
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        // How To Use This App Button
        Flexible(
          child: CustomButton(
            buttonTitle: StaticString.deletAccount,
            onPressed: () async {
              await showAlert(
                signleBttnOnly: false,
                context: getContext,
                title: StaticString.deletAccount,
                message: StaticString.deletAccountMessage,
                leftBttnTitle: StaticString.cancel,
                rigthBttnTitle: StaticString.ok,
                onRightAction: () async {
                  try {
                    await Get.find<AuthController>().authenticateServerSideUser(
                      context: getContext,
                      userInfo: UserInfoModel(
                        authType: AuthType.DeleteAccount,
                        token: controller.lenderProfile.value!.token,
                      ),
                    );
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
            },
            buttonColor: custMaterialPrimaryColor.withOpacity(0.08),
            loaderAndTextColor: custMaterialPrimaryColor,
            hideShadow: true,
          ),
        ),
      ],
    );
  }

  //!---------------------- Helper Function ----------------------------
  // /// Image Pick Option
  // Future _buildImagePickOption() {
  //   return Get.defaultDialog(
  //     title: "Pick Image From",
  //     titleStyle: const TextStyle(
  //       fontSize: 16,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     content: Padding(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 50,
  //       ),
  //       child: Column(
  //         children: [
  //           ElevatedButton(
  //             onPressed: () async {
  //               setState(() {
  //                 _pickImageOption = PickImageOption.camera;
  //               });
  //               Get.back();
  //               await _pickImage();
  //             },
  //             child: const CustomText(
  //               txtTitle: "Camera",
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               setState(() {
  //                 _pickImageOption = PickImageOption.gallery;
  //               });
  //               Get.back();
  //               await _pickImage();
  //             },
  //             child: const CustomText(
  //               txtTitle: "Gallery",
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  //!-----------------------Button Action -------------------------

  void _editButton() {
    Get.toNamed("EditProfileDetailScreen");
    // Get.to(const EditProfileDetailScreen());
  }

  void _howToUseThisApp() {
    debugPrint(
        "************************  Hoe to use this app *********************");
    Get.toNamed("HowToUseScreen");
    // Get.to(const HowToUseScreen());
  }

  void _myRequest() {
    debugPrint("************************  My Request *********************");
    Get.to(MyRequestScreen());
  }

  void _history() {
    debugPrint("************************  History  *********************");
    Get.toNamed("HistoryScreen");
  }

  Future<void> _logout() async {
    _userInfo.authType = AuthType.Logout;

    await showAlert(
      signleBttnOnly: false,
      context: getContext,
      title: StaticString.confirm,
      message: StaticString.logoutAlertMsg,
      leftBttnTitle: StaticString.cancel,
      rigthBttnTitle: StaticString.ok,
      onRightAction: () async {
        try {
          await SocialLoginService.signOut(SocialLoginType.EmailPassword);

          Get.find<AuthController>().authenticateServerSideUser(
            context: getContext,
            userInfo: _userInfo,
          );
        } catch (e, st) {
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

    // Get.offAll(const LoginRegisterScreen());
  }
}
