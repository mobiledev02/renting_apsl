// To parse this JSON data, do
//
//     final howToUseModel = howToUseModelFromJson(jsonString);

import 'dart:convert';

List<HowToUseModel> howToUseModelFromJson(String str) =>
    List<HowToUseModel>.from(
        json.decode(str).map((x) => HowToUseModel.fromJson(x)));

String howToUseModelToJson(List<HowToUseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HowToUseModel {
  HowToUseModel({
    this.icon = "",
    this.title = "",
    this.description = "",
  });

  String icon;
  String title;
  String description;

  factory HowToUseModel.fromJson(Map<String, dynamic> json) => HowToUseModel(
        icon: json["icon"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "description": description,
      };
}

// final listOfHowToUseJson = [
//   {
//     "icon": ImgName.registerImage,
//     "title": "Rent",
//     "description": "Rent items from people in your community."
//   },
//   {
//     "icon": ImgName.lendImage,
//     "title": "Lend",
//     "description": "Earn money by lending items you are not using."
//   },
//   {
//     "icon": ImgName.request,
//     "title": "Request",
//     "description": "Request an item to rent if it is not already availlable."
//   },
//   {
//     "icon": ImgName.chatIcon,
//     "title": "Chat",
//     "description": "Chat with renter/lender to coordinate a pickup/dropoff."
//   },
// ];
// //  _items = List<Album>.from(
// //         response.data.map((x) => Album.fromJson(x)),
// //       );

// List<HowToUseModel> listOfHowToUse = List<HowToUseModel>.from(
//   listOfHowToUseJson.map(
//     (e) => HowToUseModel.fromJson(e),
//   ),
// );
