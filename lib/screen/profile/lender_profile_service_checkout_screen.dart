import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import '../../cards/total_payment_card.dart';
import '../../controller/chat_controller.dart';
import '../../controller/lend_controller.dart';
import '../../models/item_detail_model.dart';
import '../../widgets/calender_dialog.dart';
import '../../widgets/common_functions.dart';
import '../../widgets/expand_child.dart';
import '../../widgets/review_card.dart';
import '../../widgets/rich_text.dart';
import '../chat/chat_screen.dart';
import '../payment/pay_with_screen.dart';
import '/main.dart';
import '/screen/request/my_request_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/spinner.dart';
import '/constants/img_font_color_string.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_text.dart';
import '../../controller/auth_controller.dart';
import '../../controller/social_signin_controller.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/image_picker.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';

// ItemDetailModel itemDetailModel = ItemDetailModel();

PickImageOption? _pickImageOption = PickImageOption.gallery;

class LenderProfileServiceCheckoutScreen extends GetView<LendController> {
  final ItemDetailModel itemDetail;

  LenderProfileServiceCheckoutScreen({Key? key, required this.itemDetail})
      : super(key: key) {
    final paymentController = Get.find<PaymentController>();
    paymentController.getUserCards(getContext);
  }

//   @override
//   State<ViewProfileScreen> createState() => _ViewProfileScreenState();
// }

// class _ViewProfileScreenState extends State<ViewProfileScreen> {
//!------------------------------ Variable ------------------------------

  UserInfoModel _userInfo = UserInfoModel(
    authType: AuthType.UpdateProfile,
  );
  File? compressFile;
  Directory? directory;
  String? targetPath;
  final ValueNotifier _imageNotifier = ValueNotifier(true);
  final _paymentController = Get.find<PaymentController>();

  bool _expandChild = false;

  int dropdownValue = 0;
  int productQuntity = 0;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime, selectStartTime;

  final ValueNotifier _valueNotifier = ValueNotifier(true);
  final ValueNotifier _initialNotify = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.profile,
        bgColor: primaryColor,
        backButtonColor: Colors.white,
        isBackButton: true,
        centerTitle: false,
        titleColor: custWhiteFFFFFF,
      ),
      body: GetBuilder<AuthController>(builder: (auth) {
        return Obx(() {
          return controller.loadingLenderProfile.value
              ? Spinner()
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: _buildStackAndEdit(context),
                );
        });
      }),
    );
  }

  ///Background , Profile Image An Edit button
  Widget _buildStackAndEdit(BuildContext context) {
    if (controller.lenderProfile.value != null) {
      debugPrint('name is ${controller.lenderProfile.value!.name}');
      return Stack(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: primaryColor,
          ),

          //Profile Image

          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: _buildUserInformation(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// User Image
                ValueListenableBuilder(
                    valueListenable: _imageNotifier,
                    builder: (context, val, child) => _buildUserImage()),

                const SizedBox(
                  width: 23,
                ),
                _buildUserProfileAndPriceRow(context),
              ],
            ),
          ),
        ],
      );
    } else {
      return const Center(child: Text('Error Occurred'));
    }
  }

  /// User Image
  Widget _buildUserImage() {
    return Obx(() {
      return Stack(
        children: [
          const SizedBox(
            height: 84,
            width: 84,
          ),

          /// User Image
          if (controller.loadingLenderProfile.value)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Spinner(),
            )
          else if (controller.lenderProfile.value != null)
            GestureDetector(
              onTap: () {
                zoomablePhotoDialogue(
                    imageUrl: controller.lenderProfile.value!.profileImage);
              },
              child: CustImage(
                imgURL: controller.lenderProfile.value!.profileImage,
                width: 80,
                height: 80,
                cornerRadius: 20,
                errorImage: ImgName.profileImage,
                // backgroundColor: Colors.grey.withOpacity(0.5),
              ),
            ),
        ],
      );
    });
  }

  /// total Balance

  Widget _buildUserProfileAndPriceRow(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          bottom: 5,
        ),
        child: Row(
          children: [
            Spacer(),
            CustImage(
              imgURL: ImgName.tick,
              imgColor: custMaterialPrimaryColor,
              height: 20,
              width: 20,
            ),
            const SizedBox(
              width: 6,
            ),
            CustomText(
              txtTitle:
                  '${controller.lenderProfile.value!.jobsDone ?? '0'} Services Done',
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: custBlack102339,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Spacer(),
            CustomRichText(
              title: "#\$" + (getDailyOrHourlyRate() ?? ""),
              normalTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                    color: custBlack102339,
                    fontWeight: FontWeight.w600,
                  ),
              fancyTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                    color: custMaterialPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  String? getDailyOrHourlyRate() {
    if (itemDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      return '${double.parse(itemDetail?.ratePerHour ?? "0.0").toString()}/hr';
    } else {
      return '${double.parse(itemDetail?.ratePerDay ?? "0").toString()}/day';
    }
  }

  /// Edit button
  Widget _rate(BuildContext context) {
    return Row(
      children: [
        CustomText(
          txtTitle: '\$24',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: primaryColor),
        ),
        const CustomText(txtTitle: '/hr'),
      ],
    );
  }

  /// User Info
  Widget _buildUserInformation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: custWhiteFFFFFF,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.00),
          topRight: Radius.circular(20.00),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 56,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// User Name
                  Row(
                    children: [
                      CustomText(
                        txtTitle: controller.lenderProfile.value!.name,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ///User Email
                  Visibility(
                    visible: controller.lenderProfile.value!.email.isNotEmpty,
                    child: CustomText(
                      txtTitle: controller.lenderProfile.value!.email,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: cust87919C,
                          ),
                    ),
                  ),
                  Visibility(
                    visible: controller.lenderProfile.value!.email.isNotEmpty,
                    child: const SizedBox(
                      height: 16,
                    ),
                  ),

                  /// location
                  Visibility(
                    visible: controller.lenderProfile.value!.address.isNotEmpty,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CustomText(
                        maxLine: 2,
                        textOverflow: TextOverflow.ellipsis,
                        txtTitle: controller.lenderProfile.value!.address,
                        // txtTitle: userInfo.location,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.lenderProfile.value!.address.isNotEmpty,
                    child: const SizedBox(
                      height: 30,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    txtTitle: 'Service Name:',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    txtTitle: itemDetail.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: custBlack102339WithOpacity),
                  ),
                ],
              )
            ],
          ),

          /// About me text
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: StaticString.aboutMe,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// About me
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: CustomText(
              txtTitle: controller.lenderProfile.value!.info,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: controller.lenderProfile.value!.info.isNotEmpty,
            child: const SizedBox(
              height: 30,
            ),
          ),

          _buildWidget(itemDetail.getEnumForDayAndHourly),
          const SizedBox(
            height: 20.00,
          ),

          /// Pay With
          _buildPaymentWith(context),

          lenderEmailid(
            context: context,
            title: StaticString.emailID,
            email: itemDetail.lenderInfoModel?.email ?? "",
          ),

          const SizedBox(
            height: 40,
          ),
          //Rent And Chat with lender button
          Visibility(
            visible: itemDetail.lenderInfoModel?.id !=
                getAuthController?.getUserInfo.id,
            child: _buildRentAndChatButton(),
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
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

  void _selectCard() {
    debugPrint(
        "**************************************** Select Card ***************************");
    Get.toNamed("SelectCardScreen");
    // Get.to(SelectCardScreen());
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
                  height: 2.0));
        }
      },
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

    debugPrint(
        "****************************** Check Price *****************************");
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
