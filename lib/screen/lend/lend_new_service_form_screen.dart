// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/spinner.dart';
import '/models/image_model.dart';
import '/widgets/cust_button.dart';
import '../../controller/item_controller.dart';
import '../../models/place_service.dart';
import '../../widgets/address_search.dart';
import '/widgets/custom_appbar.dart';
import '../../constants/img_font_color_string.dart';
import '../../controller/category_controller.dart';
import '../../controller/lend_controller.dart';
import '../../models/categories_model.dart';
import '../../models/item_detail_model.dart';
import '../../models/item_model.dart';
import '../../utils/custom_enum.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/image_picker.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/keyboard_with_done_button.dart';
import '../../widgets/loading_indicator.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/screen/payment/connect_stripe_account_screen.dart';

class LendNewServiceFormScreen extends StatefulWidget {
  const LendNewServiceFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LendNewServiceFormScreen> createState() =>
      _LendNewServiceFormScreenState();
}

class _LendNewServiceFormScreenState extends State<LendNewServiceFormScreen> {
  //!-------------------------------variable---------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LendController lendController = Get.find<LendController>();
  ItemController itemController = Get.find<ItemController>();
  final _paymentController = Get.find<PaymentController>();

  // final ServiceDetailModel serviceDetailModel = ServiceDetailModel();
  CategoryContoller categoryContoller = Get.find<CategoryContoller>();
  ItemDetailModel itemDetailModel = ItemDetailModel(
    deleteImagesIdList: [],
    category: CategoryModel(
      id: 0,
    ),
    lendItemServiceImages: [ImageModel(), ImageModel()],
  );

  List<ImageModel> image = [ImageModel(), ImageModel()];
  PickImageOption? _pickImageOption;

  Suggestion? result;
  bool _apiCallingInProgress = false;

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  ItemModel? itemModel;

  final ValueNotifier _imageNotifier = ValueNotifier(true);
  final ValueNotifier _selectNotifier = ValueNotifier(true);

  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceCategoryController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();
  final TextEditingController _dayHourController = TextEditingController();

  final FocusNode _serviceNameFocusNode = FocusNode();
  final FocusNode _serviceCategoryFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _valueFocusNode = FocusNode();
  final FocusNode _moreInfoFocusNode = FocusNode();

  late AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool? _isSelectedImage;

  File? compressFile;
  Directory? directory;
  String? targetPath;

  RxBool initialApiCallInProgress = false.obs;

  final List<String> _selectList = [
  //  "Per Day",
    "Per Hour",
  ];

  String dropdownvalue = "Per Hour";

  int? id = Get.arguments;

  @override
  void initState() {
    super.initState();
    final _authController = Get.find<AuthController>();
    if (!_authController.getUserInfo.stripeConnected) {
      showMessage();
    }
    // if(_authController.getUserInfo.verified == null) {
    //   showVerficationAlert();
    // }
    fetchData();

    Future.delayed(Duration(milliseconds: 100), () {
      locationDialogueIfLocationIsDisale(backTwise: true);
    });
  }

  Future<void> showMessage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if(!mounted) return;
    showAlert(
        context: context,
        title: 'Alert',
        message: 'Stripe account is not yet connected. Please select \'yes\' to connect your stripe account in order to receive payments.',
        signleBttnOnly: false,
        onRightAction:  () async {
            _paymentController.setStripePageLoading(true);
            var accLinkRes = await _paymentController.createStripeAccount();
            String url = json.decode(accLinkRes)["data"]["url"];
            debugPrint(url);
            String account = json.decode(accLinkRes)["data"]["account"];
              Get.to(() => ConnectStripeAccountScreen(url: url, accountId: account));
          },
          onLeftAction:  () async {
          Get.back();
        }
      );
  }

  void showVerficationAlert() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if(!mounted) return;
    showAlert(
        context: context,
        title: 'Alert',
        signleBttnOnly: false,
        leftBttnTitle: 'Skip',
        rigthBttnTitle: 'Verify Yourself',
        onRightAction: () {
          debugPrint('worked or not');
          Get.toNamed("VerifyIDBackgroundCheckFormScreen");
        },
        message: 'You are not verified. You can verify yourself so that the renters know you are a legit service provider');

  }

  Future fetchData() async {
    try {
      initialApiCallInProgress.value = id != null;

      await categoryContoller.fetchCategories(type: "service");
      directory = await getTemporaryDirectory();
      if (id != null) {
        await lendController.fetchItemDetail(context: context, id: id ?? 0);
        final ItemDetailModel tempItemModel = lendController.itemDetail.value;
        itemDetailModel.id = id ?? 0;
        image = (tempItemModel.lendItemServiceImages?.isEmpty ?? true)
            ? [ImageModel(), ImageModel()]
            : tempItemModel.lendItemServiceImages ?? [];
        _serviceNameController.text = tempItemModel.name;

        _locationController.text = tempItemModel.address;
        _descriptionController.text = tempItemModel.description;
        _valueController.text = tempItemModel.ratePerDay != "0.0"
            ? tempItemModel.ratePerDay
            : tempItemModel.ratePerHour;
        _moreInfoController.text = tempItemModel.moreInfo;
        itemDetailModel.category = tempItemModel.category;
        _serviceCategoryController.text = tempItemModel.category?.name ?? "";
        dropdownvalue =
            tempItemModel.ratePerDay != "0.0" ? "Per Day" : "Per Hour";

        image =
            tempItemModel.lendItemServiceImages ?? [ImageModel(), ImageModel()];

        if (image.isEmpty) {
          image = [ImageModel(), ImageModel()];
        } else if (image.length == 1) {
          image.add(ImageModel());
        }

        itemDetailModel.lendItemServiceImages = image;
      } else {
        // itemDetailModel.category?.id =
        //     categoryContoller.listOfCategoryService[0].id;
      }
    } catch (e) {
      showAlert(context: context, message: e);
    } finally {
      initialApiCallInProgress.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _serviceNameController.dispose();
    _serviceCategoryController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _moreInfoController.dispose();

    _serviceNameFocusNode.dispose();
    _serviceCategoryFocusNode.dispose();
    _locationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _valueFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: id == null
              ? StaticString.lendNewService
              : StaticString.lendEditService,
        ),
        body: Obx(() {
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
                          _serviceNameFocusNode,
                          _serviceCategoryFocusNode,
                          _locationFocusNode,
                          _descriptionFocusNode,
                          _valueFocusNode,
                          _moreInfoFocusNode
                        ],
                        onDoneClicked: () {
                          final FocusScopeNode currentFocus = FocusScope.of(context);
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
                              //-----------------Service Name TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.serviceName,
                                child: _buildNameTextFormField(),
                              ),

                              //-----------------Service Category TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.serviceCategory,
                                child: _buildServiceCategory(),
                              ),

                              //-----------------Location TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.location,
                                child: _buildLocationTextFormField(),
                              ),

                              //-----------------Description TextFormField--------------
                              textFieldWithTitle(
                                title: StaticString.description,
                                child: _buildDescriptionTextFormField(),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ---------------- Selct Day or hour DropDown --------------
                                  SizedBox(
                                    width: 120,
                                    child: textFieldWithTitle(
                                      title: StaticString.select,
                                      child: Center(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            // hint: dropdownvalue,
                                            // dropdownItems: _selectList,
                                            dropdownOverButton: true,

                                            buttonPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 14,
                                            ),

                                            items: _selectList
                                                .map(
                                                  (item) =>
                                                      DropdownMenuItem<String>(
                                                    onTap: () {
                                                      dropdownvalue = item;
                                                      _selectNotifier
                                                          .notifyListeners();
                                                    },
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: cust87919C,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                                .toList(),

                                            value: dropdownvalue,
                                            iconEnabledColor: cust87919C,
                                            iconDisabledColor: cust87919C,
                                            buttonHeight: 50,
                                            buttonWidth: 160,

                                            icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                            ),
                                            iconSize: 20,
                                            buttonDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: custBlack102339
                                                    .withOpacity(0.1),
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                dropdownvalue = value as String;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //-----------------Value TextFormField-------------------
                                  Expanded(
                                    child: textFieldWithTitle(
                                      title: StaticString.enterValue2,
                                      child: _buildValueTextFormField(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              //-----------------Description TextFormField--------------
                              // textFieldWithTitle(
                              //   title: StaticString.moreInfoAboutYou + ":",
                              //   child: _buildMoreInfoTextFormField(),
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
        }));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      _pickImageOption = await imagePickOption();
                      targetPath = (directory?.path ?? "") +
                          "/" +
                          DateTime.now().toString() +
                          ".jpeg";
                      _imageNotifier.notifyListeners();
                      if (_pickImageOption != null) {
                        final imageTemporary =
                            await PickImage(pickImageOption: _pickImageOption!);

                        if (image.isNotEmpty) {
                          if (image[0].id != null &&
                              !itemDetailModel.deleteImagesIdList
                                  .any((element) => element == image[0].id)) {
                            itemDetailModel.deleteImagesIdList
                                .add(image[0].id!);
                          }
                        }

                        if (imageTemporary.path.isNotEmpty) {
                          image[0].imageUrl = imageTemporary.path;
                          compressFile =
                              await FlutterImageCompress.compressAndGetFile(
                            imageTemporary.path,
                            targetPath ?? "",
                            quality: 90,
                            format: CompressFormat.jpeg,
                          );
                          itemDetailModel.lendItemServiceImages?[0].imageUrl =
                              compressFile?.path ?? "";
                          _isSelectedImage = image
                              .any((element) => element.imageUrl.isNotEmpty);
                        }
                      }

                      _imageNotifier.notifyListeners();
                    },
                    // onTap: () => _pickImage(0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CustImage(
                        defaultImageWithDottedBorder: true,
                        imgURL: image[0].imageUrl,
                        height: 100,
                        width: double.infinity,
                        boxfit: BoxFit.cover,
                        cornerRadius: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      _pickImageOption = await imagePickOption();
                      targetPath = (directory?.path ?? "") +
                          "/" +
                          DateTime.now().toString() +
                          ".jpeg";
                      _imageNotifier.notifyListeners();

                      if (_pickImageOption != null) {
                        final imageTemporary =
                            await PickImage(pickImageOption: _pickImageOption!);

                        // Deleted id list for add deleted images id
                        if (image.length >= 2) {
                          if (image[1].id != null &&
                              !itemDetailModel.deleteImagesIdList
                                  .any((element) => element == image[1].id)) {
                            itemDetailModel.deleteImagesIdList
                                .add(image[1].id!);
                          }
                        }

                        if (imageTemporary.path.isNotEmpty) {
                          image[1].imageUrl = imageTemporary.path;
                          compressFile =
                              await FlutterImageCompress.compressAndGetFile(
                            imageTemporary.path,
                            targetPath ?? "",
                            quality: 90,
                            format: CompressFormat.jpeg,
                          );
                          itemDetailModel.lendItemServiceImages?[1].imageUrl =
                              compressFile?.path ?? "";
                          _isSelectedImage = image
                              .any((element) => element.imageUrl.isNotEmpty);
                        }
                      }
                      _imageNotifier.notifyListeners();
                    },
                    // onTap: () => _pickImage(1),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CustImage(
                        defaultImageWithDottedBorder: true,
                        imgURL: image[1].imageUrl,
                        height: 100,
                        width: double.infinity,
                        boxfit: BoxFit.cover,
                        cornerRadius: 8,
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: _pickImage,
                //   child: CustImage(
                //     imgURL: ImgName.imagePlacheHolderImage,
                //   ),
                // ),
              ],
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
      },
    );
  }

  // /// Image Pick Option
  // Future _buildImagePickOption(int index) {
  //   return Get.defaultDialog(
  //     title: "Pick Image From",
  //     titleStyle: const TextStyle(
  //       fontSize: 16,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     content: Padding(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 50,
  //       ),
  //       child: Column(
  //         children: [
  //           ElevatedButton(
  //             onPressed: () async {
  //               setState(() {
  //                 _pickImageOption = PickImageOption.camera;
  //               });
  //               Get.back();
  //               await _pickImage(index);
  //             },
  //             child: const CustomText(
  //               txtTitle: "Camera",
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               setState(() {
  //                 _pickImageOption = PickImageOption.gallery;
  //               });
  //               Get.back();
  //               await _pickImage(index);
  //             },
  //             child: const CustomText(
  //               txtTitle: "Gallery",
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

// Item Name Text Form Field
  Widget _buildNameTextFormField() {
    return TextFormField(
      focusNode: _serviceNameFocusNode,
      enabled: itemDetailModel.id == null,
      textInputAction: TextInputAction.next,
      validator: (val) => val!.validateItemName,
      onSaved: (name) => itemDetailModel.name = name ?? "",
      controller: _serviceNameController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: StaticString.hintServiceName,
          labelStyle: TextStyle(color: Colors.red)),
    );
  }

  /// Service Category
  Widget _buildServiceCategory() {
    return Autocomplete<CategoryModel>(
      optionsBuilder: (TextEditingValue value) {
        Iterable<CategoryModel> sortedList =
            categoryContoller.listOfCategoryService.where(
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
        _serviceCategoryController.text = itemDetailModel.category?.name ?? "";
        // });
      },
      fieldViewBuilder: (context, service, _serviceCategoryFocusNode,
          VoidCallback onFieldSubmitted) {
        Future.delayed(const Duration(microseconds: 10), () {
          service.text = _serviceCategoryController.text;
        });
        return _buildServiceCategoryTextFormField(
            lendTypeController: service,
            lendTypeFocusNode: _serviceCategoryFocusNode);
      },
      optionsViewBuilder: (_, onSelected, sortedList) {
        return _buildServiceCategorySortedList(
          sortedList: sortedList,
          onSelected: onSelected,
        );
      },
    );
  }

  /// Service Category sorted List
  Widget _buildServiceCategorySortedList(
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

  /// Service Category Text form Field
  Widget _buildServiceCategoryTextFormField({
    required TextEditingController lendTypeController,
    required FocusNode lendTypeFocusNode,
  }) {
    return TextFormField(
      // initialValue: itemDetailModel.category?.name ?? "",
      textInputAction: TextInputAction.next,
      validator: (lender) => lender!.validateLenderType,
      // onChanged: ((value) => print(value)),
      controller: lendTypeController,
      focusNode: lendTypeFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 15,
        ),
        hintText: StaticString.serviceCategory.replaceAll(":", ""),
      ),
    );
  }

  /// Category Drop Down
  Widget _buildServiceTypeDropDown(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectNotifier,
      builder: (context, val, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: custLightGreenEAF0FC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            menuMaxHeight: 300,
            value: dropdownvalue,
            borderRadius: BorderRadius.circular(10),
            isExpanded: true,
            underline: const SizedBox(),
            icon: CustImage(
              imgURL: ImgName.dropDownIcon,
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            items: _selectList.map((String items) {
              return DropdownMenuItem(
                enabled: true,
                value: items,
                child: CustomText(
                  txtTitle: items,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: custBlack102339WithOpacity,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              // setState(() {
              dropdownvalue = value ?? "";
              _selectNotifier.notifyListeners();
              // itemDetailModel .type = value ?? "";
              // });
            },
          ),
        );
      },
    );
  }

  // Location Text Form Field
  Widget _buildLocationTextFormField() {
    return TextFormField(
      focusNode: _locationFocusNode,
      readOnly: true,
      textInputAction: TextInputAction.next,
      onTap: () async {
        // final sessionToken = "32df207a-b3f9-4edb-9a1f-3a2731e1f40f";
        final sessionToken = Uuid().v4();
        await showSearch(
          context: context,
          delegate: AddressSearch(sessionToken),
        ).then((value) {
          if (value?.placeId.isNotEmpty ?? false) {
            result = value;

            // This will change the text displayed in the TextField
            setState(() {
              _locationController.text = result?.description ?? "";
            });
          }
        });
        print(result);
        FocusScope.of(context).requestFocus(_descriptionFocusNode);
      },
      validator: (loc) => loc!.validatelocation,
      onSaved: (location) => itemDetailModel.address = result?.placeId ?? "",

      controller: _locationController,
      // style: const TextStyle(
      //   fontSize: 20.0,
      //   color: Colors.grey,
      // ),
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

// Value Text Form Field
  Widget _buildValueTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      focusNode: _valueFocusNode,
      textInputAction: TextInputAction.next,
      validator: (value) => value!.validateValue,
      onSaved: (value) => dropdownvalue == "Per Day"
          ? (itemDetailModel.ratePerDay = value ?? "")
          : {itemDetailModel.ratePerHour = value ?? ""},
      controller: _valueController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        hintText: StaticString.hintValue,
      ),
    );
  }

  /// More Info About you text Form Field
  Widget _buildMoreInfoTextFormField() {
    return TextFormField(
      maxLines: 3,
      textInputAction: TextInputAction.done,
      onSaved: (value) {
        itemDetailModel.moreInfo = value ?? "";
      },
      // validator: (val) => val?.validateMoreInfo,
      controller: _moreInfoController,
      focusNode: _moreInfoFocusNode,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 20, right: 45, top: 30),
        hintText: StaticString.moreInfoAboutYou,
      ),
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

        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     // shadowColor: Colors.black,
        //     shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
        //     elevation: 10,
        //   ),
        //   onPressed: _formSubmit,
        //   child: const CustomText(
        //     txtTitle: StaticString.lend,
        //     style: TextStyle(
        //       letterSpacing: 1,
        //       fontWeight: FontWeight.bold,
        //       fontFamily: CustomFont.metropolis,
        //     ),
        //   ),
        // ),
      );
    });
  }

  //!--------------------------------Button Action -----------------------

  void _formSubmit() async {
    try {
      if (!_formKey.currentState!.validate()) {
        _autovalidateMode = AutovalidateMode.always;

        // if (_isSelectedImage == null &&
        //     image.every((element) => element.imageUrl.isEmpty)) {
        //   _isSelectedImage = false;
        //   setState(() {});
        // }
        // return;
      }
      // if (_isSelectedImage == null &&
      //     image.every((element) => element.imageUrl.isEmpty)) {
      //   _isSelectedImage = false;
      //   setState(() {});
      //   return;
      // }
      // itemModel.category = _categoryTypeController.text;
      _loadingIndicatorNotifier.show();
      _formKey.currentState?.save();

      if (id == null) {
        // print(itemDetailModel);
        await lendController.createService(
          context: context,
          itemDetailModel: itemDetailModel,
        );

        Get.back();
        Get.showSnackbar(const GetSnackBar(
          message: StaticString.serviceCreatedSuccessfully,
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ));
      } else {
        // print(itemDetailModel);
        await lendController.updateItemAndService(
          context: context,
          itemDetailModel: itemDetailModel,
        );

        Get.back();
        Get.showSnackbar(
          const GetSnackBar(
            message: StaticString.serviceUpdatedSuccessfully,
            animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        showAlert(context: context, message: e);
      }
    } finally {
      _loadingIndicatorNotifier.hide();
      // await itemController.fetchMyItems(
      //   context: context,
      //   onTap: true,
      // );
      //
    }
  }
}
