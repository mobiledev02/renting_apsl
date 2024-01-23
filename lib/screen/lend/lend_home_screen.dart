// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, must_be_immutable, use_key_in_widget_constructors

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';

import '/widgets/cust_button.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/spinner.dart';
import '../../controller/category_controller.dart';
import '/constants/img_font_color_string.dart';
import '/controller/request_controller.dart';
import '/widgets/calender_dialog.dart';
import '/widgets/common_widgets.dart';
import '/widgets/custom_text.dart';
import '/widgets/empty_screen_ui.dart';
import '../../cards/lending_card.dart';
import '../../cards/request_card.dart';
import '../../controller/item_controller.dart';
import '../../main.dart';
import '../../widgets/custom_alert.dart';

class LendHomeScreen extends GetView<ItemController> {
  LendHomeScreen() {
    try {
      controller.lazyLoadingMyLending.value = true;

      // controller.itemList

      controller.fetchMyItems(
        context: getContext,
        forRefresh: false,
        onTap: false,
      );
      requestController.fetchRequest(
        context: getContext,
        onTap: true,
      );
      if (categoryContoller.listOfCategoryItem.isEmpty) {
        Future.delayed(Duration(microseconds: 100), () {
          categoryContoller.fetchCategories(type: "item");
        });
      }
      if (categoryContoller.listOfCategoryService.isEmpty) {
        Future.delayed(Duration(microseconds: 200), () {
          categoryContoller.fetchCategories(type: "service");
        });
      }

      // await itemController.fetchMyItems(context: context, forRefresh: false);
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

//!------------------------------------------- variable ----------------------------------------

  final _authController = Get.find<AuthController>();

  DateTime _selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat("y-MM-d");

  RequestController requestController = Get.find<RequestController>();
  ItemController itemController = Get.find<ItemController>();
  CategoryContoller categoryContoller = Get.find<CategoryContoller>();

  RxInt selectedTabIndex = 0.obs;

  // Future<void> _fetchRequest({required BuildContext context}) async {
  //   try {
  //     await requestController.fetchRequest(context: context);
  //     // await itemController.fetchMyItems(context: context, forRefresh: false);
  //   } catch (e) {
  //     showAlert(context: context, message: e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _fetchRequest(context: context);
    return Scaffold(
      appBar: CustomAppbar(
        isBackButton: false,
        title: StaticString.lendingHomeScreen,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchMyItems(
              context: getContext,
            );
            await requestController.fetchRequest(
              context: getContext,
              onTap: true,
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: RefreshIndicator(
              onRefresh: () async {
                try {
                  controller.lazyLoadingMyLending.value = true;

                  // controller.itemList
                  controller.fetchMyItems(
                    context: getContext,
                    onTap: true,
                  );
                  requestController.fetchRequest(
                      context: getContext, onTap: true);

                  Future.delayed(Duration(microseconds: 100), () {
                    categoryContoller.fetchCategories(type: "item");
                  });

                  Future.delayed(Duration(microseconds: 200), () {
                    categoryContoller.fetchCategories(type: "service");
                  });

                  // await itemController.fetchMyItems(context: context, forRefresh: false);
                } catch (e) {
                  showAlert(context: getContext, message: e);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 18,
                  ),

                  /// lend new item And service button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildLendNewItemAndServiceButton(),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //---------------Text Your Lending History---------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildTitleText(title: StaticString.yourLendingHistory),
                        const Spacer(),

                        /// view more
                        InkWell(
                          onTap: _viewAll,
                          child: CustomText(
                            txtTitle: StaticString.viewAll,
                            style:
                                Theme.of(context).textTheme.overline?.copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),

                  /// your history List

                  GetBuilder<ItemController>(
                    builder: (context) {
                      return Obx(() {
                        return itemController.loadingMyItemService.value
                            ? SizedBox(height: 160, child: Spinner())
                            : itemController.myItemList.isEmpty
                                ? EmptyScreenUi(
                                    imgUrl: ImgName.emptylendingImage,
                                    width: 200,
                                    height: 132.5,
                                    title: StaticString.whoops,
                                    description:
                                        StaticString.lookLikeTheresNoData,
                                  )
                                : SizedBox(
                                    height: 170,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 20,
                                      ),
                                      // gridDelegate:
                                      //     const SliverGridDelegateWithMaxCrossAxisExtent(
                                      //   maxCrossAxisExtent: 200,
                                      //   crossAxisSpacing: 20,
                                      //   childAspectRatio: 156 / 170,
                                      //   mainAxisSpacing: 20,
                                      // ),
                                      // physics:
                                      //     const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          itemController.myItemList.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          height: 170,
                                          width: 150,
                                          child: LendingCard(
                                            itemModel: itemController
                                                .myItemList[index],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                      });
                    },
                  ),

                  // -------------- Request Near you text----------
                  const SizedBox(
                    height: 20,
                  ),
                  // _buildItemServiceTabBar(),

                  ///Request Near You Text And Calender Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildRequestNearYouTextAndCalenderButton(context),
                  ),

                  /// --------------Request list--------------
                  GetBuilder<RequestController>(
                    builder: (context) {
                      return Obx(() {
                        return requestController.loadingRequest.value
                            ? Spinner()
                            : requestController.listOfRequest.isEmpty
                                ? EmptyScreenUi(
                                    imgUrl: ImgName.emptylendingImage,
                                    width: 200,
                                    height: 132.5,
                                    title: StaticString.whoops,
                                    description:
                                        StaticString.lookLikeTheresNoData,
                                  )
                                : Column(
                                    children: [
                                      ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 12,
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 14,
                                          left: 20,
                                          right: 20,
                                        ),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: requestController
                                            .listOfRequest.length,
                                        itemBuilder: (context, index) {
                                          return RequestCard(
                                            onTap: _requestCard,
                                            requestModel: requestController
                                                .listOfRequest[index],
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (requestController
                                              .listOfRequest.length >
                                          3)
                                        InkWell(
                                          onTap: _viewMore,
                                          child: Center(
                                            child: CustomText(
                                              txtTitle: StaticString.viewAll,
                                              style: Theme.of(getContext)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//!-----------------------Widget------------------------------
  /// custom title
  Widget _buildTitleText({required String title}) {
    return CustomText(
      txtTitle: title,
      style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// lend new item And service button
  Widget _buildLendNewItemAndServiceButton() {
    return Row(
      children: [
        // ---------------Lend New Item Button---------------
        Flexible(
          child: CustomButton(
            buttonTitle: StaticString.lendNewItem,
            onPressed: _lendNewItem,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        // ---------------Lend a service Button---------------
        Flexible(
          child: CustomButton(
            buttonTitle: StaticString.lendAService,
            onPressed: _lendAService,
          ),
        ),
      ],
    );
  }

  ///Request Near You Text And Calender Button
  Widget _buildRequestNearYouTextAndCalenderButton(BuildContext context) {
    return Row(
      children: [
        _buildTitleText(title: StaticString.requestsNearYou),

        const Spacer(),

        /// Calender Icon Button
        _buildCalenderIconButton(context)
      ],
    );
  }

  /// Calender Icon Button
  Widget _buildCalenderIconButton(BuildContext context) {
    return customIconButton(
      icon: ImgName.calender,
      buttonHeight: 26.00,
      buttonWidth: 26.00,
      iconHeight: 12.00,
      iconWidth: 10.41,
      onTap: () => showCalender(
          context: context,
          selectedDay: _selectedDate,
          firstDate: DateTime(_selectedDate.year - 1),
          currentDate: _selectedDate,
          focusedDay: _selectedDate,
          setDateOnCallBack: (date) async {
            // requestList = requestController.listOfRequest
            //     .where((p0) => p0.needBy == formatter.format(date))
            //     .toList();
            // print(requestList);
            try {
              await requestController.fetchRequest(
                  context: context, date: formatter.format(date), onTap: true);
              _selectedDate = date;
            } catch (e) {
              showAlert(context: context, message: e);
            }

            // requestController.notifyRequestcontroller();
          }),
      bgColor: primaryColor.withOpacity(0.1),
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
      child: DefaultTabController(
        length: 2,
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
            Tab(text: "Requests"),
            Tab(text: "Offers"),
          ],
          onTap: (index) async {
            selectedTabIndex.value = index;

           // print(selectedTabIndex.value);
            // switch (index) {
            //   case 0:
            //     break;
            //   case 1:
            //     break;
            // }
          },
        ),
      ),
    );
  }

  //!--------------------------Button action--------------------------
  void _requestCard() {
    return;
    Get.toNamed("ViewRequestedItemScreen");
    // Get.to(const ViewRequestedItemScreen());
    debugPrint(
        "***************************************** Request Card ****************************");
  }

  // Lend New Item Button Action
  void _lendNewItem() {
    debugPrint(
        "***************************************** Lending New item ****************************");
    Get.toNamed("LendNewItemFormScreen");
    // Get.to(() => const LendNewItemFormScreen());
  }

  // Lend New Service Button Action
  void _lendAService() {
    // final user = _authController.getUserInfo;
    // if(user.verified) {
    //   debugPrint(
    //       "***************************************** Lending New Services ****************************");
    //   Get.toNamed("LendNewServiceFormScreen");
    // } else {
    //   Get.toNamed("VerifyIDBackgroundCheckFormScreen");
    // }
       Get.toNamed("LendNewServiceFormScreen");
  }

  // view All Button Action
  void _viewAll() {
    debugPrint(
        "***************************************** View All ****************************");
    Get.toNamed("MyLendingHistoryScreen");
  }

// view More Button Action
  void _viewMore() {
    debugPrint(
        "***************************************** View More ****************************");
    Get.toNamed("ViewAllRequestScreen");
  }
}
