import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/models/payment_request_model.dart';
import 'package:renting_app_mobile/screen/payment/pay_with_screen.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';
import '../../controller/total_payment_controller.dart';
import '../../main.dart';
import '/controller/auth_controller.dart';
import '/widgets/common_widgets.dart';
import '/widgets/expand_child.dart';
import '/constants/img_font_color_string.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_row_image.dart';
import '../../cards/total_payment_card.dart';
import '../../models/item_detail_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_indicator.dart';

class CheckoutScreen extends GetView<AuthController> {
  CheckoutScreen() {
    final paymentController = Get.find<PaymentController>();
    paymentController.getUserCards(getContext);
  }

  //!----------------------------------- Variable ------------------------------------

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();
  bool _isMsgVisible = true;
  String _finalPayment = "";

  final ItemDetailModel itemDetailModel = Get.arguments[0];
  final chatId = Get.arguments[1];
  ValueNotifier _msgNotifier = ValueNotifier(true);

  TotalPaymentController _totalPaymentController =
      Get.find<TotalPaymentController>();

  final _paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          _buildScaffold(context),
          _paymentController.loadingPaymentAPI.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Spinner(),
                )
              : SizedBox(),
        ],
      );
    });
  }

  Scaffold _buildScaffold(BuildContext context) {
    debugPrint(
        'images are here ${itemDetailModel.getFirstImageModel?.imageUrl}');
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.checkout,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.00),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// warning message
                //   _buildWarningMessage(context),
                CustomText(
                  txtTitle:
                      'Coordinate a time and place to get the item from the Lender via Chat before paying.',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
                const SizedBox(
                  height: 30.00,
                ),

                /// Seller name
                _buildLenderName(context),
                const SizedBox(
                  height: 30.00,
                ),

                /// Item Image
                CustomRowImage(
                  image1: itemDetailModel.getFirstImageModel?.imageUrl ?? "",
                  image2: itemDetailModel.getSecondImageModel?.imageUrl ?? "",
                  height: 120.00,
                ),

                const SizedBox(
                  height: 14.00,
                ),

                /// item name and tag
                _buildItemNameAndTag(
                  context: context,
                  smallDescription: itemDetailModel.name,
                ),

                const SizedBox(
                  height: 12,
                ),

                /// item value


                itemOrServicePriceText(
                  context: context,
                  textColor: primaryColor,
                  price:
                  "Per Day: \$${itemDetailModel.ratePerDay}",
                  itemOrServices:
                  itemDetailModel.category?.type.name ??
                      "",
                ),
                // CustomText(
                //   txtTitle:
                //       (itemDetailModel.category?.type.name ?? "") == "item"
                //           ? "\$${itemDetailModel.getPrice}"
                //           : itemDetailModel.getEnumForDayAndHourly ==
                //                   ServiceType.Hourly
                //               ? "\$${itemDetailModel.ratePerHour} "
                //               : "\$${itemDetailModel.ratePerDay}",
                //   // "\$${itemDetailModel.getPrice}",
                //   style: Theme.of(context).textTheme.headline1?.copyWith(
                //       color: primaryColor, fontWeight: FontWeight.w600),
                // ),

                const SizedBox(
                  height: 30,
                ),

                /// Rent Duration ...
                _buildCommonTitlerAndSubtitle(
                    context: context,
                    title: StaticString.rentDuration,
                    subTitle: itemDetailModel.getEnumForDayAndHourly ==
                            ServiceType.Hourly
                        ? itemDetailModel.getStartDate
                        : "${itemDetailModel.getStartDate} to ${itemDetailModel.getEndtDate} " //"Wednesday, May 18 to Monday, May 23",
                    ),

                const SizedBox(
                  height: 30.00,
                ),

                /// Renter Details

                // _buildCommonTitlerAndSubtitle(
                //     context: context,
                //     title: StaticString.renterDetails,
                //     subTitle:
                //         "Austin Distel \n6703 Academy Rd NE, Albuquerque, New York, United States. \n +1-202-555-0124"),

                /// Renter Details
                CustomText(
                  txtTitle: StaticString.renterDetails,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 10.00,
                ),

                /// Renter name
                CustomText(
                  txtTitle: controller.getUserInfo.name,
                  textOverflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: custBlack102339WithOpacity,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(
                  height: 10.00,
                ),

                /// Renter Address
                CustomText(
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                  txtTitle: controller.getUserInfo.address,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: custBlack102339WithOpacity,
                        fontWeight: FontWeight.w500,
                      ),
                ),

                /// Renter phone number
                CustomText(
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                  txtTitle: controller.getUserInfo.phone,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: custBlack102339WithOpacity,
                        fontWeight: FontWeight.w500,
                      ),
                ),

                // const SizedBox(
                //   height: 10.00,
                // ),

                // /// Renter Mobile No
                // CustomText(
                //   txtTitle: "+1-202-555-0124",
                //   style: Theme.of(context).textTheme.caption?.copyWith(
                //         color: custBlack102339WithOpacity,
                //         fontWeight: FontWeight.w500,
                //       ),
                // ),
                const SizedBox(
                  height: 20.00,
                ),

                /// Pay With
                _buildPaymentWith(context),

                const SizedBox(
                  height: 29.00,
                ),

                // /// item info
                // CustomText(
                //   txtTitle: StaticString.itemInfo,
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),

                // const SizedBox(
                //   height: 14.00,
                // ),
                TotalPaymentCard(
                  itemDetailModel: itemDetailModel,
                  valueSetter: (val) {
                    _finalPayment = val;
                  },
                ),

                // /// item price
                // _buildTitlewithPrice(
                //   context: context,
                //   title: StaticString.itemPrice,
                //   child: CustomText(
                //     txtTitle:
                //         "${StaticString.rupeeSymbol} ${priceFormat.format(25999)}",
                //     style: Theme.of(context).textTheme.caption,
                //   ),
                // ),
                // const SizedBox(
                //   height: 14.00,
                // ),

                // /// item charges
                // _buildTitlewithPrice(
                //   context: context,
                //   title: "Charges (+5% / ₹60 Per Day)",
                //   child: CustomText(
                //     txtTitle: "+${StaticString.rupeeSymbol}${300}",
                //     style: Theme.of(context).textTheme.caption,
                //   ),
                // ),
                // const SizedBox(
                //   height: 14.00,
                // ),
                // _buildTitlewithPrice(
                //   context: context,
                //   title: StaticString.safetyDeposite.replaceAll(":", ""),
                //   child: CustomText(
                //     txtTitle: "+${StaticString.rupeeSymbol}${5000}",
                //     style: Theme.of(context).textTheme.caption,
                //   ),
                // ),
                // const SizedBox(
                //   height: 20.00,
                // ),
                // _buildTitlewithPrice(
                //   context: context,
                //   title: StaticString.totalPayment,
                //   child: CustomText(
                //     txtTitle: "+${StaticString.rupeeSymbol}${5000}",
                //     style: Theme.of(context).textTheme.bodyText2,
                //   ),
                // ),

                const SizedBox(
                  height: 10.00,
                ),

                /// Description
                // CustomText(
                //   txtTitle: itemDetailModel.description,
                //   style: Theme.of(context).textTheme.overline?.copyWith(
                //         color: custBlack102339WithOpacity,
                //         fontWeight: FontWeight.w500,
                //         height: 1.4,
                //       ),
                // ),

                const SizedBox(
                  height: 30.00,
                ),

                /// Confirm and Pay  button
                _buildConfirmAndPayButton(),
                const SizedBox(
                  height: 30.00,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//!------------------------------------------------ Widget ------------------------------
  /// warning message
  Widget _buildWarningMessage(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _msgNotifier,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ExpandChild(
            expand: _isMsgVisible,
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                top: 10,
                bottom: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: custRedFF3F50.withOpacity(
                  0.06,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  /// warning text
                  Expanded(
                    child: CustomText(
                      maxLine: 2,
                      txtTitle: StaticString.warningMsg,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: custRedFF3F50,
                            height: 1.5,
                          ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  //close button
                  InkWell(
                    onTap: () {
                      _isMsgVisible = false;
                      _msgNotifier.notifyListeners();
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: custRedFF3F50,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      child: CustImage(
                        imgURL: ImgName.close,
                        width: 10,
                        height: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  /// Seller name
  Widget _buildLenderName(BuildContext context) {
    return Row(
      children: [
        CustomText(
          txtTitle: StaticString.lenderName,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: custBlack102339WithOpacity,
              ),
        ),
        const SizedBox(
          width: 3,
        ),
        Flexible(
          child: CustomText(
            txtTitle: itemDetailModel.lenderInfoModel?.name ?? "",
            style: Theme.of(context).textTheme.bodyText2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// item Small description
  Widget _buildItemNameAndTag(
      {required BuildContext context, required String smallDescription}) {
    return Row(
      children: [
        Flexible(
          child: CustomText(
            maxLine: 1,
            textOverflow: TextOverflow.ellipsis,
            txtTitle: smallDescription,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  height: 1.8,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        itemAndServiceTagCard(
            ItemOrServices: itemDetailModel.category?.type.name ?? "")
      ],
    );
  }

  /// common title and Subtitle
  Widget _buildCommonTitlerAndSubtitle(
      {required BuildContext context,
      required String title,
      required String subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          txtTitle: title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: 10.00,
        ),
        CustomText(
          // textOverflow: TextOverflow.ellipsis,
          txtTitle: subTitle,
          style: Theme.of(context).textTheme.caption?.copyWith(
              color: custBlack102339WithOpacity,
              fontWeight: FontWeight.w500,
              height: 2.0),
        ),
      ],
    );
  }

  /// Payment With

  Widget _buildPaymentWith(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              txtTitle: StaticString.payWith,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        const SizedBox(
          height: 10.00,
        ),
        InkWell(
          onTap: () {
            Get.to(PayWithScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _paymentController.getCardsLoading.value
                  ? CircularProgressIndicator()
                  : _buildSelectedCard(context),
              InkWell(
                onTap: _selectCard,
                child: CustImage(
                  imgURL: ImgName.rightArrow,
                  imgColor: Colors.black,
                  height: 8.00,
                  width: 3.2,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// Pay with Selected Card

  Widget _buildSelectedCard(context) {
    return GetBuilder<PaymentController>(
      builder: (_pc) {
        debugPrint('value of selected car ${_pc.selectedCard}');
        if (_pc.selectedCard.value != null) {
          return Row(
            children: [
              CustImage(
                imgURL: ImgName.visa,
                height: 20,
                width: 40,
              ),
              const SizedBox(
                width: 6.00,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    txtTitle: _pc.selectedCard.value!.brand,
                    style: Theme.of(context).textTheme.overline,
                  ),
                  CustomText(
                    txtTitle:
                        "**** **** ${_paymentController.selectedCard.value!.last4}",
                    style: Theme.of(context).textTheme.overline?.copyWith(
                        color: custBlack102339WithOpacity, height: 2),
                  ),
                ],
              ),
            ],
          );
        } else {
          return CustomText(
            txtTitle: 'Select a card',
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custBlack102339WithOpacity,
                  fontWeight: FontWeight.w500,
                  height: 2.0,
                ),
          );
        }
      },
    );
  }

  /// title and Price
  Widget _buildTitlewithPrice(
      {required BuildContext context,
      required String title,
      required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          txtTitle: title,
          style: Theme.of(context).textTheme.caption?.copyWith(
                color: custBlack102339WithOpacity,
                fontWeight: FontWeight.w500,
              ),
        ),
        child
      ],
    );
  }

  /// Confirm And Pay button
  Widget _buildConfirmAndPayButton() {
    return Center(
      child: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicatorNotifier.statusNotifier,
        indicatorType: LoadingIndicatorType.Spinner,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
            elevation: 10,
          ),
          onPressed: _confirmAndPay,
          child: const CustomText(
            txtTitle: StaticString.confirmAndPay,
            style: TextStyle(
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontFamily: CustomFont.metropolis,
              color: Color.fromRGBO(172, 172, 172, 0.5),
            ),
          ),
        ),
      ),
    );
  }

  //!------------------------------------------------- Button Action -------------------------------
  void _selectCard() {
    debugPrint(
        "**************************************** Select Card ***************************");
    Get.toNamed("SelectCardScreen");
    // Get.to(SelectCardScreen());
  }

  Future<void> _confirmAndPay() async {
    try {
      debugPrint('confirmpayment called ${itemDetailModel.toJson()}');
    // return;
      PaymentRequestModel paymentRequestModel = PaymentRequestModel(
        endDate: itemDetailModel.endDate?.toUtc().toString() ?? "",
            //     ?.toUtc()
            //     .toString()
            //     .toDateFormat(requiredFormat: "yyyy-MM-dd") ??
            // "",
        endTime: itemDetailModel.serviceEndTime,
        lendItemServiceId: itemDetailModel.id.toString(),
        paymentMethod: "",
        startDate: itemDetailModel.startDate?.toUtc().toString() ?? "",
            //     ?.toUtc()
            //     .toString()
            //     .toDateFormat(requiredFormat: "yyyy-MM-dd") ??
            // "",
        startTime: itemDetailModel.serviceStartTime,
        //! UNCOMMENT
        totalPayment: double.parse(_finalPayment).toStringAsFixed(2),
      );

      paymentRequestModel.paymentMethod = 'card';

      //   await BrainTreePayment().initializePayment(paymentRequestModel);
      if (_paymentController.selectedCard.value != null) {
        _paymentController.confirmPayment(
          getContext,
          paymentRequestModel,
          _paymentController.selectedCard.value!,
          itemDetailModel,
          chatId,
        );
      } else {
        showAlert(
            context: getContext, message: 'Please select a card for payment');
      }
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }
}
