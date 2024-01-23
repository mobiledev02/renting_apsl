import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../cards/item_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../controller/item_controller.dart';
import '../../../main.dart';
import '../../../models/menu_model.dart';
import '../../../widgets/cust_image.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/empty_screen_ui.dart';
import '../../../widgets/spinner.dart';

class ItemViewAllScreen extends GetView<ItemController> {
  final String catId;
  final String searchedTextName;

  ItemViewAllScreen({
    this.catId = "",
    this.searchedTextName = "",
  }) {
    if (catId.isNotEmpty || searchedTextName.isNotEmpty) {
      initialApiCall.value = true;
      Future.delayed(Duration(milliseconds: 200), () {
        controller
            .fetchItems(
          controller.type.value,
          context: getContext,
          categoryId: catId,
          name: searchedTextName,
          forRefresh: true,
        )
            .then((value) {
          initialApiCall.value = false;
        });
      });
    }
  }

  List<String> menuItems = ["Recommended", "Price(Highest)", "Price(Lowest)"];

  String selectedFilter = "Recommended";

  String sortBy = "";

  ValueNotifier _filterNotifier = ValueNotifier(true);

  ValueNotifier _statusFilterNotifier = ValueNotifier(true);

  RxBool initialApiCall = false.obs;

  List<bool> _isSelected = [false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        /// item name
        title: StaticString.items,
        backFunction: () async {
          // Get.back();
          await Future.delayed(Duration(milliseconds: 500));
          if (selectedFilter != "Recommended" || catId.isNotEmpty) {
            await controller.fetchItems(
              controller.type.value,
              context: getContext,
              sortBy: "",
              forRefresh: true,
              name: searchedTextName,
            );
          }
        },
        actions: [
          // _buildFilterDropdown(),

          ValueListenableBuilder(
            valueListenable: _statusFilterNotifier,
            builder: (context, val, child) {
              return ToggleButtons(
                color: primaryColor,
                constraints: BoxConstraints(minHeight: 30, minWidth: 60),
                borderRadius: BorderRadius.circular(12.0),
                children: <Widget>[
                  FittedBox(child: Text('All', style: TextStyle(fontSize: 8),)),
                  FittedBox(child: Text('Available', style: TextStyle(fontSize: 8),)),
                ],
                isSelected: _isSelected,
                onPressed: (int index) {
                 // setState(() {
                     for(int i = 0; i<_isSelected.length; i++) {
                       if(i == index) {
                         _isSelected[i] = true;
                         if(i == 0) {
                           controller.type.value = 'all';
                         }
                         else {
                           controller.type.value = 'available';
                         }
                       }
                       else {
                         _isSelected[i] = false;
                       }
                       controller.fetchItems(controller.type.value, context: context,forRefresh: true);
                     }
                    _statusFilterNotifier.notifyListeners();
                 // });
                },
              );
            },
          ),

          const SizedBox(width: 4,),
          ValueListenableBuilder(
              valueListenable: _filterNotifier,
              builder: (context, val, child) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<MenuItemModel>(
                    customButton: CustImage(
                      imgURL: ImgName.filterPng,
                      height: 30,
                      width: 30,
                    ),
                    // customItemsIndexes: const [3],
                    // customItemsHeight: 8,
                    items: [
                      ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItemModel>(
                          value: item,
                          child: MenuItems.buildItem(
                            item,
                            selected: selectedFilter == item.text,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) async {
                      selectedFilter = value?.text ?? "Recommended";

                      String sortBy = selectedFilter == "Price(Highest)"
                          ? "desc"
                          : selectedFilter == "Price(Lowest)"
                              ? "asc"
                              : "";

                      await controller.fetchItems(
                        controller.type.value,
                        context: getContext,
                        sortBy: sortBy,
                        forRefresh: true,
                        categoryId: catId,
                      );

                      _filterNotifier.notifyListeners();
                    },
                    itemHeight: 48,
                    itemPadding: const EdgeInsets.only(left: 16, right: 16),
                    dropdownWidth: 180,
                    dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    dropdownElevation: 8,
                    offset: const Offset(0, 8),
                  ),
                );
              }),

          const SizedBox(
            width: 14,
          ),
        ],
      ),
      body: _buildItemList(),

      // Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      //       child: _buildSearchTextFormField(),
      //     ),
      //     Expanded(
      //       child: _buildItemList(),
      //     ),
      //   ],
      // ),
    );
  }

  // /// Search Text Form Field
  // Widget _buildSearchTextFormField() {
  //   return Focus(
  //     onFocusChange: (val) async {
  //       if (!val) {
  //         _searchedTextDetection?.disposeListners();
  //         return;
  //       }

  //       _searchedTextDetection = SearchedTextDetection(
  //         searchQueryController: searchController,
  //         onSearchedText: onChangeAction,
  //         onEmptyText: () => onChangeAction(""),
  //       );
  //     },
  //     child: SizedBox(
  //       height: 38,
  //       child: TextFormField(
  //         onChanged: (value) {
  //           // searchList = itemController.itemList
  //           //     .where((element) => element.name.contains(value))
  //           //     .toList();
  //           // setState(() {});
  //         },
  //         controller: searchController,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: const BorderSide(
  //               width: 0,
  //             ),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: const BorderSide(width: 0, color: Colors.transparent),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: const BorderSide(width: 0, color: Colors.transparent),
  //           ),
  //           filled: true,
  //           fillColor: custBlack102339.withOpacity(0.04),
  //           contentPadding: const EdgeInsets.only(
  //             left: 5,
  //             right: 5,
  //             top: 4,
  //           ),
  //           prefixIcon: CustImage(
  //             height: 16,
  //             width: 16,
  //             imgURL: ImgName.searchImage,
  //           ),
  //           hintText: StaticString.search,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> onChangeAction(String val) async {
  //   try {
  //     searchedText = val;
  //     await controller.fetchItems(
  //       context: getContext,
  //       forSearch: true,
  //       name: val,
  //     );
  //   } catch (e) {
  //     showAlert(context: getContext, message: e);
  //   }
  // }

  // Item List
  Widget _buildItemList() {
    return Obx(() {
      return controller.loadingItems.value || initialApiCall.value
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 26,
                      width: 26,
                      child: Spinner(),
                    ),
                  ],
                ),
              ),
            )
          : controller.getItemList.isEmpty
              ? EmptyScreenUi(
                  width: 180.0,
                  height: 80.0,
                  imgUrl: ImgName.browseEmptyImage,
                  title: StaticString.noResults,
                  description: StaticString.noItemsToLeftShow,
                )
              : LazyLoadScrollView(
                  onEndOfPage: () async {
                    await controller.fetchItems(
                      controller.type.value,
                      context: getContext,
                      categoryId: catId,
                      name: searchedTextName,
                    );
                  },
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: CustImage(
                        imgURL: ImgName.divider,
                        height: 1,
                      ),
                    ),
                    itemCount: controller.lazyLoadingItems.value
                        ? controller.getItemList.length + 1
                        : controller.getItemList.length,
                    itemBuilder: (_, index) {
                      return controller.lazyLoadingItems.value &&
                              controller.getItemList.length == index
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Spinner(),
                                ),
                              ],
                            )
                          : ItemCard(
                              context: getContext,
                              itemModel: controller.getItemList[index],
                            );
                    },
                  ),
                );
    });
  }
}
