import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controller/item_controller.dart';
import '/widgets/spinner.dart';
import '/utils/custom_enum.dart';
import '/widgets/custom_row_image.dart';
import '../../constants/img_font_color_string.dart';
import '../../controller/lend_controller.dart';
import '../../main.dart';
import '../../models/item_detail_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class ItemStatusScreen extends StatefulWidget {
  const ItemStatusScreen({Key? key}) : super(key: key);

  @override
  State<ItemStatusScreen> createState() => _ItemStatusScreenState();
}

class _ItemStatusScreenState extends State<ItemStatusScreen> {
  //!------------------------ variable------------------

  LendController lendController = Get.find<LendController>();

  ItemDetailModel itemDetail = ItemDetailModel();
  ItemController itemController = ItemController();

  // final ItemDetailModel itemDetail =
  //     itemDetailModelFromJson(json.encode(itemDetailJson));

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _maxTermController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  bool _isChecked = true;

  int id = Get.arguments;

  Future fetchData() async {
    try {
      print(" * * * * * * *  item status screen * * * * * *  * * *");

      await lendController.fetchItemDetail(context: getContext, id: id);
      itemDetail = lendController.itemDetail.value;
      setState(() {});
    } catch (e) {
      showAlert(context: context, message: e);
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _maxTermController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(itemDetail.toJson());
    return Scaffold(
      appBar: CustomAppbar(
        /// item name
        title: itemDetail.name,
      ),
      body: SafeArea(
        child: GetBuilder<LendController>(builder: (val) {
          return lendController.iDetailLoading.value
              ? Spinner()
              : SingleChildScrollView(
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
                          image1: itemDetail.getFirstImageModel?.imageUrl ?? "",
                          image2:
                              itemDetail.getSecondImageModel?.imageUrl ?? "",
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        /// item name
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
                          // price: ,
                          price: itemDetail.getEnum ==
                                  ItemAndServiceStatus.Available
                              ? "\$${itemDetail.getPrice}"
                              : "Per Day: \$${itemDetail.getRatePerDayWithDecimal2}",
                          textColor: itemDetail.getEnum ==
                                  ItemAndServiceStatus.Available
                              ? primaryColor
                              : custGrey7E7E7E,
                          itemOrServices: itemDetail.category?.type.name ?? "",
                        ),

                        const SizedBox(
                          height: 16,
                        ), // /Location detail
                        location(
                          context: context,
                          location: '${itemDetail.city.isNotEmpty ? "${itemDetail.city}," : ''} ${itemDetail.state.isNotEmpty ? "${itemDetail.state}," : ''} ${itemDetail.country}',
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

                        ///Price And Max. Term text form field
                        Row(
                          children: [
                            if (itemDetail.getEnum ==
                                ItemAndServiceStatus.Rented)
                              _buildTitleAndSubtitle(
                                  context: context,
                                  title: "Amount You'll receive",
                                  subTitle:
                                      "\$${itemDetail.rent?.amountToReceive ?? ""}"),
                            // _buildTitleAndSubtitle(
                            //     context: context,
                            //     title: StaticString.totalPayment,
                            //     subTitle:
                            //     "\$${itemDetail.rent?.totalPayment ?? ""}"),
                            _buildTitleAndSubtitle(
                                context: context,
                                title: StaticString.maxTerm,
                                //             duration = DateTime.parse(itemDetail.rent?.startDate ?? "")
                                // .difference(DateTime.parse(itemDetail.rent?.endDate ?? ""))
                                // .inDays
                                subTitle: "${itemDetail.maxDuration} Days"),
                          ],
                        ),

                        _buildWidget(itemDetail.getEnum),

                        /// Edit Listing Button
                        _editButton(),
                        const SizedBox(
                          height: 20,
                        ),

                        /// Cancel Button

                        _buildDeleteButton(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
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

  /// build widget by item Status
  Widget _buildWidget(ItemAndServiceStatus itemStatus) {
    Widget? child;
    switch (itemStatus) {
      case ItemAndServiceStatus.Rented:
        // var duration;
        // if (itemDetail.rent != null) {
        //   duration = DateTime.parse(itemDetail.rent?.startDate ?? "")
        //       .difference(DateTime.parse(itemDetail.rent?.endDate ?? ""))
        //       .inDays;
        // }
        child = Column(
          children: [
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
          children: [
            const SizedBox(
              height: 30,
            ),

            /// term & condition


            const SizedBox(
              height: 30,
            ),
          ],
        );
        break;
    }
    return child;
  }

  /// Term  & condition Check Box
  Widget _buildTermAndConditionCheckBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
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

  /// Edit Listing Button
  Widget _editButton() {
    return Obx(() {
      return Center(
        child: CustomButton(
          loadingIndicator: lendController.loadingItemDetail.value,
          buttonTitle: StaticString.editListing,
          onPressed: itemDetail.getEnum == ItemAndServiceStatus.Rented
              ? () {}
              : () => _edit(),
        ),
      );
    });
  }

  /// Delete Listing Button
  Widget _buildDeleteButton() {
    return Obx(() {
      return Center(
        child: CustomButton(
          buttonColor: declineColor,
          loadingIndicator: lendController.loadingItemDelete.value,
          buttonTitle: StaticString.delete,
          onPressed: itemDetail.getEnum == ItemAndServiceStatus.Rented
              ? () {}
              : () => _deleteButton(id: id),
        ),
      );
    });
  }

  //!--------------------- button Action----------------
  void _deleteButton({required int id}) async {
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
        title: "Delete Item",
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

  void _edit() {
    if ((itemDetail.category?.type ?? ItemOrService.item) ==
        ItemOrService.item) {
      Get.toNamed("LendNewItemFormScreen", arguments: itemDetail.id);
    } else {
      Get.toNamed("LendNewServiceFormScreen", arguments: itemDetail.id);
    }
  }
}
