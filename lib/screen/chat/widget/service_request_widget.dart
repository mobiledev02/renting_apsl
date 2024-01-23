import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:renting_app_mobile/controller/lend_controller.dart';
import 'package:renting_app_mobile/screen/review/write_review_screen.dart';
import 'package:renting_app_mobile/utils/dialog_utils.dart';
import 'package:renting_app_mobile/widgets/log_disputed_hours_renter.dart';
import 'package:renting_app_mobile/widgets/log_hours_dialog_lender.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../controller/job_offer_controller.dart';
import '../../../models/job_offer_model.dart';
import '../../../utils/custom_enum.dart';
import '../../../widgets/custom_short_button.dart';
import '../../../widgets/custom_text.dart';
import '../../profile/lender_service_profile_screen.dart';
import '../../../cards/job_offer_card.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import '/models/item_detail_model.dart';
import '/widgets/cust_image.dart';

class ServiceRequestWidget extends StatefulWidget {
  final String requestId;
  final bool isLender;

  const ServiceRequestWidget(
      {Key? key, required this.requestId, required this.isLender})
      : super(key: key);

  @override
  State<ServiceRequestWidget> createState() => _ServiceRequestWidgetState();
}

class _ServiceRequestWidgetState extends State<ServiceRequestWidget> {
  Stream<QuerySnapshot>? _requestStream;
  StreamSubscription? _subsciption;
  final _paymentController = Get.find<PaymentController>();
  final _jobOfferController = Get.find<JobOfferController>();

  Future fetchData(context, serviceId) async {
    try {
      await _jobOfferController.getJobOffersByService(context, serviceId);
      setState(() {});
    } catch (e) {
      print("There was an error");
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchData(context, widget.requestId);    
    debugPrint('lender status ${widget.isLender}');
    debugPrint('service request widget request id ${widget.requestId}');
    _requestStream = FirebaseFirestore.instance
        .collection(StaticString.serviceRequestCollection)
        .where('chat_id', isEqualTo: widget.requestId.trim())
        .orderBy('created_at', descending: true)
        .limit(1)
        .snapshots();
    print("Requestisosnr: ");
    print({_requestStream!.first.obs.value});
    
  }

  Future<void> getCompletedCount() async {}

  Future<void> initiateStream() async {
    //  debugPrint('yes doc is here ${results.docs.first.id}');
    //   if (results.docs.isNotEmpty) {
    //     setState(() {
    //       _requestStream = FirebaseFirestore.instance
    //           .collection(StaticString.itemRequestsCollection)
    //           .doc(results.docs.first.id)
    //           .snapshots();
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _requestStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data != null &&
            snapshot.data?.docs != null &&
            snapshot.data!.docs.isNotEmpty) {
          debugPrint('data is present ${snapshot.data!.docs.first.data()}');

          final serviceRequest = JobOfferModel.fromFirebase(
            snapshot.data!.docs.first.data()! as Map<String, dynamic>,
            snapshot.data!.docs.first.id,
          );

          debugPrint(snapshot.data!.docs.first.data()!.toString());
          debugPrint('object data ${serviceRequest}');
          debugPrint('object data 2 ${serviceRequest.serviceId}');
          if (serviceRequest.status == OfferStatus.Disputed) {
            return CustomText(
              txtTitle: 'The Service is in dispute',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.red),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '         Hire         ',
                        style: TextStyle(fontSize: 10),
                      ),
                      //   Spacer(),
                      Text(
                        'Hours Logged',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),

                      Text('  Completed',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 35,
                            width: 50,
                            decoration: BoxDecoration(
                              color:
                                  serviceRequest.status == OfferStatus.Hired ||
                                          serviceRequest.status ==
                                              OfferStatus.Completed ||
                                          serviceRequest.status ==
                                              OfferStatus.Logged ||
                                          serviceRequest.status ==
                                              OfferStatus.Disputed
                                      ? requestProgressColor
                                      : custGrey,
                            ),
                            child: const Center(
                                child: CustomText(
                              txtTitle: '1',
                            )),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 3,
                          color: serviceRequest.status == OfferStatus.Logged ||
                                  serviceRequest.status == OfferStatus.Completed
                              ? requestProgressColor
                              : custGrey,
                        )),
                        ClipOval(
                          child: Container(
                            height: 35,
                            width: 50,
                            decoration: BoxDecoration(
                              color:
                                  serviceRequest.status == OfferStatus.Logged ||
                                          serviceRequest.status ==
                                              OfferStatus.Completed
                                      ? requestProgressColor
                                      : custGrey,
                            ),
                            child: const Center(
                                child: CustomText(
                              txtTitle: '2',
                            )),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 3,
                          color: serviceRequest.status == OfferStatus.Completed
                              ? requestProgressColor
                              : custGrey,
                        )),
                        ClipOval(
                          child: Container(
                            height: 35,
                            width: 50,
                            decoration: BoxDecoration(
                              color:
                                  serviceRequest.status == OfferStatus.Completed
                                      ? requestProgressColor
                                      : custGrey,
                            ),
                            child: const Center(
                                child: CustomText(
                              txtTitle: '3',
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!widget.isLender && serviceRequest.status == OfferStatus.Accepted)
                    InkWell(
                      onTap: () async {
                        if (serviceRequest.serviceId != null) {
                          showLoadingDialog(context);
                          await Get.find<LendController>().fetchItemDetail(
                              context: context,
                              id: int.parse(serviceRequest.serviceId!));
                          Get.back();
                          final service =
                              Get.find<LendController>().itemDetail.value;
                          if (service.lenderInfoModel != null) {
                            if (!mounted) return;
                            Get.find<JobOfferController>()
                                .checkSentOffer(context, service.id.toString());
                            Get.find<LendController>().getLenderProfile(context,
                                service.lenderInfoModel!.id.toString());
                            Get.off(() => LenderServiceProfileScreen(
                                  serviceDetail: service,
                                ));
                          }
                        }
                      },
                      child: _buildHireButton(Get.find<LendController>().itemDetail.value)
                    )
                  else if (widget.isLender && serviceRequest.status == OfferStatus.Pending)
                    JobOfferCard(jobOfferModel: serviceRequest, 
                                  service: Get.find<LendController>().itemDetail.value,),
                  if (widget.isLender &&
                      serviceRequest.status == OfferStatus.Hired)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomShortButton(
                          text: 'Log Hours Worked',
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => LogHoursDialogLender(
                                      offer: serviceRequest,
                                    ));
                          },
                          backgroundColor: primaryColor,
                        ),
                      ],
                    )
                  else if (widget.isLender == false &&
                      serviceRequest.status == OfferStatus.Logged)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (serviceRequest.reviewed != null &&
                            !serviceRequest.reviewed!)
                          CustomShortButton(
                            text: 'Write Review',
                            onTap: () async {
                              if (serviceRequest.id != null) {
                                _goToReviewScreen(
                                  serviceRequest.serviceId!,
                                  serviceRequest,
                                  context,
                                );
                              }
                            },
                            backgroundColor: primaryColor,
                          )
                        else
                          const Text('Review Submitted')
                      ],
                    )
                  else if (widget.isLender == false &&
                      serviceRequest.status == OfferStatus.Completed &&
                      serviceRequest.reviewed != true)
                    CustomShortButton(
                      text: 'Write Review',
                      onTap: () {
                        if (serviceRequest.id != null) {
                          _goToReviewScreen(serviceRequest.serviceId!,
                              serviceRequest, context);
                        }
                      },
                      backgroundColor: primaryColor,
                    )
                  else
                    const SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          }
        } else {
          debugPrint('out else worked service request Widget');
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildJobOffer(ItemDetailModel serviceDetail, JobOfferModel offer, BuildContext context) {
    debugPrint("Testing 123 ${offer}, ${serviceDetail}");
    return JobOfferCard(jobOfferModel: offer, service: serviceDetail);
  }

  _goToReviewScreen(
      String serviceId, JobOfferModel offer, BuildContext context) async {
    showLoadingDialog(context);
    await Get.find<LendController>()
        .fetchItemDetail(context: context, id: int.parse(serviceId));
    Get.back();
    Get.to(WriteAReviewScreen(
      service: Get.find<LendController>().itemDetail.value,
      offer: offer,
    ));
  }

Future<void> _hireButtonAction(ItemDetailModel serviceDetail) async {
    await _jobOfferController.hireLender(
        context,
        _jobOfferController.sentOffer.value!,
        serviceDetail.id.toString(),
        _jobOfferController.sentOffer.value?.chatId,
          serviceDetail,
      );
      await _jobOfferController.checkSentOffer(
          context, serviceDetail.id.toString());
  }

  Widget _buildHireButton(ItemDetailModel serviceDetail) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(120, 44),
          shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
          elevation: 10,
        ),
        onPressed: () {_hireButtonAction(serviceDetail);},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustImage(
              imgURL: ImgName.whiteUser,
              height: 10,
              width: 14,
              cornerRadius: 10,
              boxfit: BoxFit.contain,
            ),
            const SizedBox(
              width: 2,
            ),
            CustomText(
              txtTitle: StaticString.hire,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _requestStream = null;
    super.dispose();
  }
}
