// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

import '../utils/custom_enum.dart';
import '../widgets/generic_enum.dart';

List<CategoryModel> listOfCategoryModelFromJson(String str) =>
    List<CategoryModel>.from(
      json.decode(str)['dataset'].map(
            (x) => CategoryModel.fromJson(x),
          ),
    );

String listOfCategoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.id,
    this.name = "",
    this.type = ItemOrService.service,
    this.status = "",
    this.imageUrl = "",
  });

  int id;
  String name;
  ItemOrService type;
  String status;
  String imageUrl;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"] ?? "",
        type: GenericEnum<ItemOrService>().getEnumValue(
          key: json["type"], // ItemOrService,
          enumValues: ItemOrService.values,
          defaultEnumValue: ItemOrService.service,
        ),
        status: json["status"] ?? "",
        imageUrl: json["image_url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type.name,
        "status": status,
        "image_url": imageUrl,
      };
}
