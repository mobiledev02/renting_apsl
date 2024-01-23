import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:renting_app_mobile/models/user_model.dart';
import '../constants/img_font_color_string.dart';
import '../controller/item_controller.dart';
import '../models/image_model.dart';
import '../models/message_model.dart';
import '../utils/custom_enum.dart';
import 'cust_flat_button.dart';
import 'cust_image.dart';
import 'custom_text.dart';
import 'image_picker.dart';

class ItemRentingDialog extends StatefulWidget {
  final MessageModel messageModel;
  final UserInfoModel lenderModel;
  final String roomId;

  const ItemRentingDialog(
      {Key? key,
      required this.roomId,
      required this.messageModel,
      required this.lenderModel})
      : super(key: key);

  @override
  State<ItemRentingDialog> createState() => _ItemRentingDialogState();
}

class _ItemRentingDialogState extends State<ItemRentingDialog> {
  final ValueNotifier _imageNotifier = ValueNotifier(true);
  List<ImageModel> image = [];
  PickImageOption? _pickImageOption = PickImageOption.camera;
  List<String> filePaths = [];
  bool? _isSelectedImage;
  File? compressFile;
  Directory? directory;
  String? targetPath;

  bool _isOptionError = false;
  bool _isImageError = false;

  RentingItemStatus? _status;
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
              'Item Received?',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Submit the following answer and let us know that you have received the item from the lender',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: cust838485),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            // RadioListTile<RentingItemStatus>(
            //   title: Text(
            //     'Item is in good condition (scratches, wear and tear acceptable).',
            //     style: Theme.of(context).textTheme.bodyLarge,
            //   ),
            //   value: RentingItemStatus.Good,
            //   groupValue: _status,
            //   onChanged: (RentingItemStatus? value) {
            //     setState(() {
            //       _status = value;
            //       _isOptionError = false;
            //     });
            //   },
            // ),
            // RadioListTile<RentingItemStatus>(
            //   title: Text(
            //       'Item is already damaged and not what I thought I was renting.',
            //       style: Theme.of(context).textTheme.bodyLarge),
            //   value: RentingItemStatus.Damaged,
            //   groupValue: _status,
            //   onChanged: (RentingItemStatus? value) {
            //     setState(() {
            //       _status = value;
            //       _isOptionError = false;
            //     });
            //   },
            // ),
            // Visibility(
            //   visible: _isOptionError,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: CustomText(
            //       txtTitle: 'Please choose correct option',
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall
            //           ?.copyWith(color: Colors.red),
            //     ),
            //   ),
            // ),
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
            SizedBox(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: image.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustImage(
                      closeButton: () {
                        image.removeAt(index);

                        setState(() {});
                      },
                      boxfit: BoxFit.cover,
                      cornerRadius: 8,
                      imgURL: image[index].imageUrl,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 4,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              controller: _descriptionController,
              // validator: (val) => val?.validateMoreInfo,
              // controller: _moreInfoController,
              // focusNode: _moreInfoFocusNode,
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
                      if (image.isNotEmpty) {
                        _isImageError = false;
                        _isOptionError = false;
                        // String value = '5';
                        // switch (_status) {
                        //   case RentingItemStatus.Good:
                        //     {
                        //       value = '0';
                        //       break;
                        //     }
                        //   case RentingItemStatus.Damaged:
                        //     {
                        //       value = '1';
                        //       break;
                        //     }
                        //   default:
                        //     {
                        //       value = '5';
                        //       break;
                        //     }
                        // }
                        const String value = '0';

                        final roomID = widget.roomId;
                        List<String> paths =
                            image.map((e) => e.imageUrl).toList();
                        await Get.find<ItemController>().submitRentingItemInfo(
                          context,
                          roomID,
                          value,
                          _descriptionController.text,
                          widget.lenderModel,
                          widget.messageModel,
                          paths,
                        );
                      }
                      if (_status == null) {
                        setState(() {
                          _isOptionError = true;
                        });
                      }
                      if (image.isEmpty) {
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
                  directory = await getTemporaryDirectory();
                  _pickImageOption = await imagePickOption();
                  targetPath =
                      "${directory?.path ?? ""}/${DateTime.now()}.jpeg";
                  _imageNotifier.notifyListeners();

                  if (_pickImageOption != null) {
                    final imageTemporary = await PickImage(
                      pickImageOption: _pickImageOption!,
                    );

                    if (imageTemporary.path.isNotEmpty) {
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
                        //  filePaths.add(imageTemporary!.path);
                        image.add(ImageModel(imageUrl: compressFile!.path));
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
                  //     imgURL: image.isNotEmpty ? image[0].imageUrl : "",
                  height: 100,
                  //     width: double.infinity,
                  //    boxfit: BoxFit.cover,
                  cornerRadius: 8,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        );
      },
    );
  }
}
