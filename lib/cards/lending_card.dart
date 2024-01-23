// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controller/lend_controller.dart';
import '../constants/img_font_color_string.dart';
import '../main.dart';
import '../models/item_model.dart';
import '../utils/custom_enum.dart';
import '../widgets/common_widgets.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_alert.dart';
import '../widgets/custom_text.dart';

class LendingCard extends GetView<LendController> {
  LendingCard({
    Key? key,
    required this.itemModel,
  }) : super(key: key);
  ItemModel itemModel = ItemModel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _lendingItem,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// item image
          Stack(
            children: [
              Container(
                height: 110,
                width: 160,
                padding: const EdgeInsets.only(top: 4),
                child: CustImage(
                  defaultImageWithDottedBorder: true,
                  imgURL: (itemModel.images?.isEmpty ?? true)
                      ? ""
                      : itemModel.images?[0].imageUrl ?? "",
                  height: 106,
                  width: 160,
                  cornerRadius: 10,
                ),
              ),
              Positioned(
                top: 10,
                right: 1,
                child: itemModel.category?.type == ItemOrService.service && itemModel.offerCount != null && itemModel.offerCount! > 0
                    ? Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            txtTitle: '${itemModel.offerCount! > 99 ? "99+" : itemModel.offerCount} offer(s)',
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.0),
                          ),
                        ),
                      )
                    : const SizedBox(),
              )
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          /// Item name
          CustomText(
            textOverflow: TextOverflow.ellipsis,
            txtTitle: itemModel.name,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              // /// tag
              itemAndServiceTagCard(
                  ItemOrServices: itemModel.category?.type.name ?? ""),
              const SizedBox(
                width: 20,
              ),

              /// edit Button
              customIconButton(
                icon: ImgName.editButton,
                onTap: _edit,
                iconHeight: 10,
                iconWidth: 8,
                bgColor: primaryColor.withOpacity(0.1),
                buttonHeight: 24,
                buttonWidth: 30,
              ),

              const SizedBox(
                width: 10,
              ),

              /// delete button
              customIconButton(
                icon: ImgName.delete,
                onTap: _delete,
                iconHeight: 10,
                iconWidth: 8.43,
                bgColor: custRedFF3F50.withOpacity(0.1),
                buttonHeight: 24,
                buttonWidth: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //!-------------------------------- Button Action----------------------------------------
  //  Edit Button Action
  void _edit() {
    if ((itemModel.category?.type ?? ItemOrService.item) ==
        ItemOrService.item) {
      Get.toNamed("LendNewItemFormScreen", arguments: itemModel.id);
    } else {
      Get.toNamed("LendNewServiceFormScreen", arguments: itemModel.id);
    }
  }

  //  Delete Button Action
  void _delete() {
    if ((itemModel.category?.type ?? ItemOrService.item) ==
        ItemOrService.item) {
      showAlert(
          signleBttnOnly: false,
          context: getContext,
          title: "Delete Item",
          message: StaticString.itemDeleteAlertMsg,
          rigthBttnTitle: StaticString.delete,
          leftBttnTitle: StaticString.cancel,
          onRightAction: () async {
            try {
              await controller.deleteItemAndService(
                  context: getContext, id: itemModel.id ?? 0);
            } catch (e) {
              showAlert(context: getContext, message: e);
            } finally {
              // await itemController.fetchMyItems(
              //   context: context,
              //   onTap: true,
              // );
              // Get.back();
            }
          });
    } else {
      showAlert(
          signleBttnOnly: false,
          context: getContext,
          title: "Delete Service",
          message: StaticString.itemDeleteAlertMsg,
          rigthBttnTitle: StaticString.delete,
          leftBttnTitle: StaticString.cancel,
          onRightAction: () async {
            try {
              await controller.deleteItemAndService(
                  context: getContext, id: itemModel.id ?? 0);
            } catch (e) {
              showAlert(context: getContext, message: e);
            } finally {
              // await itemController.fetchMyItems(
              //   context: context,
              //   onTap: true,
              // );
              // Get.back();
            }
          });
    }
  }

  // Lending history card Action
  void _lendingItem() {
    if ((itemModel.category?.type ?? ItemOrService.item) ==
        ItemOrService.item) {
      Get.toNamed("ItemStatusScreen", arguments: itemModel.id);
    } else {
      Get.toNamed("ServiceStatusScreen", arguments: itemModel.id);
    }

    // Get.to(() => const ServiceStatusScreen());
  }
}
