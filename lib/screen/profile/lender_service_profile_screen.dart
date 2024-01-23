import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';
import 'package:renting_app_mobile/models/service_chat_key.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import 'package:renting_app_mobile/widgets/custom_disabled_button.dart';
import '../../cards/total_payment_card.dart';
import '../../controller/chat_controller.dart';
import '../../controller/lend_controller.dart';
import '../../models/item_detail_model.dart';
import '../../utils/date_time_util.dart';
import '../../utils/location_util.dart';
import '../../widgets/calender_dialog.dart';
import '../../widgets/common_functions.dart';
import '../../widgets/expand_child.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/rich_text.dart';
import '../chat/chat_screen.dart';
import '../payment/pay_with_screen.dart';
import '/main.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/spinner.dart';
import '/constants/img_font_color_string.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_text.dart';
import '../../controller/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';
import 'lender_profile_screen.dart';
import '/controller/request_controller.dart';

PickImageOption? _pickImageOption = PickImageOption.gallery;

class LenderServiceProfileScreen extends GetView<LendController> {
  final ItemDetailModel serviceDetail;

  LenderServiceProfileScreen({Key? key, required this.serviceDetail})
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
  final _jobOfferController = Get.find<JobOfferController>();
  RefreshController _refreshController = RefreshController();

  bool _expandChild = false;

  int dropdownValue = 0;
  int productQuntity = 0;
  DateTime? startDate;
  DateTime? startTime;
  TimeOfDay endTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime, selectStartTime;

  final ValueNotifier _valueNotifier = ValueNotifier(true);
  final ValueNotifier _initialNotify = ValueNotifier(true);

  final _q1Controller = TextEditingController();
  final _q2Controller = TextEditingController();
  final _q3Controller = TextEditingController();

  final _maxHourController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> onRefresh() async {
    await Get.find<JobOfferController>()
        .checkSentOffer(getContext, serviceDetail.id.toString());
    _refreshController.loadComplete();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: CustomAppbar(
            title: serviceDetail.name,
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
                  : SmartRefresher(
                      physics: BouncingScrollPhysics(),
                      header: const MaterialClassicHeader(),
                      controller: _refreshController,
                      onRefresh: onRefresh,
                      child: SingleChildScrollView(
                          child: _buildStackAndEdit(context)),
                    );
            });
          }),
        ),
      ),
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
        ),
        child: Row(
          children: [
            const Spacer(),
            Spacer(),
            Column(
              children: [
                CustomRichText(
                  title: "#\$" + (getDailyOrHourlyRate() ?? ""),
                  normalTextStyle:
                      Theme.of(context).textTheme.caption?.copyWith(
                            color: custBlack102339,
                            fontWeight: FontWeight.w600,
                          ),
                  fancyTextStyle: Theme.of(context).textTheme.caption?.copyWith(
                        color: custMaterialPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () {
                    Get.off(LenderProfileScreen());
                  },
                  child: CustomText(
                    textOverflow: TextOverflow.ellipsis,
                    txtTitle: 'View Profile',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? getDailyOrHourlyRate() {
    if (serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      return '${double.parse(serviceDetail?.ratePerHour ?? "0.0").toString()} /hr';
    } else {
      return '${double.parse(serviceDetail?.ratePerDay ?? "0").toString()}/day';
    }
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
                          txtTitle: controller.lenderProfile.value!.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomText(
                      txtTitle: serviceDetail.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: custBlack102339WithOpacity),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    /// location
                    Visibility(
                      visible:
                          controller.lenderProfile.value!.longitude != null &&
                              controller.lenderProfile.value!.latitude != null,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Row(
                          children: [
                            CustImage(
                              imgURL: ImgName.locationPlain,
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            FutureBuilder<String>(
                              future: getLocalitySubLocality(
                                  controller.lenderProfile.value!.latitude,
                                  controller.lenderProfile.value!.longitude),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return CustomText(
                                    maxLine: 2,
                                    textOverflow: TextOverflow.ellipsis,
                                    txtTitle: snapshot.data,
                                    // txtTitle: userInfo.location,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: custBlack102339WithOpacity),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
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
                              '${controller.lenderProfile.value!.jobsDone ?? 0} Service(s) Done',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: custBlack102339WithOpacity),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        CustImage(
                          imgURL: ImgName.user,
                          imgColor: custMaterialPrimaryColor,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        if (controller.lenderProfile.value!.verified != null &&
                            (controller.lenderProfile.value!.verified!
                                    .toLowerCase() ==
                                'clear' || controller.lenderProfile.value!.verified!
                                    .toLowerCase() ==
                                'jobsclear'))
                          Tooltip(
                            showDuration: const Duration(seconds: 10),
                            triggerMode: TooltipTriggerMode.tap,
                            message: StaticString.verifiedText,
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
                            child: CustomText(
                              txtTitle: 'Verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: primaryColor),
                            ),
                          )
                        else
                          Tooltip(
                            showDuration: const Duration(seconds: 10),
                            triggerMode: TooltipTriggerMode.tap,
                            message: StaticString.notVerifiedText,
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
                            child: CustomText(
                              txtTitle: 'Not Verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: custBlack102339WithOpacity),
                            ),
                          ),
                      ],
                    ),
                    // Visibility(
                    //   visible: controller.lenderProfile.value!.email.isNotEmpty,
                    //   child: const SizedBox(
                    //     height: 16,
                    //   ),
                    // ),

                    // Visibility(
                    //   visible:
                    //       controller.lenderProfile.value!.address.isNotEmpty,
                    //   child: const SizedBox(
                    //     height: 30,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          rentedText(
                context: getContext,
                rentedText:
                    'We will not charge you until after the service has been provided and Service Provider has logged hours worked.',
              ),
          /// More info
          const SizedBox(
            height: 16,
          ),
          _buildPaymentWith(context),
          const SizedBox(
            height: 40,
          ),
          
          Visibility(
            visible: serviceDetail.description.isNotEmpty,
            child: CustomText(
              textOverflow: TextOverflow.ellipsis,
              txtTitle: 'Service Description',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Visibility(
            visible: serviceDetail.description.isNotEmpty,
            child: const SizedBox(
              height: 10,
            ),
          ),
          //
          // /// More Info
          Visibility(
            visible: serviceDetail.description.isNotEmpty,
            child: CustomText(
              txtTitle: serviceDetail.description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: custBlack102339WithOpacity, height: 1.5),
            ),
          ),
          Visibility(
            visible: serviceDetail.description.isNotEmpty,
            child: const SizedBox(
              height: 30,
            ),
          ),
          _buildOfferWidget(context),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 34,
            ),
            child: Row(
              children: [
                Expanded(child: _buildSendOfferButton()),
                const Spacer(),
                Expanded(child: _buildChatButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferWidget(BuildContext context) {
    if(Get.find<AuthController>().guest.value) {
      return const SizedBox();
    }
    return Obx(
      () =>

          _jobOfferController.loadingCheckOffer.value ? Spinner() : Column(
        children: [
          if (_jobOfferController.loadingCheckOffer.value) Spinner() else (_jobOfferController.sentOffer.value != null && 
              (_jobOfferController.sentOffer.value!.status != OfferStatus.Completed))
                  ? _buildAlreadySentOffer(context)
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            textOverflow: TextOverflow.ellipsis,
                            txtTitle: StaticString.jobDescription,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStartDate(context),
                              const SizedBox(
                                width: 10,
                              ),
                              _buildStartTime(context),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 100,
                                height: 35,
                                child: TextFormField(
                                  style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w500, color: custBlack102339WithOpacity),
                                  
                                  controller: _maxHourController,
                                  validator: (val) => val?.validateMaxHours,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 10, top: 16),
                                        hintText: 'Max Hours',
                                        hintStyle: TextStyle(fontWeight: FontWeight.w500, color: custGrey93A2B2,
),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            textOverflow: TextOverflow.visible,
                            txtTitle: StaticString.jobQ1,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            maxLines: 4,
                            controller: _q1Controller,
                            // textInputAction: TextInputAction.next,
                            onSaved: (value) {},
                            validator: (val) => val?.validateDescription,
                            // controller: _moreInfoController,
                            // focusNode: _moreInfoFocusNode,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 20,
                                right: 45,
                                top: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            textOverflow: TextOverflow.visible,
                            txtTitle: StaticString.jobQ2,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            maxLines: 4,
                            controller: _q2Controller,
                            // textInputAction: TextInputAction.next,
                            onSaved: (value) {},
                            validator: (val) => val?.validateDescription,
                            // controller: _moreInfoController,
                            // focusNode: _moreInfoFocusNode,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 20,
                                right: 45,
                                top: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            textOverflow: TextOverflow.visible,
                            txtTitle: StaticString.jobQ3,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            maxLines: 4,
                            controller: _q3Controller,
                            // textInputAction: TextInputAction.next,
                            onSaved: (value) {},
                            validator: (val) => val?.validateDescription,
                            // controller: _moreInfoController,
                            // focusNode: _moreInfoFocusNode,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 20,
                                right: 45,
                                top: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildAlreadySentOffer(BuildContext context) {
    if(Get.find<AuthController>().guest.value) {
      return const SizedBox();
    }
    return Column(
      children: [
        //_buildHireWidget(context),
        Align(
          alignment: Alignment.centerLeft,
          child: Visibility(
              visible: _jobOfferController.sentOffer.value!.status ==
                  OfferStatus.Disputed,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  align: TextAlign.left,
                  txtTitle: 'Disputed by you',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.red),
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Visibility(
              visible: _jobOfferController.sentOffer.value!.status ==
                  OfferStatus.Accepted,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  align: TextAlign.left,
                  txtTitle: 'Offer Accepted',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: primaryColor),
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Visibility(
              visible: _jobOfferController.sentOffer.value!.status ==
                  OfferStatus.Rejected,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  align: TextAlign.left,
                  txtTitle: 'Offer Rejected',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.red),
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Visibility(
              visible: _jobOfferController.sentOffer.value!.status ==
                  OfferStatus.Hired,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  align: TextAlign.left,
                  txtTitle: 'You have hired',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: primaryColor),
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Visibility(
              visible: _jobOfferController.sentOffer.value!.status ==
                  OfferStatus.Logged,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  align: TextAlign.left,
                  txtTitle: 'Hours have been logged',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: primaryColor),
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Visibility(
              visible: _jobOfferController.sentOffer.value!.status ==
                  OfferStatus.Completed,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  align: TextAlign.left,
                  txtTitle: 'Job has been completed',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: primaryColor),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildHireWidget(BuildContext context) {
    if(Get.find<AuthController>().guest.value) {
      return const SizedBox();
    }
    return _jobOfferController.sentOffer.value!.status == OfferStatus.Accepted
        ? Column(
            children: [
              _buildPaymentWith(context),
              const SizedBox(
                height: 40,
              ),
              rentedText(
                context: getContext,
                rentedText:
                    'We will not charge you until after the service has been provided and Service Provider has logged hours worked',
              ),
              const SizedBox(
                height: 20,
              ),
              //       _buildHireAndChatButton(),
              const SizedBox(
                height: 20,
              ),
            ],
          )
        : const SizedBox();
    // (_jobOfferController.sentOffer.value!.status == OfferStatus.Hired ||
    //             _jobOfferController.sentOffer.value!.status ==
    //                 OfferStatus.Logged ||
    //             _jobOfferController.sentOffer.value!.status ==
    //                 OfferStatus.Disputed ||
    //             _jobOfferController.sentOffer.value!.status ==
    //                 OfferStatus.Completed)
    //         ? Column(
    //             children: [
    //               _buildChatWithLenderButton(),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //             ],
    //           )
    //         : const SizedBox();
  }

  Widget _buildChatButton() {
    if(Get.find<AuthController>().guest.value) {
      return const SizedBox();
    }
    return CustomButton(
      onPressed: _chatWithLenderButton,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            txtTitle: 'Chat',
            style: Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          )
        ],
      ),
    );
  }

  Widget _buildSendOfferButton() {

    if(Get.find<AuthController>().guest.value) {
      return const SizedBox();
    }
    debugPrint('job offer status ${_jobOfferController.sentOffer.value?.status}');
    return Obx(
      () => _jobOfferController.loadingCheckOffer.value
          ? const SizedBox()
          : _jobOfferController.sentOffer.value != null
              ?

      // _jobOfferController.sentOffer.value!.status == OfferStatus.Accepted ?
      //     _buildHireButton() :
      _jobOfferController.sentOffer.value != null  &&
          _jobOfferController.sentOffer.value!.status ==
              OfferStatus.Completed ?
      CustomButton(
        // style: ElevatedButton.styleFrom(
        //   fixedSize: const Size(120, 44),
        //   shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
        //   elevation: 10,
        // ),
        loadingIndicator:
        _jobOfferController.loadingSendJobOffer.value,
        onPressed: _sendOfferAction,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              txtTitle: StaticString.sendOffer,
              style:
              Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ) :
      CustomDisabledButton(
                  buttonColor: custGrey,
                  child: CustomText(
                    txtTitle: _jobOfferController.sentOffer.value!.status == OfferStatus.Hired ? 'Hired' : 'Offer has been sent',
                    style: Theme.of(getContext)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                )
              :
      _jobOfferController.sentOffer.value != null  &&
      _jobOfferController.sentOffer.value!.status ==
          OfferStatus.Completed ?
      CustomButton(
                  // style: ElevatedButton.styleFrom(
                  //   fixedSize: const Size(120, 44),
                  //   shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
                  //   elevation: 10,
                  // ),
                  loadingIndicator:
                      _jobOfferController.loadingSendJobOffer.value,
                  onPressed: _sendOfferAction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        txtTitle: StaticString.sendOffer,
                        style:
                            Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                      )
                    ],
                  ),
                ) :    CustomButton(
        // style: ElevatedButton.styleFrom(
        //   fixedSize: const Size(120, 44),
        //   shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
        //   elevation: 10,
        // ),
        loadingIndicator:
        _jobOfferController.loadingSendJobOffer.value,
        onPressed: _sendOfferAction,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              txtTitle: StaticString.sendOffer,
              style:
              Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  void goToChat() {}

  void _sendOfferAction() {
    if (_formKey.currentState!.validate()) {
      if (startDate == null) {
        Get.showSnackbar(GetSnackBar(
          // title: "Your account is created successfully",
          message: "Start Date cannot be empty",
          duration: const Duration(seconds: 2),
        ));
      }
      if (startTime == null) {
        Get.showSnackbar(GetSnackBar(
          // title: "Your account is created successfully",
          message: "Start Time cannot be empty",
          duration: const Duration(seconds: 2),
        ));
      }

      final selectedCard = Get.find<PaymentController>().getSelectedCard();
      debugPrint('selected method $selectedCard');

      if (startTime != null && startDate != null && selectedCard != null && selectedCard.id != null) {
        final chatId = FirebaseFirestore.instance
            .collection(StaticString.serviceRequestCollection)
            .doc()
            .id;

        final jobOffer = JobOfferModel(
                id: 0,
                status: OfferStatus.Pending,
                renter: Get.find<AuthController>().getUserInfo,
                startTime: startTime!,
                startDate: startDate!,
                chatId: chatId,
                serviceProvider: serviceDetail.lenderInfoModel!,
                description: "${_q1Controller.text} \n ${_q2Controller.text} \n ${_q3Controller.text}",
                maxHours: int.tryParse(_maxHourController.text) ?? 0);
        Get.find<ChatController>().createChatInFirebase(
            itemDetailModel: serviceDetail, docId: chatId);
        _jobOfferController.sendJobOffer(
            getContext,
            jobOffer,
            serviceDetail.id.toString(),
            selectedCard.id.toString());
      }
    }
  }

  // Future<void> _hireButtonAction() async {
  //   final selectedCard = Get.find<PaymentController>().getSelectedCard();
  //   debugPrint('selected method $selectedCard');
  //   if (selectedCard != null && selectedCard.id != null) {
  //     await _jobOfferController.hireLender(
  //       getContext,
  //       _jobOfferController.sentOffer.value!,
  //       serviceDetail.id.toString(),
  //       selectedCard.id.toString(),
  //       _jobOfferController.sentOffer.value?.chatId,
  //         serviceDetail,
  //     );
  //     await _jobOfferController.checkSentOffer(
  //         getContext, serviceDetail.id.toString());
  //   } else {
  //     Get.showSnackbar(GetSnackBar(
  //       // title: "Your account is created successfully",
  //       message: "Error adding payment method",
  //       duration: const Duration(seconds: 2),
  //     ));
  //   }
  // }

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
          rentedText: serviceDetail.rent?.msg ?? "",
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
            height: ((serviceDetail.startDate != null ||
                            serviceDetail.serviceEndTime.isNotEmpty ||
                            serviceDetail.serviceStartTime.isNotEmpty) &&
                        _expandChild) &&
                    !(((hoursBetween(
                                  itemDetailModel: serviceDetail,
                                ) /
                                60) <=
                            0) &&
                        serviceDetail.getEnumForDayAndHourly ==
                            ServiceType.Hourly)
                ? 20
                : 0.0,
          ),
        ),

        /// item Detail
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) =>
              ((serviceDetail.startDate != null &&
                              serviceDetail.serviceEndTime.isNotEmpty &&
                              serviceDetail.serviceStartTime.isNotEmpty) &&
                          _expandChild) &&
                      !(((hoursBetween(
                                    itemDetailModel: serviceDetail,
                                  ) /
                                  60) <=
                              0) &&
                          serviceDetail.getEnumForDayAndHourly ==
                              ServiceType.Hourly)
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
                          itemDetailModel: serviceDetail,
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
                serviceDetail.startDate = date;
                // });
                _expandChild = false;
                _valueNotifier.notifyListeners();
              },
            ),
        icon: ImgName.calender,
        context: context,
        date: serviceDetail.startDate == null
            ? StaticString.date
            : StaticString.formatter
                .format(serviceDetail.startDate ?? DateTime.now()));
  }

  ///  Service start time
  Widget _buildStartTime(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, j, w) => dateTextAndCalenderAndTimeIcon(
        onTap: _startTime,
        icon: ImgName.clock,
        context: context,
        date: startTime == null
            ? StaticString.startTime
            : formatTimeHM(startTime),
      ),
    );
  }

  ///  Service end time
  Widget _buildEndTime(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
      onTap: _endTime,
      icon: ImgName.clock,
      context: context,
      date: serviceDetail.serviceEndTime.isEmpty
          ? StaticString.endTime
          : serviceDetail.serviceEndTime,
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
              serviceDetail.startDate == null || serviceDetail.endDate == null
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
                            itemDetailModel: serviceDetail,
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
              //_buildStartDate(context),
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
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, j, w) => dateTextAndCalenderAndTimeIcon(
        onTap: () => showCalender(
          context: context,
          focusedDay: startDate,
          firstDate: DateTime.now(),
          currentDate: DateTime.now(),
          selectedDay: startDate ?? DateTime.now(),
          setDateOnCallBack: (date) {
            // setState(() {
            startDate = date;
            debugPrint('date selected $date');
            // serviceDetail.startDate = date;
            serviceDetail.endDate = null;
            _expandChild = false;
            // });

            _valueNotifier.notifyListeners();
          },
        ),
        icon: ImgName.calender,
        context: context,
        date: startDate == null
            ? StaticString.startDate
            : StaticString.formatter.format(
                startDate ?? DateTime.now(),
              ),
      ),
    );
  }

  /// End Date
  Widget _buildEndDate(BuildContext context) {
    return dateTextAndCalenderAndTimeIcon(
      onTap: () => showCalender(
        context: context,
        focusedDay: serviceDetail.startDate?.add(Duration(hours: 24)),
        firstDate: serviceDetail.startDate?.add(Duration(hours: 24)),
        currentDate: serviceDetail.endDate,
        selectedDay: serviceDetail.endDate ??
            serviceDetail.startDate?.add(Duration(hours: 24)),
        setDateOnCallBack: (date) {
          _expandChild = false;
          // setState(() {
          // if ((daysBetween(
          //             from: (serviceDetail.startDate ?? DateTime.now()),
          //             to: (date))) >
          //         (serviceDetail.maxDuration ?? 0) &&
          //     serviceDetail.getEnumForDayAndHourly == ServiceType.Day) {
          //   Get.showSnackbar(GetSnackBar(
          //     // title: "Your account is created successfully",
          //     message:
          //         "You can book this item for maximume ${serviceDetail.maxDuration} days",
          //     duration: const Duration(seconds: 2),
          //   ));
          //   return;
          // } else
          if (hoursBetween(itemDetailModel: serviceDetail) >
                  (serviceDetail.maxDuration ?? 0) &&
              serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
            Get.showSnackbar(GetSnackBar(
              // title: "Your account is created successfully",
              message:
                  "You can book this item for maximum ${serviceDetail.maxDuration} days",
              duration: const Duration(seconds: 2),
            ));
            return;
          }

          serviceDetail.endDate = date;

          // });
          _valueNotifier.notifyListeners();
        },
      ),
      icon: ImgName.calender,
      context: context,
      date: serviceDetail.endDate == null
          ? StaticString.endDate
          : StaticString.formatter.format(
              serviceDetail.endDate ?? DateTime.now(),
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

  // Widget _buildHireAndChatButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       //Rent button
  //       if (serviceDetail.getEnumForDayAndHourly != ServiceType.Rented)
  //         _buildHireButton(),

  //       const SizedBox(
  //         width: 15,
  //       ),
  //       // Chat With lender button
  //       //   _buildChatWithLenderButton(),
  //     ],
  //   );
  // }

  // rent button
  // Widget _buildHireButton() {
  //   return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         fixedSize: const Size(120, 44),
  //         shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
  //         elevation: 10,
  //       ),
  //       onPressed: _hireButtonAction,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           CustImage(
  //             imgURL: ImgName.whiteUser,
  //             height: 10,
  //             width: 14,
  //             cornerRadius: 10,
  //             boxfit: BoxFit.contain,
  //           ),
  //           const SizedBox(
  //             width: 2,
  //           ),
  //           CustomText(
  //             txtTitle: StaticString.hire,
  //             style: Theme.of(getContext).textTheme.caption?.copyWith(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //           )
  //         ],
  //       ));
  // }

  // Chat with lender button

  Widget _buildChatWithLenderButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 44),
        shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
        elevation: 10,
      ),
      onPressed: _chatWithLenderButton,
      child: const CustomText(
        txtTitle: 'Chat',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
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

    if (serviceDetail.getEnumForDayAndHourly == ServiceType.Day &&
        (serviceDetail.startDate == null || serviceDetail.endDate == null)) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date.",
        duration: Duration(seconds: 2),
      ));
      return;
    } else if (serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly &&
        (serviceDetail.startDate == null ||
            serviceDetail.serviceStartTime.isEmpty ||
            serviceDetail.serviceEndTime.isEmpty)) {
      String message1 = "Please select date and time.";

      if (serviceDetail.startDate == null &&
          serviceDetail.serviceStartTime.isEmpty &&
          serviceDetail.serviceEndTime.isEmpty) {
        message1 = "Please select date and time.";
      } else if (serviceDetail.startDate == null) {
        message1 = "Please select date.";
      } else if (serviceDetail.serviceStartTime.isEmpty) {
        message1 = "Please select start date.";
      } else if (serviceDetail.serviceEndTime.isEmpty) {
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
    // if (((serviceDetail.startDate == null || serviceDetail.endDate == null) &&
    //     serviceDetail.getEnumForDayAndHourly == ServiceType.Day)) {
    //   return;
    // }

    if (serviceDetail.startDate == null &&
        serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date",
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (((hoursBetween(
                  itemDetailModel: serviceDetail,
                ) /
                60) <=
            0) &&
        serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "End time must be greater than start time.",
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (!valideTime &&
        serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
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
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    debugPrint(
        'start date $startDate and actual date ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0)}');
    if (startDate != null &&
        DateTime(startDate!.year, startDate!.month, startDate!.day, 0, 0, 0, 0,
                0) ==
            DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                0,
                0,
                0,
                0,
                0)) if (((selectStartTime?.hour ?? 0) < TimeOfDay.now().hour) ||
        (((selectStartTime?.hour ?? 0) == TimeOfDay.now().hour) &&
            ((selectStartTime?.minute ?? 0) <= TimeOfDay.now().minute))) {
      Get.showSnackbar(
        const GetSnackBar(
          message: "Start time should be greater than current time.",
          duration: Duration(seconds: 2),
        ),
      );
      //  startTime == null;
      return;
    }

    _expandChild = false;
    if (selectStartTime != null) {
      startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectStartTime!.hour,
        selectStartTime!.minute,
      );
    }
    if (selectStartTime != null && selectStartTime != startTime) {
      serviceDetail.serviceStartTime =
          "${selectStartTime?.hour}:${selectStartTime?.minute.toString().length == 1 ? "0${selectStartTime?.minute}" : selectStartTime?.minute}:00";

      serviceDetail.serviceEndTime = "";
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
      serviceDetail.serviceEndTime =
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

    if (serviceDetail.getEnumForDayAndHourly == ServiceType.Day &&
        (serviceDetail.startDate == null || serviceDetail.endDate == null)) {
      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Please select date.",
        duration: Duration(seconds: 2),
      ));
      return;
    } else if (serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      if (serviceDetail.startDate == null ||
          serviceDetail.serviceStartTime.isEmpty ||
          serviceDetail.serviceEndTime.isEmpty) {
        String message1 = "Please select date and time.";

        if (serviceDetail.startDate == null &&
            serviceDetail.serviceStartTime.isEmpty &&
            serviceDetail.serviceEndTime.isEmpty) {
          message1 = "Please select date and time.";
        } else if (serviceDetail.startDate == null) {
          message1 = "Please select date.";
        } else if (serviceDetail.serviceStartTime.isEmpty) {
          message1 = "Please select start time.";
        } else if (serviceDetail.serviceEndTime.isEmpty) {
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
                  itemDetailModel: serviceDetail,
                ) /
                60) <=
            0) &&
        serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
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
        serviceDetail.getEnumForDayAndHourly == ServiceType.Hourly) {
      Get.showSnackbar(
        const GetSnackBar(
          // title: "Your account is created successfully",
          message: "At least 1 hour has to be selected.",
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Get.toNamed("CheckoutScreen", arguments: serviceDetail);
  }

  void _chatWithLenderButton() async {
    if (_jobOfferController.sentOffer.value != null &&
        (_jobOfferController.sentOffer.value!.status == OfferStatus.Hired ||
            _jobOfferController.sentOffer.value!.status == OfferStatus.Accepted ||
            _jobOfferController.sentOffer.value!.status == OfferStatus.Logged ||
            _jobOfferController.sentOffer.value!.status ==
                OfferStatus.Disputed ||
            _jobOfferController.sentOffer.value!.status ==
                OfferStatus.Completed)) {
      if (serviceDetail.lenderInfoModel != null) {
        serviceDetail.lenderInfoModel?.itemDetailModel = serviceDetail;

        Get.to(
          () => ChatScreen(
            isLender: false,
            userInfoModel: serviceDetail.lenderInfoModel!,
            isSingleChat: true,
            chatId: _jobOfferController.sentOffer.value!.chatId,
          ),
        );
      }
    } else if (serviceDetail.lenderInfoModel != null) {
      showDialog(context: getContext, builder: (context) => const Loading());
      final chatKeyDoc = await FirebaseFirestore.instance
          .collection(StaticString.serviceChatCollection)
          .where('renter_id',
              isEqualTo: Get.find<AuthController>().getUserInfo.id)
          .where('lender_id', isEqualTo: serviceDetail.lenderInfoModel!.id)
          .where('service_id', isEqualTo: serviceDetail.id.toString())
          .limit(1)
          .get();
      if (chatKeyDoc.docs.isNotEmpty) {
        Get.back();
        final key = chatKeyDoc.docs.first.id;
        Get.to(
          () => ChatScreen(
            isLender: false,
            userInfoModel: serviceDetail.lenderInfoModel!,
            isSingleChat: true,
            chatId: key,
          ),
        );
      } else {
        final chatDocId = FirebaseFirestore.instance
            .collection(StaticString.serviceChatCollection)
            .doc()
            .id;
        final serviceChatKey = ServiceChatKey(
            serviceId: serviceDetail.id.toString(),
            lenderId: serviceDetail.lenderInfoModel!.id,
            id: chatDocId,
            renterId: Get.find<AuthController>().getUserInfo.id);
        FirebaseFirestore.instance
            .collection(StaticString.serviceChatCollection)
            .doc(chatDocId)
            .set(serviceChatKey.toFirebase());
        await Get.find<ChatController>().createChatInFirebase(
            itemDetailModel: serviceDetail, docId: chatDocId);
        Get.back();
        Get.to(
          () => ChatScreen(
            isLender: false,
            userInfoModel: serviceDetail.lenderInfoModel!,
            isSingleChat: true,
            chatId: chatDocId,
          ),
        );
        serviceDetail.lenderInfoModel?.itemDetailModel = serviceDetail;
      }
    }
  }

  /// payment with widget
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
            Get.to(const PayWithScreen());
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
}
