// ignore_for_file: unused_local_variable

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/binding/routs.dart';
import 'package:renting_app_mobile/controller/category_controller.dart';
import 'package:renting_app_mobile/controller/chat_controller.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/controller/lend_controller.dart';
import 'package:renting_app_mobile/controller/notification_controller.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/controller/request_controller.dart';
import 'package:renting_app_mobile/controller/total_payment_controller.dart';
import 'package:renting_app_mobile/models/customer_card.dart';
import 'package:renting_app_mobile/models/location_model.dart';
import 'package:renting_app_mobile/screen/auth/otp_screen.dart';

import '../utils/push_notification.dart';
import '../widgets/custom_alert.dart';
import '/main.dart';
import '/screen/auth/login_register_screen.dart';
import '/screen/home_screen_setup.dart';
import '/utils/shared_preference.dart';
import '../api/api_end_points.dart';
import '../api/api_middleware.dart';
import '../models/user_model.dart';
import '../utils/custom_enum.dart';
import '../utils/push_notification_original.dart';

class AuthController extends GetxController {
  // UserInfoModel userProfile = UserInfoModel(authType: AuthType.UpdateProfile);
  UserInfoModel get getUserInfo => ApiMiddleware.getUserInfo;
  UserInfoModel userModel = UserInfoModel(authType: AuthType.None);

  /// Set token for logging user in
  RxBool get isUserLoggedIn => (getUserInfo.token.isNotEmpty).obs;

  RxBool get paymentConnected => getUserInfo.stripeConnected.obs;
  RxBool loginApiInProgress = false.obs;
  RxBool registerApiInProgress = false.obs;
  RxBool otpApiInProgress = false.obs;
  RxBool resendOtpInProgress = false.obs;
  RxBool forgotpasswordApiInProgress = false.obs;
  RxBool loadingMyProfile = false.obs;
  RxBool updateMyProfile = false.obs;
  RxBool deleteAccount = false.obs;
  RxBool submittingVerification = false.obs;
  RxBool guest = false.obs;
  RxBool isTestMode = false.obs;

  set setUserInfo(UserInfoModel info) {
    if ((info.authType != AuthType.Logout &&
            info.authType != AuthType.DeleteAccount) &&
        info.token.isEmpty) {
      // info.token == getUserInfo.token;
      userModel = info;
    }
    ApiMiddleware.setUserInfo = info;
  }

  setRegisterApiInprogress() {
    registerApiInProgress.value = true;
  }

  void setGuest() {
    guest.value = true;
    update();
  }

  Future<void> authenticateServerSideUser({
    required BuildContext context,
    required UserInfoModel userInfo,
  }) async {
    try {
      switch (userInfo.authType) {
        case AuthType.Login:
          loginApiInProgress.value = true;
          break;
        case AuthType.SignUp:
          registerApiInProgress.value = true;
          break;
        case AuthType.OTP:
          otpApiInProgress.value = true;
          break;
        case AuthType.resentOTP:
          resendOtpInProgress.value = true;
          break;
        case AuthType.ForgotPassword:
          forgotpasswordApiInProgress.value = true;
          break;
        case AuthType.ChangePassword:
          break;
        case AuthType.UpdateProfile:
          updateMyProfile.value = true;
          break;
        case AuthType.SetFcmToken:
          break;
        case AuthType.Logout:
          break;
        case AuthType.DeleteAccount:
          deleteAccount.value = true;
          break;
        case AuthType.TermsAndCondition:
          break;
        case AuthType.PrivacyPolicy:
          break;
        case AuthType.None:
          break;
      }

      if (userInfo.authType == AuthType.Login ||
          userInfo.authType == AuthType.SignUp ||
          userInfo.authType == AuthType.Logout) {
        userInfo.userDevice = UserDevice();
        userInfo.userDevice?.fcmId =
            await PushNotification.instance.getFCMToken();
        userInfo.userDevice?.deviceId =
            await PushNotification.instance.fetchDeviceInfo();

        debugPrint('device id info ${userInfo.userDevice?.id}');
        // Set time zone...
        // userInfo.timeZone = await FlutterNativeTimezone.getLocalTimezone();
        // print(userInfo.fcmId);
      }
      String response = "";
      response = await ApiMiddleware.callService(
        context: context,
        requestInfo: userInfo.toAPIRequestInfo(),
      );

      switch (userInfo.authType) {
        case AuthType.Login:
          UserInfoModel? userInfoModel;
          userInfoModel = userInfoFromServerJson(response);
          setUserInfo = userInfoModel;
          Get.offAll(() => OTPScreen());

          break;
        case AuthType.SignUp:
          UserInfoModel? userInfoModel;
          userInfoModel = userInfoFromServerJson(response);
          setUserInfo = userInfoModel;
          Get.offAll(() => OTPScreen());

          break;
        case AuthType.OTP:
          UserInfoModel? userInfoModel;
          userInfoModel = userInfoFromServerJson(response);
          setUserInfo = userInfoModel;

          await FirebaseAuth.instance
              .signInWithCustomToken(getUserInfo.customToken);

          getChatController?.createUser(userInfoModel: userInfoModel);
          Get.offAll(() => HomeSetUpScreen());
          break;
        case AuthType.resentOTP:
          UserInfoModel? userInfoModel;
          userInfoModel = userInfoFromServerJson(response);
          userInfoModel.authType = AuthType.OTP;
          setUserInfo = userInfoModel;
          break;
        case AuthType.ForgotPassword:
          UserInfoModel? userInfoModel;
          userInfoModel = userInfoFromServerJson(response);
          Get.back();
          break;
        case AuthType.ChangePassword:
          UserInfoModel? userInfoModel;
          userInfoModel = userInfoFromServerJson(response);
          Get.back();
          break;
        case AuthType.UpdateProfile:
          UserInfoModel? userInfoModel;
          debugPrint(userInfoFromServerJson(response).toJson().toString());
          userInfoModel = userInfoFromServerJson(response);
          userInfoModel.token = getUserInfo.token;
          userInfoModel.userDevice = getUserInfo.userDevice;
          getChatController?.createUser(userInfoModel: userInfoModel);
          setUserInfo = userInfoModel;

          break;
        case AuthType.SetFcmToken:
          break;
        case AuthType.Logout:
          UserInfoModel userInfoModel = getUserInfo;
          Get.find<ChatController>()
              .updateFcmIdList(isLogout: true, userInfoModel: userInfoModel);
          Get.find<CategoryContoller>().clearData();
          Get.find<ItemController>().clearData();
          Get.find<LendController>().clearData();
          Get.find<NotificationController>().clearData();
          Get.find<RequestController>().clearData();
          Get.find<TotalPaymentController>().clearData();
          userInfoModel.token = "";
          userInfoModel = UserInfoModel(authType: AuthType.None);

          SharedPreferencesHelper.setUserInfo = userInfoModel;
          await SharedPreferencesHelper.removeUserDetail();
          Get.offAll(() => LoginRegisterScreen());
          break;
        case AuthType.DeleteAccount:
          UserInfoModel userInfoModel = getUserInfo;
          Get.find<CategoryContoller>().clearData();
          Get.find<ItemController>().clearData();
          Get.find<LendController>().clearData();
          Get.find<NotificationController>().clearData();
          Get.find<RequestController>().clearData();
          Get.find<TotalPaymentController>().clearData();
          userInfoModel.token = "";

          SharedPreferencesHelper.setUserInfo = userInfoModel;
          await SharedPreferencesHelper.removeUserDetail();
          Get.offAll(() => LoginRegisterScreen());
          break;
        case AuthType.TermsAndCondition:
          break;
        case AuthType.PrivacyPolicy:
          break;
        case AuthType.None:
          throw "Please set authentication type";
      }
    } catch (e, st) {
      debugPrint('authenticateSeverSideUser error $e $st');
      rethrow;
    } finally {
      switch (userInfo.authType) {
        case AuthType.Login:
          if (loginApiInProgress.value) {
            loginApiInProgress.value = false;
          }

          break;
        case AuthType.SignUp:
          if (registerApiInProgress.value) {
            registerApiInProgress.value = false;
          }

          break;
        case AuthType.OTP:
          if (otpApiInProgress.value) {
            otpApiInProgress.value = false;
          }

          break;
        case AuthType.resentOTP:
          if (resendOtpInProgress.value) {
            resendOtpInProgress.value = false;
          }

          break;
        case AuthType.ForgotPassword:
          if (forgotpasswordApiInProgress.value) {
            forgotpasswordApiInProgress.value = false;
          }

          break;
        case AuthType.ChangePassword:
          break;
        case AuthType.UpdateProfile:
          if (updateMyProfile.value) {
            updateMyProfile.value = false;
          }
          // fetchMyProfile(context: getContext);
          // update();
          break;
        case AuthType.SetFcmToken:
          break;
        case AuthType.Logout:
          break;
        case AuthType.DeleteAccount:
          deleteAccount.value = false;
          break;
        case AuthType.TermsAndCondition:
          break;
        case AuthType.PrivacyPolicy:
          break;
        case AuthType.None:
          break;
      }
      guest.value = false;
    }
  }

  /// fetch my profile data

  Future<void> fetchMyProfile({
    required BuildContext context,
  }) async {
    try {
      if (getUserInfo.id.isEmpty) {
        loadingMyProfile.value = true;
      }

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: AuthEndPoints.myProfile +
              (getUserInfo.userDevice?.deviceId ?? ""),
        ),
      );

      UserInfoModel _userInfo = userInfoFromServerJson(response);
      debugPrint('stripe connected ${_userInfo.stripeConnected}');
      _userInfo.token = getUserInfo.token;

      setUserInfo = _userInfo;

      update();
    } catch (e, st) {
      debugPrint('fetchMyProfile $e $st');
      rethrow;
    } finally {
      loadingMyProfile.value = false;
    }
  }

  Future<void> verifyIDBackgroundCheck({
    required BuildContext context,
  }) async {
    try {
      if (getUserInfo.id.isEmpty) {
        loadingMyProfile.value = true;
      }

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: AuthEndPoints.myProfile +
              (getUserInfo.userDevice?.deviceId ?? ""),
        ),
      );

      final UserInfoModel _userInfo = userInfoFromServerJson(response);
      debugPrint('stripe connected ${_userInfo.stripeConnected}');

      _userInfo.token = getUserInfo.token;

      setUserInfo = _userInfo;

      update();
    } catch (e, st) {
      debugPrint('fetchMyProfile $e $st');
      rethrow;
    } finally {
      loadingMyProfile.value = false;
    }
  }

  void setUserPaymentConnected(data) {
    setUserInfo = data;
  }

  Future<void> updatePushNotificationStatus({
    required UserInfoModel userInfoModel,
  }) async {
    final String response;
    try {
      response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url:
              "${AuthEndPoints.updateNotification}?device_id=${getUserInfo.userDevice?.deviceId ?? ""}&fcm_id=${getUserInfo.userDevice?.fcmId ?? ""}&push_notification=${userInfoModel.userDevice?.pushNotification ?? false}&email_notification=${userInfoModel.userDevice?.emailNotification ?? false}",
          requestType: HTTPRequestType.GET,
          //parameter: userInfoModel.toJson(),
        ),
      );
      update();
    } catch (e) {
      //print(response); // Where 'response' is the API response
      rethrow;
    } finally {}
  }

  Future<void> updateFcmToken({
    required UserInfoModel userInfoModel,
  }) async {
    try {
      await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url:
              "${AuthEndPoints.updateNotification}?device_id=${getUserInfo.userDevice?.deviceId ?? ""}&fcm_id=${getUserInfo.userDevice?.fcmId ?? ""}&push_notification=${userInfoModel.userDevice?.pushNotification ?? false}&email_notification=${userInfoModel.userDevice?.emailNotification ?? false}",
          requestType: HTTPRequestType.GET,
          parameter: userInfoModel.toJson(),
        ),
      );
      update();
    } catch (e) {
      rethrow;
    } finally {}
  }

  // update address
  Future<void> updateLocation({
    required LocationModel locationModel,
  }) async {
    try {
      final String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: AuthEndPoints.locationUpdate,
          parameter: {
            "place_object": locationModel.toJson(),
          },
        ),
      );
      final UserInfoModel _userInfo = userInfoFromServerJson(response);
      _userInfo.token = getUserInfo.token;
      setUserInfo = _userInfo;

      update();
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future<void> submitVerification({
    required BuildContext context,
    // required String dob,
    // required String ssn,
    required String lastName,
    required CustomerCard custCard,
  }) async {
    try {
      submittingVerification.value = true;
      update();
      final paymentController = Get.find<PaymentController>();
      final int status =
          await paymentController.confirmPaymentForCheckr(context, custCard);
      // final response = await ApiMiddleware.callService(
      //   context: context,
      //   requestInfo: APIRequestInfoObj(
      //       requestType: HTTPRequestType.POST,
      //       url: EventEndPoints.submitVerification,
      //       parameter: {'dob': dob, 'last_name': lastName, 'ssn': ssn}),
      // );

      showAlert(
          context: context,
          title: 'Alert',
          message:
              'A mail has been sent to your e-mail address from Checkr. Please proceed with the e-mail to further verify your identity');

      update();
    } catch (e) {
      if (e is AppException) {
        showAlert(
            context: context, title: e.title ?? 'Error', message: e.message);
      } else {
        rethrow;
      }
    } finally {
      submittingVerification.value = false;
      fetchMyProfile(context: context);
    }
  }
}
