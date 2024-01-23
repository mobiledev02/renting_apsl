// To parse this JSON data, do
//
//     final endRequestModel = endRequestModelFromJson(jsonString);

import 'dart:convert';

List<EndRequestModel> endRequestModelFromJson(String str) =>
    List<EndRequestModel>.from(
        json.decode(str).map((x) => EndRequestModel.fromJson(x)));

String endRequestModelToJson(List<EndRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EndRequestModel {
  EndRequestModel({
    this.title = "",
    this.image,
    this.location = "",
    this.date = "",
    this.termAndCondition = "",
  });

  List<dynamic>? image = ["", ""];
  String title;
  String location;
  String date;
  String termAndCondition;

  factory EndRequestModel.fromJson(Map<dynamic, dynamic> json) =>
      EndRequestModel(
        title: json["title"] ?? "",
        image: json["image"] == null
            ? ["", ""]
            : List<dynamic>.from(json["image"].map((x) => x)),
        location: json["location"] ?? "",
        date: json["date"] ?? "",
        termAndCondition: json["termAndCondition"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": List<dynamic>.from(image?.map((x) => x) ?? []),
        "location": location,
        "date": date,
        "termAndCondition": termAndCondition,
      };
}
