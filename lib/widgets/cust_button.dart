// import 'package:flutter/material.dart';
// import 'package:renting_app_mobile/widgets/spinner.dart';

// import '../constants/img_font_color_string.dart';
// import '../main.dart';
// import 'cust_image.dart';
// import 'custom_text.dart';

// class CustButton extends StatelessWidget {
//   final String title;
//   final Function() onTap;
//   final String? image;
//   final Color? backgroundColor;
//   final Color? imageColor;
//   final Color? shadowColor;
//   final double? height = 44;
//   final double? width;
//   final bool showLoader;
//   const CustButton({
//     Key? key,
//     required this.title,
//     required this.onTap,
//     this.image,
//     this.imageColor,
//     this.shadowColor,
//     this.width,
//     this.backgroundColor,
//     this.showLoader = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return buildButton();
//   }

// // Custom Button
//   Widget buildButton() {
//     return GestureDetector(
//       /// ontap
//       onTap: onTap,
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(
//               10,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: shadowColor ?? Colors.transparent,
//                 blurRadius: 20.0,
//                 spreadRadius: 4.00,
//                 offset: const Offset(0, 6),
//               ),
//             ]
//             // border: Border.all(
//             //   color: custBlack102339.withOpacity(
//             //     0.10,
//             //   ),
//             //   width: 1,
//             // ),
//             ),
//         child: showLoader
//             ? Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: Spinner(
//                     progressColor: Colors.white,
//                   ),
//                 ),
//               )
//             : Stack(
//                 children: [
//                   if (image?.isNotEmpty ?? false)
//                     Positioned(
//                       top: -5,

//                       /// button Image
//                       child: CustImage(
//                         imgURL: image ?? "",
//                         boxfit: BoxFit.contain,
//                         height: 40,
//                         width: 40,
//                         imgColor: imageColor,
//                       ),
//                     ),

//                   /// button text
//                   _buildButtonText()
//                 ],
//               ),
//       ),
//     );
//   }

//   Center _buildButtonText() {
//     return Center(
//       child: CustomText(
//         txtTitle: title,
//         style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//             ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';

import '../constants/img_font_color_string.dart';

import '../main.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final Color? buttonColor;
  final Function() onPressed;
  final bool loadingIndicator;
  final Color? shadowColor;
  final double buttonHeight;
  final double? buttonWidth;
  final bool hideShadow;
  final Color? loaderAndTextColor;
  final TextStyle? textStyle;
  final double radius;
  final BorderSide? borderSide;
  final Widget? child;

  const CustomButton({
    this.buttonTitle = "Button Text",
    required this.onPressed,
    this.buttonColor = custMaterialPrimaryColor,
    this.loadingIndicator = false,
    this.shadowColor,
    this.buttonHeight = 48,
    this.buttonWidth,
    this.hideShadow = false,
    this.loaderAndTextColor,
    this.borderSide,
    this.textStyle,
    this.radius = 10.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: hideShadow
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              boxShadow: [
                BoxShadow(
                  color: (shadowColor ?? custACACAC).withOpacity(
                    0.2,
                  ),
                  offset: const Offset(0, 6),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: borderSide == null
                  ? const BorderSide(color: Colors.transparent, width: 0)
                  : (borderSide ??
                      const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      )),
            ),
          ),
          elevation: hideShadow ? MaterialStateProperty.all<double>(0) : null,
        ),
        onPressed: loadingIndicator ? () {} : onPressed,
        child: loadingIndicator
            ? SizedBox(
                height: 30,
                width: 30,
                child: Spinner(
                  progressColor: loaderAndTextColor ?? Colors.white,
                ),
              )
            : child ??
                CustomText(
                  txtTitle: buttonTitle,
                  align: TextAlign.center,
                  style: textStyle ??
                      Theme.of(getContext).textTheme.bodyText1?.copyWith(
                            color: loaderAndTextColor ?? Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                ),
      ),
    );
  }
}

Widget commonViewAllButton({
  String title = StaticString.viewAll,
  void Function()? onPressed,
}) {
  return CustomText(
    onPressed: onPressed,
    txtTitle: title,
    style: Theme.of(getContext).textTheme.caption?.copyWith(
          color: custMaterialPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
  );
}
