import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/constants/img_font_color_string.dart';
import '/main.dart';
import '/widgets/common_widgets.dart';
import '/widgets/cust_button.dart';
import '/widgets/cust_image.dart';
import '../../controller/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_indicator.dart';
import '/utils/custom_extension.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  //!---------------------variable------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final UserInfoModel _userInfoModel = UserInfoModel(
    authType: AuthType.ForgotPassword,
  );

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  ValueNotifier _valueNotifier = ValueNotifier(true);

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

                      /// Forgot Passwprd
                      _buildForgotPassText(context),
                      const SizedBox(
                        height: 10,
                      ),

                      /// Don't Worry.....
                      _buildDontWorryText(context),
                      const SizedBox(
                        height: 26,
                      ),

                      /// email Textformfield
                      _buildEmailTextFormField(),
                      const SizedBox(
                        height: 40,
                      ),

                      /// Sent Button
                      _buildSentButton(),
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
          CustBackButton(),
        ],
      ),
      title: CustomText(
        txtTitle: StaticString.forgotPassword.replaceAll("?", ""),
        style: const TextStyle(
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

  /// Forgot Passwprd
  Widget _buildForgotPassText(BuildContext context) {
    return CustomText(
      txtTitle:
          StaticString.forgotPassword.replaceAll("?", ""), //  Forgot Password
      style: Theme.of(context).textTheme.headline4?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  /// Don't Worry.....
  Widget _buildDontWorryText(BuildContext context) {
    return CustomText(
      txtTitle: StaticString.dontWorry, // don't Worry ......
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: custGrey93A2B2,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  /// Email Text Form Field
  Widget _buildEmailTextFormField() {
    return TextFormField(
      // initialValue: "abhay@gmail.com",
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (email) {
        _userInfoModel.email = email ?? "";
      },

      validator: (val) => val?.validateEmail,
      controller: _emailController,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(
          img: ImgName.email,
        ),
        hintText: StaticString.emailID,
      ),
    );
  }

  /// Sent button
  Widget _buildSentButton() {
    return Obx(() {
      return CustomButton(
        onPressed: _formSent,
        buttonTitle: StaticString.send,
        loadingIndicator: controller.forgotpasswordApiInProgress.value,
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
    debugPrint(
        "************************** Forgot Password Sent ************************");
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;

      _valueNotifier.notifyListeners();
      return;
    }
    try {
      _loadingIndicatorNotifier.show();
      _formKey.currentState?.save();
      debugPrint(_userInfoModel.email);
      // Call API...
      await Get.find<AuthController>().authenticateServerSideUser(
        context: getContext,
        userInfo: _userInfoModel,
      );

      Get.showSnackbar(
        const GetSnackBar(
          message: AlertMessageString.resetPasswordLinkHasBeenSent,
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

    // try {
    //   _loadingIndicatorNotifier.show();
    //   _formKey.currentState?.save();

    //   await SocialLoginService.signIn(SocialLoginType.EmailPassword,
    //       userInfo: _userInfoModel);

    //   Get.find<AuthController>().currentUser();

    //   Get.offAll(const HomeSetUpScreen());

    //   Get.showSnackbar(const GetSnackBar(
    //     message: "Logged In Successfully",
    //     animationDuration: Duration(seconds: 2),
    //     duration: Duration(seconds: 2),
    //   ));
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // } finally {
    //   _loadingIndicatorNotifier.hide();
    // }
  }
}
