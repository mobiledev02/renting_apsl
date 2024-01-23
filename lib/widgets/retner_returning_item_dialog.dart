import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import '../constants/img_font_color_string.dart';
import '../controller/item_controller.dart';
import '../models/image_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/custom_enum.dart';
import 'cust_flat_button.dart';
import 'cust_image.dart';
import 'custom_text.dart';
import 'image_picker.dart';

class RenterReturningItemDialog extends StatefulWidget {
  final MessageModel messageModel;
  final UserInfoModel lenderModel;
  final String roomId;

  const RenterReturningItemDialog(
      {Key? key,
      required this.messageModel,
      required this.lenderModel,
      required this.roomId})
      : super(key: key);

  @override
  State<RenterReturningItemDialog> createState() =>
      _RenterReturningItemDialogState();
}

class _RenterReturningItemDialogState extends State<RenterReturningItemDialog> {
  final ValueNotifier _imageNotifier = ValueNotifier(true);
  List<ImageModel> image = [ImageModel()];
  PickImageOption? _pickImageOption = PickImageOption.camera;
  List<String> filePaths = [];
  bool? _isSelectedImage;
  File? compressFile;
  Directory? directory;
  String? targetPath;

  bool _isImageError = false;

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Return Item',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Let us know that you have returned the item to the lender',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: cust838485),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            _buildImagePicker(),
            Visibility(
              visible: _isImageError,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  txtTitle: 'Image is required',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: CustomFlatButton(
                    buttonColor: Colors.white,
                    borderSide: const BorderSide(color: primaryColor),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: CustomFlatButton(
                    onPressed: () async {
                      if (filePaths.isNotEmpty) {
                        _isImageError = false;

                        final roomID = widget.roomId;

                        await Get.find<ItemController>()
                            .submitItemReturningInfo(
                          context,
                          roomID,
                          _descriptionController.text,
                          widget.lenderModel,
                          widget.messageModel,
                          filePaths,
                        );
                      }
                      if (filePaths.isEmpty) {
                        setState(() {
                          _isImageError = true;
                        });
                      }
                    },
                    buttonTitle: 'Submit',
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return ValueListenableBuilder(
      valueListenable: _imageNotifier,
      builder: (context, val, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  _pickImageOption = await imagePickOption();
                  targetPath =
                      "${directory?.path ?? ""}/${DateTime.now()}.jpeg";
                  _imageNotifier.notifyListeners();

                  if (_pickImageOption != null) {
                    final imageTemporary = await PickImage(
                      pickImageOption: _pickImageOption!,
                    );

                    // Deleted id list for add deleted images id
                    // if (image.isNotEmpty) {
                    //   if (image[0].id != null &&
                    //       !itemDetailModel.deleteImagesIdList
                    //           .any((element) => element == image[0].id)) {
                    //     itemDetailModel.deleteImagesIdList
                    //         .add(image[0].id!);
                    //   }
                    // }

                    if (imageTemporary.path.isNotEmpty) {
                      image[0].imageUrl = imageTemporary.path;

                      compressFile =
                          await FlutterImageCompress.compressAndGetFile(
                        imageTemporary.path,
                        targetPath!,
                        quality: 90,
                        format: CompressFormat.jpeg,
                      );

                      // itemDetailModel.lendItemServiceImages?[0].imageUrl =
                      //     compressFile?.path ?? "";

                      _isSelectedImage =
                          image.any((element) => element.imageUrl.isNotEmpty);
                      if (compressFile != null) {
                        filePaths.add(imageTemporary!.path);
                      }
                    }
                  }
                  _imageNotifier.notifyListeners();
                  setState(() {
                    _isImageError = false;
                  });
                  // await _buildImagePickOption(0);
                } catch (e, st) {
                  debugPrint(
                    'ItemRentingDialog error uploading image $e $st',
                  );
                }
              },
              // onTap: () => _pickImage(0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CustImage(
                  defaultImageWithDottedBorder: true,
                  imgURL: image.isNotEmpty ? image[0].imageUrl : "",
                  height: 100,
                  //     width: double.infinity,
                  //    boxfit: BoxFit.cover,
                  cornerRadius: 8,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            if (_isSelectedImage == false)
              const SizedBox(
                height: 8,
              ),
            if (_isSelectedImage == false)
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: CustomText(
                  txtTitle: AlertMessageString.emptyImage,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
