// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:uuid/uuid.dart';

import '../../constants/img_font_color_string.dart';
import '../../controller/auth_controller.dart';
import '../../controller/request_controller.dart';
import '../../main.dart';
import '../../models/menu_model.dart';
import '../../models/place_service.dart';
import '../../models/request_model.dart';
import '../../widgets/address_search.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_calendar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/keyboard_with_done_button.dart';

class RequestItemScreen extends StatefulWidget {
  @override
  State<RequestItemScreen> createState() => _RequestItemScreenState();
}

class _RequestItemScreenState extends State<RequestItemScreen> {
  //!-----------------------variable----------------------
  RequestController requestController = Get.find<RequestController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isChecked = false;

  final TextEditingController _yourItemController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  final FocusNode _yourItemFocusNode = FocusNode();

  final FocusNode _locationFocusNode = FocusNode();

  Suggestion? result;

  ValueNotifier _initialNotifier = ValueNotifier(true);

  ValueNotifier _onDateSelectionNotifier = ValueNotifier(true);

  ValueNotifier _oncheckTermNotifier = ValueNotifier(true);

  RequestModel requestModel = RequestModel();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // CalendarFormat _calendarFormat = CalendarFormat.month;
  double _value = 10;

  String selectedFilter = "Item";

  ValueNotifier _filterNotifier = ValueNotifier(true);

  ValueNotifier _milesNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.requestAnItem,
      ),
      body: ValueListenableBuilder(
          valueListenable: _initialNotifier,
          builder: (context, val, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: KeyboardWithDoneButton(
                focusNodeList: [_yourItemFocusNode, _locationFocusNode],
                onDoneClicked: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 28,
                      ),
                      // I`m looking Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            txtTitle:
                                StaticString.imLookingFor, // I'm Looking for...
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: _filterNotifier,
                            builder: (context, val, child) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton2<MenuItemModel>(
                                  customButton: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: custBlack102339.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomText(
                                          txtTitle: requestModel.type,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                color: custBlack102339,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        CustImage(
                                          imgURL: ImgName.dropdownIcon,
                                          width: 10,
                                          height: 4,
                                        )
                                      ],
                                    ),
                                  ),
                                  // customItemsIndexes: const [3],
                                  //customItemsHeight: 8,
                                  items: [
                                    ...FilterItemsForReqestScreen.firstItems
                                        .map(
                                      (item) => DropdownMenuItem<MenuItemModel>(
                                        value: item,
                                        child: FilterItemsForReqestScreen
                                            .buildItem(
                                          item,
                                          selected: selectedFilter == item.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) async {
                                    selectedFilter = value?.text ?? "Item";

                                    requestModel.type = selectedFilter;

                                    _filterNotifier.notifyListeners();
                                    setState(() {});
                                  },
                                  itemHeight: 48,
                                  itemPadding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                  ),
                                  dropdownWidth: 180,
                                  dropdownPadding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  dropdownElevation: 8,
                                  offset: const Offset(0, 8),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      // Your Item Text form Feild
                      _buildYourItemTextAndTextFormField(),
                      const SizedBox(
                        height: 14,
                      ),
                      //  Your Location Text Form Feild
                      _buildLocationTextAndTextFormField(),
                      const SizedBox(
                        height: 22,
                      ),
                      const CustomText(
                        txtTitle: StaticString.selectMiles,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _milesNotifier,
                        builder: (context, val, child) {
                          return Center(
                            child: SfSliderTheme(
                              data: SfSliderThemeData(
                                thumbRadius: 8,
                              ),
                              child: SfSlider(
                                max: 100.0,
                                min: 10,
                                interval: 10,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 10,
                                value: double.parse(
                                  requestModel.miles.toString(),
                                ),
                                onChanged: (dynamic newValue) {
                                  requestModel.miles = int.parse(
                                      double.parse(newValue.toString())
                                          .toStringAsFixed(0));
                                  _milesNotifier.notifyListeners();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      // SfRangeSelector(
                      //   min: 0.0,
                      //   max: 100.0,
                      //   startThumbIcon: SizedBox(),
                      //   initialValues: SfRangeValues(0, 100),
                      //   labelPlacement: LabelPlacement.betweenTicks,
                      //   interval: 10.0,

                      //   onChanged: (val) {
                      //     print(val.end);
                      //   },
                      //   // showTicks: true,
                      //   // showLabels: true,

                      //   child: SizedBox(
                      //     height: 30,
                      //   ),
                      // ),

                      const SizedBox(
                        height: 24,
                      ),
                      const CustomText(
                        txtTitle: StaticString.needItby,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),

                      /// Calender
                      _buildCalender(),

                      /// Check box And Term And Condition Agree
                      // _buildCheckBoxAndTerms(),
                      const SizedBox(
                        height: 26,
                      ),
                      _buildPostButton(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  ///Your Item Text And Text Form Field
  Widget _buildYourItemTextAndTextFormField() {
    return Row(
      children: [
        CustomText(
          txtTitle: selectedFilter == 'Item'
              ? StaticString.yourItem
              : 'Your Service:', // Your Item
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 37,
            ),
            child: _buildyourItemTextFormField(),
          ),
        ),
      ],
    );
  }

  // Your Item name Text Form Field
  Widget _buildyourItemTextFormField() {
    return TextFormField(
      focusNode: _yourItemFocusNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => _locationFocusNode.requestFocus(),
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter name";
        } else {
          return null;
        }
      },
      onSaved: (name) {
        requestModel.name = name ?? "";
      },
      controller: _yourItemController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            top: 8,
            left: 15,
            right: 15,
          ),
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: CustomFont.metropolis,
            fontWeight: FontWeight.w600,
            color: custBlack102339.withOpacity(0.4),
          ),
          hintText: selectedFilter == 'Item'
              ? 'Enter item name'
              : 'Enter service name'
          //StaticString.hintItemName,
          ),
    );
  }

  /// Location Text And Text Form Feild
  Widget _buildLocationTextAndTextFormField() {
    return Row(
      children: [
        const CustomText(
          txtTitle: StaticString.location, // Location
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 87,
            ),
            child: _buildLocationTextFormField(),
          ),
        ),
      ],
    );
  }

  // Location name Text Form Field
  Widget _buildLocationTextFormField() {
    return TextFormField(
      focusNode: _locationFocusNode,
      textInputAction: TextInputAction.next,
      controller: _locationController,
      readOnly: true,
      onTap: () async {
        // final sessionToken = "32df207a-b3f9-4edb-9a1f-3a2731e1f40f";
        final sessionToken = Uuid().v4();
        result = await showSearch(
          context: getContext,
          delegate: AddressSearch(sessionToken),
        );

        // This will change the text displayed in the TextField
        if (result?.placeId.isNotEmpty ?? false) {
          final placeDetails = await PlaceApiProvider(sessionToken)
              .getPlaceDetailFromId(result?.placeId ?? "");
        }

        _locationController.text = result?.description ?? "";
      },
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter Location";
        } else {
          return null;
        }
      },
      onSaved: (location) {
        requestModel.city = result?.placeId ?? "";

        // requestModel.city = "ChIJR8lD7LK-woARCaoi0RcwIJs";
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 8,
          left: 15,
          right: 15,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontFamily: CustomFont.metropolis,
          fontWeight: FontWeight.w600,
          color: custBlack102339.withOpacity(0.4),
        ),
        hintText: StaticString.hintLocation,
      ),
    );
  }

  /// Calender
  Widget _buildCalender() {
    return ValueListenableBuilder(
      valueListenable: _onDateSelectionNotifier,
      builder: (context, val, child) {
        return CustomCalendarView(
          initialStartDate: DateTime.now(),
          minimumDate: DateTime.now(),
          startEndDateChange: (
            startDate,
          ) {
            requestModel.needBy = startDate.toIso8601String();
            _onDateSelectionNotifier.notifyListeners();
          },
        );
      },
    );
    // ValueListenableBuilder(
    //   valueListenable: _onDateSelectionNotifier,
    //   builder: (context, val, child) {
    //     return customCalender(
    //       context: context,
    //       firstDate: DateTime.now(),
    //       currentDate: DateTime.now(),
    //       setDateOnCallBack: (date) {
    //         requestModel.needBy = date.toIso8601String();
    //         _onDateSelectionNotifier.notifyListeners();
    //         // itemDetail.startDate = date;
    //         // itemDetail.endDate = null;
    //         // _expandChild = false;
    //         // _onTimeSelectionNotifier.notifyListeners();
    //       },
    //     );
    //   },
    // );
  }

  /// Term & condition Check box
  Widget _buildCheckBoxAndTerms() {
    return ValueListenableBuilder(
        valueListenable: _oncheckTermNotifier,
        builder: (context, val, child) {
          return InkWell(
            onTap: () {
              _isChecked = !_isChecked;
              _oncheckTermNotifier.notifyListeners();
            },
            child: Row(
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
                CustomText(
                  txtTitle: StaticString.tapToAgreeToOurTermsAndConditions,
                  // Tap to agree toour terms & condition
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: custBlack102339.withOpacity(0.5),
                  ),
                )
              ],
            ),
          );
        });
  }

  // Post Button
  Widget _buildPostButton() {
    return Obx(
      () => Center(
        child: CustomButton(
          loadingIndicator: requestController.loadingRequest.value,
          onPressed: _postButton,
          buttonTitle: StaticString.post,
          buttonWidth: 200,
        ),
      ),
    );
  }

  //!----------------------------- button Action----------------------
  void _postButton() async {
    if (Get.find<AuthController>().guest.value) {
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Sign in to post items',
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.always;

      _initialNotifier.notifyListeners();
      return;
    }
    // if (!_isChecked) {
    //   Get.showSnackbar(const GetSnackBar(
    //     message: "Must accept terms & conditions",
    //     duration: Duration(seconds: 2),
    //   ));
    //   return;
    // }
    if (requestModel.needBy.isEmpty) {
      requestModel.needBy = DateTime.now().toIso8601String();
    }
    _formKey.currentState?.save();
    // print(requestModel);
    try {
      await requestController.createReuest(
        requestModel: requestModel,
        context: getContext,
      );
    } catch (e) {
      showAlert(context: getContext, message: e);
    } finally {
      Get.back();
      Get.showSnackbar(
        const GetSnackBar(
          message: StaticString.requestCreatedSuccessfully,
          animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
