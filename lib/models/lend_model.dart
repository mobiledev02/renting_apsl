
import 'dart:convert';

List<LendModel> lendModelFromJson(String str) =>
    List<LendModel>.from(json.decode(str).map((x) => LendModel.fromJson(x)));

String lendModelToJson(List<LendModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LendModel {
  LendModel({
    this.itemList,
    this.imgList,
  });

  List<ItemList>? itemList;
  List<dynamic>? imgList;

  factory LendModel.fromJson(Map<String, dynamic> json) => LendModel(
        itemList: List<ItemList>.from(
          json["item_list"] == null
              ? []
              : json["item_list"].map((x) => ItemList.fromJson(x)),
        ),
        imgList: List<dynamic>.from(
          json["img_list"] == null ? [] : json["img_list"].map((x) => x),
        ),
      );

  Map<String, dynamic> toJson() => {
        "item_list": List<dynamic>.from(itemList?.map((x) => x.toJson()) ?? []),
        "img_list": List<dynamic>.from(imgList?.map((x) => x) ?? []),
      };
}

class ItemList {
  ItemList({
    this.title = "",
    this.detail,
  });

  String title;
  List<Detail>? detail = [];

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        title: json["title"] ?? "",
        detail: List<Detail>.from(json["detail"] == null
            ? []
            : json["detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "detail": List<dynamic>.from(detail?.map((x) => x.toJson()) ?? []),
      };
}

class Detail {
  Detail({
    this.title = "",
    this.image = "",
  });

  String title;
  String image;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        title: json["title"] ?? "",
        image: json["image"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
      };
}
