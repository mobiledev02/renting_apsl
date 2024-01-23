// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';

import '../constants/img_font_color_string.dart';
import '../models/item_model.dart';
import '../widgets/common_widgets.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/rich_text.dart';

class ItemCard extends StatelessWidget {
  ItemCard({
    Key? key,
    required this.context,
    required this.itemModel,
    this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final ItemModel itemModel;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => _cardOnTap(itemModel),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7),
        width: 350,
        height: 83,
        padding: const EdgeInsets.only(
          left: 17,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                zoomablePhotoDialogue(
                  imageUrl: itemModel.getFirstImageModel?.imageUrl ?? "",
                );
              },
              child: CustImage(
                // imgURL: "",
                defaultImageWithDottedBorder: true,
                imgURL: itemModel.getFirstImageModel?.imageUrl ?? "",
                width: 100.00,
                height: 100.00,

                cornerRadius: 10,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    //title
                    child: CustomText(
                      txtTitle: itemModel.name, // item name
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: CustomFont.redHatDisplay,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  //Category
                  CustomText(
                    txtTitle: itemModel.category?.name ?? "", // item category
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: custBlack102339.withOpacity(0.5),
                        ),
                  ),
                  // Row(
                  //   children: [
                  //     CustomText(
                  //       txtTitle:
                  //           itemModel.category?.name ?? "", // item category
                  //       style: Theme.of(context).textTheme.caption?.copyWith(
                  //             color: custBlack102339.withOpacity(0.5),
                  //           ),
                  //     ),
                  //     const SizedBox(
                  //       width: 8,
                  //     ),
                  //     itemAndServiceTagCard(
                  //         ItemOrServices: itemModel.category?.type.name ?? ""),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 6,
                  ),
                  //Price
                  CustomRichText(
                    title: "\$${itemModel.price}", // item price
                    normalTextStyle: TextStyle(
                      color: custBlack102339.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: CustomFont.redHatDisplay,
                    ),
                    fancyTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: CustomFont.redHatDisplay,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //!-------------------------- Button Action -------------------------

  void _cardOnTap(ItemModel itemModel) {
    // (itemModel.category?.type.name ?? "") == "item"
    //     ?
    Get.toNamed(
      "ItemDetailScreen",
      arguments: itemModel.id,
    );
    // : Get.toNamed(
    //     "ServiceDetailScreen",
    //     arguments: itemModel.id,
    //   );
  }
}
