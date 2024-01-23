import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import 'package:renting_app_mobile/widgets/custom_appbar.dart';
import 'package:renting_app_mobile/widgets/keyboard_with_done_button.dart';

import '../../constants/img_font_color_string.dart';
import '../../controller/auth_controller.dart';
import '../../main.dart';
import '../../utils/date_time_util.dart';
import '../../utils/text_formatters.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_text.dart';
import '../payment/pay_with_screen.dart';

class VerifyIDBackgroundCheckFormScreen extends StatefulWidget {
  const VerifyIDBackgroundCheckFormScreen({Key? key}) : super(key: key);

  @override
  State<VerifyIDBackgroundCheckFormScreen> createState() =>
      _VerifyIDBackgroundCheckFormScreenState();
}

class _VerifyIDBackgroundCheckFormScreenState
    extends State<VerifyIDBackgroundCheckFormScreen> {
  late AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // final TextEditingController _dobController = TextEditingController();
  //final TextEditingController _ssnController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  // final FocusNode _dobFocusNode = FocusNode();
  //final FocusNode _ssnFocusNode = FocusNode();
  final FocusNode _zipCodeFocusNode = FocusNode();

  final _paymentController = Get.find<PaymentController>();

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Verify Identity',
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: GetBuilder<AuthController>(
            builder: (controller) {
              return controller.getUserInfo.verificationSubmitted == 'Pending'
                  ? const Center(
                      child: CustomText(
                      txtTitle:
                          'An e-mail from Checkr has been sent to you. Please proceed with the sent email for further verification process. Your application will be reviewed upon further submission.',
                      align: TextAlign.center,
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: KeyboardWithDoneButton(
                        focusNodeList: [
                          _firstNameFocusNode,
                          _middleNameFocusNode,
                          _lastNameFocusNode,
                          // _dobFocusNode,
                          //  _ssnFocusNode,
                          _zipCodeFocusNode,
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
                            children: [
                              /// Information note
                              redBox(
                                context: context,
                                rentedText:
                                    'To become a trusted and credible lender, sign up to become verified. '
                                    'Lender\'s can either sign up for immediate verification status by completing a background check '
                                    'in which they will be charged \$31.25 or after completing 10 successful lending transactions with '
                                    '4.0 stars or greater.',
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              /// First Name
                              textFieldWithTitle(
                                title: 'First Name',
                                child: _buildFirstNameTextFormField(),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              /// Middle Name
                              textFieldWithTitle(
                                title: 'Middle Name',
                                child: _buildMiddleNameTextFormField(),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              /// Last Name
                              textFieldWithTitle(
                                title: 'Last Name',
                                child: _buildLastNameTextFormField(),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              /// DOB
                              //    textFieldWithTitle(
                              //    title: 'Date of Birth',
                              //  child: _buildDobTextFormField(),
                              //),

                              //     const SizedBox(
                              //    height: 20,
                              //  ),

                              /// SSN
                              //   textFieldWithTitle(
                              //   title: 'Social Security Number',
                              // child: _buildSsnTextFormField(),
                              //),

                              //   const SizedBox(
                              //    height: 20,
                              //  ),

                              /// Zip Code
                              textFieldWithTitle(
                                title: 'Zip Code',
                                child: _buildZipCodeTextFormField(),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              _buildPaymentWith(context),

                              const SizedBox(
                                height: 20,
                              ),

                              _buildSubmitButton(),

                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameTextFormField() {
    return TextFormField(
      focusNode: _firstNameFocusNode,
      // readOnly: ,
      // enabled: itemDetailModel.id == null,
      onFieldSubmitted: (_) {},
      validator: (val) => val!.validateItemName,
      //onSaved: (name) => _firstNameController.name = name ?? "",
      controller: _firstNameController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: 'First Name',
          labelStyle: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildMiddleNameTextFormField() {
    return TextFormField(
      focusNode: _middleNameFocusNode,
      // readOnly: ,
      // enabled: itemDetailModel.id == null,
      onFieldSubmitted: (_) {},
      //validator: (val) => val!.validateItemName,
      //onSaved: (name) => _firstNameController.name = name ?? "",
      controller: _middleNameController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: 'Middle Name',
          labelStyle: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildLastNameTextFormField() {
    return TextFormField(
      focusNode: _lastNameFocusNode,
      // readOnly: ,
      // enabled: itemDetailModel.id == null,
      onFieldSubmitted: (_) {},
      validator: (val) => val!.validateLastName,
      //onSaved: (name) => _firstNameController.name = name ?? "",
      controller: _lastNameController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: 'Last Name',
          labelStyle: TextStyle(color: Colors.red)),
    );
  }

  // Widget _buildDobTextFormField() {
  //   return TextFormField(
  //     focusNode: _dobFocusNode,
  //     readOnly: true,
  //     onTap: () async {
  //       final dob = await showDatePicker(
  //           context: context,
  //           initialDate: DateTime(2000),
  //           firstDate: DateTime(1880, 1),
  //           lastDate: DateTime.now());
  //       if (dob != null) {
  //         _dobController.text = formatDateYMD(dob);
  //       }
  //     },
  //     // enabled: itemDetailModel.id == null,
  //     onFieldSubmitted: (_) {},
  //     validator: (val) => val!.validateDob,
  //     //onSaved: (name) => _firstNameController.name = name ?? "",
  //     controller: _dobController,
  //     decoration: const InputDecoration(
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: 15,
  //         ),
  //         hintText: 'Date of Birth',
  //         labelStyle: TextStyle(color: Colors.red)),
  //   );
  // }

  // Widget _buildSsnTextFormField() {
  //   return TextFormField(
  //     focusNode: _ssnFocusNode,
  //     // readOnly: ,
  //     // enabled: itemDetailModel.id == null,
  //     onFieldSubmitted: (_) {},
  //     inputFormatters: [SSNTextInputFormatter()],
  //     validator: (val) => val!.validateSsn,
  //     //onSaved: (name) => _firstNameController.name = name ?? "",
  //     controller: _ssnController,
  //     decoration: const InputDecoration(
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: 15,
  //         ),
  //         hintText: '123-45-6789',
  //         labelStyle: TextStyle(color: Colors.red)),
  //   );
  // }

  Widget _buildZipCodeTextFormField() {
    return TextFormField(
      focusNode: _zipCodeFocusNode,
      // readOnly: ,
      // enabled: itemDetailModel.id == null,
      onFieldSubmitted: (_) {},
      validator: (val) => val!.validateZipCode,
      //onSaved: (name) => _firstNameController.name = name ?? "",
      controller: _zipCodeController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: 'Zip Code',
          labelStyle: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildSubmitButton() {
    //  return Obx(() {
    return Center(
      child: GetBuilder<AuthController>(
        builder: (controller) {
          return CustomButton(
            loadingIndicator: controller.submittingVerification.value,
            buttonTitle: "Submit",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                debugPrint(
                    'working verify id ${_paymentController.selectedCard.value}');
                if (_paymentController.selectedCard.value != null) {
                  _authController.submitVerification(
                      context: context,
                      custCard: _paymentController.selectedCard.value!,
                      //   dob: _dobController.text,
                      // ssn: _ssnController.text,
                      lastName: _lastNameController.text);
                } else {
                  showAlert(
                      context: context,
                      message: 'Please select a card for payment');
                }
              }
            },
          );
        },
      ),
    );
    //  });
  }

  Widget _buildPaymentWith(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              txtTitle: StaticString.payWith,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        const SizedBox(
          height: 10.00,
        ),
        InkWell(
          onTap: () {
            Get.to(PayWithScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _paymentController.getCardsLoading.value
                  ? CircularProgressIndicator()
                  : _buildSelectedCard(context),
              InkWell(
                onTap: _selectCard,
                child: CustImage(
                  imgURL: ImgName.rightArrow,
                  imgColor: Colors.black,
                  height: 8.00,
                  width: 3.2,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _selectCard() {
    debugPrint(
        "**************************************** Select Card ***************************");
    Get.toNamed("SelectCardScreen");
    // Get.to(SelectCardScreen());
  }

  Widget _buildSelectedCard(context) {
    return GetBuilder<PaymentController>(
      builder: (_pc) {
        debugPrint('value of selected car ${_pc.selectedCard}');
        if (_pc.selectedCard.value != null) {
          return Row(
            children: [
              CustImage(
                imgURL: ImgName.visa,
                height: 20,
                width: 40,
              ),
              const SizedBox(
                width: 6.00,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    txtTitle: _pc.selectedCard.value!.brand,
                    style: Theme.of(context).textTheme.overline,
                  ),
                  CustomText(
                    txtTitle:
                        "**** **** ${_paymentController.selectedCard.value!.last4}",
                    style: Theme.of(context).textTheme.overline?.copyWith(
                        color: custBlack102339WithOpacity, height: 2),
                  ),
                ],
              ),
            ],
          );
        } else {
          return CustomText(
              txtTitle: 'Select a card',
              style: Theme.of(context).textTheme.caption?.copyWith(
                  color: custBlack102339WithOpacity,
                  fontWeight: FontWeight.w500,
                  height: 2.0));
        }
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    //  _dobController.dispose();
    //  _ssnController.dispose();
    _zipCodeController.dispose();
    _firstNameFocusNode.dispose();
    _middleNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    //  _dobFocusNode.dispose();
    //  _ssnFocusNode.dispose();
    _zipCodeFocusNode.dispose();
    super.dispose();
  }
}
