import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../constants/img_font_color_string.dart';
import 'cust_image.dart';

final List<String> imgList = [
  ImgName.creditCard1,
  ImgName.creditCard2,
  ImgName.image1,
];

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  //!----------------------------------- variable-------------------------

  final List<Widget> imageSliders = imgList
      .map(
        (item) => Container(
          margin: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Color.fromRGBO(65, 78, 155, 0.2),
              )
            ],
          ),
          child: CustImage(
            imgURL: item,
            // width: 300,
            // height: 184,
          ),
        ),
      )
      .toList();

  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, reason) => setState(() {
              _activeIndex = index;
            }),
            aspectRatio: 2.0,
            autoPlay: true,
          ),
          items: imageSliders,
        ),
        SizedBox(
          height: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imgList.length,
              (index) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: CircleAvatar(
                  radius: index == _activeIndex ? 4 : 3,
                  backgroundColor: index == _activeIndex
                      ? primaryColor
                      : custBlack102339.withOpacity(0.2),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
