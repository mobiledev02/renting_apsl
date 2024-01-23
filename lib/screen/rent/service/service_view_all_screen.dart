import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:renting_app_mobile/cards/home_service_card.dart';

import '../../../constants/img_font_color_string.dart';
import '../../../controller/item_controller.dart';
import '../../../main.dart';
import '../../../models/menu_model.dart';
import '../../../widgets/cust_image.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/empty_screen_ui.dart';
import '../../../widgets/spinner.dart';

class ServiceViewAllScreen extends GetView<ItemController> {
  final String catId;
  final String searchedTextName;

  ServiceViewAllScreen({
    Key? key,
    this.catId = "",
    this.searchedTextName = "",
  }) : super(key: key) {
    if (catId.isNotEmpty || searchedTextName.isNotEmpty) {
      initialApiCall.value = true;

      Future.delayed(const Duration(milliseconds: 200), () {
        controller
            .fetchServices(
          context: getContext,
          sortBy: sortBy,
          forRefresh: true,
          categoryId: catId,
          name: searchedTextName,
        )
            .then((value) {
          initialApiCall.value = false;
        });
      });
    }
  }

  // TextEditingController searchController = TextEditingController();

  // SearchedTextDetection? _searchedTextDetection;

  // String searchedText = "";

  List<String> menuItems = ["Recent", "Price(Highest)", "Price(Lowest)"];

  String selectedFilter = "Recent";

  ValueNotifier _filterNotifier = ValueNotifier(true);
  String sortBy = "";

  RxBool initialApiCall = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        /// item name
        title: StaticString.serviceProviders,
        backFunction: () async {
          Get.back();
          await Future.delayed(Duration(milliseconds: 500));

          await controller.fetchServices(
            context: getContext,
            sortBy: "",
            forRefresh: true,
            name: searchedTextName,
          );
        },
        actions: [
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
                    //  customItemsIndexes: const [3],
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

                      sortBy = selectedFilter == "Price(Highest)"
                          ? "desc"
                          : selectedFilter == "Price(Lowest)"
                              ? "asc"
                              : "";

                      await controller.fetchServices(
                        context: getContext,
                        sortBy: sortBy,
                        forRefresh: true,
                        categoryId: Get.arguments ?? "",
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
      body: _buildServiceList(),

      //  Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      //       child: _buildSearchTextFormField(),
      //     ),
      //     Expanded(
      //       child: _buildServiceList(),
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
  //     await controller.fetchServices(
  //       context: getContext,
  //       forSearch: true,
  //       name: val,
  //     );
  //   } catch (e) {
  //     showAlert(context: getContext, message: e);
  //   }
  // }

  // Item List
  Widget _buildServiceList() {
    return Obx(() {
      return controller.loadService.value || initialApiCall.value
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
          : controller.getServiceList.isEmpty
              ? EmptyScreenUi(
                  width: 180.0,
                  height: 80.0,
                  imgUrl: ImgName.browseEmptyImage,
                  title: StaticString.noResults,
                  description: StaticString.noServicesLeftToShow,
                )
              : LazyLoadScrollView(
                  onEndOfPage: () async {
                    await controller.fetchServices(
                      context: getContext,
                      categoryId: catId,
                      name: searchedTextName,
                    );
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: controller.lazyLoadingServices.value
                        ? controller.getServiceList.length + 1
                        : controller.getServiceList.length,
                    itemBuilder: (_, index) {
                      return controller.lazyLoadingServices.value &&
                              controller.getServiceList.length == index
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
                          : ServiceHomeCard(
                              serviceModel: controller.getServiceList[index],
                            );
                    },
                  ),
                );
    });
  }
}
