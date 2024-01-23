import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../utils/custom_enum.dart';

class SharedPreferencesHelper {
  // variable

  static UserInfoModel? _userInfo;
  // Shared Preference Keys
  static const String _kUserInfo = 'user_info';

  static SharedPreferences? _prefs;

  // Load saved data...
  static Future<void> loadSavedData() async {
    _prefs = await SharedPreferences.getInstance();
    _getUserDetail();
  }

  //!------------------------------------------------- Setter --------------------------------------------------//

  static Future<bool> removeUserDetail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_kUserInfo);

    return prefs.clear();
  }

  // Set UserInfo...
  static set setUserInfo(UserInfoModel userInfo) {
    _userInfo = userInfo;
    _prefs?.setString(_kUserInfo, userInfoToRawJson(userInfo));
  }

  static UserInfoModel get getUserInfo =>
      _userInfo ??
      UserInfoModel(authType: AuthType.None, userPhotoIdForDelete: []);

  // User detail...
  static void _getUserDetail() {
    String userInfo = _prefs?.getString(_kUserInfo) ?? "";
    _userInfo = userInfoFromStoredJson(userInfo);
  }
}
