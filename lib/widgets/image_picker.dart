// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';

import '../main.dart';
import '../utils/custom_enum.dart';
import '../utils/permissions.dart';
import 'custom_alert.dart';
import 'custom_text.dart';

// class ImagePick extends StatefulWidget {
//   ImagePick({Key? key}) : super(key: key);

//   @override
//   State<ImagePick> createState() => _ImagePickState();
// }

// class _ImagePickState extends State<ImagePick> {
//   // PickImageOption? _pickImageOption;
//   @override
//   // void initState() {
//   //   ImagePickOption(1);
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

/// Image Pick Option
Future<PickImageOption?> imagePickOption() async {
  PickImageOption? _pickImageOption;
  await Get.defaultDialog(
    // barrierDismissible: false,
    titlePadding: EdgeInsets.only(top: 14, bottom: 4),
    title: "Pick Image From",
    titleStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () {
            _pickImageOption = PickImageOption.camera;
            Get.back();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Icon(Icons.camera_alt),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  txtTitle: "Camera",
                  style: Theme.of(getContext).textTheme.caption,
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _pickImageOption = PickImageOption.gallery;
            Get.back();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Icon(
                  Icons.photo,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  txtTitle: "Gallery",
                  style: Theme.of(getContext).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
  return _pickImageOption;
}

Future<File> PickImage({required PickImageOption pickImageOption}) async {
  // bool _isGranted = await checkGalleryPermission();
  XFile? image;
  switch (pickImageOption) {
    case PickImageOption.camera:
      if (await checkCameraPermission()) {
        image = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );
      } else {
        showAlert(
          context: getContext,
          message:
              "Go to Settings - Camera and grant permission to capture photo.",
          title: "Permission denied",
          signleBttnOnly: false,
          leftBttnTitle: "Settings",
          rigthBttnTitle: "Cancel",
          onLeftAction: () async {
            await openAppSettings();
          },
        );
        // await openAppSettings();
      }

      break;
    case PickImageOption.gallery:
      if (await checkGalleryPermission()) {
        try {
          image = (await ImagePicker().pickImage(
            source: ImageSource.gallery,
          ));
        } on PlatformException catch (e) {
          debugPrint("Failed  to pick image : $e");
        }
      } else {
        showAlert(
          context: getContext,
          message:
              "Go to Settings - Photos and grant permission to access photo.",
          title: "Permission denied",
          signleBttnOnly: false,
          leftBttnTitle: "Settings",
          rigthBttnTitle: "Cancel",
          onLeftAction: () async {
            await openAppSettings();
          },
        );
        // await openAppSettings();
      }
      break;
  }

  return File(image?.path ?? "");
}
// }
