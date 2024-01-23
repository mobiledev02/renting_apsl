// ignore_for_file: prefer_final_fields, unused_field, unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/models/item_model.dart';
import 'package:renting_app_mobile/models/user_model.dart';

import '/controller/chat_controller.dart';
import '/controller/item_controller.dart';
import '/models/lend_model.dart';
import '../api/api_end_points.dart';
import '../api/api_middleware.dart';
import '../models/item_detail_model.dart';
import '../models/rate_model.dart';
import '../models/service_detail_model.dart';
import '../utils/custom_enum.dart';
import 'auth_controller.dart';

class LendController extends GetxController {
  LendModel listOfLend = LendModel();

  LendModel get getLendList => listOfLend;
  final itemDetail = ItemDetailModel().obs;

  ItemDetailModel get getItemList => itemDetail.value;

  RxBool showFullReviews = false.obs;
  final lenderProfile = Rxn<UserInfoModel>();

  RxBool loadingItemDetail = false.obs;
  RxBool iDetailLoading = false.obs;
  RxBool sDetailLoading = false.obs;
  RxBool loadingItemDelete = false.obs;
  RxBool loadingLenderProfile = false.obs;

  void clearData() {
    listOfLend = LendModel();
    loadingItemDetail.value = false;
    loadingItemDelete.value = false;
  }

  ChatController _chatController = Get.find<ChatController>();
  ItemController _itemController = Get.find<ItemController>();

  //---------------------------------- items -------------------------------------------

  Future<void> fetchItemDetail({
    required BuildContext context,
    required int id,
  }) async {
    try {
      debugPrint('fetchitem detail id $id');
      iDetailLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 100));

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url:

          Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.detail}' + "$id" :  EventEndPoints.detail + "$id",
        ),
      );

      log('full item response $response');

      itemDetail.value = itemDetailModelFromJson(response);
    } catch (e, st) {
      debugPrint('fetchItemDetail error $e $st');
      rethrow;
    } finally {
      iDetailLoading.value = false;
    }
  }

  Future<ItemDetailModel> fetchItemDetailForProfile({
    required BuildContext context,
    required int id,
  }) async {
    try {
      //   iDetailLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 100));

      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: Get.find<AuthController>().guest.value ? 'guest-${EventEndPoints.detail}$id' :  EventEndPoints.detail + "$id",
        ),
      );

      ItemDetailModel itemDetail = itemDetailModelFromJson(response);

      debugPrint(response);
      return itemDetail;
      //   itemDetail.value = itemDetailModelFromJson(response);
    } catch (e) {
      rethrow;
    } finally {
      //   iDetailLoading.value = false;
    }
  }

  Future<void> createItem({
    required BuildContext context,
    required ItemDetailModel itemDetailModel,
  }) async {
    try {
      debugPrint(
          'images length while posting ${itemDetailModel.lendItemServiceImages?.length}');
      itemDetailModel.lendItemServiceImages?.forEach((element) {
        debugPrint(
            'while creating item image is posted ${element.imageUrl} these are paths ');
      });
      loadingItemDetail.value = true;
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.createItemAndService,
          docList: [
            UploadDocumentObj(
              docKey: "images[]",
              docPathList: itemDetailModel.lendItemServiceImages
                      ?.map((e) => e.imageUrl)
                      .toList() ??
                  [],
            ),
          ],
          parameter: itemDetailModel.toCreateItemJson(),
        ),
      );

      debugPrint('response returned $response');
      ItemDetailModel _itemDetail = itemDetailModelFromJson(response);

      _itemController.myItemList.insert(
        0,
        ItemModel(
          category: _itemDetail.category,
          id: _itemDetail.id,
          name: _itemDetail.name,
          price: _itemDetail.price,
          images: _itemDetail.lendItemServiceImages,
        ),
      );

      update();
    } catch (e, st) {
      debugPrint('create item error $e $st');
      rethrow;
    } finally {
      loadingItemDetail.value = false;
    }
  }

  /// rename to item
  Future<void> updateItemAndService({
    required BuildContext context,
    required ItemDetailModel itemDetailModel,
  }) async {
    try {
      loadingItemDetail.value = true;
      List<String> imageList = [];
      if (itemDetailModel.lendItemServiceImages != null) {
        for (final image in itemDetailModel.lendItemServiceImages!) {
          if (!image.imageUrl.startsWith('http')) {
            imageList.add(image.imageUrl);
          }
        }
      }
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.updateItemAndService +
              (itemDetailModel.id.toString()),
          docList: [
            UploadDocumentObj(
              docKey: "images[]",
              docPathList: imageList,

              // itemDetailModel.lendItemServiceImages
              //         ?.map((e) =>  e.imageUrl)
              //         .toList() ??
              //     [],
            ),
          ],
          parameter: itemDetailModel.category?.type == ItemOrService.item
              ? itemDetailModel.toCreateItemJson()
              : itemDetailModel.toCreateServiceJson(),
        ),
      );

      await _itemController.fetchMyItems(context: context, onTap: true);

      itemDetail.value = itemDetailModelFromJson(response);

      // await _chatController.createLandInFirebase(
      //   itemDetailModel: itemDetailModelFromJson(response),
      // );

      update();
    } catch (e, st) {
      rethrow;
    } finally {
      loadingItemDetail.value = false;
    }
  }

  Future<void> updateService({
    required BuildContext context,
    required ServiceDetailModel serviceDetailModel,
  }) async {
    try {
      loadingItemDetail.value = true;
      List<String> imageList = [];
      if (serviceDetailModel.lendItemServiceImages != null) {
        for (final image in serviceDetailModel.lendItemServiceImages!) {
          if (!image.imageUrl.startsWith('http')) {
            imageList.add(image.imageUrl);
          }
        }
      }
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.updateItemAndService +
              (serviceDetailModel.id.toString()),
          docList: [
            UploadDocumentObj(
              docKey: "images[]",
              docPathList: imageList,
            ),
          ],
          parameter: serviceDetailModel.toCreateServiceJson(),
        ),
      );

      /// rename the api
      await _itemController.fetchMyItems(context: context, onTap: true);

      itemDetail.value = itemDetailModelFromJson(response);

      update();
    } catch (e, st) {
      rethrow;
    } finally {
      loadingItemDetail.value = false;
    }
  }

  /// rename to delete item
  Future<void> deleteItemAndService(
      {required BuildContext context, required int id}) async {
    try {
      loadingItemDelete.value = true;

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.DELETE,
          url: EventEndPoints.deleteItemAndService + id.toString(),
        ),
      );

      // itemDetail.value = itemDetailModelFromJson(json.encode(itemDetailJson));
      // itemDetail.value = itemDetailModelFromJson(response);
      _itemController.deleteLocal(id: id);
      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingItemDelete.value = false;
    }
  }

  Future<void> deleteService(
      {required BuildContext context, required int id}) async {
    try {
      loadingItemDelete.value = true;

      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.DELETE,
          url: EventEndPoints.deleteItemAndService + id.toString(),
        ),
      );
      _itemController.deleteLocal(id: id);
      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingItemDelete.value = false;
    }
  }

//---------------------------------- Service -------------------------------------------

  Future<void> createService(
      {required BuildContext context,
      required ItemDetailModel itemDetailModel}) async {
    try {
      final List<String> list = [];
      if (itemDetailModel.lendItemServiceImages != null) {
        for (int i = 0;
            i < itemDetailModel.lendItemServiceImages!.length;
            i++) {
          if (itemDetailModel.lendItemServiceImages![i].imageUrl.isNotEmpty) {
            list.add(itemDetailModel.lendItemServiceImages![i].imageUrl);
          }
        }
      }
      debugPrint('what is the value ${list}');
      loadingItemDetail.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.createItemAndService,
          docList: [
            UploadDocumentObj(
              docKey: "images[]",
              docPathList: list ?? [],
            ),
          ],
          parameter: itemDetailModel.toCreateServiceJson(),
        ),
      );

      final ItemDetailModel _itemDetail = itemDetailModelFromJson(response);

      _itemController.myItemList.insert(
        0,
        ItemModel(
          category: _itemDetail.category,
          id: _itemDetail.id,
          name: _itemDetail.name,
          price: _itemDetail.price,
          images: _itemDetail.lendItemServiceImages,
        ),
      );

      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingItemDetail.value = false;
    }
  }

//--------------------------------- Rate -----------------------------------------------
  final rate = RateModel().obs;

  RateModel get getRate => rate.value;

  Future<void> fetchRate(context) async {
    try {
      String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: EventEndPoints.rates,
        ),
      );

      rate.value = rateModelFromJson(response);

      update();
    } catch (e) {
      rethrow;
    } finally {}
  }

  void updateRate(String value) {
    rate.value = RateModel(itemDailyRate: value);
    update();
  }

  Future<void> getLenderProfile(BuildContext context, String lenderId) async {
    try {
      loadingLenderProfile.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          url: Get.find<AuthController>().guest.value ?  'guest-${EventEndPoints.lenderProfile}' :  EventEndPoints.lenderProfile,
          parameter: {'user_id': lenderId},
        ),
      );
      log('Lender profile $response');
      final data = json.decode(response);
      final reviews = data['dataset']['reviews'] as List;

      lenderProfile.value =
          UserInfoModel.fromJsonWithReviews(data['dataset']['user'], reviews);
    } catch (e, st) {
      debugPrint('getLenderProfile error $e $st');
    } finally {
      loadingLenderProfile.value = false;
      update();
    }
  }

  void setFullReviewVisibility() {
    if (showFullReviews.value) {
      showFullReviews.value = false;
    } else {
      showFullReviews.value = true;
    }
  }
}
