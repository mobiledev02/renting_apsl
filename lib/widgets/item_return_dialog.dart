import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import '../constants/img_font_color_string.dart';
import '../models/image_model.dart';
import '../models/message_model.dart';
import '../utils/custom_enum.dart';
import 'cust_flat_button.dart';
import 'cust_image.dart';
import 'custom_text.dart';
import 'image_picker.dart';

class ItemReturnDialog extends StatefulWidget {
  final String roomId;

  // final UserInfoModel? renter;
  final String? renter;
  final MessageModel messageModel;

  const ItemReturnDialog(
      {Key? key, required this.roomId, this.renter, required this.messageModel})
      : super(key: key);

  @override
  State<ItemReturnDialog> createState() => _ItemReturnDialogState();
}

class _ItemReturnDialogState extends State<ItemReturnDialog> {
  LendingItemReturnStatus? _status;

  final TextEditingController _descriptionController = TextEditingController();
  bool _isOptionError = false;
  bool _isImageError = false;

  final ValueNotifier _imageNotifier = ValueNotifier(true);
  List<ImageModel> image = [ImageModel()];
  PickImageOption? _pickImageOption = PickImageOption.camera;

  bool _isChecked = false;
  bool? _isSelectedImage;
  List<String> filePaths = [];
  File? compressFile;
  Directory? directory;
  String? targetPath;

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
              'Lending Item Returned?',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Submit the following answer and let us know that the renter has returned you the item with care',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: cust838485),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            // RadioListTile<LendingItemReturnStatus>(
            //   title: Text(
            //     'Item returned on time and in reasonable condition',
            //     style: Theme.of(context).textTheme.bodyText1,
            //   ),
            //   value: LendingItemReturnStatus.OnTimeWithoutDamage,
            //   groupValue: _status,
            //   onChanged: (LendingItemReturnStatus? value) {
            //     setState(() {
            //       _status = value;
            //       _isOptionError = false;
            //     });
            //   },
            // ),
            RadioListTile<LendingItemReturnStatus>(
              title: RichText(
                text: TextSpan(
                  text: 'Renter has broken my item',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    const TextSpan(
                        text: ' (scratches and normal wear and tear do '),
                    TextSpan(
                        text: 'not ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const TextSpan(text: 'qualify for this option.')
                  ],
                ),
              ),
              value: LendingItemReturnStatus.OnTimeWithDamage,
              groupValue: _status,
              onChanged: (LendingItemReturnStatus? value) {
                setState(() {
                  _status = value;
                  _isOptionError = false;
                });
              },
            ),
            RadioListTile<LendingItemReturnStatus>(
              title: Text('Item has not been returned',
                  style: Theme.of(context).textTheme.bodyText1),
              value: LendingItemReturnStatus.NotOnTime,
              groupValue: _status,
              onChanged: (LendingItemReturnStatus? value) {
                setState(() {
                  _status = value;
                  _isOptionError = false;
                });
              },
            ),
            Visibility(
              visible: _isOptionError,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  txtTitle: 'Please choose correct option',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ),
            if (_status == LendingItemReturnStatus.OnTimeWithDamage)
              _buildImagePicker(),
            if (_status == LendingItemReturnStatus.OnTimeWithDamage)
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
            Visibility(
              visible: _status == LendingItemReturnStatus.OnTimeWithDamage,
              child: const Column(
                children: [
                  Text(
                    'Please upload an image of your broken item above. We will be comparing this to the image uploaded originally and to the image that was sent by the Renter. Provide other details below',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            TextFormField(
              maxLines: 4,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              controller: _descriptionController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 45, top: 30),
                hintText: 'Let us know more',
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
                    // loadingIndicator: controller.addCardLoading.value,

                    onPressed: () async {
                      if (_status != null) {
                        int value = 5;

                        switch (_status) {
                          case LendingItemReturnStatus.OnTimeWithDamage:
                            {
                              value = 1;
                              break;
                            }
                          case LendingItemReturnStatus.NotOnTime:
                            {
                              value = 2;
                              break;
                            }
                          default:
                            {
                              value = 5;
                              break;
                            }
                        }

                        if (_status ==
                                LendingItemReturnStatus.OnTimeWithDamage &&
                            filePaths.isEmpty) return;

                        var roomID = widget.roomId;
                        await Get.find<ItemController>().submitReturnedItemInfo(
                          context,
                          roomID,
                          value,
                          _descriptionController.text,
                          widget.renter,
                          widget.messageModel,
                          filePaths,
                        );
                      }
                      if (_status == null) {
                        setState(() {
                          _isOptionError = true;
                        });
                      }
                      if (_status == LendingItemReturnStatus.OnTimeWithDamage &&
                          filePaths.isEmpty) {
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
                  print(image);
                  _pickImageOption = await imagePickOption();
                  targetPath = (directory?.path ?? "") +
                      "/" +
                      DateTime.now().toString() +
                      ".jpeg";
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
                        targetPath ?? "",
                        quality: 90,
                        format: CompressFormat.jpeg,
                      );
                      // itemDetailModel.lendItemServiceImages?[0].imageUrl =
                      //     compressFile?.path ?? "";
                      if (compressFile != null) {
                        filePaths.add(imageTemporary.path);
                      }

                      _isSelectedImage =
                          image.any((element) => element.imageUrl.isNotEmpty);
                    }
                  }
                  _imageNotifier.notifyListeners();
                  setState(() {
                    _isImageError = false;
                  });

                  // await _buildImagePickOption(0);
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
                        .bodyText1
                        ?.copyWith(color: Colors.red),
                  ),
                ),
            ],
          );
        });
  }
}
