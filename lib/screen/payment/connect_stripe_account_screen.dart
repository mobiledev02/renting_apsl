import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import 'package:renting_app_mobile/widgets/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConnectStripeAccountScreen extends GetView<PaymentController> {

  final String url;
  final String accountId;

  const ConnectStripeAccountScreen({
    this.url = "",
    this.accountId = "",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Create/Manage Stripe Account',
        backFunction: () {
          showDialog(
                    context: context,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()));
          Get.back();
          Get.back();
          controller.deleteStripeAccount(
                    accountId);
          return NavigationDecision.prevent;
            //change to message ?
        }
      ),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: Uri.encodeFull(url),
            navigationDelegate: (NavigationRequest request) async {
              debugPrint('WebView handling following url: $request');
              if (request.url
                  .contains('staging.rentingandlending.com/connected')) { // check stripe connected
                showDialog(
                    context: context,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()));
                var res = await controller.requestConnectStripeAccount(
                    accountId, context);
                Get.back();
                Get.back();
                if (res) {
                  Get.showSnackbar(const GetSnackBar(
                    message: "Your account has been created successfully.",
                    duration: Duration(seconds: 2),
                    animationDuration: Duration(seconds: 3),
                  ));
                } else {
                  Get.showSnackbar(const GetSnackBar(
                    message: "Error connecting account, please retry later.",
                    duration: Duration(seconds: 2),
                    animationDuration: Duration(seconds: 3),
                  ));
                  // delete account
                  var res = await controller.deleteStripeAccount(
                    accountId);
                }
              }
              return NavigationDecision.navigate;
            },
            onPageFinished: (url) {
              controller.setStripePageLoading(false);
            },
          ),
          Obx(() => controller.stripePageLoading.value
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox(),)
        ],
      ),
    );
  }
}
