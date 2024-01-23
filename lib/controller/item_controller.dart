// ignore_for_file: non_constant_identifier_names, unused_local_variable, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/main.dart';
import 'package:renting_app_mobile/models/rented_item_service_detail_model.dart';
import 'package:renting_app_mobile/models/review_model.dart';
import 'package:renting_app_mobile/models/service_model.dart';
import 'package:renting_app_mobile/models/service_provider_profile_model.dart';
import 'package:renting_app_mobile/screen/home_screen_setup.dart';
import 'package:renting_app_mobile/widgets/loading_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import '../api/api_end_points.dart';
import '../api/api_middleware.dart';
import '../constants/img_font_color_string.dart';
import '../models/item_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/custom_enum.dart';
import '../widgets/custom_alert.dart';
import 'auth_controller.dart';
import 'chat_controller.dart';

class ItemController extends GetxController {
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;
  RxList<ItemModel> myItemList = <ItemModel>[].obs;
  RxList<String> _milesList = <String>[].obs;

  final rentedItemService = Rxn<RentedItemServiceDetailModel>();
  RxBool loadingHomeScreenData = false.obs;
  RxBool loadingItems = false.obs;
  RxBool lazyLoading = false.obs;
  RxBool loadService = false.obs;
  RxBool filterApplied = false.obs;
  RxBool lazyLoadingMyLending = true.obs;
  RxBool lazyLoadingItems = true.obs;
  RxBool lazyLoadingServices = true.obs;
  RxBool loadingMyItemService = false.obs;
  RxBool loadingRentedItemServiceDetail = false.obs;
  RxBool submitReviewLoading = false.obs;
  RxBool submitReturnRequestLoading = false.obs;
  RxBool profileLoading = false.obs;
  RxString type = 'all'.obs;

  String _selectedDistance = "";

  List<ItemModel> get getItemList => [...itemList];

  List<ServiceModel> get getServiceList => [...serviceList];

  List<ItemModel> get getMyItemList => [...myItemList];

  List<String> get getMilesList => _milesList;

  String get getSelectedMiles => _selectedDistance;

  set setMilesList(List<String> milesList) {
    _milesList.value = milesList;
  }

  set setSelectedMiles(String mile) {
    _selectedDistance = mile;

    // if (filterApplied.value) {
    fetchItems(
      type.value,
      context: getContext,
      forRefresh: true,
    );

    fetchServices(context: getContext, forRefresh: true);

    // filterApplied.value = false;
    // }
  }

  void clearData() {
    itemList.clear();
    serviceList.clear();
    myItemList.clear();
    loadingItems.value = false;
    loadingHomeScreenData.value = false;
    lazyLoading.value = false;

    loadService.value = false;
    lazyLoadingMyLending.value = true;
    lazyLoadingItems.value = true;
    lazyLoadingServices.value = true;
  }

  void deleteLocal({required int id}) {
    myItemList.removeWhere((element) => element.id == id);
    itemList.removeWhere((element) => element.id == id);
    update();
  }

  // void selectDeselectMiles(String mile) {

  //   _milesList.value.forEach((element) {
  //     if (element.distance == mile) {
  //       element.isSelected = !element.isSelected;
  //     } else {
  //       element.isSelected = false;
  //     }
  //   });

  //   update();
  // }

  void selectDeselectMiles({required String mile, bool callApi = true}) {
    if (mile == _selectedDistance) {
      setSelectedMiles = "";
    } else {
      setSelectedMiles = mile;
    }

    // _milesList.value.forEach((element) {
    //   if (element.distance == mile) {
    //     element.isSelected = !element.isSelected;
    //   } else {
    //     element.isSelected = false;
    //   }
    // });
    fetchItems('all', context: getContext);
    update();
  }

  Future<void> fetchItems(
  String? type,
      {
    required BuildContext context,
    String name = "",
    bool forRefresh = false,
    bool forSearch = false,
    String sortBy = "",
    String categoryId = "",

  }) async {
    debugPrint('fetch item called $type');
    debugPrint('fetch items guest status ${Get.find<AuthController>().guest}');
    try {
      if ((name.isNotEmpty || getSelectedMiles.isNotEmpty) &&
          !filterApplied.value) {
        filterApplied.value = true;
      }

      if (forRefresh || forSearch) {
        lazyLoadingItems.value = true;
      }

      if (loadingItems.value) {
        debugPrint('this work');
        return;
      }

      if (itemList.isEmpty && !forRefresh) {
        lazyLoadingItems.value = true;
        loadingItems.value = true;
      }

      int offset = forRefresh || forSearch ? 0 : itemList.length;

      if (lazyLoadingItems.value) {
        debugPrint('yes lazy loading items');
        final String response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.GET,
            url:
                "${Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.lendItem}' : EventEndPoints.lendItem}?name=$name&miles=$getSelectedMiles&offset=$offset&limit=${APISetup.lazyLoadLimit}&price_order=$sortBy&category_id=$categoryId&type=$type",
          ),
        );
        log('miles item real $response');
        if (forRefresh) {
          itemList.clear();
        }

        final List<ItemModel> responseList = listOfItemModelFromJson(response);

        print(responseList.length);

        if (responseList.length < APISetup.lazyLoadLimit) {
          lazyLoadingItems.value = false;
        }

        if (forRefresh || forSearch) {
          itemList.clear();
         itemList.value = responseList;
        } else {
          itemList.addAll(responseList);
        }

        update();
      }
    } catch (e) {
      rethrow;
    } finally {
      loadingItems.value = false;
    }
  }

  Future<void> fetchServices({
    required BuildContext context,
    String name = "",
    bool forRefresh = false,
    bool forSearch = false,
    String sortBy = "",
    String categoryId = "",
  }) async {
    try {
      if ((name.isNotEmpty || getSelectedMiles.isNotEmpty) &&
          !filterApplied.value) {
        filterApplied.value = true;
      }

      if (forRefresh || forSearch) {
        lazyLoadingServices.value = true;
      }

      if (loadService.value) {
        return;
      }

      if (serviceList.isEmpty && !forRefresh) {
        lazyLoadingServices.value = true;
        loadService.value = true;
      }

      await Future.delayed(Duration(milliseconds: 300));

      int offset = forRefresh || forSearch ? 0 : serviceList.length;
      print(lazyLoadingServices.value);
      if (lazyLoadingServices.value) {
        print("Come to call api ${Get.find<AuthController>().guest.value}");
        final String response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.GET,
            url:
                "${Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.lendServices}' : EventEndPoints.lendServices}?name=$name&miles=$getSelectedMiles&offset=$offset&limit=${APISetup.lazyLoadLimit}&price_order=$sortBy&category_id=$categoryId",
          ),
        );
        log('mile fetch response $response');
        if (forRefresh) {
          serviceList.clear();
        }

        final List<ServiceModel> responseList =
            listOfServiceModelFromJson(response);

        if (responseList.length < APISetup.lazyLoadLimit) {
          lazyLoadingServices.value = false;
        }

        if (forRefresh || forSearch) {
          serviceList.clear();
          serviceList.value = responseList;
        } else {
          serviceList.addAll(responseList);
        }

        // print(serviceList.length);

        update();
      }
    } catch (e) {
      rethrow;
    } finally {
      loadService.value = false;
    }
  }

  Future<void> fetchMyItems({
    required BuildContext context,
    String name = "",
    String type = "",
    bool forRefresh = false,
    bool onTap = false,
  }) async {
    try {
      if (onTap) {
        lazyLoadingMyLending.value = true;
        myItemList.clear();
      }

      if (forRefresh) {
        lazyLoadingMyLending.value = true;
      }

      if (lazyLoadingMyLending.value) {
        if (!forRefresh && myItemList.isEmpty) {
          loadingMyItemService.value = true;
        }

        final String response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.GET,
            url:
                "${EventEndPoints.myLending}?offset=${myItemList.length}&limit=${APISetup.lazyLoadLimit}&name=$name&type=$type",
          ),
        );

        final List<ItemModel> responseList = listOfItemModelFromJson(response);
        if (responseList.length < APISetup.lazyLoadLimit) {
          lazyLoadingMyLending.value = false;
        }
        myItemList.addAll(responseList);

        update();
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    } finally {
      loadingMyItemService.value = false;
    }
  }

  Future<void> getCategoryItemListById({
    required int id,
    required BuildContext context,
  }) async {
    try {
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.lendItem}' :  EventEndPoints.lendItem,
          parameter: {"category_id": id},
        ),
      );
     log('miles item $response');
      itemList.clear();
      itemList.value = listOfItemModelFromJson(response);
      update();
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future<void> fetchMiles() async {
    try {
      final String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: EventEndPoints.miles,
        ),
      );

      var list
 = List<String>.from(
        json.decode(response)["dataset"].map(
              (x) => x.toString(),
            ),
      );
      list.add('All');
      setMilesList = list;
      // itemList.value = itemModelFromJson(response) as List<ItemModel>;
      update();
    } catch (e) {
      rethrow;
    } finally {}
  }

  ItemModel getProduct(String id) {
    return getItemList.firstWhere((element) => element.id == id);
  }

  // Service Provider`s profile detail
  Future<ServiceProviderProfileModel> fetchServiceProvidersDetail(
    String serviceId,
  ) async {
    try {
      final String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: EventEndPoints.serviceProviderDetail + serviceId,
        ),
      );

      debugPrint(response);

      return serviceProviderProfileModelFromJson(response);
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future<void> getRentedItemDetails(
      BuildContext context, String transactionId) async {
    try {
      debugPrint('guest status ${Get.find<AuthController>().guest.value}');
      loadingRentedItemServiceDetail.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.rentItemServiceDetail}' : EventEndPoints.rentItemServiceDetail,
          parameter: {'id': transactionId},
        ),
      );
      log('paymenthistory data $response');
      final data = json.decode(response);
      rentedItemService.value =
          RentedItemServiceDetailModel.fromJson(data['data']);
      log('GetRentedItemServiceDetails response $response');

      // final data = json.decode(response)['dataset']['user_card'] as List;
      debugPrint('description ${rentedItemService.value?.description}');

      //
    } catch (e, st) {
      debugPrint('GetRentedItemServiceDetails error $e $st');
    } finally {
      loadingRentedItemServiceDetail.value = false;
    }
  }

  Future<void> getRentedServiceDetails(
      BuildContext context, String transactionId) async {
    try {
      debugPrint('guest status ${Get.find<AuthController>().guest.value}');
      loadingRentedItemServiceDetail.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.rentServiceDetail}' : EventEndPoints.rentServiceDetail,
          parameter: {'id': transactionId},
        ),
      );
      log('paymenthistory  service  data $response');
      final data = json.decode(response);
      rentedItemService.value =
          RentedItemServiceDetailModel.fromJson(data['data'][0]);
      log('rented service response $response');

      // final data = json.decode(response)['dataset']['user_card'] as List;
      debugPrint('description ${rentedItemService.value?.description}');

      //
    } catch (e, st) {
      debugPrint('GetRentedItemServiceDetails error $e $st');
    } finally {
      loadingRentedItemServiceDetail.value = false;
    }
  }

  Future<void> submitReview(BuildContext context, ReviewModel review) async {
    try {
      submitReviewLoading.value = true;
      final params = review.toJson();
      params['type'] = null;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.submitReview,
          parameter: params,
        ),
      );

      debugPrint('submitReview ${rentedItemService.value?.description}');
      Get.offAll(() => HomeSetUpScreen());
      await Future.delayed(const Duration(milliseconds: 200));
      Get.showSnackbar(const GetSnackBar(
        message: "Review submitted successfully",
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 2),
      ));
    } catch (e, st) {
      showAlert(context: getContext, message: e);
      debugPrint('submitReview error $e $st');
    } finally {
      submitReviewLoading.value = false;
    }
  }

  Future<void> submitReviewService(
      BuildContext context, ReviewModel review, String offerId) async {
    try {
      submitReviewLoading.value = true;
      final params = review.toJson();
      params['offer_id'] = offerId;
      debugPrint('param of offer_id ${params['offer_id']} offerId ');

      params['type'] = 'service';
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.submitReview,
          parameter: params,
        ),
      );
      FirebaseFirestore.instance
          .collection(StaticString.serviceRequestCollection)
          .doc(offerId)
          .update({'reviewed': true, 'updated_at': Timestamp.now(), 'current_status': 'completed'});
      debugPrint('submitReview ${rentedItemService.value?.description}');
      Get.offAll(() => HomeSetUpScreen());
      await Future.delayed(const Duration(milliseconds: 200));
      Get.showSnackbar(const GetSnackBar(
        message: "Review submitted successfully",
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 2),
      ));
    } catch (e, st) {
      showAlert(context: getContext, message: e);
      debugPrint('submitReview error $e $st');
    } finally {
      submitReviewLoading.value = false;
    }
  }

  // Fetch the timestamp from the backend
  Future<String?> fetchTimestamp(
      BuildContext context,
      String id,) async {
    final response = await ApiMiddleware.callService(
      context: context,
      requestInfo: APIRequestInfoObj(
        requestType: HTTPRequestType.POST,
        url: 'get-timestamp',
        parameter: {
          'id': id,
        },
      ),
    );

    final data = json.decode(response);
    final timestamp = data['dataset']['timestamp'];
    return timestamp;
  }

  Future<void> submitReturnedItemInfo(
      BuildContext context,
      String id,
      int option,
      String description,
      String? renter,
       MessageModel messageModel,
      List<String> filePaths,) async {
    try {
      debugPrint('room id in submission $id');
      submitReturnRequestLoading.value = true;

      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      List<String> images = [];
      if (filePaths.isNotEmpty) {
        images = await pickAndUploadImageAsMessage(filePaths, id);
      }
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'submit-survey',
          parameter: {
            'id': id,
            'survey': option,
            'feedback': description,
          },
        ),
      );
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          await Get.find<ChatController>().sendMessage(
            messageModel: MessageModel(
              lenderId: renter ?? '',
              renterId: Get.find<AuthController>().getUserInfo.id,
              chatRoomId: id,
              toSend: messageModel.lenderId,
              forSingleChat: "false",
              sendBy: Get.find<AuthController>().getUserInfo.id,
              senderInfo: Get.find<AuthController>().getUserInfo,
              receiverInfo:
                  UserInfoModel(
                      authType: AuthType.None, id: renter ?? ''),
              itemId: messageModel.itemId,
              eventServiceId: "",
              messageType: MessageType.Image,
              docUrl: images[i],
              time: DateTime.now().millisecondsSinceEpoch,
              message: "Image",
            ),
          );
        }
      }

      debugPrint('submitReview ${rentedItemService.value?.description}');
      Get.back();
      Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      Get.showSnackbar(const GetSnackBar(
        message:
            "Your request is submitted successfully. We will review it and will process your request",
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 2),
      ));
    } catch (e, st) {
      Get.back();
      showAlert(context: getContext, message: e);
      debugPrint('submitReview error $e $st');
    } finally {
      submitReturnRequestLoading.value = false;
    }
  }

  Future<bool> alreadySubmitted(BuildContext context, String id) async {
    try {
      debugPrint('already submitted id$id');
      showDialog(
          context: context,
          builder: (context) => Center(child: CircularProgressIndicator()));
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'check-survey',
          parameter: {
            'id': id,
          },
        ),
      );

      debugPrint('checkRequestInfo ');
      Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      var data = json.decode(response);
      if (data['dataset']['already'] == true) {
        Get.showSnackbar(const GetSnackBar(
          message: "Your request is already submitted",
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ));
        return false;
      } else if (data['dataset']['already'] == false) {
        return true;
      }
      return false;
    } catch (e, st) {
      Get.back();
      showAlert(context: getContext, message: e);
      debugPrint('checkRequestInfo error $e $st');
      return false;
    } finally {}
  }

  Future<bool> alreadySubmittedRenter(BuildContext context, String id) async {
    try {
      debugPrint('already submitted id $id');
      showDialog(
          context: context,
          builder: (context) => const Loading(),);
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'renter-check-survey',
          parameter: {
            'id': id,
          },
        ),
      );

      debugPrint('checkRequestInfo ');
      Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      var data = json.decode(response);
      if (data['dataset']['already'] == true) {
        Get.showSnackbar(const GetSnackBar(
          message: "Your request is already submitted",
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ));
        return false;
      } else if (data['dataset']['already'] == false) {
        return true;
      }
      return false;
    } catch (e, st) {
      Get.back();
      showAlert(context: getContext, message: e);
      debugPrint('alreadySubmittedRenter error $e $st');
      return false;
    } finally {}
  }

  Future<bool> alreadySubmittedRenterReturn(BuildContext context, String id) async {
    try {

      showDialog(
        context: context,
        builder: (context) => const Loading(),);
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'check-return-survey',
          parameter: {
            'id': id,
          },
        ),
      );

      debugPrint('checkRequestInfo ');
      Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      var data = json.decode(response);
      if (data['dataset']['already'] == true) {
        Get.showSnackbar(const GetSnackBar(
          message: "Your request is already submitted",
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ));
        return false;
      } else if (data['dataset']['already'] == false) {
        return true;
      }
      return false;
    } catch (e, st) {
      Get.back();
      showAlert(context: getContext, message: e);
      debugPrint('alreadySubmittedRenter error $e $st');
      return false;
    } finally {}
  }

  Future<void> submitRentingItemInfo(
      BuildContext context,
      String id,
      String option,
      String description,
      UserInfoModel? lender,
      MessageModel messageModel,
      List<String> filePaths) async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Loading(),);
      List<String> images = [];
      if (filePaths.isNotEmpty) {
        images = await pickAndUploadImageAsMessage(filePaths, id);
      }
      debugPrint('room id in submission renter item obtaining $id $option');
      submitReturnRequestLoading.value = true;

      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'renter-submit-survey',
          parameter: {
            'id': id,
            'survey': option,
            'feedback': description,
          },
        ),
      );

      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          await Get.find<ChatController>().sendMessage(
            messageModel: MessageModel(
              lenderId: lender?.id ?? '',
              renterId: Get.find<AuthController>().getUserInfo.id,
              chatRoomId: id,
              toSend: messageModel.lenderId,
              forSingleChat: "false",
              sendBy: Get.find<AuthController>().getUserInfo.id,
              senderInfo: Get.find<AuthController>().getUserInfo,
              receiverInfo: lender ??
                  UserInfoModel(
                      authType: AuthType.None, id: messageModel.lenderId),
              itemId: messageModel.itemId,
              eventServiceId: "",
              messageType: MessageType.Image,
              docUrl: images[i],
              time: DateTime.now().millisecondsSinceEpoch,
              message: "Image",
            ),
          );
        }
      }

      debugPrint(
          'submitRentingItemInfo ${rentedItemService.value?.description}');
      Get.back();
      Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      Get.showSnackbar(const GetSnackBar(
        message: "Thank you for submitting to us.",
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 2),
      ));
    } catch (e, st) {
      Get.back();
      showAlert(context: getContext, message: e);
      debugPrint('submitRentingItemInfo error $e $st');
    } finally {
      submitReturnRequestLoading.value = false;
    }
  }

  Future<void> submitItemReturningInfo(
      BuildContext context,
      String id,
      String description,
      UserInfoModel? lender,
      MessageModel messageModel,
      List<String> filePaths,) async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Loading(),);
      List<String> images = [];
      if (filePaths.isNotEmpty) {
        images = await pickAndUploadImageAsMessage(filePaths, id);
      }
      debugPrint('room id in submission renter item obtaining $id ');
      submitReturnRequestLoading.value = true;

      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'submit-return-survey',
          parameter: {
            'id': id,
            'survey': '1',
            'feedback': description,
          },
        ),
      );

      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          await Get.find<ChatController>().sendMessage(
            messageModel: MessageModel(
              lenderId: lender?.id ?? '',
              renterId: Get.find<AuthController>().getUserInfo.id,
              chatRoomId: id,
              toSend: messageModel.lenderId,
              forSingleChat: "false",
              sendBy: Get.find<AuthController>().getUserInfo.id,
              senderInfo: Get.find<AuthController>().getUserInfo,
              receiverInfo: lender ??
                  UserInfoModel(
                      authType: AuthType.None, id: messageModel.lenderId,),
              itemId: messageModel.itemId,
              eventServiceId: "",
              messageType: MessageType.Image,
              docUrl: images[i],
              time: DateTime.now().millisecondsSinceEpoch,
              message: "Image",
            ),
          );
        }
      }

      debugPrint(
          'submitRentingItemInfo ${rentedItemService.value?.description}',);
      Get.back();
      Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      Get.showSnackbar(const GetSnackBar(
        message: "Thank you for submitting to us.",
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 2),
      ));
    } catch (e, st) {
      Get.back();
      showAlert(context: getContext, message: e);
      debugPrint('submitRentingItemInfo error $e $st');
    } finally {
      submitReturnRequestLoading.value = false;
    }
  }

  Future<List<String>> pickAndUploadImageAsMessage(
      List<String> documentList, String roomId) async {
    if (documentList.isEmpty) return [];

    List<String> downlaodedUrls = [];
    try {
      for (String document in documentList) {
        const uuid = Uuid();
        final String extension = p.extension(document);
        final String fileName = '${roomId}${uuid.v4()}.$extension';

        final Reference firebaseStorage =
            FirebaseStorage.instance.ref().child(fileName);

        final UploadTask uploadTask = firebaseStorage.putFile(
          File(document), // File path
        );

        await uploadTask.then(
          (p0) async {
            debugPrint('task uploaded');

            final String temp = await p0.ref.getDownloadURL();

            downlaodedUrls.add(temp);
          },
        );
      }
    } catch (e) {
      rethrow;
    }
    return downlaodedUrls;
  }

  Future<bool> checkDisputeIsValid(
    BuildContext context, String id,) async {
      try {
        String? timestamp = await Get.find<ItemController>().fetchTimestamp(context, id);
        
        if (timestamp != null) {
          // Use the retrieved timestamp here
          print('Timestamp from Lender Submit: $timestamp');
          // Get the returned DateTime (for example, from API response)
          final DateTime returnedDateTime = DateTime.parse(timestamp);

          // Get the current DateTime
          final DateTime currentDateTime = DateTime.now();

          // Calculate the difference between current time and returned time
          final Duration difference = currentDateTime.difference(returnedDateTime);

          // Define a duration of 24 hours
          const Duration twentyFourHours = Duration(hours: 24);

          // Check if the difference is less than 24 hours
          final bool within24Hours = difference < twentyFourHours;

          if (within24Hours) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
    } catch (error) {
      return false;
    }
  }
}

