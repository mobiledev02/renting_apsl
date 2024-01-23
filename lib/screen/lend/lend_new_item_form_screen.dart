// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '/controller/payment_controller.dart';
import '/models/item_exchange_return_preferences.dart';
import '/screen/payment/connect_stripe_account_screen.dart';
import '/widgets/spinner.dart';
import '/controller/category_controller.dart';
import '/controller/lend_controller.dart';
import '/models/categories_model.dart';
import '/models/image_model.dart';
import '/models/item_detail_model.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/keyboard_with_done_button.dart';
import '/widgets/rich_text.dart';
import '/constants/img_font_color_string.dart';
import '/controller/auth_controller.dart';
import '/models/place_service.dart';
import '/utils/custom_enum.dart';
import '/utils/custom_extension.dart';
import '/widgets/address_search.dart';
import '/widgets/common_widgets.dart';
import '/widgets/cust_button.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_alert.dart';
import '/widgets/custom_text.dart';
import '/widgets/image_picker.dart';

class LendNewItemFormScreen extends StatefulWidget {
  const LendNewItemFormScreen({Key? key}) : super(key: key);

  @override
  State<LendNewItemFormScreen> createState() => _LendNewItemFormScreenState();
}

class _LendNewItemFormScreenState extends State<LendNewItemFormScreen> {
  //!-------------------------------variable---------------------

  ItemDetailModel itemDetailModel = ItemDetailModel(
    category: CategoryModel(
      id: 0,
    ),
    deleteImagesIdList: [],
    lendItemServiceImages: [],
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<ImageModel> image = [ImageModel(), ImageModel()];
  PickImageOption? _pickImageOption = PickImageOption.camera;

  final ValueNotifier _imageNotifier = ValueNotifier(true);

  LendController lendController = Get.find<LendController>();
  CategoryContoller categoryContoller = Get.find<CategoryContoller>();
  final _paymentController = Get.find<PaymentController>();

  Suggestion? result;

  final TextEditingController _itemNameController = TextEditingController();

  final TextEditingController _ceategoryTypeController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _exchangePrefController = TextEditingController();
  final TextEditingController _returnPrefController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _perDayController = TextEditingController();

  // final TextEditingController _perWeekController = TextEditingController();
  // final TextEditingController _perMonthController = TextEditingController();
  final TextEditingController _safetyDepositeController =
      TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  late FocusNode _ceategoryTypeFocusNode = FocusNode();

  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _durationFocusNode = FocusNode();
  final FocusNode _valueFocusNode = FocusNode();
  final FocusNode _perDayFocusNode = FocusNode();
  late FocusNode _exchangePrefFocusNode = FocusNode();
  late FocusNode _returnPrefFocusNode = FocusNode();
  final FocusNode _safetyDepositeFocusNode = FocusNode();

  late AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool _isChecked = false;
  bool? _isSelectedImage;

  File? compressFile;
  Directory? directory;
  String? targetPath;

  RxBool initialApiCallInProgress = false.obs;

  int? id = Get.arguments;

  @override
  void initState() {
    super.initState();
    final _authController = Get.find<AuthController>();
    if (!_authController.getUserInfo.stripeConnected) {
      showMessage();
    }
    fetchData();
    Future.delayed(Duration(milliseconds: 100), () {
      locationDialogueIfLocationIsDisale(backTwise: true);
    });
  }

  void showMessage() async {
    await Future.delayed(Duration(milliseconds: 100));
    showAlert(
        context: context,
        title: 'Alert',
        message:
            'Stripe account is not yet connected. Please select \'yes\' to connect your stripe account in order to receive payments.',
        signleBttnOnly: false,
        onRightAction: () async {
          _paymentController.setStripePageLoading(true);
          var accLinkRes = await _paymentController.createStripeAccount();
          String url = json.decode(accLinkRes)["data"]["url"];
          debugPrint(url);
          String account = json.decode(accLinkRes)["data"]["account"];
          Get.to(
              () => ConnectStripeAccountScreen(url: url, accountId: account));
        },
        onLeftAction: () async {
          Get.back();
        });
  }

  Future fetchData() async {
    try {
      initialApiCallInProgress.value = id != null;
      itemDetailModel.lendItemServiceImages = [];
      await lendController.fetchRate(context);
      await categoryContoller.fetchCategories(type: "item");

      directory = await getTemporaryDirectory();

      if (id != null) {
        await lendController.fetchItemDetail(context: context, id: id ?? 0);

        itemDetailModel.id = id ?? 0;
        debugPrint(
            'daily rate is ${lendController.itemDetail.value.name} ${lendController.rate.value.itemDailyRate}');

        ItemDetailModel tempItemModel = lendController.itemDetail.value;

        _itemNameController.text = tempItemModel.name;
        // image =
        //     (lendController.itemDetail.value.lendItemServiceImages?.isEmpty ??
        //             true)
        //         ? [ImageModel(), ImageModel()]
        //         : lendController.itemDetail.value.lendItemServiceImages ?? [];

        // image =
        //     lendController.itemDetail.value.lendItemServiceImages ?? ["", ""];
        _locationController.text = tempItemModel.address;
        _descriptionController.text = tempItemModel.description;
        _durationController.text = tempItemModel.maxDuration.toString();
        _valueController.text = tempItemModel.price;
        _perDayController.text = tempItemModel.ratePerDay;
        //   _exchangePrefController.text = tempItemModel.exchangePref ?? "";
        //   _returnPrefController.text = tempItemModel.returnPref ?? "";
        _safetyDepositeController.text = tempItemModel.safetyDeposit;
        _ceategoryTypeController.text = tempItemModel.category?.name ?? "";
        itemDetailModel.category = tempItemModel.category;
        _isChecked = tempItemModel.optInInsurance;

        image =
            tempItemModel.lendItemServiceImages ?? [ImageModel(), ImageModel()];

        if (image.isEmpty) {
          image = [ImageModel(), ImageModel()];
        } else if (image.length == 1) {
          image.add(ImageModel());
        }

        itemDetailModel.lendItemServiceImages = image;

        _imageNotifier.notifyListeners();
      } else {
        // itemDetailModel.category?.id =
        //     categoryContoller.listOfCategoryItem[0].id;
      }
    } catch (e, st) {
      debugPrint('Lend new item fetchData Error $e $st');
      showAlert(context: context, message: e);
    } finally {
      initialApiCallInProgress.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    // _ceategoryTypeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _valueController.dispose();
    _perDayController.dispose();
    _returnPrefController.dispose();
    _exchangePrefController.dispose();
    // _perWeekController.dispose();
    // _perMonthController.dispose();
    _safetyDepositeController.dispose();
    // _exchangePrefFocusNode.dispose();
    //   _returnPrefFocusNode.dispose();

    _nameFocusNode.dispose();

    _locationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _durationFocusNode.dispose();
    _valueFocusNode.dispose();
    _perDayFocusNode.dispose();

    _safetyDepositeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title:
            id == null ? StaticString.lendNewItem : StaticString.lendEditItem,
      ),
      body: Obx(
        () {
          return initialApiCallInProgress.value
              ? Spinner()
              : GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: KeyboardWithDoneButton(
                        focusNodeList: [
                          _nameFocusNode,
                          _ceategoryTypeFocusNode,
                          _locationFocusNode,
                          _descriptionFocusNode,
                          _durationFocusNode,
                          _exchangePrefFocusNode,
                          _returnPrefFocusNode,
                          _valueFocusNode,
                          _safetyDepositeFocusNode,
                        ],
                        onDoneClicked: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        child: Form(
                          autovalidateMode: _autovalidateMode,
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              //------------------Image Picker----------------
                              _buildImagePicker(),

                              const SizedBox(
                                height: 22,
                              ),
                              //-----------------Item Name TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.itemName,
                                child: _buildNameTextFormField(),
                              ),

                              const SizedBox(
                                height: 12,
                              ),
                              // ---------------- categories DropDown --------------

                              textFieldWithTitle(
                                title: StaticString.itemCategory,
                                child: _buildCategory(),
                                // child: _buildItemCategoryDropDown(context),
                                // _buildCategoryType(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),

                              //-----------------Location TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.location,
                                child: _buildLocationTextFormField(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              // Center(
                              //   child: SearchLocation(
                              //     apiKey: APISetup.googlePlaceKey,
                              //     placeholder: StaticString.hintLocation,
                              //     language: 'en',

                              //     // country: 'IN',
                              //     onSelected: (Place place) async {
                              //       print(place.fullJSON);
                              //       List<Map<String, dynamic>> placeData =
                              //           List<Map<String, dynamic>>.from(
                              //               place.fullJSON['terms']);
                              //       placeData.forEach(
                              //         (element) {
                              //           element.forEach((key, value) {
                              //             if (key == "offset") print(value);
                              //             if (key == "value") print(value);
                              //           });
                              //         },
                              //       );
                              //     },
                              //   ),
                              // ),
                              //-----------------Description TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.description,
                                child: _buildDescriptionTextFormField(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              // -----------------Max Duration TextFormField--------------

                              textFieldWithTitle(
                                title: StaticString.maxDuration,
                                child: _buildMaxDurationTextFormField(),
                              ),

                              // ///-----------------Exchange Pref TextFormField--------------
                              // textFieldWithTitle(
                              //   title: StaticString.exchangePref,
                              //   child: _buildExchange(),
                              // ),
                              //
                              // const SizedBox(
                              //   height: 22,
                              // ),
                              //
                              // ///-----------------Return Pref TextFormField--------------
                              // textFieldWithTitle(
                              //   title: StaticString.returnPref,
                              //   child: _buildReturn(),
                              // ),

                              const SizedBox(
                                height: 22,
                              ),
                              //-----------------Value TextFormField-------------------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildRatePerWithTitle(
                                      context: context,
                                      fontSize: 14,
                                      title: StaticString.enterValue,
                                      child: _buildValueTextFormField(),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // Obx(() {
                                  // return
                                  Expanded(
                                    child: _buildRatePerWithTitle(
                                      context: context,
                                      title: " Daily",
                                      // title: StaticString.dayilyRate,
                                      child: _buildRatePerDayTextFormField(),
                                    ),
                                  ),
                                  //  );
                                  // }),
                                ],
                              ),

                              const SizedBox(
                                height: 22,
                              ),
                              //----------------- safety Deposit TextFormField-------------------

                              textFieldWithTitle(
                                title: StaticString.safetyDeposite,
                                child: _buildSafetyDepositeTextFormField(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),

                              /// ---------------- Check Box And Opt ....
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                  border: Border.all(
                                    color: custBlack102339.withOpacity(0.1),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isChecked = !_isChecked;
                                              // itemDetailModel.opt = val ?? false;
                                            });
                                          },
                                          child: CustomText(
                                            txtTitle: "Insurance",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Tooltip(
                                          showDuration:
                                              const Duration(seconds: 10),
                                          triggerMode: TooltipTriggerMode.tap,
                                          message: StaticString.optText,
                                          decoration: BoxDecoration(
                                            color: custBlack102339,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 17.00,
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            letterSpacing: 1,
                                            color: custWhiteFFFFFF,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          child: CustImage(
                                            imgURL: ImgName.infoIcon,
                                            height: 14,
                                            width: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _buildInsuranceBox(
                                      insuranceYes: true,
                                      content:
                                          "Yes, I want to be fully reimbursed in the event that my item is missing or broken beyond normal wear and tear.",
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _buildInsuranceBox(
                                      insuranceYes: false,
                                      content:
                                          "No, I understand that i will only recoup the security deposit amount in the event that my item is missing or broken beyond normal wear and tear.",
                                    )
                                  ],
                                ),
                              ),

                              // const SizedBox(
                              //   height: 22,
                              // ),

                              /// ----------------Email Text--------------
                              // _buildEmailText(
                              //     context: context,
                              //     email: StaticString.millergarciaGmail),

                              const SizedBox(
                                height: 40,
                              ),
                              //----------------Lend button--------------------
                              _buildLendButton(),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

//!-----------------------Widget---------------------------

  /// Image Picker
  Widget _buildImagePicker() {
    return ValueListenableBuilder(
        valueListenable: _imageNotifier,
        builder: (context, val, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: GestureDetector(
                        onTap: () async {
                          addImage();
                        },
                        // onTap: () => _pickImage(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CustImage(
                            defaultImageWithDottedBorder: true,
                            width: double.infinity,
                            boxfit: BoxFit.cover,
                            cornerRadius: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (itemDetailModel.lendItemServiceImages != null &&
                        itemDetailModel.lendItemServiceImages!.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              itemDetailModel.lendItemServiceImages!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            debugPrint(
                                'value of the image is ${itemDetailModel.lendItemServiceImages?[index].imageUrl}');
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CustImage(
                                closeButton: () {
                                  debugPrint(
                                      'image path to delete ${itemDetailModel.lendItemServiceImages?[index].id}');
                                  if (itemDetailModel.lendItemServiceImages !=
                                          null &&
                                      itemDetailModel
                                          .lendItemServiceImages!.isNotEmpty &&
                                      itemDetailModel
                                          .lendItemServiceImages![index]
                                          .imageUrl
                                          .contains('http')) {
                                    debugPrint('yes it is server file');
                                    itemDetailModel.deleteImagesIdList.add(
                                        itemDetailModel
                                            .lendItemServiceImages![index].id!);
                                  }
                                  itemDetailModel.lendItemServiceImages
                                      ?.removeAt(index);

                                  setState(() {});
                                },
                                boxfit: BoxFit.cover,
                                cornerRadius: 8,
                                imgURL: itemDetailModel
                                    .lendItemServiceImages![index].imageUrl,
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     /// first Image
              //     Flexible(
              //       child: GestureDetector(
              //         onTap: () async {
              //           print(image);
              //           _pickImageOption = await imagePickOption();
              //           targetPath = (directory?.path ?? "") +
              //               "/" +
              //               DateTime.now().toString() +
              //               ".jpeg";
              //           _imageNotifier.notifyListeners();
              //
              //           if (_pickImageOption != null) {
              //             final imageTemporary = await PickImage(
              //               pickImageOption: _pickImageOption!,
              //             );
              //
              //             // Deleted id list for add deleted images id
              //             if (image.isNotEmpty) {
              //               if (image[0].id != null &&
              //                   !itemDetailModel.deleteImagesIdList
              //                       .any((element) => element == image[0].id)) {
              //                 itemDetailModel.deleteImagesIdList
              //                     .add(image[0].id!);
              //               }
              //             }
              //
              //             if (imageTemporary.path.isNotEmpty) {
              //               image[0].imageUrl = imageTemporary.path;
              //
              //               compressFile =
              //                   await FlutterImageCompress.compressAndGetFile(
              //                 imageTemporary.path,
              //                 targetPath ?? "",
              //                 quality: 90,
              //                 format: CompressFormat.jpeg,
              //               );
              //               itemDetailModel.lendItemServiceImages?[0].imageUrl =
              //                   compressFile?.path ?? "";
              //
              //               _isSelectedImage = image
              //                   .any((element) => element.imageUrl.isNotEmpty);
              //             }
              //           }
              //           _imageNotifier.notifyListeners();
              //
              //           // await _buildImagePickOption(0);
              //         },
              //         // onTap: () => _pickImage(0),
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(8.0),
              //           child: CustImage(
              //             defaultImageWithDottedBorder: true,
              //             imgURL: image.isNotEmpty ? image[0].imageUrl : "",
              //             height: 100,
              //             width: double.infinity,
              //             boxfit: BoxFit.cover,
              //             cornerRadius: 8,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 15,
              //     ),
              //
              //     /// second image
              //     Flexible(
              //       child: GestureDetector(
              //         onTap: () async {
              //           _pickImageOption = await imagePickOption();
              //           targetPath = (directory?.path ?? "") +
              //               "/" +
              //               DateTime.now().toString() +
              //               ".jpeg";
              //           _imageNotifier.notifyListeners();
              //
              //           if (_pickImageOption != null) {
              //             final imageTemporary = await PickImage(
              //               pickImageOption: _pickImageOption!,
              //             );
              //
              //             // Deleted id list for add deleted images id
              //             if (image.length >= 2) {
              //               if (image[1].id != null &&
              //                   !itemDetailModel.deleteImagesIdList
              //                       .any((element) => element == image[1].id)) {
              //                 itemDetailModel.deleteImagesIdList
              //                     .add(image[1].id!);
              //               }
              //             }
              //
              //             if (imageTemporary.path.isNotEmpty) {
              //               image[1].imageUrl = imageTemporary.path;
              //
              //               compressFile =
              //                   await FlutterImageCompress.compressAndGetFile(
              //                 imageTemporary.path,
              //                 targetPath ?? "",
              //                 quality: 90,
              //                 format: CompressFormat.jpeg,
              //               );
              //               itemDetailModel.lendItemServiceImages?[1].imageUrl =
              //                   compressFile?.path ?? "";
              //
              //               _isSelectedImage = image
              //                   .any((element) => element.imageUrl.isNotEmpty);
              //             }
              //           }
              //           _imageNotifier.notifyListeners();
              //         },
              //         // onTap: () => _pickImage(1),
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(8.0),
              //           child: CustImage(
              //             defaultImageWithDottedBorder: true,
              //             imgURL: image.length >= 2 ? image[1].imageUrl : "",
              //             height: 100,
              //             width: double.infinity,
              //             boxfit: BoxFit.cover,
              //             cornerRadius: 8,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
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

// Item Name Text Form Field
  Widget _buildNameTextFormField() {
    return TextFormField(
      focusNode: _nameFocusNode,
      readOnly: itemDetailModel.id != null,
      //  enabled: itemDetailModel.id == null,
      onFieldSubmitted: (_) {},
      validator: (val) => val!.validateItemName,
      onSaved: (name) => itemDetailModel.name = name ?? "",
      controller: _itemNameController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: StaticString.hintItemName,
          labelStyle: TextStyle(color: Colors.red)),
    );
  }

  /// Category Drop Down
  Widget _buildCategory() {
    return Autocomplete<CategoryModel>(
      optionsBuilder: (TextEditingValue value) {
        Iterable<CategoryModel> sortedList =
            categoryContoller.listOfCategoryItem.where(
          (suggestion) => suggestion.name.toLowerCase().contains(
                value.text.toLowerCase(),
              ),
        );
        return sortedList;
      },
      onSelected: (value) {
        // setState(() {
        itemDetailModel.category = value;
        FocusScope.of(context).unfocus();
        _ceategoryTypeController.text = itemDetailModel.category?.name ?? "";
        // });
      },
      fieldViewBuilder: (context, service, _serviceCategoryFocusNode,
          VoidCallback onFieldSubmitted) {
        Future.delayed(const Duration(microseconds: 10), () {
          service.text = _ceategoryTypeController.text;
          // _serviceCategoryFocusNode = _ceategoryTypeFocusNode;
        });
        return _buildCategoryTextFormField(
            lendTypeController: service,
            lendTypeFocusNode: _serviceCategoryFocusNode);
      },
      optionsViewBuilder: (_, onSelected, sortedList) {
        return _buildCategorySortedList(
          sortedList: sortedList,
          onSelected: onSelected,
        );
      },
    );
  }

  ///  Category sorted List
  Widget _buildCategorySortedList(
      {required Iterable<CategoryModel> sortedList,
      required AutocompleteOnSelected<CategoryModel> onSelected}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(
            right: 40,
          ),
          height: 120,
          // width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(16, 35, 57, 0.1),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            itemCount: sortedList.length,
            itemBuilder: (BuildContext context, int index) {
              final option = sortedList.elementAt(index);

              return GestureDetector(
                onTap: () {
                  onSelected(option);
                },
                child: Container(
                  color: index == 0
                      ? custBlack102339.withOpacity(0.04)
                      : Colors.transparent,
                  height: 36,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 13,
                        ),
                        height: 36,
                        width: 2,
                        color: index == 0 ? primaryColor : Colors.transparent,
                      ),
                      CustomText(
                        txtTitle: option.name,
                        style: TextStyle(
                          color: custBlack102339.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  ///  Category Text form Field
  Widget _buildCategoryTextFormField({
    required TextEditingController lendTypeController,
    required FocusNode lendTypeFocusNode,
  }) {
    _ceategoryTypeFocusNode = lendTypeFocusNode;
    return TextFormField(
      // initialValue: itemDetailModel.category?.name ?? "",
      textInputAction: TextInputAction.next,
      validator: (cat) => cat!.validateCategoryType,
      // onChanged: ((value) => print(value)),
      controller: lendTypeController,
      focusNode: _ceategoryTypeFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 15,
        ),
        hintText: StaticString.itemCategory.replaceAll(":", ""),
      ),
    );
  }

  /// Item Exchange & Pickup Preferences
  Widget _buildExchange() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final Iterable<String> sortedList =
            ItemExchangeReturnPrefernces.preferences.where(
          (suggestion) => suggestion.toLowerCase().contains(
                '',
              ),
        );

        return sortedList;
      },
      onSelected: (value) {
        // itemDetailModel.exchangePref = value;
        // FocusScope.of(context).unfocus();
        // _exchangePrefController.text = itemDetailModel.exchangePref ?? "";
      },
      fieldViewBuilder: (context, prefController, _prefFocusNode,
          VoidCallback onFieldSubmitted) {
        Future.delayed(const Duration(microseconds: 10), () {
          prefController.text = "";
          prefController.text = _exchangePrefController.text;
        });
        return _buildExchangePrefTextFormField(
          prefController: prefController,
          prefFocusNode: _prefFocusNode,
        );
      },
      optionsViewBuilder: (_, onSelected, sortedList) {
        return _buildPrefSortedList(
          sortedList: sortedList,
          onSelected: onSelected,
        );
      },
    );
  }

  Widget _buildReturn() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final Iterable<String> sortedList =
            ItemExchangeReturnPrefernces.preferences.where(
          (suggestion) => suggestion.toLowerCase().contains(
                '',
              ),
        );

        return sortedList;
      },
      onSelected: (value) {
        // itemDetailModel.returnPref = value;
        // FocusScope.of(context).unfocus();
        // _returnPrefController.text = itemDetailModel.returnPref ?? "";
      },
      fieldViewBuilder: (context, prefController, _prefFocusNode,
          VoidCallback onFieldSubmitted) {
        Future.delayed(const Duration(microseconds: 10), () {
          prefController.text = "";
          prefController.text = _returnPrefController.text;
        });
        return _buildReturnPrefTextFormField(
          prefController: prefController,
          prefFocusNode: _prefFocusNode,
        );
      },
      optionsViewBuilder: (_, onSelected, sortedList) {
        return _buildPrefSortedList(
          sortedList: sortedList,
          onSelected: onSelected,
        );
      },
    );
  }

  ///  prefs sorted List
  Widget _buildPrefSortedList(
      {required Iterable<String> sortedList,
      required AutocompleteOnSelected<String> onSelected}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(
            right: 40,
          ),
          height: 120,
          // width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(16, 35, 57, 0.1),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            itemCount: sortedList.length,
            itemBuilder: (BuildContext context, int index) {
              final option = sortedList.elementAt(index);

              return GestureDetector(
                onTap: () {
                  onSelected(option);
                },
                child: Container(
                  color: index == 0
                      ? custBlack102339.withOpacity(0.04)
                      : Colors.transparent,
                  height: 36,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 13,
                        ),
                        height: 36,
                        width: 2,
                        color: index == 0 ? primaryColor : Colors.transparent,
                      ),
                      CustomText(
                        txtTitle: option,
                        style: TextStyle(
                          color: custBlack102339.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  ///  Exchange Pref Text form Field
  Widget _buildExchangePrefTextFormField({
    required TextEditingController prefController,
    required FocusNode prefFocusNode,
  }) {
    _exchangePrefFocusNode = prefFocusNode;
    return TextFormField(
      // initialValue: itemDetailModel.category?.name ?? "",
      textInputAction: TextInputAction.next,
      validator: (val) => val!.validateExchangePref,
      // onChanged: ((value) => print(value)),
      controller: prefController,
      focusNode: _exchangePrefFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 15,
        ),
        hintText: ItemExchangeReturnPrefernces.preferences.first,
      ),
    );
  }

  ///  Return Pref Text form Field
  Widget _buildReturnPrefTextFormField({
    required TextEditingController prefController,
    required FocusNode prefFocusNode,
  }) {
    _returnPrefFocusNode = prefFocusNode;
    return TextFormField(
      // initialValue: itemDetailModel.category?.name ?? "",
      textInputAction: TextInputAction.next,
      validator: (val) => val!.validateReturnPref,
      // onChanged: ((value) => print(value)),
      controller: prefController,
      focusNode: _returnPrefFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 15,
        ),
        hintText: ItemExchangeReturnPrefernces.preferences.first,
      ),
    );
  }

  // /// Category Drop Down
  // Widget _buildItemCategoryDropDown(BuildContext context) {
  //   return GetBuilder<CategoryContoller>(builder: (context) {
  //     return Container(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 15,
  //       ),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: custLightGreenEAF0FC),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: DropdownButton<int>(
  //         menuMaxHeight: 300,
  //         value: dropdownvalue,
  //         borderRadius: BorderRadius.circular(10),
  //         isExpanded: true,
  //         underline: const SizedBox(),
  //         icon: CustImage(
  //           imgURL: ImgName.dropDownIcon,
  //         ),
  //         items: categoryContoller.listOfCategoryItem.map((items) {
  //           return DropdownMenuItem(
  //             enabled: true,
  //             value: items.id,
  //             child: CustomText(
  //               txtTitle: items.name,
  //               style: Theme.of(getContext).textTheme.bodyText1?.copyWith(
  //                     color: custBlack102339WithOpacity,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (int? value) {
  //           setState(() {
  //             dropdownvalue = value ?? 0;

  //             itemDetailModel.category?.id = value!;
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // Location Text Form Field
  Widget _buildLocationTextFormField() {
    return TextFormField(
      focusNode: _locationFocusNode,
      readOnly: true,
      onTap: () async {
        final sessionToken = Uuid().v4();
        await showSearch(
          context: context,
          delegate: AddressSearch(sessionToken),
        ).then((value) async {
          debugPrint('value is $value');
          print(value?.placeId.isEmpty);
          if (value != null && value.placeId.isNotEmpty) {
            debugPrint('result value is ${result?.placeId}');

            PlaceApiProvider apiClient = PlaceApiProvider("");
            final place =
                await apiClient.getPlaceStateAndCityFromId(value.placeId);
            itemDetailModel.city = place.city;
            itemDetailModel.country = place.country;
            itemDetailModel.state = place.state;
            result = value;
            setState(() {
              _locationController.text = result?.description ?? "";
            });
          }
        });

        FocusScope.of(context).requestFocus(_descriptionFocusNode);
      },
      textInputAction: TextInputAction.next,
      validator: (loc) => loc!.validatelocation,
      onSaved: (location) {
        itemDetailModel.address = result?.placeId ?? "";
        debugPrint('selected address is ${itemDetailModel.address}');
      },
      // location ?? "",
      onFieldSubmitted: (_) => _descriptionFocusNode.requestFocus(),
      controller: _locationController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 15,
        ),
        hintText: StaticString.hintLocation,
        suffixIcon: CustImage(
          imgURL: ImgName.locationImage,
          width: 12,
          height: 17,
        ),
      ),
    );
  }

  // Description Text Form Field
  Widget _buildDescriptionTextFormField() {
    return TextFormField(
      focusNode: _descriptionFocusNode,
      textInputAction: TextInputAction.next,
      maxLines: 3,
      onFieldSubmitted: (_) => _durationFocusNode.requestFocus(),
      validator: (des) => des!.validateDescription,
      onSaved: (des) => itemDetailModel.description = des ?? "",
      controller: _descriptionController,
      // style: const TextStyle(
      //   fontSize: 20.0,
      //   color: Colors.grey,
      // ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          top: 16,
          left: 15,
          right: 15,
        ),
        hintText: StaticString.hintDescription,
      ),
    );
  }

  /// Max DurationText Form Field
  Widget _buildMaxDurationTextFormField() {
    return Slider(
        value: itemDetailModel.maxDuration?.toDouble() ?? 0.0,
        divisions: 100,
        max: 100,
        label: itemDetailModel.maxDuration?.toString(),
        onChanged: (value) {
          setState(() {
            itemDetailModel.maxDuration = value.toInt();
            debugPrint('max duration is ${itemDetailModel.maxDuration}');
          });
        });
    //   TextFormField(
    //   focusNode: _durationFocusNode,
    //   keyboardType: TextInputType.number,
    //   textInputAction: TextInputAction.next,
    //   onFieldSubmitted: (_) => _valueFocusNode.requestFocus(),
    //   validator: (val) => val!.validateDuration,
    //   onSaved: (duration) =>
    //       itemDetailModel.maxDuration = int.parse(duration ?? "0"),
    //   controller: _durationController,
    //   decoration: const InputDecoration(
    //       contentPadding: EdgeInsets.symmetric(
    //         horizontal: 15,
    //       ),
    //       hintText: StaticString.hintDuration,
    //       labelStyle: TextStyle(color: Colors.red)),
    // );
  }

// Value Text Form Field
  Widget _buildValueTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      //  focusNode: _valueFocusNode,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      textInputAction: TextInputAction.next,
      //  onFieldSubmitted: (_) => _valueFocusNode.requestFocus(),
      //  focusNode: _valueFocusNode,
      validator: (value) => value!.validateValue,
      onChanged: (value) {
        debugPrint('error $value}');

        // value.isEmpty
        //     ? _perDayController.text = ""
        //     : _perDayController.text =
        //         //  "\$" +
        //         ((double.parse(value) *
        //                     double.parse(
        //                       double.parse(
        //                         lendController.rate.value.itemDailyRate,
        //                       ).toStringAsFixed(2),
        //                     )) /
        //                 100)
        //             .toString();

        value.isEmpty
            ? _safetyDepositeController.text = ""
            : _safetyDepositeController.text =
                //  "\$" +
                (double.parse(value) / 2).toString();
        // itemModel.value = int.parse(value ?? "0");
        if (int.parse(value) > 5000) {
          _valueController.text = "5000";
          _valueController.selection =
              TextSelection.collapsed(offset: _valueController.text.length);
        }
      },

      onSaved: (value) {
        itemDetailModel.price = value ?? "0";

        // itemModel.value = int.parse(value ?? "0");
      },
      controller: _valueController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        hintText: StaticString.hintValue,
      ),
    );
  }

  /// Rate per With Title
  Widget _buildRatePerWithTitle({
    required BuildContext context,
    required String title,
    double fontSize = 12,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomRichText(
          title: title,
          normalTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
          fancyTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: custBlack102339WithOpacity,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(
          height: 12,
        ),
        child,
      ],
    );
  }

  /// Rate Per Day Text Form Field
  Widget _buildRatePerDayTextFormField() {
    return TextFormField(
      //   enabled: false,
      keyboardType: TextInputType.number,
      controller: _perDayController,
      focusNode: _perDayFocusNode,
      validator: (value) => value!.validateRatePerDay,
      onChanged: (value) {
        lendController.updateRate(value);
      },
      onSaved: (value) {
        itemDetailModel.ratePerDay =
            double.parse(value.toString()).toStringAsFixed(2);
      },
      //  controller: _perDayController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        filled: true,
        // fillColor: custBlack102339.withOpacity(0.05),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        hintText: "Rate",
      ),
    );
  }

  /// Safety Deposite Text Form Field
  Widget _buildSafetyDepositeTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      readOnly: true,

      controller: _safetyDepositeController,
      //   focusNode: _safetyDepositeFocusNode,
      textInputAction: TextInputAction.done,
      // onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
      validator: (deposite) {
        if (deposite!.isEmpty) {
          return AlertMessageString.emptySafetyDeposite;
        }
        //  else if (int.parse(deposite) >= int.parse(_valueController.text)) {
        //   return AlertMessageString.invalidSafetyDeposite;
        // }
        else {
          return null;
        }
        // value!.validateSafetyDeposite;
      },
      onSaved: (value) => itemDetailModel.safetyDeposit = value ?? "0",
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        hintText: StaticString.hintsafetyDeposite,
      ),
    );
  }

  Widget _buildInsuranceBox(
      {required String content, required bool insuranceYes}) {
    return InkWell(
      onTap: () {
        debugPrint(
            ((insuranceYes && _isChecked) || (!insuranceYes && !_isChecked))
                .toString());
        if ((insuranceYes && _isChecked) || (!insuranceYes && !_isChecked)) {
          return;
        }

        setState(() {
          _isChecked = !_isChecked;
          // itemDetailModel.opt = val ?? false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            5,
          ),
          border: Border.all(
            color: custBlack102339.withOpacity(0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // color: Colors.green,
              height: 20,
              width: 20,

              child: Checkbox(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // activeColor: primaryColor,
                checkColor: Colors.white,
                value: insuranceYes ? _isChecked : !_isChecked,
                onChanged: (val) {
                  setState(
                    () {
                      _isChecked = val ?? false;
                      // itemDetailModel.opt = val ?? false;
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: CustomText(
                txtTitle: content,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      // fontWeight: FontWeight.w500,
                      color: custBlack102339WithOpacity,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Check Box And Opt ....
  Widget _buildCheckBoxAndOptText(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          // activeColor: primaryColor,
          checkColor: Colors.white,
          value: _isChecked,
          onChanged: (val) {
            setState(
              () {
                _isChecked = val ?? false;
                // itemDetailModel.opt = val ?? false;
              },
            );
          },
        ),
        const SizedBox(
          width: 3,
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              // itemDetailModel.opt = val ?? false;
            });
          },
          child: CustomText(
            txtTitle: StaticString.optInInsurance,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  // fontWeight: FontWeight.w500,
                  color: custBlack102339WithOpacity,
                ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Tooltip(
          showDuration: const Duration(seconds: 10),
          triggerMode: TooltipTriggerMode.tap,
          message: StaticString.optText,
          decoration: BoxDecoration(
            color: custBlack102339,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 57),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 17.00,
          ),
          textStyle: const TextStyle(
            fontSize: 10,
            color: custWhiteFFFFFF,
            fontWeight: FontWeight.w700,
          ),
          child: CustImage(
            imgURL: ImgName.infoIcon,
            height: 14,
            width: 14,
          ),
        ),
      ],
    );
  }

  //Lend Button
  Widget _buildLendButton() {
    return Obx(() {
      return Center(
        child: CustomButton(
          loadingIndicator: lendController.loadingItemDetail.value,
          buttonTitle: itemDetailModel.id == null ? StaticString.lend : "Save",
          onPressed: _formSubmit,
        ),
      );
    });
  }

  //!--------------------------------Button Action -----------------------

  void _upload() {
    debugPrint(
        "************************************** Upload *************************************");
  }

  Future<void> addImage() async {
    print(image);
    directory = await getTemporaryDirectory();
    _pickImageOption = await imagePickOption();
    targetPath = "${directory?.path ?? ""}/${DateTime.now()}.jpeg";
    _imageNotifier.notifyListeners();

    if (_pickImageOption != null) {
      final imageTemporary = await PickImage(
        pickImageOption: _pickImageOption!,
      );

      if (imageTemporary.path.isNotEmpty) {
        debugPrint('picked image path ${imageTemporary.path}');
        //   image[0].imageUrl = imageTemporary.path;

        compressFile = await FlutterImageCompress.compressAndGetFile(
          imageTemporary.path,
          targetPath ?? "",
          quality: 90,
          format: CompressFormat.jpeg,
        );
        //   debugPrint('the image url is ${image[0].imageUrl}');
        debugPrint('compressed path is ${compressFile?.path}');
        // itemDetailModel.lendItemServiceImages?[0].imageUrl =
        //     compressFile?.path ?? "";

        itemDetailModel.lendItemServiceImages?.add(ImageModel(
            imageUrl: compressFile?.path ?? "",
            temporaryUrl: imageTemporary.path ?? ""));

        _isSelectedImage = image.any((element) => element.imageUrl.isNotEmpty);
      }
    }
    _imageNotifier.notifyListeners();
  }

  Future<void> _formSubmit() async {
    try {
      final _authController = Get.find<AuthController>();
      if (!_authController.getUserInfo.stripeConnected) {
        showMessage();
        return;
      }
      if (itemDetailModel.maxDuration == 0 ||
          itemDetailModel.maxDuration == null) {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Max Duration cannot be 0',
            animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      // print(image[0].imageUrl);
      // print(image[1].imageUrl);
      if (!_formKey.currentState!.validate()) {
        _autovalidateMode = AutovalidateMode.always;
        // if (_isSelectedImage == null &&
        //     image.every((element) => element.imageUrl.isEmpty)) {
        //   _isSelectedImage = false;
        //   setState(() {});
        // }
        return;
      }

      if (itemDetailModel.lendItemServiceImages == null) {
        _isSelectedImage = false;
        setState(() {});
        return;
      } else if (itemDetailModel.lendItemServiceImages != null &&
          itemDetailModel.lendItemServiceImages!.length < 2) {
        _isSelectedImage = false;
        setState(() {});
        return;
      }
      // itemModel.category = _categoryTypeController.text;

      _formKey.currentState?.save();

      // _isChecked
      itemDetailModel.optInInsurance = _isChecked;
      // itemDetailModel.lendItemServiceImages = image;
      if (id == null) {
        print('model to launch ${itemDetailModel.toJson()}');
        await lendController.createItem(
          context: context,
          itemDetailModel: itemDetailModel,
        );
        Get.back();
        Get.showSnackbar(
          const GetSnackBar(
            message: StaticString.itemCreatedSuccessfully,
            animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print(" UPDATE  * * *  ${itemDetailModel.toJson()}");
        await lendController.updateItemAndService(
          context: context,
          itemDetailModel: itemDetailModel,
        );
        Get.back();
        Get.showSnackbar(const GetSnackBar(
          message: StaticString.itemUpdatedSuccessfully,
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e, st) {
      debugPrint('error lending item $e $st');
    } finally {}
  }
}
