// To parse this JSON data, do
//
//     final itemDetailModel = itemDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';
import 'package:renting_app_mobile/models/image_model.dart';
import 'package:renting_app_mobile/models/user_model.dart';

import '../utils/custom_enum.dart';
import '../widgets/generic_enum.dart';
import '../utils/custom_extension.dart';
import 'categories_model.dart';

ItemDetailModel itemDetailModelFromJson(String str) =>
    ItemDetailModel.fromJson(json.decode(str)['data']);

String itemDetailModelToJson(ItemDetailModel data) =>
    json.encode(data.toJson());
DateFormat dateFormatter = DateFormat("MMMM dd, yyyy");

List<ItemDetailModel> listOfItemDetailModelFromJson(
        List<Map<String, dynamic>> str) =>
    List<ItemDetailModel>.from(str.map((x) => ItemDetailModel.fromJson(x)));

String listOfItemDetailModelToJson(List<ItemDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemDetailModel {
  static const serviceStripeFeeFactor = 2.9;
  static const additionalStripeCharge = 0.30;

  /// 30 cents

  ItemDetailModel({
    this.id,
    this.name = "",
    this.description = "",
    this.price = "",
    this.status = "",
    this.address = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.pincode = "",
    this.latitude = "",
    this.longitude = "",
    this.maxDuration,
    this.ratePerDay = "",
    this.ratePerHour = "",
    this.safetyDeposit = "",
    this.moreInfo = "",
    this.startTime,
    this.endTime,
    this.optInInsurance = false,
    this.category,
    this.lenderInfoModel,
    this.rent,
    this.unreadMessages,
    this.lendItemServiceImages,
    this.startDate,
    this.endDate,
    this.serviceStartTime = "",
    this.serviceEndTime = "",
    this.deleteImagesIdList = const [],
  });

  int? id;
  int? unreadMessages;
  String name;
  String description;
  String price;
  String status;
  String address;
  String city;
  String state;
  String country;
  String pincode;
  String latitude;
  String longitude;
  String? timezone;
  double? timezoneOffset;

//  String? exchangePref;
//  String? returnPref;

  String moreInfo;
  int? maxDuration;
  String ratePerDay;
  String ratePerHour;
  String safetyDeposit;
  DateTime? startDate, endDate;
  DateTime? startTime, endTime;
  String serviceStartTime, serviceEndTime;
  bool optInInsurance;
  CategoryModel? category;
  Rent? rent;
  UserInfoModel? lenderInfoModel;
  List<ImageModel>? lendItemServiceImages;
  List<int> deleteImagesIdList;

  ItemAndServiceStatus get getEnum =>
      GenericEnum<ItemAndServiceStatus>().getEnumValue(
        key: (rent?.msg.isEmpty ?? true) ? "Available" : "Rented", // status,
        enumValues: ItemAndServiceStatus.values,
        defaultEnumValue: ItemAndServiceStatus.Available,
      );

  ServiceType get getEnumForDayAndHourly =>
      GenericEnum<ServiceType>().getEnumValue(
        key: (rent?.msg.isEmpty ?? true)
            ? ratePerDay == "0.0"
                ? "Hourly"
                : "Day"
            : "Rented", //serviceType,
        enumValues: ServiceType.values,
        defaultEnumValue: ServiceType.Day,
      );

  String get getStartDate => dateFormatter.format(startDate ?? DateTime.now());

  String get getEndtDate => dateFormatter.format(endDate ?? DateTime.now());

  ImageModel? get getFirstImageModel =>
      (lendItemServiceImages?.isNotEmpty ?? false)
          ? lendItemServiceImages![0]
          : null;

  ImageModel? get getSecondImageModel =>
      ((lendItemServiceImages?.length ?? 0) >= 2)
          ? lendItemServiceImages![1]
          : null;

  factory ItemDetailModel.fromJson(Map<String, dynamic> json1) =>
      ItemDetailModel(
        id: json1["id"] == null ? null : int.parse(json1["id"].toString()),
        name: json1["name"] ?? "",
        description: json1["description"] ?? "",
        price: json1["price"] ?? "",
        endTime: DateTime.tryParse(json1["end_time"] ?? ""),
        startTime: DateTime.tryParse(json1["start_time"] ?? ""),
        status: json1["status"] ?? "",
        address: json1["address"] ?? "",
        city: json1["city"] ?? "",
        state: json1["state"] ?? "",
        unreadMessages: json1['unread_message_count'] ?? 0,
        //returnPref: json1['return_pref'],
        // exchangePref: json1['exchange_pref'],
        country: json1["country"] ?? "",
        pincode: json1["pincode"] ?? "",
        latitude: json1["latitude"] != null ? json1["latitude"].toString() : "",
        longitude:
            json1["longitude"] != null ? json1["longitude"].toString() : "",
        lenderInfoModel: json1["lender"] == null
            ? null
            : UserInfoModel.fromJson(json1['lender']),
        moreInfo: json1["more_info"] ?? "",
        maxDuration: json1["max_duration"] == null
            ? 0
            : int.parse(json1["max_duration"].toString()),
        ratePerDay: json1["rate_per_day"] ?? "0.0",
        ratePerHour: json1["rate_per_hour"] ?? "0.0",
        safetyDeposit: json1["safety_deposit"] ?? "",
        optInInsurance: json1["opt_in_insurance"] ?? false,
        category: json1["category"] == null
            ? null
            : CategoryModel.fromJson(json1["category"]),
        rent: json1["rent"] == null ? Rent() : Rent.fromJson(json1["rent"]),
        lendItemServiceImages: json1["lend_item_service_images"] == null
            ? null
            : json1["lend_item_service_images"].runtimeType == String
                ? listOfImageModelFromJson(
                    json1["lend_item_service_images"],
                  )
                : listOfImageModelFromJson(
                    json.encode(
                      json1["lend_item_service_images"],
                    ),
                  ),
      );

  factory ItemDetailModel.fromFirebaseJson(Map<String, dynamic> json1) =>
      ItemDetailModel(
        id: json1["id"] == null ? null : int.parse(json1["id"].toString()),
        name: json1["name"] ?? "",
        description: json1["description"] ?? "",
        price: json1["price"] ?? "",
        status: json1["status"] ?? "",
        address: json1["address"] ?? "",
        endTime: json1['end_time'] != null ? json1['end_time'].toDate() : null,
        startTime:
            json1['start_time'] != null ? json1['start_time'].toDate() : null,
        unreadMessages: json1['unread_message_count'] ?? 0,
        startDate: json1["start_date_f"].toDate(),
        endDate: json1["end_date_f"].toDate(),
        city: json1["city"] ?? "",
        state: json1["state"] ?? "",
        //  returnPref: json1['return_pref'],
        // exchangePref: json1['exchange_pref'],
        country: json1["country"] ?? "",
        pincode: json1["pincode"] ?? "",
        latitude: json1["latitude"] ?? "",
        longitude: json1["longitude"] ?? "",
        lenderInfoModel: json1["lender"] == null
            ? null
            : UserInfoModel.fromJson(json1['lender']),
        moreInfo: json1["more_info"] ?? "",
        maxDuration: json1["max_duration"] == null
            ? 0
            : int.parse(json1["max_duration"].toString()),
        ratePerDay: json1["rate_per_day"] ?? "0.0",
        ratePerHour: json1["rate_per_hour"] ?? "0.0",
        safetyDeposit: json1["safety_deposit"] ?? "",
        optInInsurance: json1["opt_in_insurance"] ?? false,
        category: json1["category"] == null
            ? null
            : CategoryModel.fromJson(json1["category"]),
        rent: json1["rent"] == null ? Rent() : Rent.fromJson(json1["rent"]),
        lendItemServiceImages: json1["lend_item_service_images"] == null
            ? null
            : json1["lend_item_service_images"].runtimeType == String
                ? listOfImageModelFromJson(
                    json1["lend_item_service_images"],
                  )
                : listOfImageModelFromJson(
                    json.encode(
                      json1["lend_item_service_images"],
                    ),
                  ),
      );

  Map<String, dynamic> toJson() {
    debugPrint('start date is saved ${startDate}');
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "status": status,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude,
      "start_date": startDate,
      "end_date": endDate,
      "lender": lenderInfoModel?.tolenderInfoJson(),
      "more_info": moreInfo,
      "max_duration": maxDuration,
      "rate_per_day": ratePerDay,
      "rate_per_hour": ratePerHour,
      "safety_deposit": safetyDeposit,
      "opt_in_insurance": optInInsurance,
      "category": category?.toJson(),
      "rent": rent?.toJson(),
      "lend_item_service_images": listOfImageModelToJson(
        lendItemServiceImages ?? [],
      ),
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    debugPrint('start date is saved ${startDate}');
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "status": status,
      "address": address,
      "city": city,
      "start_date_f": startDate,
      "end_date_f": endDate,
      'end_time': endTime,
      'start_time': startTime,
      "state": state,
      "country": country,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude,
      "start_date": startDate?.toString(),
      "end_date": endDate?.toString(),
      "lender": lenderInfoModel?.tolenderInfoJson(),
      "more_info": moreInfo,
      "max_duration": maxDuration,
      "rate_per_day": ratePerDay,
      "rate_per_hour": ratePerHour,
      "safety_deposit": safetyDeposit,
      "opt_in_insurance": optInInsurance,
      "category": category?.toJson(),
      "rent": rent?.toJson(),
      "lend_item_service_images": listOfImageModelToJson(
        lendItemServiceImages ?? [],
      ),
    };
  }

  Map<String, dynamic> toCreateItemJson() => {
        "category_id": category?.id.toString() ?? "0",
        "name": name,
        "start_date_f": startDate ?? '',
        "end_date_f": endDate ?? '',
        'end_time': endTime ?? '',
        'start_time': startTime ?? '',
        "description": description,
        "price": price,
        "place_id": address,
        "exchange_pref": '',
        "return_pref": '',
        "city": city,
        "country": country,
        "state": state,
        "max_duration": maxDuration.toString(),
        "rate_per_day": ratePerDay,
        "safety_deposit": safetyDeposit,
        "opt_in_insurance": optInInsurance ? "1" : "0",
        "delete_images": deleteImagesIdList.join(","),
      };

  Map<String, dynamic> toCreateServiceJson() => {
        "name": name,
        "category_id": category?.id.toString() ?? "0",
        "place_id": address,
        "city": city,
        "country": country,
        "state": state,
        "description": description,
        "rate_per_day": ratePerDay,
        "rate_per_hour": ratePerHour,
        "more_info": moreInfo,
        "delete_images": deleteImagesIdList.join(","),
      };

  Map<String, dynamic> toFirebaseCreateLendJson() => {
        "name": name,
        "id": id.toString(),
        StaticString.unreadMessageCount: 0,
        "category": category?.toJson(),
        "time": DateTime.now().millisecondsSinceEpoch,
        "lend_item_service_images": listOfImageModelToJson(
          lendItemServiceImages ?? [],
        ),
      };

  String get getPrice =>
      price.priceFormater; //priceFormat.format(double?.tryParse(price) ?? 0.0);
  String get getTotalPayment => (rent?.totalPayment ?? "0.0")
      .priceFormater; // priceFormat.format(double?.tryParse(rent?.totalPayment ?? "0.0") ?? 0.0);
  String get getRatePerDay => ratePerDay
      .rateFormater; // rateFormat.format(double?.tryParse(ratePerDay) ?? 0.0);

  String get getRatePerDayWithDecimal2 =>
      ratePerDay.rateFormaterWithDecimal2.split(".").first.isEmpty
          ? "0${ratePerDay.rateFormaterWithDecimal2}"
          : ratePerDay.rateFormaterWithDecimal2;

  String get getRatePerHour => ratePerHour
      .rateFormater; // rateFormat.format(double?.tryParse(ratePerHour) ?? 0.0);
}

class Rent {
  Rent({
    this.rentedBy = "",
    this.msg = "",
    this.startDate = "",
    this.endDate = "",
    this.startTime = "",
    this.endTime = "",
    this.rentPerDay = "",
    this.rentPerHour = "",
    this.totalPayment = "",
    this.renterId,
    this.amountToReceive = "",
    this.safetyDeposite = "",
  });

  String rentedBy;
  String msg;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String rentPerDay;
  String amountToReceive;
  String rentPerHour;
  String totalPayment;
  int? renterId;
  String safetyDeposite;

  factory Rent.fromJson(Map<String, dynamic> json) => Rent(
        rentedBy: json["rented_by"] ?? "",
        msg: json["msg"] ?? "",
        renterId: json['renter_id'],
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
        rentPerDay: json["rent_per_day"] ?? "",
        rentPerHour: json["rent_per_hour"] ?? "",
        amountToReceive: json["lender_amount"] != null
            ? json['lender_amount'].toString()
            : "",
        totalPayment: json["total_payment"] ?? "",
        safetyDeposite: json["safety_deposit"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "rented_by": rentedBy,
        "msg": msg,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "renter_id": renterId,
        "rent_per_day": rentPerDay,
        "rent_per_hour": rentPerHour,
        "total_payment": totalPayment,
        "safety_deposit": safetyDeposite,
        "amount_to_receive": amountToReceive,
      };
}
