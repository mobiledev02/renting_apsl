import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cards/category_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../controller/category_controller.dart';

import '../../../widgets/custom_appbar.dart';

import 'item_view_all_screen.dart';

class ItemCategoriesScreen extends GetView<CategoryContoller> {
  final String searchedText;

  ItemCategoriesScreen({
    Key? key,
    this.searchedText = "",
  }) : super(key: key);

  // TextEditingController searchController = TextEditingController();

  // SearchedTextDetection? _searchedTextDetection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        /// item name
        title: StaticString.itemCategoryTitle,
      ),
      body: _buildCategoryList(),

      // Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      //       child: _buildSearchTextFormField(),
      //     ),
      //     Expanded(
      //       child: _buildCategoryList(),
      //     )
      //   ],
      // ),
    );
  }

  GridView _buildCategoryList() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 200 / 190,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: controller.getCategoryItemList.length,
      itemBuilder: (BuildContext ctx, index) {
        return GestureDetector(
          onTap: () async {
            await Get.to(
              () => ItemViewAllScreen(
                catId: controller.getCategoryItemList[index].id.toString(),
                searchedTextName: searchedText,
              ),
            );
          },
          child: CategoryCard(
            categoryModel: controller.getCategoryItemList[index],
          ),
        );
      },
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

// void onChangeAction(String val) async {
//   try {
//     print(val);
//   } catch (e) {
//     showAlert(context: getContext, message: e);
//   }
// }
}
