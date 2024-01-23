import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:renting_app_mobile/api/api_middleware.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/screen/auth/register_screen.dart';
import 'package:renting_app_mobile/screen/payment/connect_stripe_account_screen.dart';
import 'package:renting_app_mobile/screen/profile/verify_id_background_check_form_screen.dart';
import 'package:renting_app_mobile/screen/profile/withdraw_screen.dart';
import 'package:renting_app_mobile/screen/auth/change_password_screen.dart';
import 'package:renting_app_mobile/widgets/cust_flat_button.dart';
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
import '../../widgets/image_picker.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';
import 'my_reviews_screen.dart';

// ItemDetailModel itemDetailModel = ItemDetailModel();

PickImageOption? _pickImageOption = PickImageOption.gallery;

class ViewProfileScreen extends GetView<AuthController> {
  ViewProfileScreen({Key? key}) : super(key: key) {
    controller.fetchMyProfile(context: getContext);
    Get.find<PaymentController>().getAccountBalance();

  }

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
    debugPrint(
        'user account connected ${controller.getUserInfo.stripeConnected}',);
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.profile,
        bgColor: primaryColor,
        centerTitle: false,
        titleColor: custWhiteFFFFFF,
      ),
      body: GetBuilder<AuthController>(builder: (auth) {
        return Obx(() {
          return controller.loadingMyProfile.value
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Edit Button                      
                      _buildEditButton(context),
                      /// Delete Account Button
                      _buildDeleteButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
          if (controller.updateMyProfile.value)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Spinner(),
            )
          else
            GestureDetector(
              onTap: () {

                zoomablePhotoDialogue(
                    imageUrl: controller.getUserInfo.profileImage);
              },
              child: CustImage(
                imgURL: controller.getUserInfo.profileImage,
                width: 80,
                height: 80,
                cornerRadius: 20,
                errorImage: ImgName.profileImage,
                // backgroundColor: Colors.grey.withOpacity(0.5),
              ),
            ),

          /// Plus icon
          Positioned(
            bottom: 0,
            right: -0,
            child: InkWell(
              onTap: _pickImage,
              child: CustImage(
                imgURL: ImgName.plus,
                height: 20,
                width: 20,
              ),
            ),
          ),
        ],
      );
    });
  }

  /// total Balance
  Widget _buildtotalBalance(BuildContext context) {
    return Obx(
       () {
        return
          !_paymentController.loadingAccountBalance.value ?
          Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          height: 26,
          decoration: BoxDecoration(
            color: cust41AEF1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: CustomText(
            txtTitle: "${_paymentController.accountBalance.value != null ? '\$${_paymentController.accountBalance.value}' : 'error'}", //
            style: Theme.of(context).textTheme.caption?.copyWith(color: cust41AEF1),
          ),
        ) : const SizedBox();
      },
    );
  }

  /// Edit button
  Widget _buildEditButton(BuildContext context) {
    if(controller.guest.value) {
      return const SizedBox();
    }
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

  Widget _buildDeleteButton(BuildContext context) {
    if(controller.guest.value) {
      return GestureDetector(
      onTap: () async {
             Get.to(RegisterScreen());
      },
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
              imgURL: ImgName.plus,
              width: 9.5,
              height: 10.0,
            ),
            const SizedBox(
              width: 4.5,
            ),

            /// Edit
            CustomText(
              txtTitle: 'Create Account',
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
    return GestureDetector(
      onTap: () async {
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
                        token: controller.getUserInfo.token,
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        height: 26,
        // width: 70,
        decoration: BoxDecoration(
          color: declineColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          children: [
            /// edit icon
            CustImage(
              imgURL: ImgName.delete,
              width: 9.5,
              height: 10.0,
            ),
            const SizedBox(
              width: 4.5,
            ),

            /// Edit
            CustomText(
              txtTitle: StaticString.deletAccount,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: declineColor),
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// User Name
                    CustomText(
                      txtTitle: controller.getUserInfo.name,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ///User Email
                    Visibility(
                      visible: controller.getUserInfo.email.isNotEmpty,
                      child: CustomText(
                        txtTitle: controller.getUserInfo.email,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: cust87919C,
                            ),
                      ),
                    ),
                    Visibility(
                      visible: controller.getUserInfo.email.isNotEmpty,
                      child: const SizedBox(
                        height: 16,
                      ),
                    ),

                    /// location
                    Visibility(
                      visible: controller.getUserInfo.address.isNotEmpty,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CustomText(
                          maxLine: 2,
                          textOverflow: TextOverflow.ellipsis,
                          txtTitle: controller.getUserInfo.address,
                          // txtTitle: userInfo.location,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.getUserInfo.address.isNotEmpty,
                      child: const SizedBox(
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),

              if (controller.guest.value) const SizedBox() else Column(
                children: [
                  Visibility(
                    visible: !controller.getUserInfo.stripeConnected,
                    child: SizedBox(
                      height: 30,
                      width: 162,
                      child: CustomFlatButton(
                        onPressed: () async {
                           _paymentController.setStripePageLoading(true);
                          var accLinkRes = await _paymentController.createStripeAccount();
                          String url = json.decode(accLinkRes)["data"]["url"];
                          debugPrint(url);
                          String account = json.decode(accLinkRes)["data"]["account"];
                          Get.to(() => ConnectStripeAccountScreen(url: url, accountId: account));
                        },
                        child: const Text(
                          'Connect Stripe Account',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.getUserInfo.stripeConnected,
                    child: SizedBox(
                        height: 30,
                        width: 162,
                        child: CustomFlatButton(
                          buttonColor: Colors.white,
                          onPressed: () async {
                            var accLinkRes = await _paymentController.getConnectedStripeAccountUrl();
                            String url = json.decode(accLinkRes)["data"]["url"];
                            debugPrint(url);
                            String account = await _paymentController.getConnectedStripeAccount();
                            _paymentController.setStripePageLoading(true);
                            Get.to(() => ConnectStripeAccountScreen(url: url, accountId: account));
                          },
                          child: const CustomText(
                            txtTitle: StaticString.manageStripeAccount,
                            style: TextStyle(color: primaryColor, fontSize: 12),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Visibility(
                  //   visible: controller.getUserInfo.verified == null,
                  //   child: SizedBox(
                  //       height: 30,
                  //       width: 162,
                  //       child: CustomFlatButton(
                  //         onPressed: () async {
                  //           Get.to(const VerifyIDBackgroundCheckFormScreen());
                  //         },
                  //         child: const Text(
                  //           'Verify ID',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       )),
                  // ),
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  Visibility(
                      visible: controller.getUserInfo.verified != null &&
                          (controller.getUserInfo.verified!.toLowerCase() ==
                              'clear' || controller.getUserInfo.verified!.toLowerCase() ==
                              'jobsclear'),
                      child: Text(
                        'Verified',
                        style: TextStyle(color: primaryColor),
                      )),
                  Visibility(
                      visible: controller.getUserInfo.verified != null &&
                          (controller.getUserInfo.verified!.toLowerCase() !=
                              'clear' && controller.getUserInfo.verified!.toLowerCase() !=
                              'jobsclear'),
                      child: Text(
                        'Not Cleared',
                        style: TextStyle(color: Colors.red),
                      )),
                  SizedBox(
                      height: 30,
                      width: 162,
                      child: CustomFlatButton(
                        onPressed: () async {
                          Get.to(ChangePasswordScreen());
                        },
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              ),
            ],
          ),

          /// About me text
          Visibility(
            visible: controller.getUserInfo.info.isNotEmpty,
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
            visible: controller.getUserInfo.info.isNotEmpty,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// About me
          Visibility(
            visible: controller.getUserInfo.info.isNotEmpty,
            child: CustomText(
              txtTitle: controller.getUserInfo.info,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),

          Visibility(
            visible: controller.getUserInfo.info.isNotEmpty,
            child: const SizedBox(
              height: 30,
            ),
          ),
          CustomButton(
            buttonTitle: 'My Reviews',
            onPressed: _myReviews,
            // image: ImgName.howToUseThisApp,
            buttonColor: custMaterialPrimaryColor.withOpacity(0.08),
            loaderAndTextColor: custMaterialPrimaryColor,
            hideShadow: true,
            // imageColor: custBlack102339.withOpacity(0.06),
          ),
          const SizedBox(
            height: 20,
          ),

          /// Account status text
          Visibility(
            visible: controller.getUserInfo.stripeConnected,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: StaticString.accountStatusTitle,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: controller.getUserInfo.stripeConnected,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// Account Status
          Visibility(
            visible: controller.getUserInfo.stripeConnected,
            child: CustomText(
              txtTitle: StaticString.accountStatusActive,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: controller.getUserInfo.stripeConnected,
            child: const SizedBox(
              height: 30,
            ),
          ),

          /// notification image and text
          ImageTitleAndChild(
            image: ImgName.notification2,
            title: StaticString.notifications,
          ),
          const SizedBox(
            height: 10,
          ),

          /// Push Notification Switch
          GetBuilder<AuthController>(
            builder: (context) {
              return ImageTitleAndChild(
                image: ImgName.user,
                title: StaticString.pushNotifications,
                child: customSwitch(
                  value: controller.getUserInfo.userDevice?.pushNotification ??
                      false,
                  onChanged: _pushNotificationsSwitch,
                ),
              );
            },
          ),

          /// Email Notification Switch
          GetBuilder<AuthController>(
            builder: (context) {
              return ImageTitleAndChild(
                image: ImgName.email,
                title: StaticString.emailNotifications,
                child: customSwitch(
                  value: controller.getUserInfo.userDevice?.emailNotification ??
                      false,
                  onChanged: _emailNotificationsSwitch,
                ),
              );
            },
          ),

          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            height: 30,
          ),
          _buildRequestsAndHowToUse(),
          const SizedBox(
            height: 15,
          ),

         controller.guest.value ? const SizedBox() :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 83.0),
            child: CustomButton(
              buttonTitle: StaticString.logOut,
              onPressed: _logout,
              buttonColor: custGrey7E7E7E.withOpacity(0.08),
              hideShadow: true,
              loaderAndTextColor: custGrey7E7E7E,
              // shadowColor: const Color.fromRGBO(255, 63, 80, 0.2),
            ),
          ),
          // // Log out Button
          // _buildLogOutButton(context),
          const SizedBox(
            height: 25,
          ),
          CustomText(
            txtTitle: ApiMiddleware.appVersionBuild,
            align: TextAlign.center,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custGreyA2A3A4,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  /// Payment And How to Use  Button
  Widget _buildRequestsAndHowToUse() {
    return Row(
      children: [
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
            buttonTitle: StaticString.myRequests,
            onPressed: _myRequest,
            // image: ImgName.howToUseThisApp,
            buttonColor: custMaterialPrimaryColor.withOpacity(0.08),
            loaderAndTextColor: custMaterialPrimaryColor,
            hideShadow: true,
            // imageColor: custBlack102339.withOpacity(0.06),
          ),
        ),
      ],
    );
  }

  //!-----------------------Button Action -------------------------

  Future _pickImage() async {
    if(controller.guest.value) {
      return;
    }
    _pickImageOption = await imagePickOption();

    if (_pickImageOption != null) {
      final imageTemporary =
          await PickImage(pickImageOption: _pickImageOption!);
      if (imageTemporary.path.isNotEmpty) {
        directory = await getTemporaryDirectory();
        targetPath =
            (directory?.path ?? "") + "/" + DateTime.now().toString() + ".jpeg";
        compressFile = await FlutterImageCompress.compressAndGetFile(
          imageTemporary.path,
          targetPath ?? "",
          quality: 90,
          format: CompressFormat.jpeg,
        );
        controller.getUserInfo.profileImage = compressFile!.path;
        try {
          // _userInfo.name = controller.getUserInfo.name;
          // _userInfo.email = controller.getUserInfo.email;
          // _userInfo.info = controller.getUserInfo.info;

          _userInfo = controller.getUserInfo;
          // _userInfo.address = "ChIJR8lD7LK-woARCaoi0RcwIJs";
          // //!UNCOMMNET
          _userInfo.placeId = "";
          _userInfo.profileImage = compressFile!.path;
          _userInfo.authType = AuthType.UpdateProfile;
          await controller.authenticateServerSideUser(
            context: getContext,
            userInfo: _userInfo,
          );

          Get.showSnackbar(const GetSnackBar(
            // title: "Your account is created successfully",
            message: "Your profile image is Updated successfully",
            duration: Duration(seconds: 2),
            animationDuration: Duration(seconds: 3),
          ));
        } catch (e) {
          showAlert(context: getContext, message: e);
        }
      }
    }
    _imageNotifier.notifyListeners();
  }

  void _editButton() {
    Get.toNamed("EditProfileDetailScreen");
    // Get.to(const EditProfileDetailScreen());
  }

  Future<void> _pushNotificationsSwitch(isTrue) async {
    controller.getUserInfo.userDevice?.pushNotification = isTrue;
    try {
      await controller.updatePushNotificationStatus(
          userInfoModel: controller.getUserInfo,);
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  Future<void> _emailNotificationsSwitch(isTrue) async {
    controller.getUserInfo.userDevice?.emailNotification = isTrue;
    try {
      await controller.updatePushNotificationStatus(
          userInfoModel: controller.getUserInfo,);
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  void _myPayment() {
    debugPrint("************************  my payment  *********************");
    Get.toNamed("PaymentListScreen");

    // Get.to(const PaymentScreen());
  }

  void _howToUseThisApp() {
    debugPrint(
        "************************  Hoe to use this app *********************");
    Get.toNamed("HowToUseScreen");
    // Get.to(const HowToUseScreen());
  }

  void _myReviews() {
    debugPrint("************************  My Reviews *********************");
    Get.to(MyReviewsScreen());
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
