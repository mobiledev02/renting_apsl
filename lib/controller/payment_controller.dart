import 'dart:convert';
import 'dart:developer';
import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';
import 'package:renting_app_mobile/controller/chat_controller.dart';
import 'package:renting_app_mobile/main.dart';
import 'package:renting_app_mobile/models/customer_card.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/models/user_model.dart';
import 'package:renting_app_mobile/utils/stripe_fee_calculator.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import '../api/api_end_points.dart';
import '../api/api_middleware.dart';
import '../models/payment_request_model.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/show_cust_alert.dart';

class PaymentController extends GetxController {
  /// gather payment
  RxBool stripeIntegrationLoading = false.obs;
  RxBool stripePageLoading = false.obs;
  RxBool addCardVisible = false.obs;
  RxBool addCardLoading = false.obs;
  RxBool getCardsLoading = false.obs;
  RxBool loadingPaymentAPI = false.obs;
  List<CustomerCard> customerCards = <CustomerCard>[].obs;
  RxString? selectedCustomerId;

  final selectedCard = Rxn<CustomerCard>();
  CardFieldInputDetails? _card;
  final _selectedPaymentMethod = Rxn<PaymentMethod?>();

  /// withdraw payment
  RxBool otherAmount = false.obs;
  RxBool loadingAccountBalance = false.obs;
  Rx<double?> accountBalance = 0.0.obs;

  void showAddCard() {
    addCardVisible.value = true;
  }

  void hidAddCard() {
    addCardVisible.value = false;
  }

  Future<void> getUserCards(BuildContext context) async {
    try {
      getCardsLoading.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: 'get-user-card',
        ),
      );
      final data = json.decode(response)['dataset']['user_card'] as List;

      customerCards = data.map((e) => CustomerCard.fromJson(e)).toList();

      //
    } catch (e, st) {
      debugPrint('getUserCards error $e $st');
    } finally {
      getCardsLoading.value = false;
      update();
    }
  }

  CustomerCard? getSelectedCard() {
    return customerCards
        .firstWhereOrNull((element) => element.selected == true);
  }

  void selectACard(CustomerCard customerCard) {
    debugPrint('called');
    for (int i = 0; i < customerCards.length; i++) {
      if (customerCards[i].customerId == customerCard.customerId) {
        customerCards[i].selected = true;
        selectedCard.value = customerCards[i];
      } else {
        customerCards[i].selected = false;
      }
      update();
    }
  }

  setCardFieldDetails(card) {
    _card = card;
  }

  Future<void> addPaymentMethod(BuildContext context) async {
    try {
      final authController = Get.find<AuthController>();
      addCardLoading.value = true;
      debugPrint('email is ${authController.getUserInfo.email}');
      final billingDetails = BillingDetails(
        email: authController.getUserInfo.email,
        phone: authController.getUserInfo.phone,
        // email: 'email@stripe.com',
        // phone: '+48888000888',
        // address: Address(
        //   city: 'Houston',
        //   country: 'US',
        //   line1: '1459  Circle Drive',
        //   line2: '',
        //   state: 'Texas',
        //   postalCode: '77063',
        // ),
      );

      var data = await Stripe.instance
          .createToken(CreateTokenParams.card(params: CardTokenParams()));
      var paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData:
                  PaymentMethodData(billingDetails: billingDetails)));
      debugPrint(
          'card token ${data.card?.expYear} ${data.card?.brand} ${data.id}');

      //if()

      if (_selectedPaymentMethod.value != null) {}
      debugPrint(
          'payment method created ${_selectedPaymentMethod.value?.customerId}');
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.saveCard,
          parameter: {
            'payment_method_id': paymentMethod.id,
            "token": data.id,
            'card_type': data.card?.brand,
            'last_digit': data.card?.last4
          },
        ),
      );
      debugPrint('returned response from save card init $response');

      final intent = json.decode(response);
      final responseI = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: intent['dataset']['intent'],
        data: PaymentMethodParams.card(
            paymentMethodData:
                PaymentMethodData(billingDetails: billingDetails)),
      );
      if (responseI.status == PaymentIntentsStatus.Succeeded) {
        debugPrint(
            'Payment successful for intitial charge with id ${responseI}');
        final String response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.POST,
            url: 'save-user-card-success',
            parameter: {
              'customer_id': intent['dataset']['customer_id'],
              'card_type': data.card?.brand,
              'last_digit': data.card?.last4
            },
          ),
        );
      }
      debugPrint('');
      debugPrint(' response return $response');
    } catch (e, st) {
      if (e is AppException) {
        showAlert(context: getContext, message: e.message);
      } else {
        debugPrint('Adding card method error $e $st');
        showAlert(
            context: getContext,
            message: 'Unable to save card please try again later');
      }
    } finally {
      addCardLoading.value = false;
      hidAddCard();
      getUserCards(context);
    }
  }

  Future<void> confirmPayment(
    BuildContext context,
    PaymentRequestModel paymentRequestModel,
    CustomerCard custCard,
    ItemDetailModel itemDetail,
    String chatId,
  ) async {
    try {
      loadingPaymentAPI.value = true;
      debugPrint('amount ${paymentRequestModel.totalPayment}');
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(url: 'get-payment-intent', parameter: {
          'customer_id': custCard.customerId,
          'amount': paymentRequestModel.totalPayment,
        }),
      );

      debugPrint('intent respone ${response}');
      final intent = json.decode(response);

      // final authController = Get.find<AuthController>();
      debugPrint(
          'intent secret ${intent['dataset']['intent']['client_secret']}');

      final responseI = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: intent['dataset']['intent']['client_secret'],
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
              paymentMethodId: intent['dataset']['pm_id']),
        ),
      );
      debugPrint(
        'confirmPayment intent response ${responseI.status} ${responseI.confirmationMethod}',
      );
      debugPrint('payment being successful with the following id');
      debugPrint(responseI.status.toString());
      debugPrint(responseI.paymentMethodId);
      debugPrint(responseI.id);

      if (responseI.status == PaymentIntentsStatus.Succeeded) {
        debugPrint('Payment successful');

        paymentRequestModel.paymentId = responseI.id;
        // await Get.find<ChatController>()
        //     .createChatInFirebase(itemDetailModel: itemDetail);
        savePaymentDetail(paymentRequestModel, chatId, itemDetail);
      }
    } catch (e, st) {
      Future.delayed(const Duration(milliseconds: 200), () {
        showAlert(context: context, message: 'Error');
      });
      debugPrint('confirmPaymentError $e $st');
      loadingPaymentAPI.value = false;
      // debugPrint('${e.}')
    } finally {}

    // getLocationInfoAtSignUp();
  }

  Future<int> confirmPaymentForCheckr(
    BuildContext context,
    CustomerCard custCard,
  ) async {
    try {
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.POST,
            url: 'get-payment-intent',
            parameter: {
              'customer_id': custCard.customerId,
              'amount': chekrFee,
            }),
      );

      debugPrint('intent respone ${response}');
      final intent = json.decode(response);

      // final authController = Get.find<AuthController>();
      debugPrint(
          'intent secret ${intent['dataset']['intent']['client_secret']}');

      final responseI = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: intent['dataset']['intent']['client_secret'],
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
              paymentMethodId: intent['dataset']['pm_id']),
        ),
      );
      debugPrint(
          'confirmPayment intent response ${responseI.status} ${responseI.confirmationMethod}');
      debugPrint('payment being successful with the following id');
      debugPrint(responseI.status.toString());
      debugPrint(responseI.paymentMethodId);
      debugPrint(responseI.id);

      if (responseI.status == PaymentIntentsStatus.Succeeded) {
        debugPrint('Payment successful');
        return 200;
      }
      return 400;
    } catch (e, st) {
      debugPrint('confirmPaymentError $e $st');
      return 400;

// debugPrint('${e.}')
    } finally {}
  }

  //TODO change the success dialog with barrier dismissible

  Future<void> savePaymentDetail(
    PaymentRequestModel paymentRequestModel,
    String chatId,
      ItemDetailModel itemDetailModel,
  ) async {
    try {
      loadingPaymentAPI.value = true;
      final params = paymentRequestModel.toJson();
      params['room_id'] = chatId;
      debugPrint('params for rent item ${params}');
      String response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.itemServiceRent,
          parameter: params,
        ),
      );

      debugPrint('savePaymentDetail $response');
      Future.delayed(const Duration(milliseconds: 200), () {
        showCustomAlert(
          context: getContext,
          status: json.decode(response)["data"]["payment_status"],
          onRightAction: () {
            Get.until((route) => route.isFirst);
          },
        );
      });
      Get.find<ChatController>().updateChatStatus(itemDetailModel: itemDetailModel, docId: chatId);
    } catch (e, st) {
      rethrow;
    } finally {
      loadingPaymentAPI.value = false;
    }
  }

  Future<String> createStripeAccount() async {
    final response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.createStripeAccount,
          parameter: {},
        ),
      );
    return response;
  }

  Future<String> getConnectedStripeAccountUrl() async {
    try {
      final String response = await ApiMiddleware.callService(
          context: getContext,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.POST,
            url: 'get-stripe-connected-account-url',
          ));
      return response;
    } catch (e, st) {
      debugPrint('get stripe account url error $e $st');
      return '';
    }
  }

  Future<String> getConnectedStripeAccount() async {
    try {
      final String response = await ApiMiddleware.callService(
          context: getContext,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.POST,
            url: 'get-stripe-connected-account',
            parameter: {},
          ));
      final data = json.decode(response);
      debugPrint('response ${data['data']}');
      await Get.find<AuthController>().fetchMyProfile(context: getContext);
      return data['account'];
    } catch (e, st) {
      debugPrint('connect stripe error $e $st');
      return '';
    }
  }

  Future<bool> requestConnectStripeAccount(
      String token, BuildContext context) async {
    try {
      final String response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.POST,
            url: 'save-stripe-connected-account',
            //  url: 'get-stripe-connected-account',
            parameter: {'code': token},
          ));
      final data = json.decode(response);
      
      final userData = UserInfoModel.fromJson(data['data']);

      // await SocialLoginService.registerUsingEmailPassword(
      //     userInfoModel: _userInfoModel);

      await Get.find<AuthController>().fetchMyProfile(context: getContext);
      return true;
    } catch (e, st) {
      debugPrint('connect stripe error $e $st');
      return false;
    }
  }

  Future<void> deleteStripeAccount (String account) async {
    try {
      final response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.deleteStripeAccount,
          parameter: {'acc': account},
          ),
      );

      log('delete stripe account $response');
      loadingAccountBalance.value = false;
      final data = json.decode(response);
      accountBalance.value = double.tryParse(data['dataset']['available']) !/ 100.0;
    } catch (e, st) {
      debugPrint('getAccountBalance error $e $st');
    }
  }

  void setStripePageLoading(bool value) {
    stripePageLoading.value = value;
  }

  Future<void> setOtherAmount(bool value) async {
    Future.delayed(Duration.zero);
    otherAmount.value = value;
    update();
  }

  Future<void> getAccountBalance() async {
    try {
      loadingAccountBalance.value = true;
      final response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.getAccountBalance,
          parameter: {},
        ),
      );

      log('getAccountBalance $response');
      loadingAccountBalance.value = false;
      final data = json.decode(response);
      accountBalance.value = double.tryParse(data['dataset']['available']) !/ 100.0;
    } catch (e, st) {
      debugPrint('getAccountBalance error $e $st');
    }
  }

  Future<void> withdrawAmount(String amount) async {
    try {
      showDialog(context: getContext, builder: (context) => const Loading());
      final response = await ApiMiddleware.callService(
        context: getContext,
        requestInfo: APIRequestInfoObj(
          url: EventEndPoints.withdrawBalance,
          parameter: {
            'amount':
                otherAmount.value ? amount : accountBalance.value.toString(),
          },
        ),
      );
      Get.back();
      final data = json.decode(response);
      showAlert(
          context: getContext, message: data['message'], title: 'Success');

      log('getAccountBalance $response');
    } catch (e, st) {
      if (e is AppException) {
        Get.back();
        showAlert(context: getContext, message: e.message);
        debugPrint('message ${e.message}');
      }
      debugPrint('getAccountBalance error $e $st');
    }
  }
}
