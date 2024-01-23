// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

import '/controller/auth_controller.dart';
import '../api/api_end_points.dart';
import '../models/api_response_model.dart';
import '../models/user_model.dart';
import '../utils/shared_preference.dart';
import '../utils/url_switcher_screen.dart';
import '../widgets/custom_alert.dart';

class ApiMiddleware {
  static String _deivceType = Platform.isAndroid ? "android" : "ios";
  static String appVersion = "";
  static String appVersionBuild = "";
  static String deviceUUID = "";
  static String appName = "";
  static String apiResponse = "";
  static String currentTimeZone = "";

  static UserInfoModel get getUserInfo => SharedPreferencesHelper.getUserInfo;

  static set setUserInfo(UserInfoModel info) {
    // if (info.id == null &&
    //     (info.authType == AuthType.None ||SharedPreferencesHelper.setUserInfo
    //         info.authType == AuthType.DeleteAccount ||
    //         info.authType == AuthType.Logout)) return;

    SharedPreferencesHelper.setUserInfo = info;
  }

  static Future<void> getDefaultParams() async {
    await SharedPreferencesHelper.loadSavedData();
    await ProductionStagingURL.loadSavedData();
    currentTimeZone = DateTime.now().timeZoneName;
    //await FlutterNativeTimezone.getLocalTimezone();

    debugPrint(currentTimeZone);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion = packageInfo.version;
  }

  static Future<void> _fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    appVersionBuild = 'Version:$version Build:$buildNumber';
    appVersion = version;
    appName = packageInfo.appName;
  }

  static Map<String, dynamic> get defaultParams => {
        "device_type": _deivceType,
        "app_version": appVersion,
        "device_id": deviceUUID,
      };

  static Future<void> _fetchDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceUUID = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceUUID = iosInfo.identifierForVendor!;
      }
    } catch (e) {
      print("Error fetching device info");
    }
  }

  //Get Final Url...
  static String getFinalURL({String endpoint = ""}) {
    String newBaseURL = ProductionStagingURL.getCustomBaseURL;

    //Live Base URL...
    String _liveBaseURL =
        (newBaseURL.isEmpty ? APISetup.productionURL : newBaseURL);

    // Test URL...
    String _testBaseURL = _liveBaseURL;

    switch (APISetup.urlTypeToTest) {
      // Stagging...
      case URLType.Staging:
        _testBaseURL = APISetup.stagingURL;
        break;

      // Production...
      case URLType.Production:
        _testBaseURL = APISetup.productionURL;
        break;

      // Local...
      case URLType.Local:
        _testBaseURL = APISetup.localURL;
        break;

      case URLType.None:
        _testBaseURL = _liveBaseURL;
        break;
    }

    //Check if App is in Debug or Live Mode...
    String finalURL = (kReleaseMode ? _liveBaseURL : _testBaseURL) + endpoint;
    return finalURL;
  }

  static Map<String, String> get getCommonHeader {
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": Get.find<AuthController>().getUserInfo.getBearerToken,
      // "x-api-key": APISetup.apiKey,
    };

    return _header;
  }

  static Future<String> callService({
    required BuildContext? context,
    required APIRequestInfoObj? requestInfo,
    bool addDefaultParameters = true,
    bool addDefaultHeaders = true,
    bool isThirdPartyUrl = false,
    bool authorizationAdd = true,
  }) async {
    try {
      // Get deivce id and app version...
      if (deviceUUID.isEmpty) {
        await _fetchAppVersion();
        await _fetchDeviceInfo();
      }

      if (!isThirdPartyUrl) {
        requestInfo!.url = getFinalURL(endpoint: requestInfo.url);
      }
      if (addDefaultHeaders) {
        requestInfo!.headers = getCommonHeader;
      }

      http.Response apiResponse = await ApiCall.callService(
        requestInfo: requestInfo!,
      );

      return processResponse(apiResponse);
    } catch (error, st) {
      debugPrint(
          'error processing response $error $st etype${error.runtimeType}');
      await FirebaseCrashlytics.instance
          .recordError(error, st, reason: 'error on api call');
      debugPrint('callService Error $error $st');
      if (error is AppException) {
        debugPrint(error.message);
      }
      if (error is AppException &&
          error.type == ExceptionType.UnderMaintainance) {
        showAlert(
          context: context,
          barrierDismissible: false,
          message: error,
          rigthBttnTitle: "Retry",
          onRightAction: () {
            callService(
              context: context,
              requestInfo: requestInfo,
            );
          },
        );
        return "";
      } else {
        rethrow;
      }
    }
  }

  static String _getErrorTitle(http.Response response) => response.body.isEmpty
      ? APIErrorMsg.defaultErrorTitle
      : defaultRespInfo(response.body).title;

  static String _getErrorMsg(http.Response response) => response.body.isEmpty
      ? APIErrorMsg.somethingWentWrong
      : defaultRespInfo(response.body).message;

  static String processResponse(http.Response response) {
    String title = _getErrorTitle(response);
    String msg = _getErrorMsg(response);
//response.statusCode
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response.body;

      case 401:
      case 410:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
          type: ExceptionType.UnAuthorised,
        );

      case 400:
      case 403:
      case 404:
      case 422:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
          type: ExceptionType.None,
        );

      case 503:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
          type: ExceptionType.UnderMaintainance,
        );

      default:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
          type: ExceptionType.None,
        );
    }
  }
}
