import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart' as lazyLoad;

import '/widgets/custom_alert.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_dropdown1.dart/cust_focus_menu.dart';
import '../../widgets/custom_dropdown1.dart/custom_dropdown.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/empty_screen_ui.dart';
import '../../widgets/searched_text_detection.dart';
import '/cards/lending_card.dart';
import '/constants/img_font_color_string.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/spinner.dart';
import '../../controller/item_controller.dart';
import '../../main.dart';

class MyLendingHistoryScreen extends GetView<ItemController> {
  MyLendingHistoryScreen({Key? key}) {
    controller.lazyLoadingMyLending.value = true;
  }

  //!-------------------------------------- variable -----------------------------
  TextEditingController searchController = TextEditingController();
  SearchedTextDetection? _searchedTextDetection;

  // filter

  List<String> selectedMenu = [];

  void onChangeAction(String val) async {
    try {
      await controller.fetchMyItems(
        context: getContext,
        name: val,
        onTap: true,
        type: selectedMenu.length == 2 || selectedMenu.isEmpty
            ? ""
            : selectedMenu[0],
      );
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.myLendingHistory,
        backFunction: () {
          controller.fetchMyItems(
            context: getContext,
            onTap: true,
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _buildSearchBar(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GetBuilder<ItemController>(
                builder: (context) => lazyLoad.LazyLoadScrollView(
                  // scrollOffset: 500,
                  onEndOfPage: () async {
                    try {
                      controller.lazyLoading.value = true;

                      await controller.fetchMyItems(
                          context: getContext, forRefresh: false);
                    } catch (e) {
                      showAlert(context: getContext, message: e);
                    } finally {
                      controller.lazyLoading.value = false;
                    }
                  },
                  child: Column(
                    children: [
                      Obx(() {
                        return context.loadingHomeScreenData.value
                            ? Expanded(child: Spinner())
                            : controller.myItemList.isEmpty
                                ? Expanded(
                                    child: EmptyScreenUi(
                                      imgUrl: ImgName.emptylendingImage,
                                      width: 200,
                                      height: 132.5,
                                      title: StaticString.whoops,
                                      description:
                                          StaticString.lookLikeTheresNoData,
                                    ),
                                  )
                                : Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        searchController.clear();
                                        print("Refresh");
                                        await controller.fetchMyItems(
                                          context: getContext,
                                          forRefresh: true,
                                          type: selectedMenu.length == 2 ||
                                                  selectedMenu.isEmpty
                                              ? ""
                                              : selectedMenu[0],
                                        );
                                      },
                                      child: GridView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 156 / 170,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemCount: controller.myItemList.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          // if (index < controller.myItemList.length) {
                                          return LendingCard(
                                            itemModel:
                                                controller.myItemList[index],
                                          );
                                          // } else {
                                          //   return controller.lazyLoadingMyLending.value == true
                                          //       ? Spinner()
                                          //       : Spinner();
                                          // }
                                        },
                                      ),
                                    ),
                                  );
                      }),
                      controller.lazyLoading.value ? Spinner() : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    return GetBuilder<ItemController>(builder: (context) {
      return CustomDropdown(
        openWithTap: true,
        focusChildPadding: EdgeInsets.only(
          left: MediaQuery.of(getContext).size.width - 110 - 30,
          right: 0,
        ),
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

                        await controller.fetchMyItems(
                          context: getContext,
                          name: searchController.text,
                          onTap: true,
                          type: selectedMenu.length == 2 || selectedMenu.isEmpty
                              ? ""
                              : selectedMenu[0],
                        );

                        // }
                      },
                    ),
                    CustomText(
                      txtTitle: data.name.capitalizeFirst,
                      style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
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

                  await controller.fetchMyItems(
                    context: getContext,
                    name: searchController.text,
                    onTap: true,
                    type: selectedMenu.length == 2 || selectedMenu.isEmpty
                        ? ""
                        : selectedMenu[0],
                  );

                  // }
                },
              ),
            )
            .toList(),
      );
    });
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
}
