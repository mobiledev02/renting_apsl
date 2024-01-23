import 'dart:convert';

import 'package:ASL_Auth/ASL_Auth.dart';

import 'package:get/get.dart';
import 'package:renting_app_mobile/api/api_middleware.dart';
import 'package:renting_app_mobile/main.dart';
import 'package:renting_app_mobile/models/payment_history_model.dart';
import 'package:renting_app_mobile/models/payment_request_model.dart';
import 'package:renting_app_mobile/models/total_payment_detail_model.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';

import '../api/api_end_points.dart';
import '../widgets/show_cust_alert.dart';

import '../constants/img_font_color_string.dart';

class TotalPaymentController extends GetxController {
  List<PaymentHistoryModel> paymentHistoryModelList = [];
  RxBool loadingPaymentAPI = false.obs, loadingPaymentHistoryAPI = false.obs;

  void clearData() {
    // listOfTotalPaymenyJson.clear();
    loadingPaymentAPI.value = false;
  }

  List<PaymentHistoryModel> get getListOfTotalPaymeny {
    var orderedList = paymentHistoryModelList;
    return orderedList;
  }

  set setPaymentListModel(List<PaymentHistoryModel> list) {
    paymentHistoryModelList = list;
  }

  Future<void> doPayment(
    PaymentRequestModel paymentRequestModel,
  ) async {
    try {
      loadingPaymentAPI.value = true;

      String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.itemServiceRent,
          parameter: paymentRequestModel.toJson(),
        ),
      );

      Future.delayed(Duration(milliseconds: 200), () {
        showCustomAlert(
          context: getContext,
          status: json.decode(response)["data"]["payment_status"],
          onRightAction: () {
            Get.until((route) => route.isFirst);
          },
        );
      });
    } catch (e, st) {
      rethrow;
    } finally {
      loadingPaymentAPI.value = false;
    }
  }

  Future<void> fetchPaymentHistory({bool forRefresh = false}) async {
    try {
      if (!forRefresh) {
        loadingPaymentHistoryAPI.value = true;
      }

      String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.getPayment,
          requestType: HTTPRequestType.GET,
        ),
      );

      setPaymentListModel = listOfPaymentHistoryModelFromJson(response);

      update();
    } catch (e) {
      rethrow;
    } finally {
      loadingPaymentHistoryAPI.value = false;
    }
  }
}
