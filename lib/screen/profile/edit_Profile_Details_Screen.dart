// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '/widgets/custom_appbar.dart';
import '/controller/auth_controller.dart';
import '../../constants/img_font_color_string.dart';
import '../../main.dart';
import '../../models/place_service.dart';
import '../../models/user_model.dart';
import '../../utils/custom_enum.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/address_search.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/keyboard_with_done_button.dart';

class EditProfileDetailScreen extends GetView<AuthController> {
  EditProfileDetailScreen({Key? key}) : super(key: key) {
    _nameController.text = controller.getUserInfo.name;
    _emailController.text = controller.getUserInfo.email;
    _moreInfoController.text = controller.getUserInfo.info;
    _addressController.text = controller.getUserInfo.address;
  }

  //!------------------- variable------------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserInfoModel _userInfoModel = UserInfoModel(
    authType: AuthType.UpdateProfile,
  );
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  Suggestion? result;

  ///  Text Form Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // late final ProfileModel _profileImage;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _moreInfoFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  final ValueNotifier _initialApiNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.profile,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: KeyboardWithDoneButton(
            focusNodeList: [
              _nameFocusNode,
              _emailFocusNode,
              // _passwordFocusNode,
              // _confirmPasswordFocusNode,
              _moreInfoFocusNode,
              _addressFocusNode
            ],
            onDoneClicked: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                FocusScope.of(context).nextFocus();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ValueListenableBuilder(
                  valueListenable: _initialApiNotifier,
                  builder: (context, val, child) {
                    return Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 30,
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
                          // // password text form feild
                          // _buildPasswordFeild(),
                          // const SizedBox(
                          //   height: 16,
                          // ),

                          // // confirm password text form feild
                          // _buildConfirmPassTextFormField(),

                          // const SizedBox(
                          //   height: 16,
                          // ),

                          /// More Info About you text Form Field
                          _buildMoreInfoTextFormField(),

                          const SizedBox(height: 16),

                          /// Address text Form Field
                          _buildAddressTextFormField(),
                          const SizedBox(height: 40),

                          /// Submit Button
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 63,
                            ),
                            child: _buildSubmitButton(),
                          ),
                          const SizedBox(
                            height: 22,
                          ),

                          // /// Profile Image And Change Avatar Button
                          // _buildProfileImageAndChangeAvatarButton(),

                          // const SizedBox(
                          //   height: 22,
                          // ),
                          // //User Name Title And Text Form Feild
                          // _buildTextFormFieldWithTitle(
                          //   context: context,
                          //   title: StaticString.userName, // User's Name
                          //   child:
                          //       _buildUserNameTextFormField(), // User Name Text Form Field
                          // ),

                          // const SizedBox(
                          //   height: 14,
                          // ),
                          // //User email Title And Text Form Feild
                          // _buildTextFormFieldWithTitle(
                          //   context: context,
                          //   title: StaticString.userEmail, // User's Email
                          //   child:
                          //       _buildUserEmailTextFormField(), // User Email Text Form Field
                          // ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

//!-------------------------------------- Widget -------------------------------------------

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
          height: 16,
          width: 16,
          boxFit: BoxFit.contain,
        ),
        hintText: StaticString.name,
      ),
    );
  }

  // Email text form feild
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
          height: 18,
          width: 18,
          boxFit: BoxFit.contain,
        ),
        hintText: StaticString.emailID,
      ),
    );
  }

  // Password Text form feild
  Widget _buildPasswordFeild() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: true,
      onSaved: (psw) {
        _userInfoModel.password = psw ?? "";
      },
      validator: (val) => val?.validatePassword,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIconForTextField(img: ImgName.password),
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

  /// Address text Form Field
  Widget _buildAddressTextFormField() {
    return Stack(
      children: [
        TextFormField(
          maxLines: 4,
          textInputAction: TextInputAction.done,
          readOnly: true,
          onTap: () async {
            // final sessionToken = "32df207a-b3f9-4edb-9a1f-3a2731e1f40f";
            final sessionToken = Uuid().v4();
            result = await showSearch(
              context: getContext,
              delegate: AddressSearch(sessionToken),
            );
            // // This will change the text displayed in the TextField
            if (result != null) {
              final placeDetails = await PlaceApiProvider(sessionToken)
                  .getPlaceDetailFromId(result?.placeId ?? "");
            }
            

            _addressController.text = result?.description ?? "";
          },
          onSaved: (add) {
            _userInfoModel.placeId = result?.placeId ?? "";
          },
          validator: (val) => val?.validateAddress,
          controller: _addressController,
          focusNode: _addressFocusNode,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, right: 45, top: 30),
            hintText: StaticString.address,
          ),
        ),
        Positioned(
          right: 20,
          top: 15,
          child: CustImage(
            imgURL: ImgName.locationIcontextFormField,
          ),
        ),
      ],
    );
  }

  // Register button
  Widget _buildSubmitButton() {
    return Obx(() {
      return CustomButton(
        loadingIndicator: controller.updateMyProfile.value,
        buttonTitle: StaticString.submit,
        onPressed: _formSubmit,
      );
    });
  }

  //!-------------------------------- Button Action -----------------------

  Future<void> _formSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;
      // _isSelectedProfile = true;
      _initialApiNotifier.notifyListeners();

      return;
    }
    try {
      _formKey.currentState?.save();
      await controller.authenticateServerSideUser(
        context: getContext,
        userInfo: _userInfoModel,
      );
      // await SocialLoginService.registerUsingEmailPassword(
      //     userInfoModel: _userInfoModel);
      await controller.fetchMyProfile(context: getContext);
      Get.back();

      Get.showSnackbar(const GetSnackBar(
        // title: "Your account is created successfully",
        message: "Your account is Updated successfully",
        duration: Duration(seconds: 2),
        animationDuration: Duration(seconds: 3),
      ));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
