import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/constants/img_font_color_string.dart';
import '/screen/auth/login_register_screen.dart';
import '/widgets/cust_image.dart';
import '../../controller/auth_controller.dart';
import '../home_screen_setup.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {}).then(
      (value) => Get.find<AuthController>().isUserLoggedIn.value
          ? Get.off(HomeSetUpScreen())
          : Get.off(LoginRegisterScreen()),

      //  Get.off(
      //   const LoginRegisterScreen(),
      //   transition: Transition.zoom,
      // ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CustImage(
            imgURL: ImgName.logo,
          ),
        ),
      ),
    );
  }
}
