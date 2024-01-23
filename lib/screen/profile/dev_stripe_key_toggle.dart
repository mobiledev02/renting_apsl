import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/dev_stripe_key_toggle_controller.dart';

class StripeToggleKeys extends GetView<StripeKeyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await controller.toggleKeys(); // Call the toggleKeys from the controller
              },
              child: const Text('Toggle Stripe Keys'),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
                  controller.isTestMode.value ? 'Test Mode' : 'Live Mode',
                  style: const TextStyle(fontSize: 18),
                ),),
          ],
        ),
      ),
    );
  }
}
