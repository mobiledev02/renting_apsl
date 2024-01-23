// ignore_for_file: unused_local_variable

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/main.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/models/item_renting_request.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';

import '../api/api_end_points.dart';
import '../api/api_middleware.dart';
import '../constants/img_font_color_string.dart';
import '../models/request_model.dart';

class RequestController extends GetxController {
  final fdb = FirebaseFirestore.instance;

  RxList<RequestModel> listOfRequest = <RequestModel>[].obs;
  RxList<RequestModel> myRequestList = <RequestModel>[].obs;

  RxBool loadingRequest = false.obs;
  RxBool loadMyRequest = false.obs;
  RxBool lazyLoadingRequest = true.obs;
  RxBool lazyLoadingMyRequest = true.obs;
  RxBool loadingRentingRequest = false.obs;

  void clearData() {
    listOfRequest.value.clear();
    myRequestList.value.clear();
    loadMyRequest.value = false;
    loadingRentingRequest.value = false;
    lazyLoadingRequest.value = true;
    lazyLoadingMyRequest.value = true;
  }

  List<RequestModel> get getRequestList => listOfRequest;

  List<RequestModel> get getMyRequestList => myRequestList;

  Future<void> createReuest({
    required RequestModel requestModel,
    required BuildContext context,
  }) async {
    try {
      loadingRequest.value = true;
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.createRequest,
          parameter: requestModel.toCreateRequestJson(),
        ),
      );
      print(response);
      listOfRequest.value = listOfRequestModelFromJson(response);
      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingRequest.value = false;
    }
  }

  /// getting list of request
  Future<void> fetchRequest({
    required BuildContext context,
    String date = "",
    bool onTap = false,
    bool forRefresh = false,
  }) async {
    if (loadingRequest.value) return;
    try {
      if (onTap) {
        lazyLoadingRequest.value = true;
        listOfRequest.clear();
      }

      if (listOfRequest.isEmpty) {
        loadingRequest.value = !forRefresh;
      }
      if (forRefresh) {
        lazyLoadingRequest.value = true;
      }
      if (!lazyLoadingRequest.value) return;
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: EventEndPoints.requestItems +
              "?offset=${listOfRequest.length}&limit=${APISetup.lazyLoadLimit}&date=$date",
        ),
      );
      // print(response);

      List<RequestModel> responseList = listOfRequestModelFromJson(response);
      if (responseList.length < APISetup.lazyLoadLimit) {
        lazyLoadingRequest.value = false;
      }
      listOfRequest.addAll(responseList);
      // print(listOfRequest.length);
      update();
      // } else {
      //   return;
      // }
    } catch (e) {
      rethrow;
    } finally {
      loadingRequest.value = false;
    }
  }

  /// request for getting service
  Future<void> fetchMyRequest({
    required BuildContext context,
    String date = "",
    bool onTap = false,
    bool forRefresh = false,
  }) async {
    try {
      if (onTap || forRefresh) {
        lazyLoadingMyRequest.value = true;
        myRequestList.clear();
      }
      if (myRequestList.isEmpty) {
        loadingRequest.value = true;
      } else {
        loadMyRequest.value = true;
      }
      if (lazyLoadingMyRequest.value) {
        final String response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.GET,
            url:
                "${EventEndPoints.myRequestList}?offset=${myRequestList.length}&limit=${APISetup.lazyLoadLimit}&date=$date",
          ),
        );
        // print(response);
        final List<RequestModel> responseList =
            listOfRequestModelFromJson(response);
        if (responseList.length < APISetup.lazyLoadLimit) {
          lazyLoadingMyRequest.value = false;
        }
        myRequestList.addAll(responseList);
        // print(listOfRequest.length);
        update();
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    } finally {
      loadingRequest.value = false;
      loadMyRequest.value = false;
    }
  }

  Future<void> deleteMyRequest({
    required BuildContext context,
    required int id,
  }) async {
    try {
      loadingRequest.value = true;
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.DELETE,
          url: EventEndPoints.deleteRequest + id.toString(),
        ),
      );

      myRequestList.removeWhere((requestModel) => requestModel.id == id);

      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingRequest.value = false;
    }
  }

  Future<void> createItemRequest(
      {required ItemRentingRequest rentingRequest,
      required String docId}) async {
    try {
      await fdb
          .collection(StaticString.itemRequestsCollection)
          .doc(docId)
          .set(rentingRequest.toJson());
    } catch (e, st) {
      debugPrint('createItemRequest $e $st');
    }
  }

  /// Item renting requests
  Future<ItemRentingRequest?> getItemRentingRequest(
      String id, String userId) async {
    try {
      debugPrint('item id is $id user id us$userId');
      loadingRentingRequest.value = true;
      final requests = await FirebaseFirestore.instance
          .collection(StaticString.itemRequestsCollection)
          .where('renter_id', isEqualTo: userId)
          .where('item_id', isEqualTo: id)
          .where('item_request_status', whereNotIn: ['lenderCompleted', 'completed'])
          .orderBy('item_request_status')
          .orderBy('updated_at', descending: true)
          .limit(1)
          .get();
      debugPrint('here is the list ${requests.docs}');
      final data = requests.docs.first;
      if (data.exists) {
        return ItemRentingRequest.fromJson(data.data());
      }
      return null;
    } catch (e, st) {
      debugPrint('getItemRentingRequest $e $st');
      return null;
    } finally {
      loadingRentingRequest.value = false;
    }
  }

  Future<void> sendNotificationToRenterItemAccept(
      String itemId, String lenderId, String renterId,) async {
    try {
      debugPrint('sendNotificationToRenterItemAccept called');
      final String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.sendNotificationRenterAccept,
          parameter: {
            'item_id': itemId,
            'lender_id': lenderId,
            'renter_id': renterId,
          }
        ),
      );
      debugPrint('sendNotificationToRenterItemAccept called success');
    } catch (e, st) {
      debugPrint('acceptRequest error $e $st');
    } finally {}
  }

  Future<void> acceptRequest(
      String id, String itemId, String lenderId, String renterId,) async {
    try {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: true,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await FirebaseFirestore.instance
          .collection(StaticString.itemRequestsCollection)
          .doc(id)
          .update({
        StaticString.itemRequestStatus:
            ItemRequestStatus.LenderAccepted.getEnumName,
        'updated_at': Timestamp.now(),
      });
      sendNotificationToRenterItemAccept(itemId, lenderId, renterId);
    } catch (e, st) {
      Get.showSnackbar(
        const GetSnackBar(
          message: "Error accepting offer",
          duration: Duration(seconds: 2),
          animationDuration: Duration(seconds: 3),
        ),
      );
      debugPrint('acceptRequest error $e $st');
    } finally {
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  Future<void> declineRequest(String id) async {
    try {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: true,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await FirebaseFirestore.instance
          .collection(StaticString.itemRequestsCollection)
          .doc(id)
          .update({
        StaticString.itemRequestStatus:
            ItemRequestStatus.LenderDeclined.getEnumName,
        'updated_at': Timestamp.now(),
      });
    } catch (e, st) {
      Get.showSnackbar(const GetSnackBar(
        message: "Error declining offer",
        duration: Duration(seconds: 2),
        animationDuration: Duration(seconds: 3),
      ));
      debugPrint('acceptRequest error $e $st');
    } finally {
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  /// Service renting requests

  Future<void> createServiceRequest(
    String serviceId,
    JobOfferModel offer,
    //   String chatId,
  ) async {
    try {
      offer.serviceId = serviceId;
      await FirebaseFirestore.instance
          .collection(StaticString.serviceRequestCollection)
          .doc(offer.id.toString())
          .set(offer.toFirebaseJson());
    } catch (e, st) {
      debugPrint('createServiceRequest error $e $st');
      rethrow;
    }
  }

  void notifyRequestcontroller() {
    update();
  }
}
