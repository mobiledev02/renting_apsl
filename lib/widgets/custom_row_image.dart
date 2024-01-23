// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/cust_image.dart';
import 'custom_alert.dart';

class CustomRowImage extends StatelessWidget {
  CustomRowImage({
    Key? key,
    this.image1,
    this.image2,
    this.height = 100,
    this.width = double.infinity,
  }) : super(key: key);
  String? image1, image2;
  double height, width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildImage(image1 ?? ""),
        const SizedBox(
          width: 15,
        ),
        (image2 ?? "").isEmpty
            ? Expanded(child: SizedBox())
            : _buildImage(image2 ?? ""),
      ],
    );
  }

  //!------------------------Widget---------------------
  //Image widget
  Widget _buildImage(String image) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          zoomablePhotoDialogue(imageUrl: image);
        },
        child: Container(
          decoration: image.isEmpty
              ? null
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(16, 35, 57, 0.2),
                      spreadRadius: 0,
                      blurRadius: 20,
                    ),
                  ],
                ),
          child: CustImage(
            imgURL: image,
            width: width,
            height: height,
            boxfit: BoxFit.cover,
            cornerRadius: 8,
            defaultImageWithDottedBorder: true,
          ),
        ),
      ),
    );
  }
}
