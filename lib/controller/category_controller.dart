import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/main.dart';

import '../api/api_end_points.dart';
import '../api/api_middleware.dart';
import '../models/categories_model.dart';
import 'auth_controller.dart';

class CategoryContoller extends GetxController {
  RxBool fetchingCatForItems = false.obs, fetchingCatForService = false.obs;
  RxList<CategoryModel> listOfCategoryItem = <CategoryModel>[].obs;
  RxList<CategoryModel> listOfCategoryService = <CategoryModel>[].obs;

  List<CategoryModel> get getCategoryItemList => listOfCategoryItem;

  List<CategoryModel> get getCategoryServiceList => listOfCategoryService;

  clearData() {
    listOfCategoryItem.value.clear();
    listOfCategoryService.value.clear();
  }

  Future<void> fetchCategories({
    required String type,
    bool forRefresh = false,
  }) async {
    try {
      if (type == "item") {
        if (fetchingCatForItems.value) return;

        fetchingCatForItems.value = !forRefresh;
      } else {
        if (fetchingCatForService.value) return;

        fetchingCatForService.value = !forRefresh;
      }

      await Future.delayed(const Duration(milliseconds: 400));

      final String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.GET,
          url: Get.find<AuthController>().guest.value
              ? 'guest-${EventEndPoints.categories}'
              : EventEndPoints.categories + type,
        ),
      );

      // rate.value =
      //     serviceDetailModelFromJson(json.encode(serviceDetailJson));
      if (type == "item") {
        listOfCategoryItem.value = listOfCategoryModelFromJson(response);
      } else {
        listOfCategoryService.value = listOfCategoryModelFromJson(response);
      }

      update();
    } catch (e) {
      rethrow;
    } finally {
      if (type == "item") {
        fetchingCatForItems.value = false;
      } else {
        fetchingCatForService.value = false;
      }
    }
  }
}
