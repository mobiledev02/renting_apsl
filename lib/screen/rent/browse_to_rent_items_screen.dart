// import 'dart:js';

// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart' as lazyLoad;
import 'package:renting_app_mobile/controller/category_controller.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/screen/rent/item/item_home_screen.dart';
import '../../widgets/common_widgets.dart';
import '/constants/img_font_color_string.dart';
import '/controller/auth_controller.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_text.dart';
import '../../controller/item_controller.dart';
import '../../main.dart';
import '../../models/item_model.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/expand_child.dart';
import '../../widgets/searched_text_detection.dart';
import 'service/service_home_screen.dart';

class BrowseToRentItemsScreen extends StatefulWidget {

  BrowseToRentItemsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BrowseToRentItemsScreen> createState() =>
      _BrowseToRentItemsScreenState();
}

class _BrowseToRentItemsScreenState extends State<BrowseToRentItemsScreen> {
// ------------------------------ Variable ----------------------------
  ItemController controller = Get.find<ItemController>();
  CategoryContoller getCategoryController = Get.find<CategoryContoller>();

  TextEditingController searchController = TextEditingController();

  SearchedTextDetection? _searchedTextDetection;

  List<ItemModel>? searchList;

  bool _isExpanded = true;

  ScrollController scrollController = ScrollController();

  RxInt selectedTabIndex = 0.obs;

  // filter
  List<String> selectedMenu = [];

  ValueNotifier _expanNotifier = ValueNotifier(true);

  ValueNotifier _searchNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    controller.lazyLoadingItems.value = true;
    Get.find<PaymentController>().getAccountBalance();

    if (controller.getMilesList.isEmpty) controller.fetchMiles();

    scrollController.addListener(() {
      if ((scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse &&
              _isExpanded) ||
          (scrollController.position.userScrollDirection ==
                  ScrollDirection.forward &&
              !_isExpanded)) {
        _isExpanded = !_isExpanded;

        _expanNotifier.notifyListeners();
      }
    });
  }

  // ------------------------------ UI ----------------------------
  @override
  Widget build(BuildContext context) {
    print("REBUILD BROWSE SCREEN - - - - - - - - - - ");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Welcome Text
                _buildWelcomeText(),

                //search bar
                const SizedBox(
                  height: 20,
                ),
                // Search field
                _buildSearchBar(),

                const SizedBox(
                  height: 25,
                ),

                // Miles selection tab
                _buildMilesSelectionTabs(),

                ///Tab bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildItemServiceTabBar(),
                ),

                Expanded(
                  child: lazyLoad.LazyLoadScrollView(
                    scrollOffset: 150,
                    onEndOfPage: () async {
                      try {
                        if (selectedTabIndex.value == 0) {
                          debugPrint("* * * * * * * 9 ");
                          await controller.fetchItems(
                            controller.type.value,
                            context: getContext,
                            name: searchController.text,
                          );
                        } else {
                          await controller.fetchServices(
                            context: getContext,
                            name: searchController.text,
                          );
                        }
                      } catch (e) {
                        showAlert(context: getContext, message: e);
                      } finally {}
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        print("PULL TO REFRESH - - - - - - - - -");
                        searchController.clear();

                        if (selectedTabIndex.value == 0) {
                          debugPrint("* * * * * * * 8 ");
                          await controller.fetchItems(
                            controller.type.value,
                            context: getContext,
                            forRefresh: true,
                          );

                          await getCategoryController.fetchCategories(
                            type: "item",
                            forRefresh: true,
                          );
                        } else {
                          await controller.fetchServices(
                            context: getContext,
                            forRefresh: true,
                          );
                          Get.find<PaymentController>().getAccountBalance();
                          await getCategoryController.fetchCategories(
                            type: "service",
                            forRefresh: true,
                          );
                        }

                        Get.find<PaymentController>().getAccountBalance();
                        await controller.fetchMiles();
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child:

                            /// Item List
                            ValueListenableBuilder(
                                valueListenable: _searchNotifier,
                                builder: (context, val, child) {
                                  return Obx(
                                    () {
                                      return selectedTabIndex.value == 0
                                          ? ItemHomeScreen(
                                              searchedText:
                                                  searchController.text,
                                              // reverseSearchText: (val) {
                                              //   searchController.text = val;
                                              // },
                                            )
                                          : ServiceHomeScreen(
                                              searchedText:
                                                  searchController.text,
                                              // reverseSearchText: (val) {
                                              //   searchController.text = val;
                                              // },
                                            ); //_buildItemList();
                                    },
                                  );
                                }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemServiceTabBar() {
    return Container(
      height: 38,
      // width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: custBlack102339.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        isScrollable: false,
        unselectedLabelColor: custBlack102339WithOpacity,
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BubbleTabIndicator(
          padding: EdgeInsets.zero,
          insets: EdgeInsets.zero,
          indicatorRadius: 10.00,
          indicatorHeight: 38.0,
          indicatorColor: primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.label,
        ),
        tabs: const [
          Tab(text: "Items"),
          Tab(text: "Services"),
        ],
        onTap: (index) async {
          selectedTabIndex.value = index;

          print(selectedTabIndex.value);
          // switch (index) {
          //   case 0:
          //     break;
          //   case 1:
          //     break;
          // }
        },
      ),
    );
  }

  ValueListenableBuilder<dynamic> _buildMilesSelectionTabs() {
    return ValueListenableBuilder(
      valueListenable: _expanNotifier,
      builder: (context, val, child) {
        return ExpandChild(
          expand: _isExpanded,
          child: _buildDistanceTabbar(),
        );
      },
    );
  }

//!--------------------------- widget---------------------
  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rent It Out
              const CustomText(
                txtTitle: StaticString.reLend, // Rent It Out!
                style: TextStyle(
                  color: custMaterialPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),

          ///  notification button
          InkWell(
            onTap: _notification,
            child: Container(
              height: 40.00,
              width: 40.00,
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10)),
              child: CustImage(
                imgURL: ImgName.notificationIcon,
                height: 20.00,
                width: 15.00,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),

          /// profile  image
          GetBuilder<AuthController>(
            init: AuthController(),
            builder: (authControll) {
              return InkWell(
                onTap: _profileIcon,
                child: CustImage(
                  imgURL: authControll.getUserInfo.profileImage,
                  height: 40.00,
                  width: 40.00,
                  cornerRadius: 10,
                  boxfit: BoxFit.cover,
                  errorImage: ImgName.profileImage,
                  // backgroundColor: Colors.grey.withOpacity(0.5),
                  spinnerHeight: 30,
                  spinnerWidth: 30,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            /// Search Text Form Field
            child: _buildSearchTextFormField(),
          ),
          const SizedBox(
            width: 25.00,
          ),
          //Request Button
          _buildRequestButton(),
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

// Request Button
  Widget _buildRequestButton() {
    return CustomButton(
      onPressed: _requestButton,
      buttonTitle: StaticString.request,
      buttonWidth: 80,
      buttonHeight: 32,
    );
  }

// Distance tabbar
  Widget _buildDistanceTabbar() {
    return GetBuilder<ItemController>(
      builder: (itemController) {
        return SizedBox(
          height: itemController.getMilesList.isEmpty ? 0 : 55,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            separatorBuilder: (context, index) => const SizedBox(
              width: 12,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: itemController.getMilesList.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _distanceTap(
                itemController.getMilesList[index],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: itemController.getMilesList[index] ==
                            itemController.getSelectedMiles
                        ? custMaterialPrimaryColor
                        : custBlack102339.withOpacity(0.1),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  children: [
                    CustImage(
                      imgURL: ImgName.distanceImage,
                      boxfit: BoxFit.contain,
                      height: 14,
                      width: 12,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomText(
                      txtTitle:
                      itemController.getMilesList[index].contains('All') ? 'All' :
                      "${itemController.getMilesList[index]}mi",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// select category
  Future categoryId(int id, BuildContext context) async {
    try {
      await controller.getCategoryItemListById(id: id, context: context);
    } catch (e) {
      showAlert(context: context, message: e);
    }
  }

  void onChangeAction(String val) async {
    try {
      debugPrint("* * * * * * * 6 ");
      await controller.fetchItems(
        controller.type.value,
        context: getContext,
        name: val,
        forSearch: true,
      );

      await controller.fetchServices(
        context: getContext,
        name: val,
        forSearch: true,
      );

      _searchNotifier.notifyListeners();
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  //!---------------------------- Button Action -----------------
  void _notification() {
    debugPrint(
        "***************************************** Notifications   ****************************");
    // Get.to(NotificationScreen());
    Get.toNamed("NotificationScreen");
  }

  void _profileIcon() {
    debugPrint(
        "***************************************** Profile   ****************************");
    Get.toNamed("ViewProfileScreen");
  }

  void _requestButton() {
    debugPrint(
        "***************************************** Request   ****************************");
    // Get.to(RequestItemScreen());
    Get.toNamed("RequestItemScreen");
  }

  void _distanceTap(String distance) async {
    debugPrint(
        "***************************************** Distance  $distance ****************************");
    final bool permissionGranted = await locationDialogueIfLocationIsDisale();

    debugPrint('$permissionGranted');

    if (permissionGranted) {
      controller.selectDeselectMiles(
        mile: distance,
        callApi: false,
      );
    }
  }

  // Widget _buildtotalBalance(BuildContext context) {
  //   return Obx(
  //         () {
  //       return
  //         Get.find<PaymentController>().loadingAccountBalance.value ?
  //         Container(
  //           alignment: Alignment.center,
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 16,
  //           ),
  //           height: 26,
  //           decoration: BoxDecoration(
  //             color: cust41AEF1.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(
  //               10,
  //             ),
  //           ),
  //           child: CustomText(
  //             txtTitle: Get.find<PaymentController>().accountBalance.value != null ? '\$${_paymentController.accountBalance.value}' : 'error', //
  //             style: Theme.of(context).textTheme.caption?.copyWith(color: cust41AEF1),
  //           ),
  //         ) : const SizedBox();
  //     },
  //   );
  // }
}
