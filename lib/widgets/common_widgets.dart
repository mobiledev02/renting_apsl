// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import 'package:renting_app_mobile/widgets/rich_text.dart';

import '../constants/img_font_color_string.dart';
import '../main.dart';
import '../models/location_model.dart';
import '../utils/permissions.dart';
import 'cust_image.dart';
import 'custom_text.dart';

class CustBackButton extends StatelessWidget {
  final Function? backFunction;
  final Color? backButtonColor;
  const CustBackButton({Key? key, this.backFunction, this.backButtonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (backFunction != null) {
          backFunction?.call();
        }

        Get.back();
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: backButtonColor != null
              ? backButtonColor!.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color: custBlack102339.withOpacity(
              0.10,
            ),
            width: 1,
          ),
        ),
        child: CustImage(
          imgURL: ImgName.back,
          width: 12,
          imgColor: backButtonColor,
        ),
      ),
    );
  }
}

// suffix widget for text field
Widget suffixIconForTextField(
    {String img = "", BoxFit? boxFit, double height = 17, double width = 12}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: CustImage(
      imgURL: img,
      width: width,
      height: height,
      boxfit: boxFit,
    ),
  );
}

/// Item, And Service Tag Card
Widget itemAndServiceTagCard({required String ItemOrServices}) {
  return Container(
    decoration: BoxDecoration(
      color: ItemOrServices == StaticString.item
          ? custBlue3AC5FF
          : custOrangeE5714A,
      borderRadius: BorderRadius.circular(4),
    ),
    padding: EdgeInsets.symmetric(
        horizontal: ItemOrServices == StaticString.item ? 11 : 8),
    alignment: Alignment.center,
    height: 20,
    child: CustomText(
      txtTitle: ItemOrServices == StaticString.item
          ? StaticString.item.capitalizeFirst
          : StaticString.service.capitalizeFirst,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/// item And Service  name and duration
Widget productNameAndDuration(
    {required BuildContext context, required String name, int? duration = 0}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: CustomText(
          txtTitle: name,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textOverflow: TextOverflow.ellipsis,
        ),
      ),
      if (duration != 0)
        CustomText(
          txtTitle: "${StaticString.maxDurationDay} $duration Days",
          style: Theme.of(context).textTheme.caption,
        )
    ],
  );
}

/// item  category Text

Widget categoryText({required BuildContext context, required String category}) {
  return CustomText(
    txtTitle: category,
    style: Theme.of(context)
        .textTheme
        .caption
        ?.copyWith(color: custBlack102339WithOpacity),
  );
}

/// item or Service Tag And Price TExt
Widget itemOrServiceTagAndPriceText(
    {required BuildContext context,
    required String itemOrServices,
    Color textColor = custGrey7E7E7E,
    String? price = ""}) {
  return Row(
    children: [
      itemAndServiceTagCard(ItemOrServices: itemOrServices),
      const SizedBox(
        width: 10,
      ),

      /// Price
      // CustomText(
      //   txtTitle: price,
      //   style: Theme.of(context).textTheme.bodyText1?.copyWith(
      //         fontWeight: FontWeight.w600,
      //         color: ,
      //       ),
      // ),
      Expanded(
        child: CustomText(
          txtTitle: price,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
        ),
      ),
    ],
  );
}

Widget itemOrServicePriceText(
    {required BuildContext context,
    required String itemOrServices,
    Color textColor = custGrey7E7E7E,
    String? price = ""}) {
  return Row(
    children: [
      Expanded(
        child: CustomText(
          txtTitle: price,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
        ),
      ),
    ],
  );
}

// Location Detail
Widget location({required BuildContext context, required String location}) {
  return Row(
    children: [
      //Location icon
      CustImage(
        imgURL: ImgName.locationImage,
        height: 14,
        width: 12,
      ),
      const SizedBox(
        width: 6,
      ),
      // Location text
      Expanded(
        child: CustomText(
          maxLine: 1,
          txtTitle: location,
          style: Theme.of(context).textTheme.caption?.copyWith(
                color: custBlack102339WithOpacity,
                fontWeight: FontWeight.w600,
              ),
          textOverflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

// Item description
Widget description(
    {required BuildContext context, required String description}) {
  return CustomText(
    txtTitle: description,
    style: Theme.of(context).textTheme.caption?.copyWith(
          fontWeight: FontWeight.w500,
          color: custBlack102339WithOpacity,
          height: 1.5,
        ),
  );
}

/// date text And calender icon
Widget dateTextAndCalenderAndTimeIcon({
  required BuildContext context,
  required String date,
  required String icon,
  required Function() onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: custBlack102339.withOpacity(0.1),
          ),
        ),
        height: 36,
        width: 117,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              txtTitle: date,
              // txtTitle: _startDate?.toIso8601String() ?? "Start Date",
              style: Theme.of(context).textTheme.overline?.copyWith(
                    color: custGrey93A2B2,
                    fontWeight: FontWeight.w500,
                  ),
              textOverflow: TextOverflow.ellipsis,
            ),
            CustImage(
              height: 14,
              width: 14,
              imgURL: icon,
            )
          ],
        ),
      ),
    ),
  );
}

/// Lender Email id (disable text form feild)
Widget lenderEmailid({
  required BuildContext context,
  required String title,
  required String email,
  Widget? sideWidget,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            txtTitle: title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            width: 5,
          ),
          sideWidget ?? const SizedBox(),
        ],
      ),
      const SizedBox(
        height: 12,
      ),
      Container(
        margin: const EdgeInsets.only(
          right: 35,
        ),
        padding: const EdgeInsets.all(16),
        // height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.00),
          color: custBlack102339.withOpacity(0.04),
        ),

        /// lender  Email id
        child: CustomText(
          txtTitle: email,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: custBlack102339WithOpacity,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    ],
  );
}

/// Rented text
Widget rentedText({required BuildContext context, required String rentedText}) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    decoration: BoxDecoration(
      color: custRedFF3F50.withOpacity(0.06),
      borderRadius: BorderRadius.circular(10),
    ),
    child: CustomRichText(
      maxLines: 5,
      title: rentedText,
      normalTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: custRedFF3F50,
      ),
      fancyTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: custRedFF3F50,
        decoration: TextDecoration.underline,
        decorationColor: custFF3F50,
        decorationThickness: 3.0,
      ),
    ),

    //  CustomText(
    //   align: TextAlign.center,
    //   txtTitle: rentedText,
    //   style: Theme.of(context).textTheme.caption?.copyWith(
    //         color: custRedFF3F50,
    //         fontWeight: FontWeight.w600,
    //       ),
    // ),
  );
}

/// Red box / Note box
Widget redBox({required BuildContext context, required String rentedText}) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 12),
    decoration: BoxDecoration(
      color: custRedFF3F50.withOpacity(0.06),
      borderRadius: BorderRadius.circular(10),
    ),
    child: CustomRichText(
      maxLines: 15,
      title: rentedText,
      normalTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: custRedFF3F50,
      ),
      fancyTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: custRedFF3F50,
        decoration: TextDecoration.underline,
        decorationColor: custFF3F50,
        decorationThickness: 3.0,
      ),
    ),

    //  CustomText(
    //   align: TextAlign.center,
    //   txtTitle: rentedText,
    //   style: Theme.of(context).textTheme.caption?.copyWith(
    //         color: custRedFF3F50,
    //         fontWeight: FontWeight.w600,
    //       ),
    // ),
  );
}

// Text form field with title
Widget textFieldWithTitle({
  required String title,
  required Widget child,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CustomRichText(
        title: title,
        normalTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        fancyTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: custBlack102339WithOpacity,
        ),
      ),
      // CustomText(
      //   txtTitle: title,
      //   style: const TextStyle(
      //     fontSize: 14,
      //     fontWeight: FontWeight.w600,
      //   ),
      // ),
      const SizedBox(
        height: 12,
      ),
      Padding(
        padding: const EdgeInsets.only(
          bottom: 14,
        ),
        // height: 46,
        // width: 300,

        child: child,
      ),
    ],
  );
}

/// Image title And Child
Widget ImageTitleAndChild({
  required String image,
  required String title,
  Widget? child,
}) {
  return Row(
    children: [
      CustImage(
        imgURL: image,
        boxfit: BoxFit.contain,
        width: 18,
        height: 18,
      ),
      const SizedBox(
        width: 10.31,
      ),
      CustomText(
        txtTitle: title,
        style: Theme.of(getContext).textTheme.caption?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      Spacer(),
      child ?? SizedBox(),
    ],
  );
}

/// Cuystom Switch
Widget customSwitch({
  required bool value,
  required Function(bool) onChanged,
}) {
  return Switch(
    inactiveThumbColor: cust88919C,
    activeTrackColor: primaryColor.withOpacity(0.2),
    inactiveTrackColor: cust88919C.withOpacity(0.2),
    value: value,
    onChanged: onChanged,
  );
}

// Custom Icon Button
Widget customIconButton({
  required String icon,
  required Function() onTap,
  double buttonHeight = 26,
  double buttonWidth = 26,
  double iconHeight = 10,
  double iconWidth = 10,
  required Color bgColor,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
      ),

      /// icon
      child: CustImage(
        imgURL: icon,
        height: iconHeight,
        width: iconWidth,
      ),
    ),
  );
}

Future<bool> locationDialogueIfLocationIsDisale(
    {bool forcefullyStopDialogue = false,
    bool backTwise = false,
    AuthType authType = AuthType.None}) async {
  // bool val = true;

  // try {
  final AuthController _authController = Get.find<AuthController>();

  if (_authController.getUserInfo.address.isNotEmpty) return true;
  final bool isGranted = await checkLocationPermission();
  if (!isGranted && !forcefullyStopDialogue) {
    showLocationPopup(backTwice: backTwise);

    return false;
  }

  final Position position =
      await GeolocatorPlatform.instance.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );

  List<Placemark> placeMarkList =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  final LocationModel _locationModel = locationModelFromJson(
    json.encode(
      placeMarkList.first.toJson(),
    ),
  );
  _locationModel.latitude = position.latitude;
  _locationModel.longitude = position.longitude;
  //if(_authController.getUserInfo.authType == )
  if (authType == AuthType.SignUp) {
  } else {
    await _authController.updateLocation(
      locationModel: _locationModel,
    );
  }

  return true;
  // } catch (e) {
  //   // showAlert(context: getContext, message: e);
  // } finally {
  //   return val;
  // }
}

Future<LocationModel?> getLocationInfoAtSignUp(
    {bool forcefullyStopDialogue = false,
    bool backTwise = false,
    AuthType authType = AuthType.None}) async {
  // bool val = true;

  // try {
  final AuthController _authController = Get.find<AuthController>();

  final bool isGranted = await checkLocationPermission();
  if (!isGranted && !forcefullyStopDialogue) {
    showLocationPopup(backTwice: backTwise);
  }

  final Position position =
      await GeolocatorPlatform.instance.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );

  List<Placemark> placeMarkList =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  final LocationModel _locationModel = locationModelFromJson(
    json.encode(
      placeMarkList.first.toJson(),
    ),
  );

  _locationModel.latitude = position.latitude;
  _locationModel.longitude = position.longitude;
  return _locationModel;
  //if(_authController.getUserInfo.authType == )
  // if(authType == AuthType.SignUp) {
  //
  // }
  // else {
  //   await _authController.updateLocation(
  //     locationModel: _locationModel,
  //   );
  // }
}

/// Permission popUp Dialog
Future<void> showLocationPopup({bool backTwice = false}) async {
  showDialog(
    barrierDismissible: false,
    context: getContext,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 385,
              width: 336,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustImage(
                    imgURL: ImgName.locationDialogImage,
                    height: 96,
                    width: 122,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomText(
                    align: TextAlign.center,
                    txtTitle:
                        StaticString.allowYourLocation, // Allow Your Location
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomText(
                    align: TextAlign.center,
                    txtTitle: StaticString.weWillNeed,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          height: 1.40,
                          color: custBlack102339.withOpacity(0.4),
                        ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(199, 46),
                            shadowColor:
                                const Color.fromRGBO(172, 172, 172, 0.5),
                            elevation: 10,
                          ),
                          onPressed: () async {
                            final result = await Permission.location.request();

                            if (result == PermissionStatus.permanentlyDenied) {
                              await openAppSettings();
                              Get.back();
                            }

                            // _isGranted = await checkLocationPermission();
                            // setState(() {});
                          },
                          child: const CustomText(
                            txtTitle: StaticString.allowLocation,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: CustomFont.metropolis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: CustomText(
                      onPressed: () {
                        Get.back();
                        if (backTwice) {
                          Get.back();
                        }
                      },
                      txtTitle: StaticString.maybeLater,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: CustomFont.metropolis,
                        color: custBlack102339.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
