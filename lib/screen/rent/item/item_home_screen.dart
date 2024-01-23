import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:renting_app_mobile/cards/category_card.dart';
import 'package:renting_app_mobile/controller/category_controller.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/screen/rent/item/item_categories.dart';

import '../../../cards/item_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../main.dart';
import '../../../models/menu_model.dart';
import '../../../widgets/cust_button.dart';
import '../../../widgets/cust_image.dart';
import '../../../widgets/custom_alert.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/empty_screen_ui.dart';
import '../../../widgets/spinner.dart';
import 'item_view_all_screen.dart';

class ItemHomeScreen extends StatefulWidget {
  final String searchedText;

  // final Function(String) reverseSearchText;
  ItemHomeScreen({
    required this.searchedText,
    // required this.reverseSearchText,
  });

  @override
  State<ItemHomeScreen> createState() => _ItemHomeScreenState();
}

class _ItemHomeScreenState extends State<ItemHomeScreen> {
  ItemController get controller => Get.find<ItemController>();

  CategoryContoller get getCategoryController => Get.find<CategoryContoller>();
  ValueNotifier _statusFilterNotifier = ValueNotifier(true);
  List<bool> _isSelected = [false, false];
  @override
  void initState() {
    super.initState();
    if (Get.currentRoute == "ItemViewAllScreen") return;
    fetchItemData();
  }

  @override
  void didUpdateWidget(ItemHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Get.currentRoute == "ItemViewAllScreen") return;
    fetchItemData();
  }

  Future<void> fetchItemData() async {
    try {
      if (controller.itemList.isEmpty && widget.searchedText.isEmpty) {
        controller.fetchItems(
          controller.type.value,
          context: getContext,
          name: widget.searchedText,
        );
      }
      if (getCategoryController.listOfCategoryItem.isEmpty) {
        await getCategoryController.fetchCategories(type: "item");
      }
    } catch (e) {
      showAlert(
        context: getContext,
        message: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemList();
  }

  // item list
  Widget _buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Category text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServicesAndItemTitle(
                title: StaticString.categories,
              ),
              commonViewAllButton(
                onPressed: () {
                  Get.to(
                    ItemCategoriesScreen(
                      searchedText: widget.searchedText,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),

        /// Category list
        Obx(
          () {
            return SizedBox(
              height: 150,
              child: getCategoryController.fetchingCatForItems.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 26,
                          width: 26,
                          child: Spinner(),
                        ),
                      ],
                    )
                  : _buildCategoryList(),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServicesAndItemTitle(
                title: StaticString.itemsNearYou,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ValueListenableBuilder(
                  //   valueListenable: _statusFilterNotifier,
                  //   builder: (context, val, child) {
                  //     return ToggleButtons(
                  //       color: primaryColor,
                  //       constraints: BoxConstraints(minHeight: 30, minWidth: 60),
                  //       borderRadius: BorderRadius.circular(12.0),
                  //       children: <Widget>[
                  //         FittedBox(child: Text('All', style: TextStyle(fontSize: 8),)),
                  //         FittedBox(child: Text('Available', style: TextStyle(fontSize: 8),)),
                  //       ],
                  //       isSelected: _isSelected,
                  //       onPressed: (int index) {
                  //         // setState(() {
                  //         for(int i = 0; i<_isSelected.length; i++) {
                  //           if(i == index) {
                  //             _isSelected[i] = true;
                  //             if(i == 0) {
                  //               controller.type.value = 'all';
                  //             }
                  //             else {
                  //               controller.type.value = 'available';
                  //             }
                  //           }
                  //           else {
                  //             _isSelected[i] = false;
                  //           }
                  //           controller.fetchItems(controller.type.value, context: context, forRefresh: true);
                  //         }
                  //         _statusFilterNotifier.notifyListeners();
                  //         // });
                  //       },
                  //     );
                  //   },
                  // ),
                  ValueListenableBuilder(
                      valueListenable: _statusFilterNotifier,
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
                              ...MenuItems2.firstItems.map(
                                (item) => DropdownMenuItem<MenuItemModel>(
                                  value: item,
                                  child: MenuItems.buildItem(
                                    item,
                                    selected:
                                        controller.type.value == item.text,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) async {
                              controller.type.value = value?.text ?? "All";

                              // String sortBy = controller.type.value == "Price(Highest)"
                              //     ? "desc"
                              //     : controller.type.value == "Price(Lowest)"
                              //     ? "asc"
                              //     : "";

                              controller.fetchItems(
                                  controller.type.value.toLowerCase(),
                                  context: context,
                                  forRefresh: true);

                              _statusFilterNotifier.notifyListeners();
                            },
                            itemHeight: 48,
                            itemPadding:
                                const EdgeInsets.only(left: 16, right: 16),
                            dropdownWidth: 180,
                            dropdownPadding:
                                const EdgeInsets.symmetric(vertical: 6),
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
                    width: 4,
                  ),
                  commonViewAllButton(
                    onPressed: () async {
                      await Get.toNamed(
                        "ItemViewAllScreen",
                        // arguments: searchedText,
                      );

                      // reverseSearchText(searchedTextOnback);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(() {
          return controller.loadingItems.value
              ? Padding(
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
                )
              : controller.getItemList.isEmpty
                  ? EmptyScreenUi(
                      width: 180.0,
                      height: 80.0,
                      imgUrl: ImgName.browseEmptyImage,
                      title: StaticString.noResults,
                      description: StaticString.noItemsToLeftShow,
                    )
                  : ListView.separated(
                      // controller: scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
                    );
        }),
        // if (controller.lazyLoadingItems.value)
        //   Spinner()
        // else
        //   const SizedBox(),
      ],
    );
  }

  /// Services And Item text
  Widget _buildServicesAndItemTitle({
    required String title,
  }) {
    return CustomText(
      txtTitle: title,
      align: TextAlign.start,
      style: Theme.of(getContext).textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// Service List
  Widget _buildCategoryList() {
    return getCategoryController.listOfCategoryItem.isEmpty
        ? EmptyScreenUi(
            width: 180.0,
            height: 80.0,
            imgUrl: ImgName.browseEmptyImage,
            title: StaticString.noResults,
            description: StaticString.noItemsToLeftShow,
          )
        : LazyLoadScrollView(
            scrollDirection: Axis.horizontal,
            scrollOffset: 100,
            onEndOfPage: () async {
              // try {
              //   await controller.fetchServices(context: getContext);
              // } catch (e) {
              //   showAlert(context: getContext, message: e);
              // } finally {}
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                width: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: getCategoryController.listOfCategoryItem.length > 5
                  ? 5
                  : getCategoryController.listOfCategoryItem.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await Get.to(
                      () => ItemViewAllScreen(
                        catId: getCategoryController
                            .listOfCategoryItem[index].id
                            .toString(),
                        searchedTextName: widget.searchedText,
                      ),
                    );
                  },
                  child: CategoryCard(
                    categoryModel:
                        getCategoryController.listOfCategoryItem[index],
                  ),
                );
              },
            ),
          );
  }
}
