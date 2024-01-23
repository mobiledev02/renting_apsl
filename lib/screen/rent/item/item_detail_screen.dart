import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/binding/routs.dart';
import 'package:renting_app_mobile/controller/request_controller.dart';
import 'package:renting_app_mobile/models/item_renting_request.dart';
import 'package:renting_app_mobile/screen/profile/lender_profile_screen.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import 'package:renting_app_mobile/utils/date_time_util.dart';
import 'package:renting_app_mobile/widgets/cust_button.dart';
import 'package:renting_app_mobile/widgets/loading_dialog.dart';
import 'package:renting_app_mobile/widgets/loading_indicator.dart';

import '../../../controller/auth_controller.dart';
import '../../../models/message_model.dart';
import '/controller/chat_controller.dart';
import '../../../cards/total_payment_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../controller/lend_controller.dart';
import '../../../controller/total_payment_controller.dart';
import '../../../main.dart';
import '../../../models/item_detail_model.dart';
import '../../../utils/custom_enum.dart';
import '../../../widgets/calender_dialog.dart';
import '../../../widgets/common_functions.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/custom_alert.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_row_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/expand_child.dart';
import '../../../widgets/spinner.dart';
import '../../chat/chat_screen.dart';

class ItemDetailScreen extends GetView<LendController> {
  ItemDetailScreen({Key? key}) {
    fetchData();
  }

//!-------------------variable------------------------
  TotalPaymentController totalPaymentController =
      Get.find<TotalPaymentController>();

  ItemDetailModel itemDetail = ItemDetailModel();

  TimeOfDay? selectedEndTime, selectStartTime;

  final ValueNotifier _startTimeNotifier = ValueNotifier(true);
  final ValueNotifier _endTimeNotifier = ValueNotifier(true);

  final TextEditingController _emailController = TextEditingController();
  int dropdownValue = 0;
  int productQuntity = 0;
  ItemRentingRequest? itemRentingRequest;

  double _totalPayment = 0;

  bool _expandChild = false;

  final ValueNotifier _initialNotifier = ValueNotifier(true);
  final ValueNotifier _onTimeSelectionNotifier = ValueNotifier(true);
  final ValueNotifier _calenderNotifier = ValueNotifier(true);

  Future fetchData() async {
    try {
      print("* * * * * * * * * * * * Come to call API * * * * * * * * * * * *");
      await controller.fetchItemDetail(context: getContext, id: Get.arguments);
      itemDetail = controller.itemDetail.value;
      _initialNotifier.notifyListeners();

      itemRentingRequest = await Get.find<RequestController>()
          .getItemRentingRequest(Get.arguments.toString(),
              Get.find<AuthController>().getUserInfo.id);
      debugPrint(
          'itemRenting date is ${itemRentingRequest?.itemDetail.startDate}');
    } catch (e, st) {
      debugPrint('item detail screen error $e $st');
      showAlert(context: getContext, message: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _initialNotifier,
        builder: (context, val, child) {
          return Scaffold(
            appBar: CustomAppbar(
              /// item name
              title: itemDetail.name,
            ),
            body: Obx(() {
              return controller.iDetailLoading.value
                  ? Spinner()
                  : Obx(
                      () {
                        return Get.find<RequestController>()
                                .loadingRentingRequest
                                .value
                            ? Spinner()
                            : SafeArea(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        // CustomText(
                                        //   txtTitle:
                                        //       'Coordinate a time and place to get the item from the Lender via Chat before paying.',
                                        //   style: TextStyle(
                                        //       fontSize: 12, color: Colors.red),
                                        // ),
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),

                                        /// Item requested Already
                                        _buildItemRequestedAlready(),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        /// Images
                                        CustomRowImage(
                                          // image1: "",
                                          image1: itemDetail.getFirstImageModel
                                                  ?.imageUrl ??
                                              "",
                                          image2: itemDetail.getSecondImageModel
                                                  ?.imageUrl ??
                                              "",
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),

                                        /// item name
                                        productNameAndDuration(
                                          context: context,
                                          name: itemDetail.name,
                                          duration: itemDetail.maxDuration,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        /// Category text
                                        categoryText(
                                          context: context,
                                          category:
                                              itemDetail.category?.name ?? "",
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        itemOrServiceTagAndPriceText(
                                          context: context,
                                          price:
                                              "Per Day: \$${itemDetail.ratePerDay}",
                                          itemOrServices:
                                              itemDetail.category?.type.name ??
                                                  "",
                                        ),

                                        const SizedBox(
                                          height: 16,
                                        ),
                                        // /Location detail
                                        location(
                                          context: context,
                                          location:
                                              '${itemDetail.city.isNotEmpty ? "${itemDetail.city}," : ''} ${itemDetail.state.isNotEmpty ? "${itemDetail.state}," : ''} ${itemDetail.country}',
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),

                                        /// Item Detail
                                        description(
                                          context: context,
                                          description: itemDetail.description,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        _buildWidget(
                                            itemDetail.getEnum, context),
                                        const SizedBox(
                                          height: 5,
                                        ),

                                        /// Name text

                                        lenderEmailid(
                                          context: context,
                                          title: StaticString.name,
                                          email: itemDetail
                                                  .lenderInfoModel?.name ??
                                              "",
                                          sideWidget:
                                              _viewProfileButton(context),
                                        ),

                                        const SizedBox(
                                          height: 40,
                                        ),
                                        _buildChatButton(itemDetail.getEnum),
                                        //Rent And Chat with lender button
                                        // Visibility(
                                        //   visible: itemDetail.lenderInfoModel?.id !=
                                        //       getAuthController?.getUserInfo.id,
                                        //   child: _buildRentAndChatButton(),
                                        // ),
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    );
            }),
          );
        });
  }

  //!------------------------widget-----------------------
  Widget _buildWidget(ItemAndServiceStatus itemStatus, context) {
    Widget? child;
    if(Get.find<AuthController>().guest.value) {
      return const SizedBox();
    }
    switch (itemStatus) {
      case ItemAndServiceStatus.Available:

        /// Select Date
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              txtTitle: 'Select Start Date',
              style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(
              height: 9,
            ),

            _startDateAndTime(getContext),
            const SizedBox(
              height: 9,
            ),

            _endDateAndTime(getContext),
            const SizedBox(
              height: 9,
            ),
            _buildCheckPrice(),

            // ///Start , End Date And check Term Button
            // _buildStartAndEndDateAndcheckTermButton(getContext),
            //const SizedBox(
            // height: 20,
            // ),

            ValueListenableBuilder(
              valueListenable: _onTimeSelectionNotifier,
              builder: (context, value, child) => ExpandChild(
                expand: _expandChild,
                child: const SizedBox(
                  height: 20,
                ),
              ),
            ),

            /// item Detail
            ValueListenableBuilder(
              valueListenable: _onTimeSelectionNotifier,
              builder: (context, value, child) =>
                  (itemDetail.startDate == null || itemDetail.endDate == null)
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.04),
                                blurRadius: 20.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpandChild(
                            expand: _expandChild,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.00,
                                right: 20.00,
                                top: 20.00,
                              ),
                              child: TotalPaymentCard(
                                itemDetailModel: itemDetail,
                                valueSetter: (val) {},
                              ),
                            ),
                          ),
                        ),
            ),

            /// Send message to lender
            _buildSendMessageWidget(context),
            const SizedBox(
              height: 50,
            ),

            _buildUpdateDateButton(),
          ],
        );
        break;
      case ItemAndServiceStatus.Rented:
        child = Column(
          children: [
            rentedText(
              context: getContext,
              rentedText: "This item is currently on rent. Please chat with the lender for more information",

            ),
          ],
        );
        break;
    }
    return child;
  }

  /// Email Text
  // Widget _buildEmailText(
  //     {required BuildContext context, required String email}) {
  //   return Row(
  //     children: [
  //       const SizedBox(
  //         width: 7,
  //       ),
  //       CustImage(
  //         imgURL: ImgName.emailIcon,
  //       ),
  //       const SizedBox(
  //         width: 9,
  //       ),
  //       CustomText(
  //         txtTitle: email,
  //         style: Theme.of(context).textTheme.caption?.copyWith(
  //               color: custBlack102339WithOpacity,
  //               fontWeight: FontWeight.w600,
  //             ),
  //       ),
  //     ],
  //   );
  // }

  // day dropdown and check price button
  // Widget _builddaysDropdownAndCheckPriceButton({required double? price}) {
  //   return Row(
  //     children: [
  //       // Price DropDown
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 1.0,
  //             color: custBlack102339.withOpacity(0.1),
  //           ),
  //           borderRadius: const BorderRadius.all(
  //             Radius.circular(
  //               10.0,
  //             ),
  //           ),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton<int>(
  //             hint: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(
  //                 children: [
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                   CustImage(
  //                     imgURL: ImgName.dayIcon,
  //                   ),
  //                   const SizedBox(
  //                     width: 8,
  //                   ),
  //                   CustomText(
  //                     txtTitle: StaticString.selectDuration,
  //                     style: TextStyle(
  //                       color: custBlack102339.withOpacity(0.5),
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             focusColor: Colors.white,
  //             value: dropdownValue == 0 ? null : dropdownValue,
  //             icon: Padding(
  //                 padding: const EdgeInsets.only(
  //                   left: 14,
  //                   right: 10,
  //                 ),
  //                 child: CustImage(
  //                   imgURL: ImgName.dropDownIcon,
  //                 )),

  //             // elevation: 16,
  //             style: TextStyle(
  //               color: custBlack102339.withOpacity(0.5),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             // underline: Container(
  //             //   height: 2,
  //             //   color: Colors.deepPurpleAccent,
  //             // ),
  //             onChanged: (int? newValue) {
  //               setState(() {
  //                 dropdownValue = newValue!;
  //               });
  //             },
  //             items: noOfDays.map<DropdownMenuItem<int>>((int value) {
  //               return DropdownMenuItem<int>(
  //                 value: value,
  //                 child: Row(
  //                   children: [
  //                     const SizedBox(
  //                       width: 10,
  //                     ),
  //                     CustImage(
  //                       imgURL: ImgName.dayIcon,
  //                     ),
  //                     const SizedBox(
  //                       width: 8,
  //                     ),
  //                     CustomText(
  //                       txtTitle: "${value.toString()} days",
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 13,
  //       ),
  //       // Check Term Button
  //       _buildCheckTerm(),
  //     ],
  //   );
  // }

  /// Item requested Already
  Widget _buildItemRequestedAlready() {
    return Align(
      alignment: Alignment.topCenter,
      child: Visibility(
          visible: itemRentingRequest != null &&
              (itemRentingRequest!.itemRequestStatus ==
                      ItemRequestStatus.Sent ||
                  itemRentingRequest!.itemRequestStatus ==
                      ItemRequestStatus.LenderAccepted),
          child: InkWell(
            onTap: _goToChat,
            child: CustomText(
              align: TextAlign.center,
              txtTitle: 'You have requested this item already\n(Go to chat)',
              style: Theme.of(getContext)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: primaryColor),
            ),
          )),
    );
  }

  /// Send Chat Message Widget
  Widget _buildSendMessageWidget(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _onTimeSelectionNotifier,
      builder: (context, data, widget) {
        return (itemDetail.startDate == null || itemDetail.endDate == null)
            ? Container()
            : Visibility(
                visible: (_expandChild && itemRentingRequest == null) ||
                    (_expandChild &&
                        itemRentingRequest != null &&
                        itemRentingRequest!.itemRequestStatus ==
                            ItemRequestStatus.Completed),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 22,
                    ),
                    CustomText(
                      txtTitle: 'Send a message to the Lender',
                      style:
                          Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: custBlack102339WithOpacity
                                      .withOpacity(0.1)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                txtTitle:
                                    '''Hello I would like to rent your item from ${formatDateDDMMYYYY(itemDetail.startDate?.toLocal())} at ${formatTimeHM(itemDetail.startDate?.toLocal())} - ${formatDateDDMMYYYY(itemDetail.endDate?.toLocal())} at ${formatTimeHM(itemDetail.endDate?.toLocal())}''',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: custBlack102339WithOpacity,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          txtTitle: 'Send',
                          onPressed: _sendMessageToLender,
                          style: Theme.of(getContext)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor),
                        ),
                      ],
                    )
                  ],
                ),
              );
      },
    );
  }

  /// Update date
  Widget _buildUpdateDateButton() {
    return Visibility(
        visible: itemRentingRequest != null &&
            itemRentingRequest!.itemRequestStatus == ItemRequestStatus.Sent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: _updateDate,
              child: Text('Update Date'),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }

  /// Chat button
  Widget _buildChatButton(ItemAndServiceStatus status) {
    return Visibility(
        visible:
           status == ItemAndServiceStatus.Rented,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: _chatWithLender,
              child: Text('Chat With Lender'),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }

  Widget _startDateAndTime(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _onTimeSelectionNotifier,
      builder: (context, val, child) {
        return Row(
          children: [
            _buildStartDate(context),
            const SizedBox(
              width: 10,
            ),
            _buildStartTime(context),
          ],
        );
      },
    );
  }

  Widget _endDateAndTime(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _onTimeSelectionNotifier,
      builder: (context, val, child) {
        return Row(
          children: [
            _buildEndDate(context),
            const SizedBox(
              width: 10,
            ),
            _buildEndTime(context),
          ],
        );
      },
    );
  }

  ///Start , End Date And check Term Button
  Widget _buildStartAndEndDateAndcheckTermButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _onTimeSelectionNotifier,
        builder: (context, val, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// end date
              _buildStartDate(context),
              const SizedBox(
                width: 10,
              ),

              /// Start Date
              _buildEndDate(context),
              const SizedBox(
                width: 10,
              ),

              /// Check Price Button
              _buildCheckPrice()
            ],
          );
        });
  }

  /// Start date
  Widget _buildStartDate(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
      onTap: () => showCalender(
        context: context,
        focusedDay: itemDetail.startDate,
        firstDate: DateTime.now(),
        currentDate: itemDetail.startDate ?? DateTime.now(),
        selectedDay: itemDetail.startDate ?? DateTime.now(),
        setDateOnCallBack: (date) {
          debugPrint('selected date ${date.toLocal()}');
          itemDetail.startDate = date;
          itemDetail.endDate = null;
          _expandChild = false;
          _onTimeSelectionNotifier.notifyListeners();
        },
      ),
      icon: ImgName.calender,
      context: context,
      date: itemDetail.startDate == null
          ? StaticString.startDate
          : StaticString.formatter.format(
              itemDetail.startDate ?? DateTime.now(),
            ),
    );
  }

  /// End Date
  Widget _buildEndDate(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
        onTap: () => showCalender(
              context: context,
            //  labelText: 'Max ${itemDetail.maxDuration} days',
              focusedDay: itemDetail.startDate?.add(Duration(hours: 1)),
              firstDate: itemDetail.startDate?.add(Duration(hours: 1)),
              currentDate: itemDetail.endDate,

              // TODO: Remove this and change back to 24 hours?
              selectedDay: itemDetail.endDate ??
                  itemDetail.startDate?.add(Duration(hours: 1
                  )),
              setDateOnCallBack: (date) {
                _expandChild = false;
                if ((daysBetween(
                      from: (itemDetail.startDate ?? DateTime.now()),
                      to: (date),
                    )) >
                    // add "=" here if you need accurate date range
                    (itemDetail.maxDuration ?? 0)) {
                  debugPrint('pressed');
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('This is a Snackbar!'),
                  //     duration: Duration(seconds: 3),
                  //   ),
                  // );
                  try {
                    Get.showSnackbar(GetSnackBar(
                      // title: "Your account is created successfully",
                      message:
                          "You can book this item for maximum ${itemDetail.maxDuration} days",
                      duration: const Duration(seconds: 2),
                    ));
                  } catch (e, st) {
                    debugPrint('error is comming $e');
                  }

                  return;
                }

                itemDetail.endDate = date;
                _onTimeSelectionNotifier.notifyListeners();
              },
            ),
        context: context,
        icon: ImgName.calender,
        date: itemDetail.endDate == null
            ? StaticString.endDate
            : StaticString.formatter
                .format(itemDetail.endDate ?? DateTime.now()));
  }

  /// Start Date
  Widget _buildStartTime(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _startTimeNotifier,
      builder: (context, j, w) => dateTextAndCalenderAndTimeIcon(
        onTap: _startTime,
        icon: ImgName.clock,
        context: context,
        date: itemDetail.startTime == null
            ? StaticString.startTime
            : formatTimeHM(itemDetail.startTime),
      ),
    );
  }

  Future<void> _startTime() async {
    selectStartTime = await showTimePicker(
      context: getContext,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (selectStartTime != null) {
      itemDetail.startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectStartTime!.hour,
        selectStartTime!.minute,
      );

      _expandChild = false;
    }

    _startTimeNotifier.notifyListeners();
    _onTimeSelectionNotifier.notifyListeners();
  }

  Widget _buildEndTime(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _endTimeNotifier,
      builder: (context, j, w) {
        return dateTextAndCalenderAndTimeIcon(
          onTap: _endTime,
          icon: ImgName.clock,
          context: context,
          date: itemDetail.endTime == null
              ? StaticString.endTime
              : formatTimeHM(itemDetail.endTime),
        );
      },
    );
  }

  Future<void> _endTime() async {
    selectedEndTime = await showTimePicker(
      context: getContext,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (selectedEndTime != null) {
      itemDetail.endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedEndTime!.hour,
        selectedEndTime!.minute,
      );
      _expandChild = false;
    }

    _endTimeNotifier.notifyListeners();
    _onTimeSelectionNotifier.notifyListeners();
  }

  _setDates() {
    itemDetail.startDate = DateTime(
      itemDetail.startDate!.year,
      itemDetail.startDate!.month,
      itemDetail.startDate!.day,
      selectStartTime!.hour,
      selectStartTime!.minute,
    );
    itemDetail.endDate = DateTime(
      itemDetail.endDate!.year,
      itemDetail.endDate!.month,
      itemDetail.endDate!.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );
  }

  /// Check Term Button
  Widget _buildCheckPrice() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(80, 32),
      ),
      onPressed: _checkPrice,
      child: CustomText(
        txtTitle: StaticString.checkPrice,
        style: Theme.of(getContext)
            .textTheme
            .overline
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  // // Email text form feild

  // Widget _buildEmailTextFormField() {
  //   return Form(
  //     key: _formKey,
  //     autovalidateMode: _autovalidateMode,
  //     child: TextFormField(
  //       keyboardType: TextInputType.emailAddress,
  //       // focusNode: _emailFocusNode,
  //       textInputAction: TextInputAction.done,
  //       validator: (val) => val?.validateEmail,
  //       controller: _emailController,
  //       // style: const TextStyle(
  //       //   fontSize: 20.0,
  //       //   color: Colors.grey,
  //       // ),
  //       decoration: InputDecoration(
  //         contentPadding: const EdgeInsets.only(
  //           top: 8,
  //           left: 15,
  //         ),
  //         hintStyle: TextStyle(
  //           fontSize: 14,
  //           fontFamily: CustomFont.metropolis,
  //           fontWeight: FontWeight.w600,
  //           color: custBlack102339.withOpacity(0.4),
  //         ),
  //         hintText: StaticString.millergarciaGmail,
  //         prefixIcon: CustImage(
  //           imgURL: ImgName.emailIcon,
  //           width: 16,
  //           height: 13,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // // final price text
  // Widget _buildFinalPriceText({required double? price}) {
  //   return CustomRichText(
  //     title:
  //         "${StaticString.finalPrice} #${StaticString.rupeeSymbol}${priceFormat.format(dropdownValue * price!)} #($dropdownValue #day #price)",
  //     normalTextStyle: const TextStyle(
  //       fontSize: 13,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     fancyTextStyle: const TextStyle(
  //       color: primaryColor,
  //       fontSize: 13,
  //       fontWeight: FontWeight.w600,
  //     ),
  //   );
  // }

  // rent and chat button
  Widget _buildRentAndChatButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Rent button
        if (itemDetail.getEnum != ItemAndServiceStatus.Rented)
          _buildRentButton(),
        const SizedBox(
          width: 15,
        ),
        // Chat With lender button
        _buildChatWithLenderButton(),
      ],
    );
  }

  // rent button
  Widget _buildRentButton() {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(120, 44),
          shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
          elevation: 10,
        ),
        onPressed: _rentButton,
        child: const CustomText(
          txtTitle: StaticString.rent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Chat with lender button

  Widget _buildChatWithLenderButton() {
    return Expanded(
      flex: 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 44),
          // maximumSize: Size(92, 36),
          // minimumSize: Size(92, 36),
          // fixedSize: MaterialStateProperty<Size>.all(
          //   Size(250.0, 46.0),
          // ),
          shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
          elevation: 10,
        ),
        onPressed: _chatWithLenderButton,
        child: const CustomText(
          txtTitle: StaticString.chatWithLender,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _viewProfileButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (itemDetail.lenderInfoModel != null) {
          controller.getLenderProfile(
              context, itemDetail.lenderInfoModel!.id.toString());
          Get.to(() => LenderProfileScreen());
        }
      },
      child: CustomText(
        txtTitle: '(View Profile)',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.w600, color: primaryColor),
      ),
    );
  }

  //!-------------------Button Action------------------

  void _checkPrice() {
    debugPrint(
        "****************************** Check price *****************************");
    if (itemDetail.startDate == null || itemDetail.endDate == null) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select start and end date.",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (itemDetail.startTime == null) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select start time.",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (itemDetail.startTime!.isBefore(DateTime.now()))
    {
        Get.showSnackbar(const GetSnackBar(
        message: "Start time must be in the future.",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (itemDetail.endTime == null) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select end time.",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (itemDetail.endDate!.isBefore(itemDetail.startDate!) || 
        (itemDetail.endDate!.isAtSameMomentAs(itemDetail.startDate!) && 
         !itemDetail.endTime!.isAfter(itemDetail.startTime!))) {
        Get.showSnackbar(const GetSnackBar(
        message: "Please select an end date/time after the start date/time.",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if ((daysBetween(
            from: (itemDetail.startDate ?? DateTime.now()),
            to: (itemDetail.endDate ?? DateTime.now()))) >
        (itemDetail.maxDuration ?? 0)) {
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message:
            "You can book this item for maximume ${itemDetail.maxDuration} days",
        duration: const Duration(seconds: 2),
      ));
      return;
    }

    itemDetail.startDate = DateTime(
      itemDetail.startDate!.year,
      itemDetail.startDate!.month,
      itemDetail.startDate!.day,
      selectStartTime!.hour,
      selectStartTime!.minute,
    );

    itemDetail.endDate = DateTime(
      itemDetail.endDate!.year,
      itemDetail.endDate!.month,
      itemDetail.endDate!.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );
    debugPrint('end date before is ${itemDetail.endDate}');
    _onTimeSelectionNotifier.notifyListeners();
    productQuntity = dropdownValue;
    _expandChild = true;
    _onTimeSelectionNotifier.notifyListeners();
  }

  Future<void> _rentButton() async {
    bool permissionGranted = await locationDialogueIfLocationIsDisale();

    if (!permissionGranted) return;

    debugPrint(
        "****************************** Rent Click *****************************");

    if (itemDetail.startDate == null || itemDetail.endDate == null) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date.",
        duration: Duration(seconds: 2),
      ));
      return;
    }

    Get.toNamed("CheckoutScreen", arguments: itemDetail);
  }

  Future<void> _updateDate() async {
    try {
      if (itemDetail.startTime == null) {
        Get.showSnackbar(const GetSnackBar(
          // title: "Your account is created successfully",
          message: "Please select start time.",
          duration: Duration(seconds: 2),
        ));
        return;
      }
      if (itemDetail.endTime == null) {
        Get.showSnackbar(const GetSnackBar(
          // title: "Your account is created successfully",
          message: "Please select end time.",
          duration: Duration(seconds: 2),
        ));
        return;
      }
      if (itemDetail.startDate != null &&
          itemDetail.endDate != null &&
          itemRentingRequest != null) {
        showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ));
        itemDetail.startDate = DateTime(
          itemDetail.startDate!.year,
          itemDetail.startDate!.month,
          itemDetail.startDate!.day,
          selectStartTime!.hour,
          selectStartTime!.minute,
        );

        itemDetail.endDate = DateTime(
          itemDetail.endDate!.year,
          itemDetail.endDate!.month,
          itemDetail.endDate!.day,
          selectedEndTime!.hour,
          selectedEndTime!.minute,
        );
        await Get.find<ChatController>().createChatInFirebase(
            itemDetailModel: itemDetail, docId: itemRentingRequest!.chatId);

        if (itemDetail.lenderInfoModel != null) {
          final ItemRentingRequest rentingRequest = ItemRentingRequest(
            type: ItemOrService.item,
            itemDetail: itemDetail,
            itemRequestStatus: ItemRequestStatus.Sent,
            chatId: itemRentingRequest!.chatId,
            itemId: itemDetail.id.toString(),
            lenderId: itemDetail.lenderInfoModel?.id ?? '',
            renterId: Get.find<AuthController>().getUserInfo.id,
          );
          await Get.find<RequestController>().createItemRequest(
            rentingRequest: rentingRequest,
            docId: itemRentingRequest!.chatId,
          );

          if (itemDetail.lenderInfoModel != null) {
            itemDetail.lenderInfoModel!.itemDetailModel = itemDetail;
            Get.find<ChatController>().updateUnreadMessageCountOfReceiverUser(
                oppositeUserInfoModel: itemDetail.lenderInfoModel!,
                isFromSingleChat: true,
                chatId: itemRentingRequest!.chatId,
                message:
                    '''Requested date has been updated to ${formatDateDDMMYYYY(itemDetail.startDate)} - ${formatDateDDMMYYYY(itemDetail.endDate)}.''');
          }
          await Get.find<ChatController>().sendMessage(
            messageModel: MessageModel(
              chatRoomId: itemRentingRequest!.chatId,
              lenderId: itemDetail.lenderInfoModel!.id,
              renterId: Get.find<AuthController>().getUserInfo.id,
              message:
                  '''Requested date has been updated to ${formatDateDDMMYYYY(itemDetail.startDate)} - ${formatDateDDMMYYYY(itemDetail.endDate)}.''',
              forSingleChat: (!true).toString(),
              itemId: itemDetail.lenderInfoModel?.id.toString() ?? "",
              eventServiceId: itemDetail
                      .lenderInfoModel!.itemDetailModel?.category?.id
                      .toString() ??
                  "",
              messageType: MessageType.DateUpdate,
              startDate: itemDetail.startDate,
              endDate: itemDetail.endDate,
              senderInfo: Get.find<AuthController>().getUserInfo,
              receiverInfo: itemDetail.lenderInfoModel,
              toSend: itemDetail.lenderInfoModel!.id,
              time: DateTime.now().millisecondsSinceEpoch,
              sendBy: Get.find<AuthController>().getUserInfo.id,
            ),
          );
        }
        Navigator.pop(navigatorKey.currentContext!);
        if (itemDetail.lenderInfoModel != null) {
          itemDetail.lenderInfoModel?.itemDetailModel = itemDetail;

          Get.off(
            () => ChatScreen(
              isLender: false,
              userInfoModel: itemDetail.lenderInfoModel!,
              chatId: itemRentingRequest!.chatId,
              isSingleChat: true,
            ),
          );
        }
      } else {
        Get.showSnackbar(const GetSnackBar(
          // title: "Your account is created successfully",
          message: "Please select date.",
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e, st) {
      debugPrint('updateerror $e $st');
    }
  }

  void _chatWithLender() async {
    if (itemDetail.lenderInfoModel != null && itemRentingRequest != null) {
      itemDetail.lenderInfoModel?.itemDetailModel = itemDetail;
      
      Get.off(
            () => ChatScreen(
          isLender: false,
          userInfoModel: itemDetail.lenderInfoModel!,
          isSingleChat: true,
          chatId: itemRentingRequest!.chatId,
        ),
      );
    }
    else if(itemDetail.lenderInfoModel != null){
      final simpleChatRoomId = '${itemDetail.lenderInfoModel!.id}L${itemDetail.id}I${Get.find<AuthController>().getUserInfo.id}R';

      await Get.find<ChatController>()
          .createChatInFirebase(itemDetailModel: itemDetail, docId: simpleChatRoomId);
      Get.off(
            () => ChatScreen(
          isLender: false,
          userInfoModel: itemDetail.lenderInfoModel!,
          isSingleChat: true,
          chatId: simpleChatRoomId,
        ),
      );
    }
  }

  void _goToChat() {
    if (itemDetail.lenderInfoModel != null && itemRentingRequest != null) {
      itemDetail.lenderInfoModel?.itemDetailModel = itemDetail;
      
      Get.off(
        () => ChatScreen(
          isLender: false,
          userInfoModel: itemDetail.lenderInfoModel!,
          isSingleChat: true,
          chatId: itemRentingRequest!.chatId,
        ),
      );
    }
  }

  Future<void> _sendMessageToLender() async {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    itemDetail.startDate = DateTime(
      itemDetail.startDate!.year,
      itemDetail.startDate!.month,
      itemDetail.startDate!.day,
      selectStartTime!.hour,
      selectStartTime!.minute,
    );

    itemDetail.endDate = DateTime(
      itemDetail.endDate!.year,
      itemDetail.endDate!.month,
      itemDetail.endDate!.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );
    final docId = FirebaseFirestore.instance
        .collection(StaticString.itemRequestsCollection)
        .doc()
        .id;
    await Get.find<ChatController>()
        .createChatInFirebase(itemDetailModel: itemDetail, docId: docId);

    if (itemDetail.lenderInfoModel != null) {
      final ItemRentingRequest rentingRequest = ItemRentingRequest(
          type: ItemOrService.item,
          itemDetail: itemDetail,
          itemRequestStatus: ItemRequestStatus.Sent,
          chatId: docId,
          itemId: itemDetail.id.toString(),
          lenderId: itemDetail.lenderInfoModel?.id ?? '',
          renterId: Get.find<AuthController>().getUserInfo.id);
      await Get.find<RequestController>()
          .createItemRequest(rentingRequest: rentingRequest, docId: docId);
      if (itemDetail.lenderInfoModel != null) {
        itemDetail.lenderInfoModel!.itemDetailModel = itemDetail;
        Get.find<ChatController>().updateUnreadMessageCountOfReceiverUser(
            oppositeUserInfoModel: itemDetail.lenderInfoModel!,
            isFromSingleChat: true,
            chatId: docId,
            message:
                '''Hi I want to rent this from ${formatDateDDMMYYYY(itemDetail.startDate)} - ${formatDateDDMMYYYY(itemDetail.endDate)}. Can you please let know what time and how I can get this item?.''');
      }
      await Get.find<ChatController>().sendMessage(
        messageModel: MessageModel(
          lenderId: itemDetail.lenderInfoModel!.id,
          renterId: Get.find<AuthController>().getUserInfo.id,
          chatRoomId: docId,
          message:
              '''Hi I want to rent this from ${formatDateDDMMYYYY(itemDetail.startDate)} - ${formatDateDDMMYYYY(itemDetail.endDate)}. Can you please let know what time and how I can get this item?''',
          forSingleChat: (!true).toString(),
          itemId: itemDetail.id.toString(),
          eventServiceId: itemDetail
                  .lenderInfoModel!.itemDetailModel?.category?.id
                  .toString() ??
              "",
          messageType: MessageType.ItemRequest,
          startDate: itemDetail.startDate,
          endDate: itemDetail.endDate,
          senderInfo: Get.find<AuthController>().getUserInfo,
          receiverInfo: itemDetail.lenderInfoModel,
          toSend: itemDetail.lenderInfoModel!.id,
          time: DateTime.now().millisecondsSinceEpoch,
          sendBy: Get.find<AuthController>().getUserInfo.id,
        ),
      );
    }
    Navigator.pop(navigatorKey.currentContext!);
    if (itemDetail.lenderInfoModel != null) {
      itemDetail.lenderInfoModel?.itemDetailModel = itemDetail;
      Get.off(
        () => ChatScreen(
          isLender: false,
          userInfoModel: itemDetail.lenderInfoModel!,
          isSingleChat: true,
          chatId: docId,
        ),
      );
    }
  }

  //TODO: remove this function
  void _chatWithLenderButton() {
 
    Get.find<ChatController>()
        .createChatInFirebase(itemDetailModel: itemDetail);
    if (itemDetail.lenderInfoModel != null) {
      final chatRoomId = itemDetail.lenderInfoModel!.chatRoomId.isNotEmpty
          ? itemDetail.lenderInfoModel!.chatRoomId
          : Get.find<ChatController>()
                  .userIdWithTag(Get.find<AuthController>().getUserInfo.id) +
              Get.find<ChatController>().lenderIdWithTag(
                itemDetail.lenderInfoModel!.id,
              ) +
              Get.find<ChatController>().eventServiceWithTag(
                itemDetail.lenderInfoModel!.itemDetailModel?.id.toString() ??
                    "",
              );
      Get.find<ChatController>().sendMessage(
        messageModel: MessageModel(
          chatRoomId: chatRoomId,
          lenderId: itemDetail.lenderInfoModel!.id,
          renterId: Get.find<AuthController>().getUserInfo.id,
          message:
              '''Hi I want to rent this from ${formatDateDDMMYYYY(itemDetail.startDate)} - ${formatDateDDMMYYYY(itemDetail.endDate)}. Can you please let know what time and how I can get this item?''',
          forSingleChat: (!true).toString(),
          itemId: itemDetail.lenderInfoModel?.id.toString() ?? "",
          eventServiceId: itemDetail
                  .lenderInfoModel!.itemDetailModel?.category?.id
                  .toString() ??
              "",
          senderInfo: Get.find<AuthController>().getUserInfo,
          receiverInfo: itemDetail.lenderInfoModel,
          toSend: itemDetail.lenderInfoModel!.id,
          time: DateTime.now().millisecondsSinceEpoch,
          sendBy: Get.find<AuthController>().getUserInfo.id,
        ),
      );
    }

    if (itemDetail.lenderInfoModel != null) {
      itemDetail.lenderInfoModel?.itemDetailModel = itemDetail;

      Get.to(
        () => ChatScreen(
          isLender: false,
          userInfoModel: itemDetail.lenderInfoModel!,
          isSingleChat: true,
        ),
      );
    }
  }
}
