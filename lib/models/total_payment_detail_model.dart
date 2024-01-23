// To parse this JSON data, do
//
//     final totalPaymentDetailModel = totalPaymentDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';

List<TotalPaymentDetailModel> listOfTotalPaymentDetailModelFromJson(
        String str) =>
    List<TotalPaymentDetailModel>.from(
        json.decode(str).map((x) => TotalPaymentDetailModel.fromJson(x)));

String listOfTotalPaymentDetailModelToJson(
        List<TotalPaymentDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

TotalPaymentDetailModel totalPaymentDetailModelFromJson(String str) =>
    TotalPaymentDetailModel.fromJson(json.decode(str));

String totalPaymentDetailModelToJson(TotalPaymentDetailModel data) =>
    json.encode(data.toJson());

class TotalPaymentDetailModel {
  TotalPaymentDetailModel({
    this.title = "",
    this.price = "0.0",
    this.subtitle = "",
    this.color,
    this.isChild = false,
  });

  String title;
  String price;
  Color? color;
  String subtitle;
  bool isChild;

  factory TotalPaymentDetailModel.fromJson(Map<String, dynamic> json) =>
      TotalPaymentDetailModel(
        title: json["title"] ?? "",
        price: json["price"] ?? "0.0",
        subtitle: json["subtitle"] ?? "",
        isChild: json['isChild'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "subtitle": subtitle,
        "isChild": isChild
      };
}

List<TotalPaymentDetailModel> totalPaymentDetailList = [
  TotalPaymentDetailModel(
    title: "Rent for Day",
    price: "5000",
    subtitle: StaticString.perDayPrice,
  ),
  TotalPaymentDetailModel(
    title: "Safety Deposit",
    price: "5000",
    isChild: true,
  ),
];
