import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/models/payment_history_model.dart';
import 'package:renting_app_mobile/screen/history/history_detail_screen.dart';
import 'package:renting_app_mobile/screen/history/lending_history_detail_screen.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import '../constants/img_font_color_string.dart';
import 'cust_image.dart';
import 'custom_text.dart';

class PaymentTransactionCard extends StatelessWidget {
  final PaymentHistoryModel paymentHistoryModel;

  const PaymentTransactionCard({required this.paymentHistoryModel});

  @override
  Widget build(BuildContext context) {
      final _authController = Get.find<AuthController>();
      final _itemController = Get.find<ItemController>();
    return InkWell(
      onTap: () {
        
        if(paymentHistoryModel.type == 'item') {
          _itemController.getRentedItemDetails(
              context, paymentHistoryModel.id.toString());
        }
        else {
          _itemController.getRentedServiceDetails(
              context, paymentHistoryModel.id.toString());
        }
        if (
        //
        // _itemController.rentedItemService.value?.lenderId.toString() ==
        //     _authController.getUserInfo.id
         paymentHistoryModel.amount.contains("+")
        ) {
          Get.to(() => const LendingHistoryDetailScreen());
          // do nothing
        } else {
          Get.to(() => const HistoryDetailScreen());
        }
      },
      child: Container(
        height: (paymentHistoryModel.amount.contains('+') || paymentHistoryModel.type != 'item') ? 76 : 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        padding: const EdgeInsets.only(
          left: 17,
          right: 24,
          top: 15,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(16, 35, 57, 0.04),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustImage(
              imgURL: paymentHistoryModel.image,
              cornerRadius: 100,
              height: 30,
              width: 30,
              imgColor: paymentHistoryModel.color.hexToColor,
              errorImage: ImgName.defaultAvatar,
              boxfit: BoxFit.contain,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        txtTitle: paymentHistoryModel.name,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                  ],
                ),
                const SizedBox(
                      height: 3,
                      width: 25,
                    ),
                CustomText(
                  txtTitle: paymentHistoryModel.getDate,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: custBlack102339.withOpacity(0.5),
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  child: 
                  CustomText(
                    txtTitle: "Security Deposit: \$${paymentHistoryModel.safetyDeposit}",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: custFFA523.withOpacity(0.5),
                        ),
                  ),
                  visible: !paymentHistoryModel.amount.contains('+') && paymentHistoryModel.type == 'item',
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: CustomText(
                txtTitle:

                paymentHistoryModel.amount.contains('+') ? '+ \$${paymentHistoryModel.lenderAmount}':
                paymentHistoryModel.amount,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                              color: paymentHistoryModel.amount.contains('+') ? Colors.green : Colors.red)
              ),
            ),
          ],
        ),
      ),
    );
  } 
}
