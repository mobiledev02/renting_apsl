import 'dart:convert';

import 'package:intl/intl.dart';

import '../utils/custom_enum.dart';
import '../widgets/generic_enum.dart';
import 'image_model.dart';

DateFormat dateFormatter = DateFormat("d MMMM, yyyy");

class RentedItemServiceDetailModel {
  int id;
  int rentId;
  int lenderId;
  String paymentStatus;
  String name;
  ItemOrService type;
  String category;
  String description;
  DateTime? startDate;
  DateTime? endDate;
  String totalPayment;
  String lenderName;
  String lenderAmount;
  //String lenderEmail;
  String finalCharge;
  DateTime date;
  bool isReviewGiven;
  String safetyDeposit;
  List<ImageModel>? images;

  RentedItemServiceDetailModel({
    required this.name,
    required this.type,
    required this.category,
    required this.startDate,
    required this.id,
    required this.rentId,
    required this.lenderId,
    required this.endDate,
    required this.totalPayment,
    required this.paymentStatus,
    //required this.lenderEmail,
    required this.lenderName,
    required this.isReviewGiven,
    required this.description,
    this.lenderAmount = "",
    this.safetyDeposit = "",
    this.finalCharge = "",
    required this.date,
    this.images,
  });

  factory RentedItemServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return RentedItemServiceDetailModel(
      id: json['lend_item_service']['id'] ?? 0,
      rentId: json['id'],
      lenderId: json['user']['id'],
      name: json['lend_item_service']['name'] ?? "",
      //lenderEmail: json['user']['email'] ?? "",
      description: json['lend_item_service']['description'] ?? "",
      startDate: DateTime.tryParse(json['start_date'] ?? ""),
      endDate: DateTime.tryParse(json['end_date'] ?? ""),
      category: json['lend_item_service']['category']['name'] ?? "",
      lenderName: json['user']['name'] ?? "",
      isReviewGiven: json['is_review_given'],
      paymentStatus: json['payment_status'].toString(),
      totalPayment: json['total_payment'].toString(),
      lenderAmount: json['lender_amount'].toString(),
      finalCharge: json['final_charge'].toString(),
      date: DateTime.parse(json['updated_at'] ?? ""),
      type: GenericEnum<ItemOrService>().getEnumValue(
        key: json["type"], // ItemOrService,
        enumValues: ItemOrService.values,
        defaultEnumValue: ItemOrService.service,
      ),
      safetyDeposit: json['safety_deposit'].toString(),
      images: json['lend_item_service']['lend_item_service_photos'] == null
          ? []
          : listOfImageModelFromJson(
              jsonEncode(
                json['lend_item_service']['lend_item_service_photos'],
              ),
            ),
    );
  }


  factory RentedItemServiceDetailModel.fromJsonService(Map<String, dynamic> json) {
    return RentedItemServiceDetailModel(
      id: json['lend_item_service_id'] ?? 0,
      rentId: json['id'],
      lenderId: json['user']['id'],
      name: json['lend_item_service']['name'] ?? "",
      //lenderEmail: json['user']['email'] ?? "",
      description: json['lend_item_service']['description'] ?? "",
      lenderAmount: json['lender_amount'],
      startDate: DateTime.tryParse(json['start_date'] ?? ""),
      endDate: DateTime.tryParse(json['end_date'] ?? ""),
      category: json['lend_item_service']['category']['name'] ?? "",
      lenderName: json['user']['name'] ?? "",
      isReviewGiven: json['is_review_given'],
      paymentStatus: json['payment_status'],
      totalPayment: json['total_payment'],
      finalCharge: json['final_charge'].toString(),
      date: DateTime.parse(json['updated_at'] ?? ""),
      type: GenericEnum<ItemOrService>().getEnumValue(
        key: json["type"], // ItemOrService,
        enumValues: ItemOrService.values,
        defaultEnumValue: ItemOrService.service,
      ),
      safetyDeposit: json['safety_deposit'],
      images: json['lend_item_service']['lend_item_service_photos'] == null
          ? []
          : listOfImageModelFromJson(
        jsonEncode(
          json['lend_item_service']['lend_item_service_photos'],
        ),
      ),
    );
  }


  ImageModel? get getFirstImageModel =>
      (images?.isNotEmpty ?? false) ? images![0] : null;

  ImageModel? get getSecondImageModel =>
      ((images?.length ?? 0) >= 2) ? images![1] : null;

  String get getStartDate => dateFormatter.format(startDate ?? DateTime.now());

  String get getEndDate => dateFormatter.format(endDate ?? DateTime.now());
}
