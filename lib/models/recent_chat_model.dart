// To parse this JSON data, do
//
//     final recentChatModel = recentChatModelFromJson(jsonString);

import 'dart:convert';

import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/models/user_model.dart';

RecentChatModel recentChatModelFromJson(String str) =>
    RecentChatModel.fromJson(json.decode(str));

String recentChatModelToJson(RecentChatModel data) =>
    json.encode(data.toJson());

class RecentChatModel {
  RecentChatModel({
    this.itemDetailModel,
    this.imgUrl = "",
    this.unreadMessageCount = 0,
    this.time = 0,
    this.users,
    this.blockBy = "",
    this.currentUserModel,
    this.otherUserId = "",
  });

  ItemDetailModel? itemDetailModel;
  String imgUrl;
  int unreadMessageCount;
  int time;
  List<String>? users;
  String blockBy;
  UserInfoModel? currentUserModel;
  String otherUserId;

  factory RecentChatModel.fromJson(Map<String, dynamic> json) =>
      RecentChatModel(
        itemDetailModel: ItemDetailModel.fromJson(json["event_service_info"]),
        imgUrl: json["img_url"],
        unreadMessageCount: json["unread_message_count"],
        time: json["time"],
        users: List<String>.from(json["users"].map((x) => x)),
        blockBy: json["blockBy"],
        currentUserModel: UserInfoModel.fromJson(json["id"]),
        otherUserId: json["other_user_id"],
      );

  Map<String, dynamic> toJson() => {
        "event_service_info": itemDetailModel?.toFirebaseCreateLendJson(),
        "img_url": imgUrl,
        "unread_message_count": unreadMessageCount,
        "time": time,
        "users": List<dynamic>.from((users ?? []).map((x) => x)),
        "blockBy": blockBy,
        "id": currentUserModel?.toJson(),
        "other_user_id": otherUserId,
      };
}
