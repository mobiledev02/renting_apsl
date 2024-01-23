// To parse this JSON data, do
//
//     final rateModel = rateModelFromJson(jsonString);

import 'dart:convert';

RateModel rateModelFromJson(String str) =>
    RateModel.fromJson(json.decode(str)["data"]);

String rateModelToJson(RateModel data) => json.encode(data.toJson());

class RateModel {
  RateModel({
    this.itemDailyRate = "",
  });

  String itemDailyRate;

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        itemDailyRate: json["item_daily_rate"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "item_daily_rate": itemDailyRate,
      };
}
