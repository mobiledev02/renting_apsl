// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';

import '../widgets/generic_enum.dart';

List<RequestModel> listOfRequestModelFromJson(String str) =>
    List<RequestModel>.from(
      json.decode(str)['dataset'].map(
            (x) => RequestModel.fromJson(
              x,
            ),
          ),
    );

String listOfRequestModelToJson(List<RequestModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

RequestModel requestModelFromJson(String str) => RequestModel.fromJson(
      json.decode(
        str,
      ),
    );

String requestModelToJson(RequestModel data) => json.encode(
      data.toJson(),
    );
final DateFormat formatter = DateFormat(
  "y-MM-d",
);

class RequestModel {
  RequestModel({
    this.id,
    this.name = "",
    this.city = "",
    this.needBy = "",
    this.type = "Item",
    this.miles = 10,
  });

  int? id;
  String name;
  String city;
  String needBy;
  String type;
  int miles;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        name: json["name"] ?? "",
        city: json["city"] ?? "",
        needBy: json["need_by"] ?? "",
        type: json["type"] ?? "Item",
        miles: json["miles"] ?? 10,
      );

  Map<String, dynamic> toCreateRequestJson() => {
        "name": name,
        "place_id": city,
        "need_by": formatter.format(
          DateTime.parse(
            needBy,
          ),
        ),
        "type": type.toLowerCase(),
        "miles": miles,
      };

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "need_by": needBy,
        "type": type,
        "miles": miles,
      };

  ItemOrService get getRequestType => GenericEnum<ItemOrService>().getEnumValue(
        key: type,
        enumValues: ItemOrService.values,
        defaultEnumValue: ItemOrService.item,
      );
}
