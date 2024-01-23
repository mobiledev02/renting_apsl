import 'dart:convert';

import '../api/api_end_points.dart';

import '../constants/img_font_color_string.dart';

ResponseObj defaultRespInfo(String str) => str.isEmpty
    ? ResponseObj()
    : ResponseObj.fromJson(
        json.decode(str),
      );

class ResponseObj {
  static const String _kErrorTitleKey = APISetup.errorTitleKey;
  static const String _kErrorMessageKey = APISetup.errorMessageKey;
  static const String _kUserStatusKey = APISetup.userStatusKey;
  static const String _kDataKey = APISetup.dataKey;
  static const String _kDatasetKey = APISetup.datasetKey;

  ResponseObj({
    this.title = AlertMessageString.defaultErrorTitle,
    this.message = AlertMessageString.somethingWentWrong,
    this.userStatus = "",
    this.resultObj = const {},
    this.resultArray = const [],
  });

  String message, title, userStatus;
  Map resultObj;
  List resultArray;

  factory ResponseObj.fromJson(Map<String, dynamic> json) {
    Map data = <dynamic, dynamic>{};
    List dataSet = [];
    String title = AlertMessageString.defaultErrorTitle;
    String message = AlertMessageString.somethingWentWrong;
    String userStatus = "";

    String? respTitle = json[_kErrorTitleKey];
    String? respMessage = json[_kErrorMessageKey];
    String? respUserStatus = json[_kUserStatusKey];
    dynamic respData = json[_kDataKey];
    dynamic respDataSet = json[_kDatasetKey];

    // Error/Success title...
    if (respTitle != null && respTitle is String) {
      title = respTitle;
    }

    // Error/Success message...
    if (respMessage != null && respMessage is String) {
      message = respMessage;
    }
    // Get object...
    if (respData != null && respData is Map) {
      data = respData;
    }

    // Get object array...
    if (respDataSet != null && respDataSet is List) {
      dataSet = respDataSet;
    }
    if (respUserStatus != null && respUserStatus is String) {
      userStatus = respUserStatus;
    }

    return ResponseObj(
        title: title,
        message: message,
        resultObj: data,
        resultArray: dataSet,
        userStatus: userStatus);
  }
}
