import 'dart:io';

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/img_font_color_string.dart';
import '../controller/auth_controller.dart';

class PushNotification {
// Create constructor...
  PushNotification._privateConstructor();

// Instance getter...
  static final PushNotification _instance =
      PushNotification._privateConstructor();

// Class instance...
  static PushNotification get instance => _instance;

  /// On message received...
  void Function(RemoteMessage, NotificationType)? onMessageReceived;

  // Notification setup methods setup...
  void pushNotificationsMethodsSetup() {
    // Initialize notification methods only once, to avoid multiple notification on logout and login again...
    if (onMessageReceived != null) return;

    // 1. This method call when app in [Terminated] state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    FirebaseMessaging.instance.getInitialMessage().then(
        (message) => decodeNotificationMessage(
              message,
              NotificationType.terminated,
            ), onError: (error) {
      print("Get Initial Message Error: $error");
    });

    // 2. This method only call when App in [Forground] it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        
        return decodeNotificationMessage(message, NotificationType.forground);
      },
      onError: (error) {
        print("On Message Error: $error");
      },
    );

    // 3. This method only call when App in [Background] and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        
        return decodeNotificationMessage(
          message,
          NotificationType.background,
        );
      },
      onError: (error) {
        print("On Message Opened App Error: $error");
      },
    );
  }

  // Decode notification message...
  void decodeNotificationMessage(
    RemoteMessage? message,
    NotificationType notificationType,
  ) {
    if (onMessageReceived != null && message != null) {
      onMessageReceived!(
        message,
        notificationType,
      );
    }
  }

  // Get push notification permission...
  Future<bool> getNotificationPermission() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else {
      await FirebaseMessaging.instance.requestPermission(
        sound: true,
        badge: true,
        alert: true,
      );

      return await Permission.notification.isGranted;
    }
  }

  //Get FCM device token if Notificatoin is granted...
  Future<String> getFCMToken() async {
    try {
      if (await getNotificationPermission()) {
        // Check connectivity because internet is required if notification is granted....
        await ApiCall.checkConnectivity();

        final String? fcmId = await FirebaseMessaging.instance.getToken();

        return fcmId ?? "";
      } else {
        return "";
      }
    } catch (error) {
      debugPrint("Error while fetching FCM token:- $error");
      return "";
    }
  }

  Future<String> fetchDeviceInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor!;
      }
    } catch (e) {
      return "";
    }
  }

  // Logout user, delete's firebase instance so that notification is not received on mobile...
  Future<void> logout() async {
    return FirebaseMessaging.instance.deleteToken();
  }

  Future<void> refreshToken() async {
    try {
      final authController = Get.find<AuthController>();
      if (authController.isUserLoggedIn.value) {
        final user = authController.getUserInfo;

        final fcmToken = await getFCMToken();

        refreshTokenServer(fcmToken);
        final userData = await FirebaseFirestore.instance
            .collection(StaticString.mainUserCollection)
            .doc(user.id)
            .get();

        if (userData.data() != null) {
          if (fcmToken != userData.data()!['fcm_id']) {
            FirebaseFirestore.instance
                .collection(StaticString.mainUserCollection)
                .doc(user.id)
                .update(
              {
                'fcm_id': fcmToken,
                'fcm_id_list': [
                  {
                    'device_id': user.userDevice?.deviceId ?? '',
                    'fcm_id': fcmToken,
                  }
                ],
              },
            );
          }
        }
      }
    } catch (e, st) {
      debugPrint('refreshToken $e $st');
    }
  }

  Future<void> refreshTokenServer(String fcmToken) async {
    final authController = Get.find<AuthController>();
    if (authController.isUserLoggedIn.value) {
      final user = authController.getUserInfo;
      user.userDevice?.fcmId = fcmToken;
      authController.updateFcmToken(userInfoModel: user);
    }
  }
}

enum NotificationType {
  terminated,
  forground,
  background,
}
