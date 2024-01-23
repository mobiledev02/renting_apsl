import 'custom_text.dart';
import 'package:flutter/material.dart';

import '../constants/img_font_color_string.dart';
import 'cust_image.dart';

class EmptyScreenUi extends StatelessWidget {
  final String imgUrl;
  final double? height;
  final double? width;
  final String title;
  final String description;

  const EmptyScreenUi(
      {Key? key,
      required this.imgUrl,
      this.title = "",
      this.description = "",
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustImage(
            imgURL: imgUrl,
            height: height,
            width: width,
          ),
          CustomText(
            txtTitle: title,
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomText(
              txtTitle: description,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: custBlack102339.withOpacity(0.4),
                  ),
              align: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
