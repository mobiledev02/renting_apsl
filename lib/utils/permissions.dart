

import 'package:permission_handler/permission_handler.dart';

Future<bool> checkGalleryPermission() async {
  final status = await Permission.photos.status;

  if (status != PermissionStatus.granted) {
    final result = await Permission.photos.request();

    if (result == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (result == PermissionStatus.granted ||
        result == PermissionStatus.limited) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

Future<bool> checkNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status != PermissionStatus.granted) {
    final result = await Permission.notification.request();

    if (result == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (result == PermissionStatus.granted ||
        result == PermissionStatus.limited) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

Future<bool> checkCameraPermission() async {
  final status = await Permission.camera.status;

  if (status != PermissionStatus.granted) {
    final result = await Permission.camera.request();

    if (result == PermissionStatus.permanentlyDenied) {
      return false;
      // return await openAppSettings();
    } else if (result == PermissionStatus.granted ||
        result == PermissionStatus.limited) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

// Future<bool> checkLocationPermission() async {
//   final status = await Permission.location.status;
//   print(status);
//   if (status != PermissionStatus.granted) {
//     // final result = await Permission.location.request();
//     // print(result);
//     // if (result == PermissionStatus.permanentlyDenied) {
//     //   return await openAppSettings();
//     // } else if (result == PermissionStatus.granted ||
//     //     result == PermissionStatus.limited) {
//     //   return true;
//     // } else {
//     return false;
//     // }
//   } else {
//     return true;
//   }

Future<bool> checkLocationPermission() async {
  final status = await Permission.location.status;

  if (status != PermissionStatus.granted) {
    final result = await Permission.location.request();

    if (result == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (result == PermissionStatus.granted ||
        result == PermissionStatus.limited) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}
