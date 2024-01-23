import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:renting_app_mobile/cards/job_offer_card.dart';
import 'package:renting_app_mobile/cards/no_offers_card.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';

import '../../cards/total_payment_card.dart';
import '../../controller/auth_controller.dart';
import '../../controller/chat_controller.dart';
import '../../controller/payment_controller.dart';
import '../../models/user_model.dart';
import '../../utils/location_util.dart';
import '../../widgets/calender_dialog.dart';
import '../../widgets/common_functions.dart';
import '../../widgets/custom_dropdown1.dart/cust_focus_menu.dart';
import '../../widgets/custom_dropdown1.dart/custom_dropdown.dart';
import '../../widgets/expand_child.dart';
import '../../widgets/review_card.dart';
import '../../widgets/rich_text.dart';
import '../chat/chat_screen.dart';
import '../profile/lender_profile_service_checkout_screen.dart';
import '/utils/custom_enum.dart';
import '/widgets/cust_button.dart';
import '../../constants/img_font_color_string.dart';
import '../../controller/lend_controller.dart';
import '../../main.dart';
import '../../models/item_detail_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/spinner.dart';

class ServiceStatusScreen extends StatefulWidget {
  const ServiceStatusScreen({Key? key}) : super(key: key);

  @override
  State<ServiceStatusScreen> createState() => _ServiceStatusScreenState();
}

class _ServiceStatusScreenState extends State<ServiceStatusScreen> {
  //!------------------------ variable------------------
  List<String> selectedMenu = [];
  final List<String> _sortList = [
    "New",
    "Accepted",
    "Hired",
    "Declined",
    "Disputed"
  ];

  String dropdownvalue = "New";

  ValueNotifier _valueNotifier = ValueNotifier(true);

  /* LendController lendController = Get.find<LendController>();

  ItemDetailModel itemDetail = ItemDetailModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final ServiceDetailModel itemDetail =
  //     serviceDetailModelFromJson(json.encode(serviceDetailJson));

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _maxPriceController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  bool _isChecked = true;
  int dropdownValue = 0;
  List<int> noOfDays = [
    1,
    2,
    3,
    4,
    5,
  ];

  int id = Get.arguments;

  // Future fetchData() async {
  //   try {
  //     await lendController.fetchItemDetail(context: getContext, id: id);
  //     itemDetail = lendController.itemDetail.value;
  //
  //     setState(() {});
  //   } catch (e) {
  //     showAlert(context: context, message: e);
  //   }
  // }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _maxPriceController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        /// service name
        title: itemDetail.name,
      ),
      body: SafeArea(
        child: GetBuilder<LendController>(builder: (val) {
          return lendController.iDetailLoading.value
              ? Spinner()
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
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
                                itemDetail.getFirstImageModel?.imageUrl ?? "",
                            image2: itemDetail.getSecondImageModel?.imageUrl,
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          /// service name
                          productNameAndDuration(
                            context: context,
                            name: itemDetail.name,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          /// Category text
                          categoryText(
                              context: context,
                              category: itemDetail.category?.name ?? ""),
                          const SizedBox(
                            height: 14,
                          ),

                          itemOrServiceTagAndPriceText(
                            context: context,
                            itemOrServices:
                                itemDetail.category?.type.name ?? "",
                            price:
                                "Per ${itemDetail.getEnumForDayAndHourly == ServiceType.Day ? "Day" : "Hour"} : \$${itemDetail.getEnumForDayAndHourly == ServiceType.Day ? itemDetail.ratePerDay : itemDetail.ratePerHour}",
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          ///Location detail
                          location(
                              context: context, location: itemDetail.address),
                          const SizedBox(
                            height: 16,
                          ),

                          /// service Detail
                          description(
                            context: context,
                            description: itemDetail.description,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _buildWidget(itemDetail.getEnum),

                          /// Delete Button

                          _buildDeleteButton(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }

//!------------------------------------widget--------------------------------

  /// title and subtitle
  Widget _buildTitleAndSubtitle({
    required BuildContext context,
    required String title,
    required String subTitle,
  }) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            txtTitle: title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomText(
            txtTitle: subTitle,
            style: Theme.of(context).textTheme.headline1?.copyWith(
                fontWeight: FontWeight.w600, color: custBlack102339WithOpacity),
          )
        ],
      ),
    );
  }

  /// build widget by service Status
  Widget _buildWidget(ItemAndServiceStatus serviceType) {
    Widget? child;
    switch (serviceType) {
      case ItemAndServiceStatus.Rented:
        var duration;

        // if ((itemDetail.rent?.startTime ?? true) == "") {
        //   duration = DateTime.parse(itemDetail.rent?.startDate ?? "")
        //       .difference(DateTime.parse(itemDetail.rent?.endDate ?? ""))
        //       .inDays;
        // } else {
        //   duration = DateTime.parse((itemDetail.rent?.startTime) ?? "")
        //       .difference(DateTime.parse(itemDetail.rent?.endTime ?? ""))
        //       .inHours;
        // }
        child = Column(
          children: [
            ///Price And Max. Price text form field
            // Row(
            //   children: [
            //     _buildTitleAndSubtitle(
            //       context: context,
            //       title: StaticString.totalPayment,
            //       subTitle: "\$${itemDetail.getTotalPayment}",
            //     ),
            //     _buildTitleAndSubtitle(
            //         context: context,
            //         title: StaticString.maxTerm,
            //         // subTitle: "",
            //         subTitle:
            //             "${itemDetail.maxDuration} ${itemDetail.getEnumForDayAndHourly == ServiceType.Day ? "Days" : "Hours"}"),
            //   ],
            // ),
            const SizedBox(
              height: 29.51,
            ),

            /// Email id text
            lenderEmailid(
              context: context,
              title: StaticString.rentedBy,
              email: itemDetail.rent?.rentedBy ?? "",
            ),
            const SizedBox(
              height: 36,
            )
          ],
        );
        break;
      case ItemAndServiceStatus.Available:
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            // CustomText(
            //   txtTitle: StaticString.price,
            //   style: Theme.of(context).textTheme.bodyText1?.copyWith(
            //         fontWeight: FontWeight.w600,
            //       ),
            // ),
            // const SizedBox(
            //   height: 9,
            // ),
            // _builddaysDropdownAndCheckPriceButton(
            // price: double.parse(itemDetail.getPrice),
            // ),

            /// Price & condition
            _buildPriceAndConditionCheckBox(),

            const SizedBox(
              height: 30,
            ),
          ],
        );
        break;
    }
    return child;
  }

  /// Price  & condition Check Box
  Widget _buildPriceAndConditionCheckBox() {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isChecked = !_isChecked;
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            checkColor: Colors.white,
            value: _isChecked,
            onChanged: (val) {
              setState(
                () {
                  _isChecked = val ?? false;
                },
              );
            },
          ),
          CustomText(
            txtTitle: StaticString.tapToAgreeToOurTermsAndConditions,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: custBlack102339.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }

  /// Cancel Button
  Widget _buildDeleteButton() {
    return Obx(() {
      return Center(
        child: CustomButton(
          loadingIndicator: lendController.loadingItemDelete.value,
          buttonTitle: StaticString.delete,
          onPressed: itemDetail.getEnum == ItemAndServiceStatus.Rented
              ? () {}
              : () => _deleteButton(id: id),
        ),
      );
    });

    //  InkWell(
    //   onTap: itemDetail.getEnum == ItemAndServiceStatus.Rented
    //       ? null
    //       : _deleteButton,
    //   child: Container(
    //     margin: const EdgeInsets.symmetric(
    //       horizontal: 63,
    //     ),
    //     alignment: Alignment.center,
    //     height: 44,
    //     decoration: BoxDecoration(
    //       boxShadow: [
    //         BoxShadow(
    //             color: itemDetail.getEnum == ItemAndServiceStatus.Rented
    //                 ? Color.fromRGBO(172, 172, 172, 0.2)
    //                 : Color.fromRGBO(2, 149, 125, 0.15),
    //             blurRadius: 20.0,
    //             offset: Offset(5, 5)),
    //       ],
    //       color: itemDetail.getEnum == ItemAndServiceStatus.Rented
    //           ? custC9CBCE
    //           : primaryColor,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: const CustomText(
    //       txtTitle: StaticString.delete,
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontWeight: FontWeight.w600,
    //         fontSize: 16,
    //       ),
    //     ),
    //   ),
    // );
  }

  // day dropdown and check price button
  Widget _builddaysDropdownAndCheckPriceButton() {
    return Row(
      children: [
        // Price DropDown
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: custBlack102339.withOpacity(0.1),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    CustImage(
                      imgURL: ImgName.dayIcon,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      txtTitle: StaticString.selectDuration,
                      style: TextStyle(
                        color: custBlack102339.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              focusColor: Colors.white,
              value: dropdownValue == 0 ? null : dropdownValue,
              icon: Padding(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 10,
                  ),
                  child: CustImage(
                    imgURL: ImgName.dropDownIcon,
                  )),

              // elevation: 16,
              style: TextStyle(
                color: custBlack102339.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              // underline: Container(
              //   height: 2,
              //   color: Colors.deepPurpleAccent,
              // ),
              onChanged: (int? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: noOfDays.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CustImage(
                        imgURL: ImgName.dayIcon,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        txtTitle:
                            "${value.toString()} ${double.parse((itemDetail.rent?.rentPerHour ?? "0.0").isEmpty ? "0.0" : (itemDetail.rent?.rentPerHour ?? "0.0")) > 0.0 ? "Hours" : "days"}",
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          width: 13,
        ),
        // Check Price Button
        _buildCheckPrice(),
      ],
    );
  }

  /// Check Price Button
  Widget _buildCheckPrice() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(100, 36),
      ),
      onPressed: _checkPrice,
      child: CustomText(
        txtTitle: StaticString.checkPrice,
        style:
            Theme.of(context).textTheme.overline?.copyWith(color: Colors.white),
      ),
    );
  }

  //!--------------------- button Action----------------
  void _deleteButton({required int id}) {
    if (!_isChecked) {
      Get.showSnackbar(
        const GetSnackBar(
          message: AlertMessageString.termsAndConditionsAggreement,
          duration: Duration(seconds: 1),
        ),
      );

      return;
    }
    debugPrint(
        "********************************* Delete ***************************");
    showAlert(
        signleBttnOnly: false,
        context: getContext,
        title: "Delete Service",
        message: StaticString.itemDeleteAlertMsg,
        rigthBttnTitle: StaticString.delete,
        leftBttnTitle: StaticString.cancel,
        onRightAction: () async {
          try {
            await lendController.deleteItemAndService(context: context, id: id);
          } catch (e) {
            showAlert(context: getContext, message: e);
          } finally {
            // await itemController.fetchMyItems(
            //   context: context,
            //   onTap: true,
            // );
            Get.back();
          }
        });
  }

  void _checkPrice() {
    debugPrint(
        "****************************** Check Price *****************************");
    // setState(() {
    //   // productQuntity = dropdownValue;
    // });
  }*/

  int id = Get.arguments;
  LendController lendController = Get.find<LendController>();

  ItemDetailModel serviceDetail = ItemDetailModel();

  Future fetchData() async {
    try {
      await lendController.fetchItemDetail(context: getContext, id: id);
      if (!mounted) return;
      await jobOfferController.getJobOffersByService(getContext, id.toString());
      serviceDetail = lendController.itemDetail.value;

      setState(() {});
    } catch (e) {
      showAlert(context: context, message: e);
    }
  }

  File? compressFile;
  Directory? directory;
  String? targetPath;
  final ValueNotifier _imageNotifier = ValueNotifier(true);
  final _paymentController = Get.find<PaymentController>();
  final jobOfferController = Get.find<JobOfferController>();

  final controller = Get.find<AuthController>();

  bool _expandChild = false;

  int dropdownValue = 0;
  int productQuntity = 0;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime, selectStartTime;

  final ValueNotifier _initialNotify = ValueNotifier(true);
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> onRefresh() async {
    await Get.find<JobOfferController>()
        .getJobOffersByService(getContext, serviceDetail.id.toString());
    _refreshController.loadComplete();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: serviceDetail.name,
        bgColor: primaryColor,
        backButtonColor: Colors.white,
        isBackButton: true,
        centerTitle: false,
        titleColor: custWhiteFFFFFF,
      ),
      body: GetBuilder<LendController>(
        builder: (value) {
          return lendController.iDetailLoading.value
              ? Spinner()
              : GetBuilder<AuthController>(builder: (auth) {
                  return SmartRefresher(
                      physics: BouncingScrollPhysics(),
                      header: const MaterialClassicHeader(),
                      onRefresh: onRefresh,
                      controller: _refreshController,
                      child: _buildStackAndEdit(context));
                });
        },
      ),
    );
  }

  ///Background , Profile Image An Edit button
  Widget _buildStackAndEdit(BuildContext context) {
    if (controller.getUserInfo != null) {
      debugPrint('name is ${controller.getUserInfo.name}');
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
    return Stack(
      children: [
        const SizedBox(
          height: 84,
          width: 84,
        ),

        /// User Image
        if (controller.getUserInfo != null)
          GestureDetector(
            onTap: () {
              zoomablePhotoDialogue(
                  imageUrl: controller.getUserInfo!.profileImage);
            },
            child: CustImage(
              imgURL: controller.getUserInfo!.profileImage,
              width: 80,
              height: 80,
              cornerRadius: 20,
              errorImage: ImgName.profileImage,
              // backgroundColor: Colors.grey.withOpacity(0.5),
            ),
          ),
      ],
    );
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
                  '${controller.getUserInfo!.jobsDone ?? 0} Services Done',
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
    if (serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      return '${double.parse(serviceDetail.ratePerHour ?? "0.0").toString()}/hr';
    } else {
      return '${double.parse(serviceDetail.ratePerDay ?? "0").toString()}/day';
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// User Name
                    Row(
                      children: [
                        CustomText(
                          txtTitle: controller.getUserInfo.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ///User Email
                    Visibility(
                      visible: controller.getUserInfo.email.isNotEmpty,
                      child: CustomText(
                        txtTitle: controller.getUserInfo.email,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: cust87919C,
                            ),
                      ),
                    ),
                    Visibility(
                      visible: controller.getUserInfo.email.isNotEmpty,
                      child: const SizedBox(
                        height: 16,
                      ),
                    ),

                    /// location
                    // Visibility(
                    //   visible: controller.getUserInfo.address.isNotEmpty,
                    //   child: SizedBox(
                    //     width: MediaQuery.of(context).size.width / 2,
                    //     child: CustomText(
                    //       maxLine: 2,
                    //       textOverflow: TextOverflow.ellipsis,
                    //       txtTitle: controller.getUserInfo.address,
                    //       // txtTitle: userInfo.location,
                    //       style:
                    //           Theme.of(context).textTheme.bodySmall?.copyWith(
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //     ),
                    //   ),
                    // ),

                    FutureBuilder<String>(
                      future: getLocalitySubLocality(controller.getUserInfo.latitude, controller.getUserInfo.longitude),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return CustomText(
                            maxLine: 2,
                            textOverflow: TextOverflow.ellipsis,
                            txtTitle: snapshot.data,
                            // txtTitle: userInfo.location,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: custBlack102339WithOpacity),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    Visibility(
                      visible: controller.getUserInfo.address.isNotEmpty,
                      child: const SizedBox(
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// About me text
          Visibility(
            visible: controller.getUserInfo.info.isNotEmpty,
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
            visible: controller.getUserInfo.info.isNotEmpty,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// About me
          Visibility(
            visible: controller.getUserInfo.info.isNotEmpty,
            child: CustomText(
              txtTitle: controller.getUserInfo.info,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: controller.getUserInfo!.info.isNotEmpty,
            child: const SizedBox(
              height: 30,
            ),
          ),

          Visibility(
            visible: serviceDetail.moreInfo.isNotEmpty,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: 'More Information',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: serviceDetail.moreInfo.isNotEmpty,
            child: const SizedBox(
              height: 10,
            ),
          ),

          /// More Info
          Visibility(
            visible: serviceDetail.moreInfo.isNotEmpty,
            child: CustomText(
              txtTitle: serviceDetail.moreInfo,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: serviceDetail.moreInfo.isNotEmpty,
            child: const SizedBox(
              height: 30,
            ),
          ),

          /// Service name
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                txtTitle: 'Service Name:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                txtTitle: serviceDetail.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: custBlack102339WithOpacity),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          /// Job Offers
          Row(

            children: [
              CustomText(
                txtTitle: 'Job Offers (${jobOfferController.jobOffers.length}):',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              CustomText(
                txtTitle: StaticString.sortby,
                style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custBlack102339.withOpacity(0.3),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (context, val, child) {
                  return SizedBox(
                    height: 14,
                    width: 70,
                    child: DropdownButton<String>(
                      // menuMaxHeight: 300,
                      value: dropdownvalue,
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
                                  color: dropdownvalue == items
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
                  );
                },
              )
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // JobOfferCard(
          //     jobOfferModel: JobOfferModel(
          //         renter: UserInfoModel(authType: AuthType.None),
          //         startDate: DateTime.now(),
          //         startTime: DateTime.now(),
          //         description: 'info',
          //         maxHours: 8,
          //         serviceProvider: UserInfoModel(authType: AuthType.None)))

          Obx(() => jobOfferController.jobOffers.isNotEmpty
              ? Expanded(
                  flex: 2,
                  child : ListView.builder(
                    shrinkWrap: true,
                    itemCount: jobOfferController.jobOffers.length,
                    itemBuilder: (context, index) => JobOfferCard(
                      jobOfferModel: jobOfferController.jobOffers[index],
                      service: serviceDetail,
                    ),
                  ),
                )
              : const NoOffersCard()),

          // Visibility(
          //   visible: controller.getUserInfo.info.isNotEmpty,
          //   child: Row(
          //     children: [
          //       CustomText(
          //         textOverflow: TextOverflow.ellipsis,
          //         txtTitle: StaticString.reviews,
          //         style: Theme.of(context)
          //             .textTheme
          //             .bodySmall
          //             ?.copyWith(fontWeight: FontWeight.w500),
          //       ),
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       InkWell(
          //         onTap: () {
          //           lendController.setFullReviewVisibility();
          //         },
          //         child: CustomText(
          //           textOverflow: TextOverflow.ellipsis,
          //           txtTitle: lendController.showFullReviews.value
          //               ? 'Show Less'
          //               : 'Show All',
          //           style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //                 fontWeight: FontWeight.w500,
          //                 color: primaryColor,
          //               ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //
          // if (controller.getUserInfo.reviews != null &&
          //     controller.getUserInfo.reviews!.isNotEmpty)
          //   if (lendController.showFullReviews.value)
          //     ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: controller.getUserInfo.reviews!.length,
          //       itemBuilder: (context, index) {
          //         return ReviewCard(
          //           review: controller.getUserInfo.reviews![index],
          //         );
          //       },
          //     )
          //   else if (controller.getUserInfo.reviews!.length > 2)
          //     ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: controller.getUserInfo.reviews!.length,
          //       itemBuilder: (context, index) {
          //         return ReviewCard(
          //           review: controller.getUserInfo.reviews![index],
          //         );
          //       },
          //     )
          //   else
          //     ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: controller.getUserInfo.reviews!.length,
          //       itemBuilder: (context, index) {
          //         return ReviewCard(
          //           review: controller.getUserInfo.reviews![index],
          //         );
          //       },
          //     )
          // else
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'No reviews given',
          //       style: Theme.of(context).textTheme.bodySmall,
          //     ),
          //   ),
        ],
      ),
    );
  }

  void _sort(String sortType) {
    debugPrint(
        "**************************************** Sort $sortType ************************************");

    dropdownvalue = sortType;
    jobOfferController.sortOffers(sortType);

    _valueNotifier.notifyListeners();
  }




}
