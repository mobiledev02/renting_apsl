import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:get/get.dart';

import 'package:renting_app_mobile/models/payment_request_model.dart';

import '../../controller/total_payment_controller.dart';

class BrainTreePayment {
  static String tokenizationKey = 'sandbox_pgmjbbzm_c7nsn2pbwcf5d2gy';

  // 1c74a2f97fed1a4433ef533e69b1ddf417be5565
  Future<BraintreeDropInResult?> initializePayment(
    PaymentRequestModel paymentRequestModel,
  ) async {
    try {
      // payPal();
      BraintreeDropInResult? result =
          await braintreeDropInRequest(paymentRequestModel);

      return result;
      // creditCardPayment();
      // payPalCheckout();
    } catch (e) {
      rethrow;
    }
  }

  void payPal() async {
    final request = BraintreePayPalRequest(
      amount: null,
      billingAgreementDescription:
          'I hereby agree that flutter_braintree is great.',
      displayName: 'Your Company',
    );
    final result = await Braintree.requestPaypalNonce(
      tokenizationKey,
      request,
    );
    if (result != null) {
      print(result);
    }
  }

  Future<BraintreeDropInResult?> braintreeDropInRequest(
    PaymentRequestModel paymentRequestModel,
  ) async {
    try {
      BraintreeDropInRequest request = BraintreeDropInRequest(
        tokenizationKey: tokenizationKey,
        collectDeviceData: true,
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice: paymentRequestModel.totalPayment,
          currencyCode: 'USD',
          billingAddressRequired: false,
        ),
        paypalRequest: BraintreePayPalRequest(
          amount: paymentRequestModel.totalPayment,
          displayName: 'Example company',
        ),
        cardEnabled: true,
      );
      BraintreeDropInResult? result = await BraintreeDropIn.start(request);

      paymentRequestModel.deviceData = result?.deviceData ?? "";
      paymentRequestModel.paymentMethod =
          result?.paymentMethodNonce.typeLabel ?? "";
      paymentRequestModel.nonce = result?.paymentMethodNonce.nonce ?? "";

      if (paymentRequestModel.nonce.isEmpty) {
        return null;
      }

      await Get.find<TotalPaymentController>().doPayment(paymentRequestModel);

      // await
      debugPrint(
        "**************************************** Confirm And Pay ${paymentRequestModel.toJson()}***************************",
      );

      return result;

      // await Get.find<TotalPaymentController>().doPayment(paymentRequestModel);
    } catch (e) {
      rethrow;
    }
  }

  void creditCardPayment() async {
    BraintreeCreditCardRequest request = BraintreeCreditCardRequest(
      cardNumber: '4111111111111111',
      expirationMonth: '12',
      expirationYear: '2021',
      cvv: '123',
    );
    final result = await Braintree.tokenizeCreditCard(
      tokenizationKey,
      request,
    );
  }

  void payPalCheckout() async {
    final request = BraintreePayPalRequest(amount: '13.37');
    final result = await Braintree.requestPaypalNonce(
      tokenizationKey,
      request,
    );
  }
}
