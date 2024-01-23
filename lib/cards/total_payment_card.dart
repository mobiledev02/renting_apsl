// Widget totalPaymentCard(
//     {required BuildContext context, List<TotalPaymentModel>? totalPayment}) {
//   return TotalPaymentCard();
// }

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils/stripe_fee_calculator.dart';
import '/models/item_detail_model.dart';
import '/widgets/common_functions.dart';
import '/widgets/cust_image.dart';
import '../constants/img_font_color_string.dart';
import '../models/total_payment_detail_model.dart';
import '../utils/custom_enum.dart';
import '../utils/custom_extension.dart';
import '../widgets/custom_text.dart';

class TotalPaymentCard extends StatelessWidget {
  final ItemDetailModel? itemDetailModel;
  final Function(String) valueSetter;

  TotalPaymentCard({
    Key? key,
    this.itemDetailModel,
    required this.valueSetter,
  }) : super(key: key) {
    calculatePrice();
  }

  final ValueNotifier _valueNotifier = ValueNotifier(true);

  List<TotalPaymentDetailModel> paymentFields = [];

  void calculatePrice() {
    // print(itemDetailModel?.toJson());

    switch (itemDetailModel?.category?.type ?? ItemOrService.service) {
      case ItemOrService.item:
        if (itemDetailModel?.getEnumForDayAndHourly == ServiceType.Hourly) {
          paymentFields = [
            TotalPaymentDetailModel(
              title: (hoursBetween(
                            itemDetailModel: itemDetailModel,
                          ) /
                          60)
                      .toString() +
                  StaticString.hoursPrice,
              price: ((hoursBetween(itemDetailModel: itemDetailModel) / 60) *
                      double.parse(itemDetailModel?.ratePerHour ?? "0.0"))
                  .toString(),
            ),
            TotalPaymentDetailModel(
              title: StaticString.safetyDeposite,
              price: itemDetailModel?.safetyDeposit ?? "0.0",
              isChild: true,
            ),
            TotalPaymentDetailModel(
              title: StaticString.serviceFee,
              price: getServiceFeeTotal(
                      ((hoursBetween(itemDetailModel: itemDetailModel) / 60) *
                              double.parse(
                                itemDetailModel?.ratePerHour ?? "0.0",
                              )) +
                          double.parse(
                            itemDetailModel?.safetyDeposit ?? "0.0",
                          ))
                  .toString(),
              color: Colors.black,
              isChild: true,
            ),
            TotalPaymentDetailModel(
              title: StaticString.totalPayment,
              price: (((hoursBetween(itemDetailModel: itemDetailModel) / 60) *
                          double.parse(
                            itemDetailModel?.ratePerHour ?? "0.0",
                          )) +
                      double.parse(
                        itemDetailModel?.safetyDeposit ?? "0.0",
                      ) +
                      getServiceFeeTotal(
                          ((hoursBetween(itemDetailModel: itemDetailModel) /
                                      60) *
                                  double.parse(
                                    itemDetailModel?.ratePerHour ?? "0.0",
                                  )) +
                              double.parse(
                                itemDetailModel?.safetyDeposit ?? "0.0",
                              )))
                  .toString(),
            )
          ];
        } else if (itemDetailModel?.getEnumForDayAndHourly == ServiceType.Day) {
          // print(itemDetailModel?.toJson());
          paymentFields = [
            TotalPaymentDetailModel(
              title: hoursBetweenItem(
                    from: itemDetailModel!.startDate!,
                    to: itemDetailModel!.endDate!,
                  ).toStringAsFixed(2) +
                  StaticString.daysPrice,
              price: (hoursBetweenItem(
                        from: itemDetailModel!.startDate!,
                        to: itemDetailModel!.endDate!,
                      ) *
                      (itemDetailModel != null
                          ? (double.parse(itemDetailModel!.ratePerDay) / 24)
                          : 0))
                  .toStringAsFixed(2),
              color: Colors.black,
            ),
            TotalPaymentDetailModel(
              title: StaticString.safetyDeposite,
              price: itemDetailModel?.safetyDeposit ?? "0.0",
              color: Colors.black,
              isChild: true,
            ),
            TotalPaymentDetailModel(
              title: StaticString.serviceFee,
              price: getServiceFeeTotal(
                (hoursBetweenItem(
                          from: itemDetailModel!.startDate!,
                          to: itemDetailModel!.endDate!,
                        ) *
                        (itemDetailModel != null
                            ? (double.parse(itemDetailModel!.ratePerDay) / 24)
                            : 0)) +
                    double.parse(
                      itemDetailModel?.safetyDeposit ?? '0.0',
                    ),
              ).toString(),
              color: Colors.black,
              isChild: true,
            ),
            TotalPaymentDetailModel(
              title: StaticString.totalPayment,
              price: (((hoursBetweenItem(
                                from: itemDetailModel!.startDate!,
                                to: itemDetailModel!.endDate!,
                              ) *
                              (itemDetailModel != null
                                  ? (double.parse(itemDetailModel!.ratePerDay) /
                                      24)
                                  : 0)) +
                          double.parse(
                            itemDetailModel?.safetyDeposit ?? "0.0",
                          )) +
                      getServiceFeeTotal((hoursBetweenItem(
                                from: itemDetailModel!.startDate!,
                                to: itemDetailModel!.endDate!,
                              ) *
                              (itemDetailModel != null
                                  ? (double.parse(itemDetailModel!.ratePerDay) /
                                      24)
                                  : 0)) +
                          double.parse(
                            itemDetailModel?.safetyDeposit ?? '0.0',
                          )))
                  .toString(),
            )
          ];
        }

        break;
      case ItemOrService.service:
        if (itemDetailModel?.getEnumForDayAndHourly == ServiceType.Hourly) {
          paymentFields = [
            TotalPaymentDetailModel(
              // " 00 Hours Price "
              title: (hoursBetween(
                            itemDetailModel: itemDetailModel,
                          ) /
                          60)
                      .toStringAsFixed(1) +
                  StaticString.hoursPrice,
              // "(Per Day Price * Selected Days)"

              price: ((hoursBetween(itemDetailModel: itemDetailModel) / 60) *
                      double.parse(itemDetailModel?.ratePerHour ?? "0.0"))
                  .toString(),
            ),
            TotalPaymentDetailModel(
              title: StaticString.serviceFee,
              price: getServiceFeeTotal(
                      (hoursBetween(itemDetailModel: itemDetailModel) / 60) *
                          double.parse(itemDetailModel?.ratePerHour ?? "0.0"))
                  .toString(),
              color: Colors.black,
              isChild: true,
            ),
            TotalPaymentDetailModel(
                title: StaticString.totalPayment,
                price: (((hoursBetween(itemDetailModel: itemDetailModel) / 60) *
                            double.parse(
                                itemDetailModel?.ratePerHour ?? "0.0")) +
                        getServiceFeeTotal(
                            (hoursBetween(itemDetailModel: itemDetailModel) /
                                    60) *
                                double.parse(
                                    itemDetailModel?.ratePerHour ?? "0.0")))
                    .toString()),
          ];
        } else if (itemDetailModel?.getEnumForDayAndHourly == ServiceType.Day) {
          paymentFields = [
            TotalPaymentDetailModel(
                title: daysBetween(
                      from: itemDetailModel!.startDate!,
                      to: itemDetailModel!.endDate!,
                    ).toString() +
                    StaticString.daysPrice,
                price: (daysBetween(
                          from: itemDetailModel!.startDate!,
                          to: itemDetailModel!.endDate!,
                        ) *
                        double.parse(itemDetailModel?.ratePerDay ?? "0"))
                    .toString()),
            TotalPaymentDetailModel(
              title: StaticString.serviceFee,
              price: getServiceFeeTotal(daysBetween(
                        from: itemDetailModel!.startDate!,
                        to: itemDetailModel!.endDate!,
                      ) *
                      double.parse(itemDetailModel?.ratePerDay ?? "0"))
                  .toString(),
              color: Colors.black,
              isChild: true,
            ),
            TotalPaymentDetailModel(
              title: StaticString.totalPayment,
              price: ((daysBetween(
                            from: itemDetailModel!.startDate!,
                            to: itemDetailModel!.endDate!,
                          ) *
                          double.parse(itemDetailModel?.ratePerDay ?? "0")) +
                      getServiceFeeTotal(daysBetween(
                            from: itemDetailModel!.startDate!,
                            to: itemDetailModel!.endDate!,
                          ) *
                          double.parse(itemDetailModel?.ratePerDay ?? "0")))
                  .toString(),
            )
          ];
        }

        break;
    }

    valueSetter(paymentFields[paymentFields.length - 1].price);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (context, val, child) {
          return
              // Container(
              //   padding: const EdgeInsets.only(
              //     left: 20.00,
              //     right: 20.00,
              //     top: 20.00,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     boxShadow: const [
              //       BoxShadow(
              //         color: Color.fromRGBO(0, 0, 0, 0.04),
              //         blurRadius: 20.0,
              //       ),
              //     ],
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child:
              Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Detail And Price title
              commonTitlerSubtitleAndPrice(
                context: context,
                title: StaticString.details,
                titleSize: 16,
                price: StaticString.price,
                priceSize: 16,
                priceColor: primaryColor,
              ),
              const SizedBox(
                height: 10.00,
              ),
              if (paymentFields.isNotEmpty)
                ...paymentFields.map((paymentDetailModel) {
                  // _totalPayment = _totalPayment + double.parse(e.price);
                  // setState(() {});
                  return commonTitlerSubtitleAndPrice(
                    context: context,
                    title: paymentDetailModel.title,
                    titleColor:
                        paymentDetailModel.title == StaticString.totalPayment
                            ? custBlack102339
                            : custBlack102339.withOpacity(0.5),
                    price:
                        "\$${double.parse(paymentDetailModel.price).toStringAsFixed(2).priceFormater}",
                    subtitle: paymentDetailModel.subtitle,
                    subTitleColor: custBlack102339.withOpacity(0.5),
                    isChild: paymentDetailModel.isChild,
                    priceColor:
                        paymentDetailModel.title == StaticString.totalPayment
                            ? custMaterialPrimaryColor
                            : paymentDetailModel.title == 'Safety Deposit' ||
                                    paymentDetailModel.title == 'Service Fee'
                                ? Colors.black
                                : primaryColor,
                  );
                }),

              // const SizedBox(
              //   height: 10.00,
              // ),

              // /// totle Price
              // commonTitlerSubtitleAndPrice(
              //   context: context,
              //   title: StaticString.totalPayment,
              //   price: "\$${paymentFields[1].price}",
              //   // price: "$",
              //   priceColor: primaryColor,
              // ),
            ],
            // ),
          );
        });
  }
}

/// common title , Subtitle And  Price
Widget commonTitlerSubtitleAndPrice({
  required BuildContext context,
  double titleSize = 14,
  Color titleColor = custBlack102339,
  double subTitleSize = 12,
  Color subTitleColor = custBlack102339,
  double priceSize = 18,
  Color priceColor = custBlack102339,
  required String title,
  required String price,
  String? subtitle,
  bool isChild = false,
}) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /// Title
                    CustomText(
                      txtTitle: title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    if (isChild)
                      const SizedBox(
                        width: 4,
                      ),

                    /// icon
                    if (isChild) _buildsafetyDepositeToolTip(title),
                  ],
                ),
                if (subtitle?.isNotEmpty ?? false)
                  const SizedBox(
                    height: 10,
                  ),
                if (subtitle?.isNotEmpty ?? false)

                  /// Subtitle
                  CustomText(
                    txtTitle: subtitle,
                    maxLine: 2,
                    style: TextStyle(
                      fontSize: subTitleSize,
                      fontWeight: FontWeight.w600,
                      color: subTitleColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.00,
          ),

          /// price
          CustomText(
            txtTitle: price,
            style: TextStyle(
              fontSize: priceSize,
              fontWeight: FontWeight.w600,
              color: priceColor,
            ),
          ),
        ],
      ),
      SizedBox(
        height: title == StaticString.totalPayment ? 10 : 20,
      )
    ],
  );
}

/// Safety Deposite Tooltip
Widget _buildsafetyDepositeToolTip(String title) {
  return Tooltip(
    triggerMode: TooltipTriggerMode.tap,
    message: title == StaticString.serviceFee
        ? StaticString.serviceFeeTooltip
        : StaticString.info,
    decoration: BoxDecoration(
      color: custBlack102339,
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 57),
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 17.00,
    ),
    textStyle: const TextStyle(
      fontSize: 10,
      color: custWhiteFFFFFF,
      fontWeight: FontWeight.w700,
    ),
    child: CustImage(
      imgURL: ImgName.infoIcon,
      height: 14,
      width: 14,
    ),
  );
}
