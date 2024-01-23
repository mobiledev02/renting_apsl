import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/main.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';
import 'package:renting_app_mobile/models/rented_item_service_detail_model.dart';
import 'package:renting_app_mobile/models/review_model.dart';
import '../../constants/img_font_color_string.dart';
import '../../models/item_detail_model.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/keyboard_with_done_button.dart';
import '../../widgets/loading_indicator.dart';

class WriteAReviewScreen extends GetView<ItemController> {
  final RentedItemServiceDetailModel? rentedItemService;
  final ItemDetailModel? service;
  final JobOfferModel? offer;

  WriteAReviewScreen(
      {Key? key, this.offer, this.rentedItemService, this.service})
      : super(key: key);

  final ValueNotifier _valueNotifier = ValueNotifier(true);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autoValidateMode = AutovalidateMode.always;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  final ReviewModel _reviewModel = ReviewModel(
      rating: 3.0,
      text: '',
      lenderId: 0,
      rentId: 0,
      renterId: 0,
      itemServiceId: 0);

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _reviewFocusNode = FocusNode();

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(title: "Write Review"),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: KeyboardWithDoneButton(
              focusNodeList: [
                _nameFocusNode,
                _emailFocusNode,
                _reviewFocusNode,
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
                      autovalidateMode: _autoValidateMode,
                      key: _formKey,
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
                            const SizedBox(
                              height: 20,
                            ),
                            _buildNameFeild(),
                            const SizedBox(
                              height: 16,
                            ),
                            _buildEmailFeild(),
                            const SizedBox(
                              height: 46,
                            ),
                            Text(
                                'Rate ${service != null ? service!.lenderInfoModel?.name : rentedItemService?.lenderName.firstName}'),
                            _buildRatingBar(),
                            const SizedBox(
                              height: 16,
                            ),
                            _buildreviewTextFormField(),
                            const SizedBox(
                              height: 46,
                            ),
                            _buildSubmitButton(context),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ));
  }

  /// Name text form feild
  Widget _buildNameFeild() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onSaved: (name) {
        _reviewModel.name = name;
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
        _reviewModel.email = email;
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

  /// Review text form field
  Widget _buildreviewTextFormField() {
    return Stack(
      children: [
        TextFormField(
          maxLines: 10,
          textInputAction: TextInputAction.next,
          onSaved: (review) {
            _reviewModel.text = review ?? "";
          },
          onChanged: (review) {
            _reviewModel.text = review;
          },
          validator: (val) => val?.validateReview,
          controller: _reviewController,
          focusNode: _reviewFocusNode,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, right: 45, top: 30),
            hintText: 'Write your review here',
          ),
        ),
      ],
    );
  }

  /// Rating bar
  Widget _buildRatingBar() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      allowHalfRating: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _reviewModel.rating = rating;
      },
    );
  }

  /// Submit button
  Widget _buildSubmitButton(BuildContext context) {
    return Obx(
      () => Center(
        child: CustomButton(
          loadingIndicator: controller.submitReviewLoading.value,
          buttonTitle: 'Submit',
          onPressed: () {
            _submitReview(context);
          },
          //  loadingIndicator: controller.registerApiInProgress.value,
        ),
      ),
    );
  }

  /// submit review
  Future<void> _submitReview(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (offer != null &&
            service != null &&
            service?.lenderInfoModel != null) {
          _reviewModel.lenderId = int.parse(service!.lenderInfoModel!.id);
          _reviewModel.rentId = 0;
          controller.submitReviewService(
              context, _reviewModel, offer!.id.toString());
        } else if (rentedItemService != null) {
          _reviewModel.lenderId = rentedItemService!.lenderId;
          _reviewModel.rentId = rentedItemService!.rentId;
          controller.submitReview(context, _reviewModel);
        }
      } catch (e, st) {
        debugPrint('submit review error $e $st');
        showAlert(
          context: getContext,
          message: e,
        );
      } finally {}
    }
  }
}
