import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:renting_app_mobile/cards/category_card.dart';
import 'package:renting_app_mobile/controller/category_controller.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/screen/rent/service/service_category.dart';
import 'package:renting_app_mobile/screen/rent/service/service_view_all_screen.dart';
import '../../../cards/home_service_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../main.dart';
import '../../../widgets/cust_button.dart';
import '../../../widgets/custom_alert.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/empty_screen_ui.dart';
import '../../../widgets/spinner.dart';

class ServiceHomeScreen extends StatefulWidget {
  final String searchedText;

  const ServiceHomeScreen({
    required this.searchedText,
  });

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  ItemController get controller => Get.find<ItemController>();

  CategoryContoller get getCategoryController => Get.find<CategoryContoller>();
  final String searchedText;

  _ServiceHomeScreenState({
    this.searchedText = "",
  });


  Future<void> fetchServiceData() async {
    try {
      if (controller.serviceList.isEmpty) {
        controller.fetchServices(
          context: getContext,
          name: widget.searchedText,
        );
      }
      if (getCategoryController.listOfCategoryService.isEmpty) {
        await getCategoryController.fetchCategories(type: "service");
      }
    } catch (e) {
      showAlert(context: getContext, message: e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.currentRoute == "ServiceViewAllScreen") return;
    fetchServiceData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchedText.isEmpty)
    {
      return _buildServiceList();
    } else {
      return _buildSearchResults();
    }
  }

  // service list
  Widget _buildServiceList() {
    print("REBUILD SERVICE HOME SCREEN");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Services text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServicesAndItemTitle(
                title: StaticString.categories,
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),

        /// Service list
          Obx(
            () {
              
                return SizedBox(
                  height: 420,
                  child: getCategoryController.fetchingCatForService.value
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
            }
          ),
      ],
    );
  }

  /// Services And Item text
  Widget _buildServicesAndItemTitle({
    required String title,
  }) {
    return CustomText(
      txtTitle: title,
      style: Theme.of(getContext).textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildSearchResults()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServicesAndItemTitle(
                title: StaticString.searchResults,
              ),
              commonViewAllButton(
                onPressed: () async {
                  Get.to(
                    () => ServiceViewAllScreen(
                      searchedTextName: widget.searchedText,
                    ),
                  );
                  // reverseSearchText(searchedTextOnback);
                },
              ),
            ],
          ),
         ),
         Obx(() {
          return controller.loadService.value
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
              : controller.getServiceList.isEmpty
                  ? EmptyScreenUi(
                      width: 180.0,
                      height: 80.0,
                      imgUrl: ImgName.browseEmptyImage,
                      title: StaticString.noResults,
                      description: StaticString.noServicesLeftToShow,
                    )
                  : ListView.separated(
                      // controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
                    );
         },)
      ],
    );
  }

  /// Service List
  Widget _buildCategoryList() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 200 / 190,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: getCategoryController.getCategoryServiceList.length,
      itemBuilder: (BuildContext ctx, index) {
        return GestureDetector(
          onTap: () async {
            Get.to(
              () => ServiceViewAllScreen(
                catId: getCategoryController.getCategoryServiceList[index].id.toString(),
                searchedTextName: widget.searchedText,
              ),
            );
          },
          child: CategoryCard(
            categoryModel: getCategoryController.getCategoryServiceList[index],
          ),
        );
      },
    );
  }
}
