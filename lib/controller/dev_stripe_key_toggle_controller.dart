import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';


class StripeKeyController extends GetxController {
  RxBool isTestMode = true.obs;

  Future<void> toggleKeys() async {
    final url = 'https://re-lend.com/api/toggle-stripe-keys';
    final keyType = isTestMode.value ? 'live' : 'test';

    final response = await http.post(
      Uri.parse(url),
      body: {'key_type': keyType},
    );

    if (keyType == 'live') {
      Stripe.publishableKey =
      'pk_live_51M34hGLqByjofhET7oCYFR3EzHEyvsVflh3m3TSF8OMAEOlFldQnupK0agP1dHxmKrqp3bYAFJyfvJ6zOgJGZx7q00u1WfH8Xh';
    } else {
      Stripe.publishableKey =
      'pk_test_51M34hGLqByjofhET7NPBUgH8HlWgAPM7CtRJ8IdVP8DpEk6VEXurzcEvUR5q8GtYmkYZnv4iqBxxuRynw18WY9Hn00atrABnQk';
    }

    if (response.statusCode == 200) {
      isTestMode.toggle(); // Toggle the mode using GetX's toggle method
    } else {
      // Handle error
      print('Failed to toggle Stripe keys');
    }
  }
}
