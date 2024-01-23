import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/screen/payment/add_new_card_with_stripe.dart';
import 'package:renting_app_mobile/screen/payment/card_list_tile.dart';
import 'package:renting_app_mobile/widgets/custom_appbar.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';

class PayWithScreen extends StatefulWidget {
  const PayWithScreen({Key? key}) : super(key: key);

  @override
  State<PayWithScreen> createState() => _PayWithScreenState();
}

class _PayWithScreenState extends State<PayWithScreen> {

  final _paymentController = Get.find<PaymentController>();
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Pay With',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.00),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: _paymentController.showAddCard,
              child: CustomText(
                maxLine: 1,
                txtTitle: 'Add new card',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Obx(
              () => _paymentController.addCardVisible.value
                  ? const AddNewCard()
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<PaymentController>(builder: (_ps) {
              return _paymentController.getCardsLoading.value
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _paymentController.customerCards.length,
                      itemBuilder: (context, index) {
                        return CardListTile(
                          customerCard: _paymentController.customerCards[index],
                        );
                      },
                    );
            })
          ]),
        ),
      ),
    );
  }
}
