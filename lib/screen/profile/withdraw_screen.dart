import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';
import 'package:renting_app_mobile/widgets/cust_button.dart';
import 'package:renting_app_mobile/widgets/custom_appbar.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';
import 'package:renting_app_mobile/widgets/keyboard_with_done_button.dart';

import '../../controller/payment_controller.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _otherAmountController = TextEditingController();

  final FocusNode _otherAmountFocusNode = FocusNode();

  final _paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Withdraw'),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: KeyboardWithDoneButton(
          focusNodeList: [
            _otherAmountFocusNode,
          ],
          onDoneClicked: () {
            final FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              FocusScope.of(context).nextFocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CustomText(
                  txtTitle: 'Select an option',
                  style: TextStyle(color: custGrey7E7E7E),
                  align: TextAlign.left,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: GestureDetector(
                    onTap: () {
                      _paymentController.setOtherAmount(false);
                    },
                    child: Row(
                      children: [
                        Obx(
                          () {
                            return Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                  color: _paymentController.otherAmount.value
                                      ? custBlack102339WithOpacity
                                      : primaryColor,
                                  shape: BoxShape.circle),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          txtTitle:
                              '${_paymentController.accountBalance.value ?? 'error'} USD',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: GestureDetector(
                    onTap: () async {
                      await _paymentController.setOtherAmount(true);
                      await Future.delayed(const Duration(milliseconds: 200));
                      _otherAmountFocusNode.requestFocus();
                    },
                    child: Row(
                      children: [
                        Obx(
                          () {
                            return Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                  color: _paymentController.otherAmount.value
                                      ? primaryColor
                                      : custBlack102339WithOpacity,
                                  shape: BoxShape.circle),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const CustomText(
                          txtTitle: 'Other',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    return TextFormField(
                      enabled: _paymentController.otherAmount.value,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [AmountInputFormatter()],
                      onSaved: (amount) {

                      },
                      controller: _otherAmountController,
                      focusNode: _otherAmountFocusNode,
                      decoration: const InputDecoration(
                        hintText: '0.00',
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      onPressed: _witdraAmount,
                      child: const Text('Withdraw'),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _witdraAmount() {

      _paymentController.withdrawAmount(_otherAmountController.text);
  }
}


class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text.replaceAll(RegExp('[^\\d]'), '');

    if (formattedText.isNotEmpty) {
      double amount = double.parse(formattedText) / 100;
      formattedText = amount.toStringAsFixed(2);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}







