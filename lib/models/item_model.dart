// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:renting_app_mobile/models/categories_model.dart';
import 'package:renting_app_mobile/models/image_model.dart';

List<ItemModel> listOfItemModelFromJson(String str) => List<ItemModel>.from(
    json.decode(str)['dataset'].map((x) => ItemModel.fromJson(x)));

String listOfItemModelToJson(List<ItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  ItemModel({
    this.id,
    this.category,
    this.name = "",
    this.price = "",
    this.images,
    this.offerCount,
  });

  int? id;
  int? offerCount;
  CategoryModel? category;
  String name;
  String price;
  List<ImageModel>? images;

  ImageModel? get getFirstImageModel =>
      (images?.isNotEmpty ?? false) ? images![0] : null;

  factory ItemModel.fromJson(Map<String, dynamic> json1) => ItemModel(
        id: json1["id"] ?? 0,
        category: json1["category"] == null
            ? null
            : CategoryModel?.fromJson(
                json1["category"],
              ),
        name: json1["name"] ?? "",
        price: json1["price"] ?? "",
        images: json1["images"] == null
            ? []
            : listOfImageModelFromJson(
                json.encode(
                  json1["images"],
                ),
              ),
        offerCount: json1['service_count'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category?.toJson() ??
            CategoryModel(
              id: 0,
            ),
        "name": name,
        "price": price,
        "images": listOfImageModelToJson(
          images ?? [],
        ),
      };
}
