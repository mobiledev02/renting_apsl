import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/constants/img_font_color_string.dart';
import '/widgets/common_widgets.dart';
import '/widgets/cust_image.dart';
import '../../controller/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_indicator.dart';
import '/utils/custom_extension.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //!---------------------variable------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final UserInfoModel _userInfoModel = UserInfoModel(
    authType: AuthType.ChangePassword,
  );

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  /// image
                  _buildImage(),
                  const SizedBox(
                    height: 20,
                  ),

                  /// Change password
                  _buildChangeText(context),
                  const SizedBox(
                    height: 26,
                  ),

                  ///current Password Text Form Field
                  _buildCurrentPasswordTExtFormField(),
                  const SizedBox(
                    height: 24,
                  ),

                  /// new Password Text Form Field
                  _buildPasswordTExtFormField(),
                  const SizedBox(
                    height: 24,
                  ),

                  /// Confirm Password text Form Field
                  _buildConfirmPassTextFormField(),
                  const SizedBox(
                    height: 30,
                  ),

                  /// Submit buttom
                  _buildSubmitButton(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //!---------------------------------------------- widget -------------------------------------------

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
      //   txtTitle: StaticString.changePassword,
      //   style: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     fontSize: 18,
      //   ),
      // ),
    );
  }

  /// Image
  Widget _buildImage() {
    return CustImage(
      imgURL: ImgName.resetPasswordImnage,
      width: 205,
      height: 200,
    );
  }

  // Reset Password
  Widget _buildChangeText(BuildContext context) {
    return CustomText(
      txtTitle: StaticString.changePassword, // change Password
      style: Theme.of(context).textTheme.headline4?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  /// Password Text Form Fiel
  Widget _buildCurrentPasswordTExtFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      // obscuringCharacter: "*",
      obscureText: true,
      onSaved: (psw) {
        _userInfoModel.password = psw ?? "";
      },
      validator: (val) => val?.validatePassword,
      controller: _currentPasswordController,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(img: ImgName.password),
        hintText: StaticString.currentPassword,
      ),
    );
  }

  /// Password Text Form Fiel
  Widget _buildPasswordTExtFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      // obscuringCharacter: "*",
      obscureText: true,
      onSaved: (psw) {
        _userInfoModel.newPassword = psw ?? "";
      },
      validator: (val) => val?.validatePassword,
      controller: _passwordController,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(img: ImgName.password),
        hintText: StaticString.newPassword,
      ),
    );
  }

  /// Confirm Password text Form Field
  Widget _buildConfirmPassTextFormField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      // obscuringCharacter: "",
      obscureText: true,
      // onSaved: (psw) {
      //   _userInfoModel.password = psw ?? "";
      // },
      validator: (pwd) {
        if (pwd!.isEmpty) {
          return AlertMessageString.emptyConfirmPwd;
        } else if (pwd != _passwordController.text) {
          return AlertMessageString.passwordDoNotMatch;
        }
        return null;
      },
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(img: ImgName.password),
        hintText: StaticString.confirmPassword,
      ),
    );
  }

  /// Submit buttom
  Widget _buildSubmitButton() {
    return Center(
      child: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicatorNotifier.statusNotifier,
        indicatorType: LoadingIndicatorType.Spinner,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
            elevation: 10,
          ),
          onPressed: _formSubmit,
          child: CustomText(
            txtTitle: StaticString.submit.toUpperCase(),
            style: const TextStyle(
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontFamily: CustomFont.metropolis,
            ),
          ),
        ),
      ),
    );
  }

  //!-----------------------Button Action-------------------------------

  Future<void> _formSubmit() async {
    debugPrint(
        "************************** Reset Password Submit ************************");
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;

      setState(() {});
      return;
    }
    try {
      _loadingIndicatorNotifier.show();
      _formKey.currentState?.save();
      debugPrint(_userInfoModel.email);
      // Call API...
      Get.find<AuthController>().authenticateServerSideUser(
        context: context,
        userInfo: _userInfoModel,
      );
    } catch (error) {
      // Show alert...
      showAlert(
        context: context,
        message: error,
      );
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }
}
