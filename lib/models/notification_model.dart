// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

import '../utils/custom_enum.dart';
import '../widgets/generic_enum.dart';

List<NotificationModel> listOfNotificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str)['dataset'].map((x) => NotificationModel.fromJson(x)));

String listOfNotificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());
DateFormat dateFormatter = DateFormat("MMMM dd, yyyy");
DateFormat timeFormatter = DateFormat.jm();

class NotificationModel {
  NotificationModel({
    this.id,
    this.requestId,
    this.itemServiceId,
    this.itemServiceRentsId,
    this.type = ItemOrService.service,
    this.title = "",
    this.message = "",
    this.icon = "",
    this.createdAt = "",
  });

  int? id;
  int? requestId;
  int? itemServiceId;
  int? itemServiceRentsId;
  ItemOrService type;
  String title;
  String message;
  String icon;
  String createdAt;

  String get getDate =>
      dateFormatter.format(DateTime.parse(createdAt).toLocal());

  String get getTime =>
      timeFormatter.format(DateTime.parse(createdAt).toLocal());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        requestId: json["request_item_id"],
        itemServiceId: json["item_service_id"],
        itemServiceRentsId: json["item_service_rents_id"],
        type: GenericEnum<ItemOrService>().getEnumValue(
          key: json["type"], // ItemOrService,
          enumValues: ItemOrService.values,
          defaultEnumValue: ItemOrService.service,
        ),
        title: json["title"] ?? "",
        message: json["message"] ?? "",
        icon: json["icon"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_item_id": requestId,
        "item_service_id": itemServiceId,
        "item_service_rents_id": itemServiceRentsId,
        "type": type.name,
        "title": title,
        "message": message,
        "icon": icon,
        "created_at": createdAt,
      };
}

// // To parse this JSON data, do
// //
// //     final notificationModel = notificationModelFromJson(jsonString);

// import 'dart:convert';

// import 'package:intl/intl.dart';

// List<NotificationModel> listOfNotificationModelFromJson(String str) =>
//     List<NotificationModel>.from(
//         json.decode(str)['dataset'].map((x) => NotificationModel.fromJson(x)));

// String listOfNotificationModelToJson(List<NotificationModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// NotificationModel notificationModelFromJson(String str) =>
//     NotificationModel.fromJson(json.decode(str));

// String notificationModelToJson(NotificationModel data) =>
//     json.encode(data.toJson());
// DateFormat dateFormatter = DateFormat("MMMM dd, yyyy");
// DateFormat timeFormatter = DateFormat.jm();

// class NotificationModel {
//   NotificationModel({
//     this.id,
//     this.image = "",
//     this.title = "",
//     this.message = "",
//     this.createdAt = "",
//   });

//   int? id;
//   String image;
//   String title;
//   String message;
//   String createdAt;

//   String get getDate => dateFormatter.format(DateTime.parse(createdAt));
//   String get getTime => timeFormatter.format(DateTime.parse(createdAt));
//   factory NotificationModel.fromJson(Map<String, dynamic> json) =>
//       NotificationModel(
//         id: json["id"],
//         image: json["image"] ?? "",
//         title: json["title"] ?? "",
//         message: json["message"] ?? "",
//         createdAt: json["created_at"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "image": image,
//         "title": title,
//         "message": message,
//         "created_at": createdAt,
//       };
// }
