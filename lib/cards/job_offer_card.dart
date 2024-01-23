import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';
import 'package:renting_app_mobile/screen/lend/job_offer_description_dialog.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';
import '../constants/img_font_color_string.dart';
import '../models/item_detail_model.dart';
import '../screen/chat/chat_screen.dart';
import '../utils/dialog_utils.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_alert.dart';
import '../widgets/custom_short_button.dart';
import '../widgets/custom_text.dart';

class JobOfferCard extends StatelessWidget {
  final JobOfferModel jobOfferModel;
  final ItemDetailModel service;

  const JobOfferCard({
    Key? key,
    required this.jobOfferModel,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jobOfferController = Get.find<JobOfferController>();
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      //    mainAxisSize: MainAxisSize.min,
                      children: [
                        CustImage(
                          width: 70,
                          height: 52,
                          cornerRadius: 12,
                          imgURL: jobOfferModel.renter.profileImage,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 70,
                                child: CustomText(
                                  txtTitle: jobOfferModel.renter.name * 100,
                                  textOverflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                ),
                              ),
                              CustomText(
                                txtTitle: 'Renter',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontSize: 14, color: cust9FA8DA),
                              ),
                              const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //  const SizedBox(width: 200,),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      JobOfferDescriptionDialog(
                                    jobOfferModel: jobOfferModel,
                                    service: service,
                                  ),
                                );
                              },
                              child: CustomText(
                                txtTitle: 'See Job Description',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                              )),
                          InkWell(
                              onTap: () {
                                debugPrint(
                                    'chat id is ${jobOfferModel.chatId}');
                                Get.to(
                                  () => ChatScreen(
                                    isLender: true,
                                    userInfoModel: jobOfferModel.renter,
                                    service: service,
                                    chatId: jobOfferModel.chatId,
                                  ),
                                );
                              },
                              child: CustomText(
                                txtTitle: 'Chat with renter',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomText(
                    txtTitle:
                        '${jobOfferModel.renter.name} wants to rent this service. Please read the job description and click below to accept or decline the job offer.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: custBlack102339WithOpacity),
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            jobOfferModel.status == OfferStatus.Accepted
                ? CustomText(
                    txtTitle: 'Offer has been accepted',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : jobOfferModel.status == OfferStatus.Hired
                    ? CustomText(
                        txtTitle: 'You have been hired',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : jobOfferModel.status == OfferStatus.Logged
                        ? CustomText(
                            txtTitle: 'You have logged hours',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : jobOfferModel.status == OfferStatus.Disputed
                            ? CustomText(
                                txtTitle: 'This job is disputed',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : jobOfferModel.status == OfferStatus.Completed
                                ? CustomText(
                                    txtTitle: 'Completed',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                : jobOfferModel.status == OfferStatus.Rejected
                                    ? Center(
                                        child: CustomText(
                                          txtTitle: 'Offer has been rejected',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      )
                                    : jobOfferModel.status ==
                                            OfferStatus.Pending
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CustomShortButton(
                                                text: 'Accept',
                                                onTap: () {
                                                  showAlert(
                                                    context: context,
                                                    showCustomContent: true,
                                                    title: 'Alert',
                                                    signleBttnOnly: false,
                                                    content: const CustomText(
                                                      txtTitle:
                                                          'Are you sure you want to accept this offer?',
                                                    ),
                                                    leftBttnTitle: 'Accept',
                                                    rigthBttnTitle: 'Cancel',
                                                    onRightAction: () {},
                                                    onLeftAction: () async {
                                                      showLoadingDialog(
                                                          context);
                                                      await jobOfferController
                                                          .acceptJobOffer(
                                                        context,
                                                        jobOfferModel,
                                                        service.id.toString(),
                                                      );
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                backgroundColor: primaryColor,
                                              ),
                                              CustomShortButton(
                                                text: 'Decline',
                                                onTap: () {
                                                  showAlert(
                                                    context: context,
                                                    showCustomContent: true,
                                                    title: 'Alert',
                                                    signleBttnOnly: false,
                                                    content: const CustomText(
                                                      txtTitle:
                                                          'Are you sure you want to reject this offer?',
                                                    ),
                                                    leftBttnTitle: 'Accept',
                                                    rigthBttnTitle: 'Cancel',
                                                    onRightAction: () {},
                                                    onLeftAction: () async {
                                                      showLoadingDialog(
                                                          context);
                                                      await jobOfferController
                                                          .rejectJobOffer(
                                                        context,
                                                        jobOfferModel,
                                                        service.id.toString(),
                                                      );
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                backgroundColor: declineColor,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
