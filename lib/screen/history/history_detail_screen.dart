import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/models/rented_item_service_detail_model.dart';
import 'package:renting_app_mobile/screen/review/write_review_screen.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';

import '../../controller/item_controller.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/spinner.dart';
import '/constants/img_font_color_string.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_text.dart';
import '/widgets/rich_text.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/custom_row_image.dart';
import '/utils/custom_enum.dart';

class HistoryDetailScreen extends GetView<ItemController> {
  const HistoryDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loadingRentedItemServiceDetail.value
        ? Scaffold(
            body: Spinner(),
          )
        : controller.rentedItemService.value != null
            ? Scaffold(
                appBar: CustomAppbar(
                    title: controller.rentedItemService.value!.name),
                body: SafeArea(
                  child: Obx(
                    () => controller.loadingRentedItemServiceDetail.value
                        ? Spinner()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),

                                /// Images
                                CustomRowImage(
                                  image1: controller.rentedItemService.value
                                          ?.getFirstImageModel?.imageUrl ??
                                      "",
                                  image2: controller.rentedItemService.value
                                          ?.getSecondImageModel?.imageUrl ??
                                      "",
                                  // image1: (itemDetail.lendItemServiceImages?.isEmpty ?? true)
                                  //     ? ""
                                  //     : itemDetail.lendItemServiceImages?[0] ?? "",
                                  // image2: (itemDetail.lendItemServiceImages?.isEmpty ?? true)
                                  //     ? ""
                                  //     : itemDetail.lendItemServiceImages?[1] ?? "",
                                ),
                                const SizedBox(
                                  height: 25,
                                ),

                                /// item name
                                productNameAndDuration(
                                  context: context,
                                  name: controller
                                          .rentedItemService.value?.name ??
                                      "", //itemDetail.name,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                /// Category text
                                categoryText(
                                    context: context,
                                    category: controller.rentedItemService.value
                                            ?.category ??
                                        "" // itemDetail.category?.name ?? "",
                                    ),
                                const SizedBox(
                                  height: 14,
                                ),
                                itemOrServiceTagAndPriceText(
                                  context: context,
                                  itemOrServices: controller.rentedItemService
                                          .value?.type.getEnumName ??
                                      'item', //itemDetail.category?.type ?? "",
                                ),

                                const SizedBox(
                                  height: 16,
                                ),

                                /// Item Detail
                                description(
                                    context: context,
                                    description: controller.rentedItemService
                                            .value?.description ??
                                        ""),
                                const SizedBox(
                                  height: 20,
                                ),

                                /// Rented Days Text
                                _buildTitleAndSubTitle(
                                  context: context,
                                  title: "Rented Days:",
                                  subTitle:
                                      "${controller.rentedItemService.value?.getStartDate} - ${controller.rentedItemService.value?.getEndDate}",
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                if (controller.rentedItemService.value?.type == ItemOrService.item)
                                  /// total Payment
                                  _buildTotalPayment(
                                      context,
                                      controller.rentedItemService.value
                                              ?.totalPayment ??
                                          "")
                                else
                                  /// total Payment
                                  _buildTotalPayment(
                                      context,
                                      controller.rentedItemService.value
                                              ?.finalCharge ??
                                          ""),
                                const SizedBox(
                                  height: 30,
                                ),

                                /// Lendor Detail Card
                                _buildLendorDetails(context,
                                    controller.rentedItemService.value),

                                const SizedBox(
                                  height: 30,
                                ),

                                /// Give Review Button
                                _buildReviewButton(
                                    controller.rentedItemService.value,
                                    context),
                              ],
                            ),
                          ),
                  ),
                ),
              )
            : const Scaffold(
                body: Center(child: CustomText(txtTitle: 'Something went wrong')),
              ));
  }

  //!-------------------------------- Widget ---------------------------------
  /// title And subTitle
  Widget _buildTitleAndSubTitle({
    required BuildContext context,
    required String title,
    required String subTitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          txtTitle: title,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(color: custGrey7E7E7E, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomText(
          txtTitle: subTitle,
          style: Theme.of(context).textTheme.caption?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        )
      ],
    );
  }

  /// totla Payment
  Widget _buildTotalPayment(BuildContext context, String totalPayment) {
    return CustomRichText(
      title: "${StaticString.totalPayment}: #\$$totalPayment",
      normalTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: custGrey7E7E7E,
            fontWeight: FontWeight.w600,
          ),
      fancyTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// Lendor Detail Card
  Widget _buildLendorDetails(
      BuildContext context, RentedItemServiceDetailModel? rentedItemService) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: custBlack102339.withOpacity(
          0.04,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            txtTitle: StaticString.lendorDetails,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 20,
          ),

          /// name
          _buildTitleAndSubTitle(
            context: context,
            title: "${StaticString.name}:",
            subTitle: rentedItemService?.lenderName ?? "",
          ),
          const SizedBox(
            height: 10,
          ),

          /// Email
          // _buildTitleAndSubTitle(
          //   context: context,
          //   title: StaticString.email,
          //   subTitle: rentedItemService?.lenderEmail ?? "",
          // ),
        ],
      ),
    );
  }

  /// Give Review button
  Widget _buildReviewButton(
      RentedItemServiceDetailModel? rentedItemService, BuildContext context) {
    if (rentedItemService != null) {
      return rentedItemService.isReviewGiven
          ? Center(
              child: TextButton(
                onPressed: () {},
                child: CustomText(
                  txtTitle:
                      'You have already given review to this ${rentedItemService.type.getEnumName}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: primaryColor),
                ),
              ),
            )
          : Center(
              child: CustomButton(
                onPressed: () {
                  Get.to(() => WriteAReviewScreen(
                        rentedItemService: rentedItemService,
                      ));
                },
                buttonTitle: StaticString.writeAReview(
                  rentedItemService.lenderName.firstName ?? "",
                ),
              ),
            );
    } else {
      return const SizedBox();
    }
  }
}
