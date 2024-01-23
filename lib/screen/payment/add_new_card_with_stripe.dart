import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/theme/palette.dart';
import 'package:renting_app_mobile/widgets/cust_button.dart';
import 'package:renting_app_mobile/widgets/cust_flat_button.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';

import '../../widgets/common_widgets.dart';

class AddNewCard extends GetView<PaymentController> {
  const AddNewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20,),
        rentedText(
          context: context,
          rentedText:
          'You will be charged 50 cents this minimal charge is required to check the validity of your card',
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: CardField(
            onCardChanged: (card) {
              controller.setCardFieldDetails(card);
              debugPrint(card?.number);
              debugPrint(card.toString());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomFlatButton(
                buttonColor: Colors.white,
                borderSide: const BorderSide(color: Palette.primary),
                onPressed: controller.hidAddCard,
                child: const Text('Cancel'),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Obx(() => CustomFlatButton(
                      loadingIndicator: controller.addCardLoading.value,
                      onPressed: () async {
                        await controller.addPaymentMethod(context);
                        controller.update();
                      },
                      buttonTitle: 'Add Card',
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
