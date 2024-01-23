// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/custom_appbar.dart';
import '../../cards/item_card.dart';
import '../../constants/img_font_color_string.dart';
import '../../controller/item_controller.dart';
import '../../main.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_dropdown1.dart/cust_focus_menu.dart';
import '../../widgets/custom_dropdown1.dart/custom_dropdown.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/empty_screen_ui.dart';
import '../../widgets/searched_text_detection.dart';

class HistoryScreen extends GetView<ItemController> {
  HistoryScreen({Key? key}) {
    // onChangeAction("");
  }

  //!-------------------------------------- variable -----------------------------
  TextEditingController searchController = TextEditingController();
  SearchedTextDetection? _searchedTextDetection;

  // filter

  List<String> selectedMenu = [];

  void onChangeAction(String val) async {
    try {
      debugPrint("* * * * * * * 13 ");
      await controller.fetchItems(
        'all',
        context: getContext,
        name: val,
      );
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "History"),
      body: Column(
        children: [
          /// Search text form field
          _buildSearchBar(),
          const SizedBox(
            height: 20,
          ),

          /// History list
          _buildItemList(),
        ],
      ),
    );
  }

  //!---------------------------------------- Widget -----------------------------------
  // search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            /// Search Text Form Field
            child: _buildSearchTextFormField(),
          ),
          const SizedBox(
            width: 31.00,
          ),
          // //Request Button
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  /// Search Text Form Field
  Widget _buildSearchTextFormField() {
    return Focus(
      onFocusChange: (val) async {
        if (!val) {
          _searchedTextDetection?.disposeListners();
          return;
        }

        _searchedTextDetection = SearchedTextDetection(
          searchQueryController: searchController,
          onSearchedText: onChangeAction,
          onEmptyText: () => onChangeAction(""),
        );
      },
      child: SizedBox(
        height: 38,
        child: TextFormField(
          onChanged: (value) {
            // searchList = itemController.itemList
            //     .where((element) => element.name.contains(value))
            //     .toList();
            // setState(() {});
          },
          controller: searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 0, color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 0, color: Colors.transparent),
            ),
            filled: true,
            fillColor: custBlack102339.withOpacity(0.04),
            contentPadding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 4,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                right: 0,
              ),
              child: CustImage(
                height: 16,
                width: 16,
                imgURL: ImgName.searchImage,
                errorImage: ImgName.imagePlacheHolderImage,
              ),
            ),
            hintText: StaticString.search,
          ),
        ),
      ),
    );
  }

  /// Filter Button
  Widget _buildFilterDropdown() {
    return GetBuilder<ItemController>(
      builder: (context) {
        return CustomDropdown(
          openWithTap: true,
          focusChildPadding: EdgeInsets.only(
              left: MediaQuery.of(getContext).size.width - 110 - 30, right: 0),
          borderRadius: BorderRadius.circular(10),
          menuItemExtent: 34,
          menuWidth: double.infinity,
          menuHeight: 81,
          child: _buildFilterButton(),
          focusChild: _buildFilterButton(),
          onTap: () {},
          onFocusedChildTap: () {},
          menuItems: FilterMenu.values
              .map<FocusedMenuItem>(
                (data) => FocusedMenuItem(
                  backgroundColor: Colors.white,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: selectedMenu.contains(data.name),
                        onChanged: (value) async {
                          // if (mounted) {
                          //   setState(() {
                          if (selectedMenu.contains(data.name)) {
                            selectedMenu.remove(data.name);
                          } else {
                            selectedMenu.add(data.name);
                          }
                          // });

                          Get.back();
                          debugPrint("* * * * * * * 12 ");
                          await controller.fetchItems(
                            'all',
                            context: getContext,
                            name: searchController.text,
                          );

                          // }
                        },
                      ),
                      CustomText(
                        txtTitle: data.name.capitalizeFirst,
                        style:
                            Theme.of(getContext).textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    // if (mounted) {
                    //   setState(() {
                    if (selectedMenu.contains(data.name)) {
                      selectedMenu.remove(data.name);
                    } else {
                      selectedMenu.add(data.name);
                    }
                    // });

                    Get.back();
                    debugPrint("* * * * * * * 11 ");
                    await controller.fetchItems(
                      'all',
                      context: getContext,
                      name: searchController.text,
                    );

                    // }
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// Filter Button
  Widget _buildFilterButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 80,
        height: 32,
        decoration: BoxDecoration(
          color: custGreen02957D.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustImage(
              imgURL: ImgName.filter,
              imgColor: custGreen02957D,
              width: 12,
              height: 9.33,
            ),
            const CustomText(
              txtTitle: StaticString.filter, //filter
              style: TextStyle(
                fontSize: 12,
                // letterSpacing: 1,
                fontWeight: FontWeight.w500,
                color: custGreen02957D,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // item list
  Widget _buildItemList() {
    return Obx(
      () => controller.getItemList.isEmpty
          ? Expanded(
              child: EmptyScreenUi(
                width: 350.0,
                height: 262.5,
                imgUrl: ImgName.browseEmptyImage,
                title: StaticString.noResults,
                description: StaticString.noItemsToLeftShow,
              ),
            )
          : Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  searchController.clear();

                  debugPrint("* * * * * * * 10 ");
                  await controller.fetchItems(
                    'all',
                    context: getContext,
                  );
                },
                child: ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: CustImage(
                      imgURL: ImgName.divider,
                    ),
                  ),
                  itemCount: controller.getItemList.length,
                  itemBuilder: (_, index) {
                    return ItemCard(
                      context: getContext,
                      itemModel: controller.getItemList[index],
                      onTap: _cardTap,
                    );
                  },
                ),
              ),
            ),
    );
  }

  //!------------------------------------------------ Widget -------------------------------
  void _cardTap() {
    debugPrint(
        "********************************* Card tap **************************************");
    Get.toNamed("HistoryDetailScreen");
  }
}
