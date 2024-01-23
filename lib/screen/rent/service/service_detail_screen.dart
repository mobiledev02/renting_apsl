import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/screen/chat/chat_screen.dart';
import 'package:renting_app_mobile/screen/profile/lender_service_profile_screen.dart';

import '../../../controller/job_offer_controller.dart';
import '../../profile/lender_profile_screen.dart';
import '/widgets/cust_button.dart';
import '/widgets/spinner.dart';
import '../../../cards/total_payment_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../controller/chat_controller.dart';
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

class ServiceDetailScreen extends GetView<LendController> {
  ServiceDetailScreen() {
    fetchData();
  }

  //!--------------------------------------- variable ----------------------------------
  TotalPaymentController totalPaymentController =
      Get.find<TotalPaymentController>();

  // late AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  int dropdownValue = 0;
  int productQuntity = 0;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  ItemDetailModel itemDetail = ItemDetailModel();

  TimeOfDay? selectedEndTime, selectStartTime;

  bool _expandChild = false;

  RxBool fetchServiceDetail = false.obs;

  Future fetchData() async {
    try {
      fetchServiceDetail.value = true;

      await controller.fetchItemDetail(context: getContext, id: Get.arguments);
      itemDetail = controller.itemDetail.value;

      _initialNotify.notifyListeners();
    } catch (e) {
      showAlert(context: getContext, message: e);
    } finally {
      fetchServiceDetail.value = false;
    }
  }

  final ValueNotifier _valueNotifier = ValueNotifier(true);
  final ValueNotifier _initialNotify = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    // final product = Get.find<ItemController>().getProduct(id);
    return ValueListenableBuilder(
        valueListenable: _initialNotify,
        builder: (context, val, child) {
          return Scaffold(
            appBar: CustomAppbar(
              /// item name
              title: itemDetail.name,
            ),
            body: Obx(() {
              return fetchServiceDetail.value
                  ? Spinner()
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),

                              /// Images
                              CustomRowImage(
                                image1:
                                    itemDetail.getFirstImageModel?.imageUrl ??
                                        "",
                                image2:
                                    itemDetail.getSecondImageModel?.imageUrl ??
                                        "",
                              ),
                              const SizedBox(
                                height: 25,
                              ),

                              /// item name
                              productNameAndDuration(
                                context: context,
                                name: itemDetail.name,
                                // duration:itemDetail  .duration,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              /// Category text
                              categoryText(
                                context: context,
                                category: itemDetail.category?.name ?? "",
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              itemOrServiceTagAndPriceText(
                                context: context,
                                price: itemDetail.ratePerDay.isEmpty ||
                                        itemDetail.ratePerDay == "0.0"
                                    ? "Per Hour : \$${itemDetail.ratePerHour}"
                                    : "Per Day : \$${itemDetail.ratePerDay}",
                                // "Per ${itemDetail.getEnumForDayAndHourly == ServiceType.Day ? "Day" : "Hour"} : \$${itemDetail.getEnumForDayAndHourly == ServiceType.Day ? itemDetail.ratePerDay : itemDetail.ratePerHour}",
                                itemOrServices:
                                    itemDetail.category?.type.name ?? "",
                              ),

                              const SizedBox(
                                height: 16,
                              ), // /Location detail
                              location(
                                  context: context,
                                  location: itemDetail.address),
                              const SizedBox(
                                height: 16,
                              ),

                              /// Item Detail
                              description(
                                context: context,
                                description: itemDetail.description,
                              ),

                              const SizedBox(
                                height: 30,
                              ),

                              /// Email id text

                              lenderEmailid(
                                  context: context,
                                  title: StaticString.emailID,
                                  email:
                                      itemDetail.lenderInfoModel?.email ?? "",
                                  sideWidget: _viewProfileButton(context)),

                              // Email Text Form Feild

                              const SizedBox(
                                height: 40,
                              ),
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
            }),
          );
        });
  }

  //!------------------------widget-----------------------

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
  //       // Check Price Button
  //       _buildCheckPrice(),
  //     ],
  //   );
  // }

  Widget _viewProfileButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (itemDetail.lenderInfoModel != null) {
          Get.find<JobOfferController>()
              .checkSentOffer(context, itemDetail.id.toString());
          controller.getLenderProfile(
              context, itemDetail.lenderInfoModel!.id.toString());
          Get.to(() => LenderServiceProfileScreen(
                serviceDetail: itemDetail,
              ));
        }
      },
      child: CustomText(
        txtTitle: '(View Details)',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.w600, color: primaryColor),
      ),
    );
  }

  Widget _buildWidget(ServiceType serviceType) {
    Widget? child;
    switch (serviceType) {
      case ServiceType.Hourly:

        /// Select hourly service
        child = _buildHourlyService();
        break;
      case ServiceType.Day:

        /// Select Day service
        child = _buildDateService();
        break;
      case ServiceType.Rented:

        /// Srevice is rented
        child = rentedText(
          context: getContext,
          rentedText: itemDetail.rent?.msg ?? "",
        );
        break;
    }
    return child;
  }

  /// Service in Hourly
  Widget _buildHourlyService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          txtTitle: StaticString.selectHours,
          style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 9,
        ),

        ///Start , End Date And check Price Button
        _buildDateAndStartAndEndTimeAndcheckPriceButton(getContext),
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => SizedBox(
            height: ((itemDetail.startDate != null ||
                            itemDetail.serviceEndTime.isNotEmpty ||
                            itemDetail.serviceStartTime.isNotEmpty) &&
                        _expandChild) &&
                    !(((hoursBetween(
                                  itemDetailModel: itemDetail,
                                ) /
                                60) <=
                            0) &&
                        itemDetail.getEnumForDayAndHourly == ServiceType.Hourly)
                ? 20
                : 0.0,
          ),
        ),

        /// item Detail
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => ((itemDetail.startDate != null &&
                          itemDetail.serviceEndTime.isNotEmpty &&
                          itemDetail.serviceStartTime.isNotEmpty) &&
                      _expandChild) &&
                  !(((hoursBetween(
                                itemDetailModel: itemDetail,
                              ) /
                              60) <=
                          0) &&
                      itemDetail.getEnumForDayAndHourly == ServiceType.Hourly)
              ? Container(
                  padding: const EdgeInsets.only(
                    left: 20.00,
                    right: 20.00,
                    top: 20.00,
                  ),
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
                    child: TotalPaymentCard(
                      itemDetailModel: itemDetail,
                      valueSetter: (val) {},
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  ///Date  start time And endtime
  Widget _buildDateAndStartAndEndTimeAndcheckPriceButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) {
            return Row(
              children: [
                /// date
                _buildDate(context),
                const SizedBox(
                  width: 10,
                ),

                /// Service Start Time
                _buildStartTime(context),
                const SizedBox(
                  width: 10,
                ),

                /// Service End Time
                _buildEndTime(context),
              ],
            );
          },
        ),

        const SizedBox(
          height: 10,
        ),

        /// Check Price Button
        _buildCheckPrice()
      ],
    );
  }

  ///  Service Date
  Widget _buildDate(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
        onTap: () => showCalender(
              context: context,
              firstDate: DateTime.now(),
              setDateOnCallBack: (date) {
                // setState(() {
                itemDetail.startDate = date;
                // });

                _expandChild = false;

                _valueNotifier.notifyListeners();
              },
            ),
        icon: ImgName.calender,
        context: context,
        date: itemDetail.startDate == null
            ? StaticString.date
            : StaticString.formatter
                .format(itemDetail.startDate ?? DateTime.now()));
  }

  ///  Service start time
  Widget _buildStartTime(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
      onTap: _startTime,
      icon: ImgName.clock,
      context: context,
      date: itemDetail.serviceStartTime.isEmpty
          ? StaticString.startTime
          : itemDetail.serviceStartTime,
    );
  }

  ///  Service end time
  Widget _buildEndTime(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
      onTap: _endTime,
      icon: ImgName.clock,
      context: context,
      date: itemDetail.serviceEndTime.isEmpty
          ? StaticString.endTime
          : itemDetail.serviceEndTime,
    );
  }

  /// Service in date
  Widget _buildDateService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          txtTitle: StaticString.selectDate,
          style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 9,
        ),

        ///Start , End Date And check Price Button
        _buildStartAndEndDateAndcheckPriceButton(getContext),
        // const SizedBox(
        //   height: 20,
        // ),
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => ExpandChild(
            expand: _expandChild,
            child: const SizedBox(
              height: 20,
            ),
          ),
        ),

        /// item Detail

        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) =>
              itemDetail.startDate == null || itemDetail.endDate == null
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
      ],
    );
  }

  ///Start , End Date And check Price Button
  Widget _buildStartAndEndDateAndcheckPriceButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (context, val, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Start date
              _buildStartDate(context),
              const SizedBox(
                width: 10,
              ),

              /// end Date
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
          // setState(() {
          itemDetail.startDate = date;
          itemDetail.endDate = null;
          _expandChild = false;
          // });

          _valueNotifier.notifyListeners();
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
        focusedDay: itemDetail.startDate?.add(Duration(hours: 24)),
        firstDate: itemDetail.startDate?.add(Duration(hours: 24)),
        currentDate: itemDetail.endDate,
        selectedDay: itemDetail.endDate ??
            itemDetail.startDate?.add(Duration(hours: 24)),
        setDateOnCallBack: (date) {
          _expandChild = false;
          // setState(() {
          // if ((daysBetween(
          //             from: (itemDetail.startDate ?? DateTime.now()),
          //             to: (date))) >
          //         (itemDetail.maxDuration ?? 0) &&
          //     itemDetail.getEnumForDayAndHourly == ServiceType.Day) {
          //   Get.showSnackbar(GetSnackBar(
          //     // title: "Your account is created successfully",
          //     message:
          //         "You can book this item for maximume ${itemDetail.maxDuration} days",
          //     duration: const Duration(seconds: 2),
          //   ));
          //   return;
          // } else
          if (hoursBetween(itemDetailModel: itemDetail) >
                  (itemDetail.maxDuration ?? 0) &&
              itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
            Get.showSnackbar(GetSnackBar(
              // title: "Your account is created successfully",
              message:
                  "You can book this item for maximume ${itemDetail.maxDuration} days",
              duration: const Duration(seconds: 2),
            ));
            return;
          }

          itemDetail.endDate = date;

          // });
          _valueNotifier.notifyListeners();
        },
      ),
      icon: ImgName.calender,
      context: context,
      date: itemDetail.endDate == null
          ? StaticString.endDate
          : StaticString.formatter.format(
              itemDetail.endDate ?? DateTime.now(),
            ),
    );
  }

  /// Check Price Button
  Widget _buildCheckPrice() {
    return CustomButton(
      onPressed: _checkPrice,
      buttonHeight: 32,
      buttonWidth: 80,
      buttonTitle: StaticString.checkPrice,
      textStyle: Theme.of(getContext)
          .textTheme
          .overline
          ?.copyWith(color: Colors.white),
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
        if (itemDetail.getEnumForDayAndHourly != ServiceType.Rented)
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

  //!-------------------Button Action------------------

  void _checkPrice() {
    int startTimeT =
        ((selectStartTime?.hour ?? 0) * 60) + (selectStartTime?.minute ?? 0);
    int endTimeT =
        ((selectedEndTime?.hour ?? 0) * 60) + (selectedEndTime?.minute ?? 0);

    bool valideTime = (endTimeT - startTimeT) >= 60;

    if (itemDetail.getEnumForDayAndHourly == ServiceType.Day &&
        (itemDetail.startDate == null || itemDetail.endDate == null)) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date.",
        duration: Duration(seconds: 2),
      ));
      return;
    } else if (itemDetail.getEnumForDayAndHourly == ServiceType.Hourly &&
        (itemDetail.startDate == null ||
            itemDetail.serviceStartTime.isEmpty ||
            itemDetail.serviceEndTime.isEmpty)) {
      String message1 = "Please select date and time.";

      if (itemDetail.startDate == null &&
          itemDetail.serviceStartTime.isEmpty &&
          itemDetail.serviceEndTime.isEmpty) {
        message1 = "Please select date and time.";
      } else if (itemDetail.startDate == null) {
        message1 = "Please select date.";
      } else if (itemDetail.serviceStartTime.isEmpty) {
        message1 = "Please select start date.";
      } else if (itemDetail.serviceEndTime.isEmpty) {
        message1 = "Please select end date.";
      }

      Get.showSnackbar(
        GetSnackBar(
          // title: "Your account is created successfully",
          message: message1,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    // if (((itemDetail.startDate == null || itemDetail.endDate == null) &&
    //     itemDetail.getEnumForDayAndHourly == ServiceType.Day)) {
    //   return;
    // }

    if (itemDetail.startDate == null &&
        itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date",
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (((hoursBetween(
                  itemDetailModel: itemDetail,
                ) /
                60) <=
            0) &&
        itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "End time must be greater than start time.",
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (!valideTime &&
        itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(
        const GetSnackBar(
          // title: "Your account is created successfully",
          message: "At least 1 hour has to be selected.",
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // setState(() {
    productQuntity = dropdownValue;
    _expandChild = true;
    _valueNotifier.notifyListeners();
    // });
  }

  void _startTime() async {
    selectStartTime = await showTimePicker(
      context: getContext,
      initialTime: startTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    final date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime? selectedDate;

    if (itemDetail.startDate != null) {
      selectedDate = DateTime(itemDetail.startDate!.year,
          itemDetail.startDate!.month, itemDetail.startDate!.day);
    }

    if (selectedDate == date) {
      if (((selectStartTime?.hour ?? 0) < TimeOfDay.now().hour) ||
          (((selectStartTime?.hour ?? 0) == TimeOfDay.now().hour) &&
              ((selectStartTime?.minute ?? 0) <= TimeOfDay.now().minute))) {
        Get.showSnackbar(
          const GetSnackBar(
            message: "Start time should be greater than current time.",
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    _expandChild = false;
    if (selectStartTime != null && selectStartTime != startTime) {
      itemDetail.serviceStartTime =
          "${selectStartTime?.hour}:${selectStartTime?.minute.toString().length == 1 ? "0${selectStartTime?.minute}" : selectStartTime?.minute}:00";

      itemDetail.serviceEndTime = "";
    }
    _valueNotifier.notifyListeners();
  }

  void _endTime() async {
    selectedEndTime = await showTimePicker(
      context: getContext,
      initialTime: endTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    _expandChild = false;
    if (selectedEndTime != null && selectedEndTime != endTime) {
      itemDetail.serviceEndTime =
          "${selectedEndTime?.hour}:${selectedEndTime?.minute.toString().length == 1 ? "0${selectedEndTime?.minute}" : selectedEndTime?.minute}:00";
    }
    _valueNotifier.notifyListeners();
  }

  Future<void> _rentButton() async {
    bool permissionGranted = await locationDialogueIfLocationIsDisale();

    if (!permissionGranted) return;

    int startTimeT =
        ((selectStartTime?.hour ?? 0) * 60) + (selectStartTime?.minute ?? 0);
    int endTimeT =
        ((selectedEndTime?.hour ?? 0) * 60) + (selectedEndTime?.minute ?? 0);

    bool valideTime = (endTimeT - startTimeT) >= 60;

    if (itemDetail.getEnumForDayAndHourly == ServiceType.Day &&
        (itemDetail.startDate == null || itemDetail.endDate == null)) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date.",
        duration: Duration(seconds: 2),
      ));
      return;
    } else if (itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      DateTime? selectedDate;
      final date = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      if (itemDetail.startDate != null) {
        selectedDate = DateTime(itemDetail.startDate!.year,
            itemDetail.startDate!.month, itemDetail.startDate!.day);
      }

      if (itemDetail.startDate == null ||
          itemDetail.serviceStartTime.isEmpty ||
          itemDetail.serviceEndTime.isEmpty) {
        String message1 = "Please select date and time.";

        if (itemDetail.startDate == null &&
            itemDetail.serviceStartTime.isEmpty &&
            itemDetail.serviceEndTime.isEmpty) {
          message1 = "Please select date and time.";
        } else if (itemDetail.startDate == null) {
          message1 = "Please select date.";
        } else if (itemDetail.serviceStartTime.isEmpty) {
          message1 = "Please select start time.";
        } else if (itemDetail.serviceEndTime.isEmpty) {
          message1 = "Please select end time.";
        }
        //
        // else if (selectedDate == date &&
        //     (((selectStartTime?.hour ?? 0) < TimeOfDay.now().hour) ||
        //     (((selectStartTime?.hour ?? 0) == TimeOfDay.now().hour) &&
        //         ((selectStartTime?.minute ?? 0) <= TimeOfDay.now().minute)))) {
        //   message1 = "Start time should be greater than current time.";
        // debugPrint('true');
        // }

        Get.showSnackbar(
          GetSnackBar(
            // title: "Your account is created successfully",
            message: message1,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    if (((hoursBetween(
                  itemDetailModel: itemDetail,
                ) /
                60) <=
            0) &&
        itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(
        const GetSnackBar(
          // title: "Your account is created successfully",
          message: "End time must be greater than start time.",
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!valideTime &&
        itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(
        const GetSnackBar(
          // title: "Your account is created successfully",
          message: "At least 1 hour has to be selected.",
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Get.toNamed("CheckoutScreen", arguments: itemDetail);
  }

  void _chatWithLenderButton() {
    Get.find<ChatController>()
        .createChatInFirebase(itemDetailModel: itemDetail);

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
