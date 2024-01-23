import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import '../constants/img_font_color_string.dart';
import '../models/item_model.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/rich_text.dart';

class ServiceCard extends StatelessWidget {
  ServiceCard({
    Key? key,
    required this.context,
    required this.serviceModel,
    this.onTap,
  }) : super(key: key);
  final BuildContext context;
  final ItemModel serviceModel;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => _cardOnTap(serviceModel),
      child: Container(
        width: 180,
        height: 200,
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            /// Srevice Image
            CustImage(
              height: 200,
              width: 180,
              imgURL: serviceModel.getFirstImageModel?.imageUrl ?? "",
              boxfit: BoxFit.cover,
              cornerRadius: 10,
              //! Comment
              errorImage: ImgName.image3,
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 127,
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    txtTitle: serviceModel.name,
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: custWhiteFFFFFF,
                        ),
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //  service Category
                  CustomText(
                    txtTitle: serviceModel.category?.name,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: custWhiteFFFFFF,
                          fontWeight: FontWeight.w600,
                        ),
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  // Service rate
                  CustomRichText(
                    title: "\$${serviceModel.price}",
                    normalTextStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: custWhiteFFFFFF,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: CustomFont.redHatDisplay,
                    ),
                    fancyTextStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: custWhiteFFFFFF,
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
    //     ? Get.toNamed(
    //         "ItemDetailScreen",
    //         arguments: itemModel.id,
    //       )
    //     :
    Get.toNamed(
      "ServiceDetailScreen",
      arguments: itemModel.id,
    );
  }
}
