// import 'dart:html';

// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renting_app_mobile/constants/textfield_decoration.dart';
import 'package:renting_app_mobile/models/location_model.dart';
import 'package:renting_app_mobile/utils/permissions.dart';
import 'package:renting_app_mobile/widgets/allow_your_location_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../api/api_middleware.dart';
import '../../constants/text_style_decoration.dart';
import '/controller/auth_controller.dart';
import '/main.dart';
import '/widgets/cust_button.dart';
import '/widgets/custom_alert.dart';
import '/widgets/keyboard_with_done_button.dart';
import '/models/user_model.dart';
import '/widgets/loading_indicator.dart';
import '../../constants/img_font_color_string.dart';
import '../../models/place_service.dart';
import '../../utils/custom_enum.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/image_picker.dart';
import '../../widgets/address_search.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_text.dart';

class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({Key? key}) : super(key: key);

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
  //!----------------------variable------------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///  Text Form Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _moreInfoFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  File? compressFile;
  Directory? directory;
  String? targetPath;
  Suggestion? result;

  PickImageOption? _pickImageOption = PickImageOption.gallery;
  String image = ImgName.chooseUserImage;
  bool? _isSelectedProfile;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final UserInfoModel _userInfoModel = UserInfoModel(
    authType: AuthType.SignUp,
  );

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  ValueNotifier _valueNotifier = ValueNotifier(true);
  ValueNotifier _oncheckTermNotifier = ValueNotifier(true);
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: KeyboardWithDoneButton(
            focusNodeList: [
              _nameFocusNode,
              _emailFocusNode,
              _passwordFocusNode,
              _confirmPasswordFocusNode,
              _moreInfoFocusNode,
              _addressFocusNode,
              _phoneFocusNode,
            ],
            onDoneClicked: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                FocusScope.of(context).nextFocus();
              }
            },
            child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, val, child) {
                return Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),

                        CustomText(
                          txtTitle: StaticString.register,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Name text form feild
                        _buildNameFeild(),
                        const SizedBox(
                          height: 16,
                        ),
                        //Email text form feild
                        _buildEmailFeild(),
                        const SizedBox(
                          height: 16,
                        ),
                        // phone text form field
                        _buildPhoneField(),
                        const SizedBox(
                          height: 16,
                        ),
                        // password text form feild
                        _buildPasswordFeild(),
                        const SizedBox(
                          height: 16,
                        ),

                        // confirm password text form feild
                        _buildConfirmPassTextFormField(),
                        const SizedBox(
                          height: 16,
                        ),

                        /// Choose File
                        _buildChooseFile(context),

                        const SizedBox(
                          height: 16,
                        ),

                        /// More Info About you text Form Field
                        _buildMoreInfoTextFormField(),

                        // const SizedBox(height: 16),

                        // /// Address text Form Field
                        // _buildAddressTextFormField(),
                        _buildCheckBoxAndTerms(),
                        const SizedBox(
                          height: 40,
                        ),

                        // Register Button
                        _buildRegisterButton(),
                        const SizedBox(
                          height: 15,
                        ),

                        _buildLoginLink(),
                        const SizedBox(
                          height: 20,
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

//!------------------widget -------------------------

  // Appbar
  AppBar _buildAppbar() {
    return AppBar(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CustBackButton(),
        ],
      ),
      title: const CustomText(
        txtTitle: StaticString.register,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

// Name text form feild
  Widget _buildNameFeild() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onSaved: (name) {
        _userInfoModel.name = name ?? "";
      },
      validator: (val) => val?.validateName,
      controller: _nameController,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(
          img: ImgName.user,
          boxFit: BoxFit.contain,
          height: 16,
          width: 16,
        ),
        hintText: StaticString.name,
      ),
    );
  }

  /// Email text form feild
  Widget _buildEmailFeild() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (email) {
        _userInfoModel.email = email ?? "";
      },
      validator: (val) => val?.validateEmail,
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(
          img: ImgName.email,
          boxFit: BoxFit.cover,
          height: 14,
          width: 18,
        ),
        hintText: StaticString.emailID,
      ),
    );
  }

  /// phone Text form field
  Widget _buildPhoneField() {
    return IntlPhoneField(
      textInputAction: TextInputAction.next,
      controller: _phoneController,
      invalidNumberMessage: AlertMessageString.inavlidPhone,
      dropdownDecoration: BoxDecoration(
        borderRadius: TextFieldDecoration.textBorderRadius,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: suffixIconForTextField(
          img: ImgName.phone,
          height: 16,
          width: 16,
        ),
        hintText: StaticString.phone,
      ),
      onChanged: (phone) {
        debugPrint('phone $phone');
        _userInfoModel.phone = '${phone.countryCode}${phone.number}';
      },
    );
  }

  /// Password Text form feild
  Widget _buildPasswordFeild() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onSaved: (psw) {
        _userInfoModel.password = psw ?? "";
      },
      obscureText: true,
      validator: (val) => val?.validatePassword,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(
          img: ImgName.password,
          height: 16,
          width: 16,
        ),
        hintText: StaticString.password,
      ),
    );
  }

  /// Confirm Password text Form Field
  Widget _buildConfirmPassTextFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: true,
      validator: (pwd) {
        if (pwd!.isEmpty) {
          return AlertMessageString.emptyConfirmPwd;
        } else if (pwd != _passwordController.text) {
          return AlertMessageString.passwordDoNotMatch;
        }
        return null;
      },
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(img: ImgName.password),
        hintText: StaticString.confirmPassword,
      ),
    );
  }

  Widget _buildCheckBoxAndTerms() {
    return ValueListenableBuilder(
      valueListenable: _oncheckTermNotifier,
      builder: (context, val, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              // activeColor: primaryColor,
              checkColor: Colors.white,
              value: _isChecked,
              onChanged: (val) {
                _isChecked = val ?? false;
                _oncheckTermNotifier.notifyListeners();
              },
            ),
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: custBlack102339.withOpacity(0.5),
                  ),
                  children: [
                    const TextSpan(text: 'Tap to agree to our '),
                    TextSpan(
                      text: 'terms & conditions',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('touching');
                          _launchTermsAndConditions();
                        },
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'privacy policy',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('touching');
                          _launchPrivacyPolicy();
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return ValueListenableBuilder(
      valueListenable: _oncheckTermNotifier,
      builder: (context, val, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: custBlack102339.withOpacity(0.5),
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Login here!',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('touching');
                          Get.toNamed("LoginScreen");
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Choose File
  Widget _buildChooseFile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            /// Choose profile Image
            CustImage(
              imgURL: image,
              height: 91.84,
              width: 93.84,
              cornerRadius: 20.00,
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// choose File Button
                InkWell(
                  onTap: _chooseFile,
                  child: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      color: custBlack102339.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.00),
                    ),
                    child: CustomText(
                      txtTitle: StaticString.chooseFile,
                      style: Theme.of(context).textTheme.overline?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomText(
                  txtTitle: StaticString
                      .fileFormatText, //JPG, GIF or PNG. Max size of 800K
                  style: Theme.of(context).textTheme.overline?.copyWith(
                        color: custGrey7E7E7E,
                        fontWeight: FontWeight.w600,
                      ),
                )
              ],
            )
          ],
        ),
        if (_isSelectedProfile == false)
          const SizedBox(
            height: 8,
          ),
        if (_isSelectedProfile == false)
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: CustomText(
              txtTitle: AlertMessageString.emptyUserProfile,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.red,
                  ),
            ),
          )
      ],
    );
  }

  /// More Info About you text Form Field
  Widget _buildMoreInfoTextFormField() {
    return Stack(
      children: [
        TextFormField(
          maxLines: 4,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            _userInfoModel.info = value ?? "";
          },
          validator: (val) => val?.validateMoreInfo,
          controller: _moreInfoController,
          focusNode: _moreInfoFocusNode,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, right: 45, top: 30),
            hintText: StaticString.moreInfoAboutYou,
          ),
        ),
        Positioned(
          right: 20,
          top: 15,
          child: CustImage(
            imgURL: ImgName.user,
            height: 16,
            width: 16,
            boxfit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  // /// Address text Form Field
  // Widget _buildAddressTextFormField() {
  //   return Stack(
  //     children: [
  //       TextFormField(
  //         maxLines: 4,
  //         textInputAction: TextInputAction.done,
  //         readOnly: true,
  //         onTap: () async {
  //           // final sessionToken = "32df207a-b3f9-4edb-9a1f-3a2731e1f40f";
  //           final sessionToken = Uuid().v4();
  //           result = await showSearch(
  //             context: getContext,
  //             delegate: AddressSearch(sessionToken),
  //           );
  //           // // This will change the text displayed in the TextField
  //           if (result != null) {
  //             final placeDetails = await PlaceApiProvider(sessionToken)
  //                 .getPlaceDetailFromId(result?.placeId ?? "");
  //           }

  //           _addressController.text = result?.description ?? "";
  //         },
  //         onSaved: (address) {
  //           _userInfoModel.placeId = result?.placeId ?? "";
  //         },
  //         validator: (val) => val?.validateAddress,
  //         controller: _addressController,
  //         focusNode: _addressFocusNode,
  //         decoration: const InputDecoration(
  //           contentPadding: EdgeInsets.only(left: 20, right: 45, top: 30),
  //           hintText: StaticString.address,
  //         ),
  //       ),
  //       Positioned(
  //         right: 20,
  //         top: 15,
  //         child: CustImage(
  //           imgURL: ImgName.locationIcontextFormField,
  //           height: 18,
  //           width: 18,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _launchTermsAndConditions() async {
    final url = Uri.parse('https://re-lend.com/termsofuse/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      //  throw 'Could not launch $url';
    }
  }

  void _launchPrivacyPolicy() async {
    final url = Uri.parse('https://re-lend.com/privacy-policy/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      //  throw 'Could not launch $url';
    }
  }

  // Register button
  Widget _buildRegisterButton() {
    return Obx(
      () {
        return CustomButton(
          onPressed: _formSubmit,
          buttonTitle: StaticString.register.toUpperCase(),
          loadingIndicator: controller.registerApiInProgress.value,
        );
      },
    );
  }

  //!--------------------------------Button Action -----------------------
  void _chooseFile() async {
    debugPrint(
        "********************************** Choose File ***********************************");
    try {
      _pickImageOption = await imagePickOption();
      // setState(() {});
      directory = await getTemporaryDirectory();
      targetPath =
          (directory?.path ?? "") + "/" + DateTime.now().toString() + ".jpeg";
      _valueNotifier.notifyListeners();

      if (_pickImageOption != null) {
        final imageTemporary =
            await PickImage(pickImageOption: _pickImageOption!);
        compressFile = await FlutterImageCompress.compressAndGetFile(
          imageTemporary.path,
          targetPath ?? "",
          quality: 90,
          format: CompressFormat.jpeg,
        );
        if (compressFile?.path.isNotEmpty ?? true) {
          image = compressFile?.path ?? "";
          _userInfoModel.profileImage = compressFile?.path ?? "";
          _isSelectedProfile = true;
          // setState(() {});
        }
      }

      // setState(() {});
      _valueNotifier.notifyListeners();
    } catch (e, st) {
      debugPrint('picking image error $e $st');
    }
  }

  Future<void> _formSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;

      if (_isSelectedProfile == null) _isSelectedProfile = false;
      // setState(() {});
      _valueNotifier.notifyListeners();
      return;
    }
    if (_isSelectedProfile == false || _isSelectedProfile == null) {
      _isSelectedProfile = false;
      _valueNotifier.notifyListeners();
      return;
    }

    if (!_isChecked) {
      Get.showSnackbar(const GetSnackBar(
        message: "Please check Terms & Conditions",
        duration: Duration(seconds: 2),
        animationDuration: Duration(seconds: 3),
      ));
      return;
    }

    try {
      _loadingIndicatorNotifier.show();
      final notificationPermission = await checkNotificationPermission();
      if (!notificationPermission) {
        await showAlert(
            context: getContext,
            message:
                'Please allow notification permissions from application settings',
            onRightAction: () {
              openAppSettings();
            },
            singleBtnTitle: 'Open App Settings');
        return;
      }
      controller.setRegisterApiInprogress();
      final LocationModel? locationModel =
          await getLocationInfoAtSignUp(authType: AuthType.SignUp);
      if (locationModel != null) {
        _userInfoModel.locationModel = jsonEncode(locationModel.toSignUpJson());
        // final String address = '${locationModel.name},${locationModel.street},${locationModel.country}';
        // debugPrint('user location ${locationModel.placeId}');
        //
        // _userInfoModel.locationModel = json.encode(locationModel);
        // _userInfoModel.address = address;
        // _userInfoModel.longitude = locationModel.longitude;
        // _userInfoModel.latitude = locationModel.latitude;

        _formKey.currentState?.save();
        debugPrint('user phone ${_userInfoModel.phone}');
        _userInfoModel.timeZone = ApiMiddleware.currentTimeZone;
        await Get.find<AuthController>().authenticateServerSideUser(
          context: getContext,
          userInfo: _userInfoModel,
        );
      } else {
        showAlert(
            context: getContext,
            message:
                'Unable to get the location. Please turn on and allow location services');
      }
      // await SocialLoginService.registerUsingEmailPassword(
      //     userInfoModel: _userInfoModel);

      // Get.back();

      // Get.showSnackbar(const GetSnackBar(
      //   // title: "Your account is created successfully",
      //   message: "Your account is created successfully",
      //   duration: Duration(seconds: 2),
      //   animationDuration: Duration(seconds: 3),
      // ));
    } catch (e) {
      showAlert(context: getContext, message: e);
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }
}
