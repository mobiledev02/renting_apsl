// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, deprecated_member_use

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../api/api_middleware.dart';
import '../constants/img_font_color_string.dart';
import '../main.dart';
import '../widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> checkIsUpdateAvailable() async {
  //Get Current installed version of app

  int currentVersion = int.parse(ApiMiddleware.appVersion.replaceAll(".", ""));

  //Get Latest version info from firebase config
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  try {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration.zero,
      ),
    );
    await remoteConfig.fetchAndActivate();
    final String update = remoteConfig.getString("app_version");

    final int newVersion = int.parse(update.replaceAll(".", ""));

    if (newVersion > currentVersion) {
      _showVersionDialog(update);
    }
  } on Exception catch (exception) {
    debugPrint(exception.toString());
  } catch (exception) {
    debugPrint(
        'Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}

_showVersionDialog(String availableVersion) async {
  await showAlert(
    context: getContext,
    signleBttnOnly: true,
    barrierDismissible: false,
    title: StaticString.newUpdateAvailable,
    message:
        "Update $availableVersion is available to download.Downloading the latest update you will get the latest features,improvements and bug fixes.", // AlertMessageString.newUpdateMsg,
    singleBtnTitle: StaticString.update,
    onRightAction: () {
      Get.back();
    },
  );
}
