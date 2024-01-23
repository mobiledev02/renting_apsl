// ignore_for_file: unused_local_variable

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/notification_model.dart';
import '../api/api_end_points.dart';
import '../api/api_middleware.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxBool loadingNotification = false.obs;

  void clearData() {
    notificationList.value.clear();
    loadingNotification.value = false;
  }

  Future<void> fetchNotification({required BuildContext context}) async {
    try {
      loadingNotification.value = true;

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: EventEndPoints.notification,
        ),
      );

      notificationList.value = listOfNotificationModelFromJson(response);
      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingNotification.value = false;
    }
  }

  Future<void> deleteNotification(
      {required BuildContext context, required int id}) async {
    try {
      loadingNotification.value = true;

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.DELETE,
          url: EventEndPoints.deleteNotification + id.toString(),
        ),
      );
      notificationList.removeWhere((element) => element.id == id);

      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingNotification.value = false;
    }
  }

  Future<void> deleteAllNotification({
    required BuildContext context,
  }) async {
    try {
      loadingNotification.value = true;

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.DELETE,
          url: EventEndPoints.deleteAllNotification,
        ),
      );
      notificationList.clear();

      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingNotification.value = false;
    }
  }
}
