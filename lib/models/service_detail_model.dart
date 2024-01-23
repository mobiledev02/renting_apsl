// To parse this JSON data, do
//
//     final serviceDetailModel = serviceDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:renting_app_mobile/models/user_model.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import 'package:renting_app_mobile/widgets/generic_enum.dart';

import '../constants/img_font_color_string.dart';
import 'categories_model.dart';
import 'image_model.dart';
import 'total_payment_detail_model.dart';

ServiceDetailModel serviceDetailModelToJson(String str) =>
    ServiceDetailModel.fromJson(json.decode(str)['data']);

String itemDetailModelToJson(ServiceDetailModel data) =>
    json.encode(data.toJson());
DateFormat dateFormatter = DateFormat("MMMM dd, yyyy");

List<ServiceDetailModel> listOfItemDetailModelFromJson(
    List<Map<String, dynamic>> str) =>
    List<ServiceDetailModel>.from(str.map((x) => ServiceDetailModel.fromJson(x)));

String listOfItemDetailModelToJson(List<ServiceDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceDetailModel {
  static const serviceStripeFeeFactor = 3;
  static const additionalStripeCharge = 0.30;

  ServiceDetailModel({
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
    this.ratePerHour = "",
    this.category,
    this.lenderInfoModel,
    this.rent,
    this.unreadMessages,
    this.lendItemServiceImages,
    this.startDate,
    this.endDate,
    this.ratePerDay = "",
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
  String ratePerHour;
  DateTime? startDate, endDate;
  DateTime? startTime, endTime;
  String serviceStartTime, serviceEndTime;
  CategoryModel? category;
  Rent? rent;
  UserInfoModel? lenderInfoModel;
  List<ImageModel>? lendItemServiceImages;
  List<int> deleteImagesIdList;
  String ratePerDay;

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

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json1) =>
      ServiceDetailModel(
        id: json1["id"] == null ? null : int.parse(json1["id"].toString()),
        name: json1["name"] ?? "",
        description: json1["description"] ?? "",
        price: json1["price"] ?? "",
        status: json1["status"] ?? "",
        address: json1["address"] ?? "",
        city: json1["city"] ?? "",
        state: json1["state"] ?? "",
        unreadMessages: json1['unread_message_count'] ?? 0,
        //returnPref: json1['return_pref'],
        // exchangePref: json1['exchange_pref'],
        country: json1["country"] ?? "",
        pincode: json1["pincode"] ?? "",
        latitude: json1["latitude"] ?? "",
        longitude: json1["longitude"] ?? "",
        lenderInfoModel: json1["lender"] == null
            ? null
            : UserInfoModel.fromJson(json1['lender']),
        ratePerDay: json1["rate_per_day"] ?? "0.0",
        ratePerHour: json1["rate_per_hour"] ?? "0.0",
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

  factory ServiceDetailModel.fromFirebaseJson(Map<String, dynamic> json1) =>
      ServiceDetailModel(
        id: json1["id"] == null ? null : int.parse(json1["id"].toString()),
        name: json1["name"] ?? "",
        description: json1["description"] ?? "",
        price: json1["price"] ?? "",
        status: json1["status"] ?? "",
        address: json1["address"] ?? "",
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
        ratePerDay: json1["rate_per_day"] ?? "0.0",
        ratePerHour: json1["rate_per_hour"] ?? "0.0",
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
      //  "exchange_pref": exchangePref,
      // "return_pref": returnPref,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude,
      "start_date": startDate,
      "end_date": endDate,
      "lender": lenderInfoModel?.tolenderInfoJson(),
      "rate_per_day": ratePerDay,
      "rate_per_hour": ratePerHour,
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
      "rate_per_day": ratePerDay,
      "rate_per_hour": ratePerHour,
      "category": category?.toJson(),
      "rent": rent?.toJson(),
      "lend_item_service_images": listOfImageModelToJson(
        lendItemServiceImages ?? [],
      ),
    };
  }

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
    this.safetyDeposite = "",
  });

  String rentedBy;
  String msg;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String rentPerDay;
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
  };
}
