// // ignore_for_file: avoid_print, avoid_classes_with_only_static_members

// import 'dart:io';

// import 'package:device_info/device_info.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PushNotification {
//   PushNotification._privateConstructor();

// // Instance getter...
//   static final PushNotification _instance =
//       PushNotification._privateConstructor();

// // Class instance...
//   static PushNotification get instance => _instance;
//   // Get push notification permission...
//   static Future<bool> getNotificationPermission() async {
//     if (Platform.isAndroid) {
//       return Permission.notification.isGranted;
//     } else {
//       await FirebaseMessaging.instance
//           .requestPermission(sound: true, badge: true, alert: true);

//       return Permission.notification.isGranted;
//     }
//   }

//   //Get FCM device token if Notificatoin is granted...
//   static Future<String> getFCMToken() async {
//     try {
//       if (await getNotificationPermission()) {
//         String? fcmId = await FirebaseMessaging.instance.getToken();

//         print("+ + + + + + + + + FCM Id : $fcmId");

//         return fcmId ?? "";
//       } else {
//         return "";
//       }
//     } catch (error) {
//       print("Error while fetching FCM token:- $error");
//       return "";
//     }
//   }

// //Get  device id
//   static Future<String> fetchDeviceInfo() async {
//     try {
//       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//       if (Platform.isAndroid) {
//         AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         return androidInfo.androidId;
//       } else {
//         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         return iosInfo.identifierForVendor;
//       }
//     } catch (e) {
//       return "";
//     }
//   }

//   // Logout user, delete's firebase instance so that notification is not received on mobile...
//   static Future logout() {
//     return FirebaseMessaging.instance.deleteToken();
//   }
// }
