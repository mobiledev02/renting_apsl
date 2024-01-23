import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/utils/dialog_utils.dart';
import '../../constants/img_font_color_string.dart';
import '../../models/item_detail_model.dart';
import '../../models/job_offer_model.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_short_button.dart';
import '../../widgets/custom_text.dart';
import '../../utils/date_time_util.dart';
import '../chat/chat_screen.dart';

class JobOfferDescriptionDialog extends StatelessWidget {
  final JobOfferModel jobOfferModel;
  final ItemDetailModel service;

  const JobOfferDescriptionDialog(
      {Key? key, required this.jobOfferModel, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jobOfferController = Get.find<JobOfferController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          txtTitle: 'User',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        CustomText(
                          txtTitle: 'Renter',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 13, color: cust9FA8DA),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CustomText(
                              txtTitle: 'Close Job Description',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        InkWell(
                          onTap: () {
                            Get.to(
                                  () => ChatScreen(
                                isLender: true,
                                userInfoModel: jobOfferModel.renter,
                               service: service,
                              ),
                            );
                          },
                            child: CustomText(
                              txtTitle: 'Chat with renter',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              txtTitle: 'Start Date:',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: custBlack102339WithOpacity),
                            ),
                            CustomText(
                              txtTitle:
                              formatDateDDMMYYYY(jobOfferModel.startDate),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              txtTitle: 'Start Time:',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: custBlack102339WithOpacity),
                            ),
                            CustomText(
                              txtTitle: formatTimeHM(jobOfferModel.startTime),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              txtTitle: 'Maximum Hours:',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: custBlack102339WithOpacity),
                            ),
                            CustomText(
                              txtTitle: jobOfferModel.maxHours.toString(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250, minHeight: 50),
                child: SingleChildScrollView(
                    child: CustomText(
                      txtTitle: jobOfferModel.description,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: custBlack102339WithOpacity),
                    )),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            jobOfferModel.status == OfferStatus.Accepted ? Center(
              child: CustomText(
                txtTitle: 'Offer has been accepted', style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,),
            ) :
            jobOfferModel.status == OfferStatus.Rejected ? Center(
              child: CustomText(
                txtTitle: 'Offer has been rejected', style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,),
            ) :
            jobOfferModel.status == OfferStatus.Pending ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          'Are you sure you want to accept this offer?'),
                      leftBttnTitle: 'Accept',
                      rigthBttnTitle: 'Cancel',
                      onRightAction: () {},
                      onLeftAction: () async {
                        showLoadingDialog(context);
                        await jobOfferController.acceptJobOffer(
                          context, jobOfferModel, service.id.toString(),);
                        Get.back();
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
                          'Are you sure you want to reject this offer?'),
                      leftBttnTitle: 'Accept',
                      rigthBttnTitle: 'Cancel',
                      onRightAction: () {},
                      onLeftAction: () async {
                        showLoadingDialog(context);
                        await jobOfferController.rejectJobOffer(
                          context, jobOfferModel, service.id.toString(),);
                        Get.back();
                        Get.back();
                      },
                    );
                  },
                  backgroundColor: declineColor,
                ),
              ],
            ) : const SizedBox()
          ],
        ),
      ),
    );
    ;
  }
}
