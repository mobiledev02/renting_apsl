import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/screen/home_screen_setup.dart';

import '/controller/auth_controller.dart';
import '/widgets/cust_button.dart';
import '../../constants/img_font_color_string.dart';
import '../../utils/url_switcher_screen.dart';
import '../../widgets/cust_image.dart';

class LoginRegisterScreen extends GetView<AuthController> {
  LoginRegisterScreen({Key? key}) {
    // checkIsUpdateAvailable();
  }

  //!-------------------- Variables--------------------

  //!-------------------- UI--------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //Image
            _buildImage(),
            // Login button
            _buildLoginButton(),
            const SizedBox(
              height: 24,
            ),
            // Register Button
            _buildRegisterButton(),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
                onTap: () {
                  Get.find<AuthController>().setGuest();
                  Get.to(HomeSetUpScreen());
                },
                child: const Text('Skip'))
          ],
        ),
      ),
    );
  }

//!-------------------- Helper Widget--------------------

  // Image
  Widget _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 41,
        ),
        child: URLSwitcher(
          child: CustImage(
            imgURL: ImgName.loginRegisterImage,
          ),
        ),
      ),
    );
  }

// Login Button
  Widget _buildLoginButton() {
    return CustomButton(
      onPressed: _goLogin,
      buttonTitle: StaticString.login.toUpperCase(),
    );
  }

// Register button
  Widget _buildRegisterButton() {
    return CustomButton(
      onPressed: _goRegister,
      buttonTitle: StaticString.register.toUpperCase(),
      buttonColor: Colors.white,
      borderSide: const BorderSide(color: custMaterialPrimaryColor, width: 1.2),
      hideShadow: true,
      loaderAndTextColor: custMaterialPrimaryColor,
    );
  }

  //!-------------------------Button Action---------------

  void _goLogin() {
    // Get.to(() => const LoginScreen());
    Get.toNamed("LoginScreen");
  }

  void _goRegister() {
    // Get.to(() => const RegisterScreen());
    Get.toNamed("RegisterScreen");
  }
}
