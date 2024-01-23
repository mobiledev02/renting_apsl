import 'package:flutter/material.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';
import 'package:renting_app_mobile/models/categories_model.dart';
import 'package:renting_app_mobile/widgets/cust_image.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryCard({Key? key, required this.categoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: 160,
            padding: const EdgeInsets.only(top: 4),
            decoration: categoryModel.imageUrl.isEmpty
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                        color: Colors.black.withOpacity(0.25),
                      )
                    ],
                  ),
            child: CustImage(
              defaultImageWithDottedBorder: true,
              imgURL: categoryModel.imageUrl,
              height: 106,
              width: 160,
              cornerRadius: 10,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          CustomText(
            txtTitle: categoryModel.name,
            maxLine: 2,
            style:
            Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
          )
        ],
      ),
    );
  }
}
