import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/api/api_middleware.dart';

import '/main.dart';
import '/widgets/cust_button.dart';
import '/widgets/keyboard_with_done_button.dart';
import '/controller/auth_controller.dart';
import '/models/user_model.dart';
import '/utils/custom_enum.dart';
import '/utils/custom_extension.dart';
import '/widgets/loading_indicator.dart';
import '../../constants/img_font_color_string.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({Key? key}) : super(key: key);

  //--------------------- Variable ------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final UserInfoModel _userInfoModel = UserInfoModel(
    authType: AuthType.Login,
  );

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  ValueNotifier _setstate = ValueNotifier(true);

  //-------------------- UI--------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 27,
            ),
            child: KeyboardWithDoneButton(
              focusNodeList: [_emailFocusNode, _passwordFocusNode],
              onDoneClicked: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  FocusScope.of(context).nextFocus();
                }
              },
              child: ValueListenableBuilder(
                  valueListenable: _setstate,
                  builder: (context, val, child) {
                    return Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          // Image
                          _buildImage(),
                          const SizedBox(
                            height: 25,
                          ),
                          // Login
                          CustomText(
                            txtTitle: StaticString.login,
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          // Email Text Form Feild
                          _buildEmailIdFeild(),
                          const SizedBox(
                            height: 24,
                          ),
                          // Password Text Form Feild
                          _buildPasswordFeild(),
                          const SizedBox(
                            height: 10,
                          ),

                          /// Forgot Password
                          _buildForgotPassword(context),
                          const SizedBox(
                            height: 40,
                          ),
                          // Login button
                          _buildLoginButton(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

// ------------------- Helper Widgets -----------------

  /// Appbar
  AppBar _buildAppbar() {
    return AppBar(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CustBackButton(),
        ],
      ),
      // title: const CustomText(
      //   txtTitle: StaticString.login,
      //   style: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     fontSize: 18,
      //   ),
      // ),
    );
  }

  // Image
  Widget _buildImage() {
    return CustImage(
      imgURL: ImgName.loginImage,
      width: 272,
      height: 200,
    );
  }

  // Email text form feild

  Widget _buildEmailIdFeild() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (email) {
        _userInfoModel.email = email ?? "";
      },
      validator: (val) => val?.validateEmail,
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 20,
        ),
        suffixIcon: suffixIconForTextField(
          img: ImgName.email,
          boxFit: BoxFit.cover,
          height: 14,
          width: 18,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontFamily: CustomFont.metropolis,
          fontWeight: FontWeight.w500,
          color: custBlack102339.withOpacity(0.4),
        ),
        hintText: StaticString.emailID,
      ),
    );
  }

  // Password Text form feild
  Widget _buildPasswordFeild() {
    return TextFormField(
      onSaved: (psw) {
        _userInfoModel.password = psw ?? "";
      },
      validator: (val) => val?.validatePassword,
      controller: _passwordController,
      obscureText: true,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(img: ImgName.password),
        hintStyle: TextStyle(
          fontSize: 14,
          fontFamily: CustomFont.metropolis,
          fontWeight: FontWeight.w500,
          color: custBlack102339.withOpacity(0.4),
        ),
        hintText: StaticString.password,
      ),
    );
  }

  /// Forgot Password
  Widget _buildForgotPassword(BuildContext context) {
    return InkWell(
      onTap: _forgotPassword,
      child: CustomText(
        align: TextAlign.right,
        txtTitle: StaticString.forgotPassword, // Forgopt Password
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  // Login button
  Widget _buildLoginButton() {
    return Obx(
      () {
        return CustomButton(
          onPressed: _formSubmit,
          buttonTitle: StaticString.LOGIN,
          loadingIndicator: controller.loginApiInProgress.value,
        );
      },
    );

    // : Center(
    //   child: LoadingIndicator(
    //     loadingStatusNotifier: _loadingIndicatorNotifier.statusNotifier,
    //     indicatorType: LoadingIndicatorType.Spinner,
    //     child: ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
    //         elevation: 10,
    //       ),
    //       onPressed: _formSubmit,
    //       child: const CustomText(
    //         txtTitle: StaticString.LOGIN,
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

  void _forgotPassword() {
    // Get.to(ForgotPasswordScreen());
    Get.toNamed("ForgotPasswordScreen");
  }

  Future<void> _formSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;
      _setstate.notifyListeners();
      return;
    }
    try {
      _loadingIndicatorNotifier.show();
      _formKey.currentState?.save();
      debugPrint(_userInfoModel.email);
      _userInfoModel.timeZone = ApiMiddleware.currentTimeZone;
      // Call API...
      await Get.find<AuthController>().authenticateServerSideUser(
        context: getContext,
        userInfo: _userInfoModel,
      );

      // Get.showSnackbar(const GetSnackBar(
      //   message: "Logged In Successfully",
      //   animationDuration: Duration(seconds: 2),
      //   duration: Duration(seconds: 2),
      // ));
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
