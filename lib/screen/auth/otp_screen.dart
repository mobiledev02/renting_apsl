import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:renting_app_mobile/widgets/timer_widget.dart';

import '/constants/img_font_color_string.dart';
import '/main.dart';
import '/widgets/cust_button.dart';
import '/widgets/cust_image.dart';
import '../../controller/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_indicator.dart';

class OTPScreen extends GetView<AuthController> {
  OTPScreen({Key? key}) : super(key: key);

  //!---------------------variable------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final UserInfoModel _userInfoModel = UserInfoModel(
    authType: AuthType.OTP,
  );

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  final ValueNotifier _valueNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: _buildAppbar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 27,
              ),
              child: ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (context, val, child) => Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),

                      /// Image
                      _buildImage(),
                      const SizedBox(
                        height: 60,
                      ),

                      /// verify title
                      _buildVerifyTiltleText(context),
                      const SizedBox(
                        height: 10,
                      ),

                      /// description
                      _buildDescriptionText(context),
                      const SizedBox(
                        height: 26,
                      ),

                      /// otp Textformfield
                      _buildOTPTextFormField(context),
                      const SizedBox(
                        height: 40,
                      ),

                      /// Sent Button
                      _buildSentButton(),
                      const SizedBox(
                        height: 20,
                      ),

                      /// Resend Button
                      TimerWidget(function: _resendOTP),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//!-----------------------Widget-------------------------------
  /// Appbar
  AppBar _buildAppbar() {
    return AppBar(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //  CustBackButton(),
        ],
      ),
      title: const CustomText(
        txtTitle: StaticString.verifyTitle,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

  /// Image
  Widget _buildImage() {
    return CustImage(
      imgURL: ImgName.forgotPasswordImnage,
      height: 150,
      width: 225,
    );
  }

  /// Verification Code
  Widget _buildVerifyTiltleText(BuildContext context) {
    return CustomText(
      txtTitle: StaticString.verifyTitle, //  Forgot Password
      style: Theme.of(context).textTheme.headline4?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  /// description
  Widget _buildDescriptionText(BuildContext context) {
    return CustomText(
      txtTitle: StaticString.getOTPString(controller.getUserInfo.phone),
      // don't Worry ......
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: custGrey93A2B2,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  /// Email Text Form Field
  Widget _buildOTPTextFormField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      textStyle: const TextStyle(fontSize: 17),
      pastedTextStyle: const TextStyle(color: Colors.blue),
      controller: _textEditingController,
      pinTheme: PinTheme(
        fieldWidth: 50,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      beforeTextPaste: (pin) {
        debugPrint("Allowing to paste $pin");
        return true;
      },
      onChanged: (pin) {
        debugPrint('value on changed $pin');
      },
      onCompleted: (pin) {
        _userInfoModel.otp = pin;
      },
    );
  }

  /// Sent button
  Widget _buildSentButton() {
    return Obx(() {
      return CustomButton(
        onPressed: _formSent,
        buttonTitle: StaticString.confirm,
        loadingIndicator: controller.otpApiInProgress.value,
      );
    });
    // Center(
    //   child: LoadingIndicator(
    //     loadingStatusNotifier: _loadingIndicatorNotifier.statusNotifier,
    //     indicatorType: LoadingIndicatorType.Spinner,
    //     child: ElevatedButton(
    //       onPressed: _formSent,
    //       child: const CustomText(
    //         txtTitle: StaticString.sent,
    //         style: TextStyle(
    //           letterSpacing: 1,
    //           fontWeight: FontWeight.bold,
    //           fontFamily: CustomFont.metropolis,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  //!-----------------------Button Action-------------------------------

  Future<void> _formSent() async {
    debugPrint("************************** OTP Sent ************************");
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;

      _valueNotifier.notifyListeners();
      return;
    }
    try {
      _loadingIndicatorNotifier.show();
      _formKey.currentState?.save();
      _userInfoModel.authType = AuthType.OTP;
      _userInfoModel.phone = controller.getUserInfo.phone;
      debugPrint('phone number ${_userInfoModel.email}');
      // Call API...
      await Get.find<AuthController>().authenticateServerSideUser(
        context: getContext,
        userInfo: _userInfoModel,
      );

      Get.showSnackbar(
        const GetSnackBar(
          message: "Logged In Successfully",
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Show alert...
      showAlert(
        context: getContext,
        message: error,
      );
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }

//!-----------------------Resend Button Action-------------------------------
  Future<void> _resendOTP() async {
    debugPrint(
        "************************** Resend OTP  ************************");
    try {
      _loadingIndicatorNotifier.show();
      _userInfoModel.authType = AuthType.resentOTP;
      _userInfoModel.phone = controller.getUserInfo.phone;

      // Call API...
      await Get.find<AuthController>().authenticateServerSideUser(
        context: getContext,
        userInfo: _userInfoModel,
      );

      Get.showSnackbar(
        const GetSnackBar(
          message: "OTP Sent Successfully",
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Show alert...
      showAlert(
        context: getContext,
        message: error,
      );
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }
}
