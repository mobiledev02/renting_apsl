// ignore_for_file: must_be_immutable

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/total_payment_controller.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';
import 'dart:convert';

import '../../constants/img_font_color_string.dart';
import '../../models/payment_history_model.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/payment_transaction_card.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/screen/payment/connect_stripe_account_screen.dart';
import 'package:renting_app_mobile/widgets/cust_flat_button.dart';
import '../../controller/auth_controller.dart';

class PaymentHistoryScreen extends GetView<TotalPaymentController> {
  PaymentHistoryScreen({Key? key}) {
    controller.fetchPaymentHistory();
  }

  //!--------------------------------------- variable ----------------------------------------------
  List<String> statusList = ["Done", "a"];

  final List<String> _sortList = ["Recent", "Done", "Pending", "Failed"];
  final List<String> _filterList = ["All", "Paid", "Earned"];

  String profitdropdownvalue = "Recent";
  String filterdropdownvalue = "All";

  ValueNotifier _valueNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.paymentScreen,
        isBackButton: false,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: _valueNotifier,
            builder: (context, val, child) {
              return Obx(() {

                List<PaymentHistoryModel> ProfitList =
                    List<PaymentHistoryModel>.from(
                  controller.getListOfTotalPaymeny,
                );
                if (profitdropdownvalue.toLowerCase() != "recent") {
                  ProfitList = ProfitList
                      .where(
                        (transaction) =>
                            transaction.status.toLowerCase() ==
                            profitdropdownvalue.toLowerCase(),
                      )
                      .toList();
                } else {
                  ProfitList.sort((a, b){ //sorting in ascending order
                      return (DateTime.parse(b.date)).compareTo(DateTime.parse(a.date));
                  });
                }

                if (filterdropdownvalue == _filterList[2]) {
                  // Filter list for money paid
                  ProfitList = ProfitList
                      .where(
                        (transaction) =>
                            transaction.amount.contains('+'),
                      )
                      .toList();
                } else if (filterdropdownvalue == _filterList[1]) {
                  // Filter list for earning
                  ProfitList = ProfitList
                      .where(
                        (transaction) =>
                            !transaction.amount.contains('+'),
                      )
                      .toList();
                }     

                return controller.loadingPaymentHistoryAPI.value
                    ? Spinner()
                    : Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 20,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: custBlack102339.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: 
                          [
                            CustomText(
                                txtTitle:
                                    "${StaticString.balance} \$${Get.find<PaymentController>().accountBalance.value}\n", // Balance
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: custBlack102339,
                                ),
                            ),
                            Visibility(
                              visible: Get.find<AuthController>().getUserInfo.stripeConnected,
                              child: SizedBox(
                                  height: 30,
                                  width: 162,
                                  child: CustomFlatButton(
                                    buttonColor: Colors.white,
                                    onPressed: () async {
                                      var accLinkRes = await Get.find<PaymentController>().getConnectedStripeAccountUrl();
                                      String url = json.decode(accLinkRes)["data"]["url"];
                                      debugPrint(url);
                                      String account = await Get.find<PaymentController>().getConnectedStripeAccount();
                                      Get.find<PaymentController>().setStripePageLoading(true);
                                      Get.to(() => ConnectStripeAccountScreen(url: url, accountId: account));
                                    },
                                    child: const CustomText(
                                      txtTitle: StaticString.manageStripeAccount,
                                      style: TextStyle(color: primaryColor, fontSize: 12),
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 8,
                              width: 4,
                            ),
                            _buildTransactionLabel(context),
                            const SizedBox(
                              height: 8,
                            ),
                            _buildFilterAndSortBy(context),
                            const SizedBox(
                              height: 13,
                            ),
                              /// Payment List Empty
                            ProfitList.isEmpty
                                ? _buildEmptyPayment(context)
                                : Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        await controller.fetchPaymentHistory(
                                          forRefresh: true,
                                        );
                                      },
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 7,
                                        ),
                                        // shrinkWrap: true,
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemCount: ProfitList.length,
                                        /// Transaction Card
                                        itemBuilder: (_, index) =>
                                            PaymentTransactionCard(
                                          paymentHistoryModel:
                                              ProfitList[index],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      );
              });
            }),
      ),
    );
  }

//!----------------------------------------- Widget ----------------------------------
  /// Payment List Empty
  Widget _buildEmptyPayment(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            const SizedBox(
              height: 327,
            ),

            /// Image
            CustImage(
              imgURL: ImgName.noPaymentBg,
              height: 266,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Column(
                children: [
                  Center(
                    /// No Transaction
                    child: CustomText(
                      txtTitle: StaticString.noTransactions,
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  /// we Don't see any records......
                  CustomText(
                    align: TextAlign.center,
                    txtTitle: StaticString.wtDontSee,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        height: 1.5, color: custBlack102339.withOpacity(0.4)),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          CustomText(
            txtTitle: StaticString.transactions, // Transactions
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }


  /// Transaction And Sort
  Widget _buildFilterAndSortBy(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          CustomText(
            txtTitle: StaticString.filterby,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custBlack102339.withOpacity(0.3),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            height: 14,
            width: 55,
            child: DropdownButton<String>(
              // menuMaxHeight: 300,
              value: filterdropdownvalue,
              // borderRadius: BorderRadius.circular(10),
              isExpanded: true,
              underline: const SizedBox(),
              icon: CustImage(
                imgURL: ImgName.dropDownIcon,
                imgColor: primaryColor,
              ),
              style: const TextStyle(
                fontSize: 50,
              ),
              items: _filterList.map((String items) {
                return DropdownMenuItem(
                  enabled: true,
                  value: items,
                  child: CustomText(
                    txtTitle: items,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: filterdropdownvalue == items
                              ? primaryColor
                              : custBlack102339,
                        ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                _filter(value ?? "");
              },
            ),
          ),
          const SizedBox(
            width: 60,
          ),
          CustomText(
            txtTitle: StaticString.sortby,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custBlack102339.withOpacity(0.3),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            height: 14,
            width: 70,
            child: DropdownButton<String>(
              // menuMaxHeight: 300,
              value: profitdropdownvalue,
              // borderRadius: BorderRadius.circular(10),
              isExpanded: true,
              underline: const SizedBox(),
              icon: CustImage(
                imgURL: ImgName.dropDownIcon,
                imgColor: primaryColor,
              ),
              style: const TextStyle(
                fontSize: 50,
              ),
              items: _sortList.map((String items) {
                return DropdownMenuItem(
                  enabled: true,
                  value: items,
                  child: CustomText(
                    txtTitle: items,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: profitdropdownvalue == items
                              ? primaryColor
                              : custBlack102339,
                        ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                _sort(value ?? "");
              },
            ),
          ),
        ],
      ),
    );
  }

  //!------------------------------------------------------ Button Action -----------------------------------------
  void _sort(String sortType) {
    debugPrint(
        "**************************************** Sort $sortType ************************************");

    profitdropdownvalue = sortType;

    _valueNotifier.notifyListeners();
  }

  void _filter(String filterType) {
    debugPrint(
        "**************************************** Sort $filterType ************************************");

    filterdropdownvalue = filterType;

    _valueNotifier.notifyListeners();
  }
}
