import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:renting_app_mobile/models/user_model.dart';

import '../utils/custom_enum.dart';
import '../utils/custom_extension.dart';
import '../widgets/generic_enum.dart';

enum ChatMessageType { Text, Image }

List<MessageModel> messageModelListFromJson(List<Map<String, dynamic>> str) =>
    List<MessageModel>.from(str.map((x) => MessageModel.fromJson(x)));

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  String toSend;
  String sendBy;
  String message;
  String renterId;
  String lenderId;
  String? adminDirect;
  String? specialText;
  DateTime? startDate;
  DateTime? endDate;
  int time;
  int type;
  String imageUrl;

  // bool isSingleBorder;
  bool showProfile;
  String docUrl, docSize, docName;
  MessageType messageType;
  String chatRoomId;
  String eventServiceId;
  String itemId;
  String forSingleChat;

  UserInfoModel? senderInfo, receiverInfo;

  MessageModel({
    this.toSend = "",
    this.sendBy = "",
    this.message = "",
    this.adminDirect,
    this.time = 0,
    this.specialText,
    this.type = 0,
    this.imageUrl = "",
    this.startDate,
    this.endDate,
    this.eventServiceId = "",
    // this.isSingleBorder = false,
    this.itemId = "",
    this.showProfile = false,
    this.docUrl = "",
    this.docName = "",
    this.docSize = "",
    this.chatRoomId = "",
    required this.lenderId,
    required this.renterId,
    this.messageType = MessageType.Text,
    this.senderInfo,
    this.receiverInfo,
    this.forSingleChat = "true",
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    try {
      return MessageModel(
        toSend: json["toSend"] ?? "",
        sendBy: json["sendBy"] ?? "",
        startDate:
            json['start_date'] != null ? json['start_date'].toDate() : null,
        endDate: json['end_date'] != null ? json['end_date'].toDate() : null,
        message: json["message"] ?? "",
        time: json["time"].toInt(),
        type: json["type"],
        renterId: json['renter_id'] ?? '',
        specialText: json["special_text"],
        adminDirect: json["admin_direct"],
        imageUrl: json["image_url"] ?? "",
        docName: json["docName"] ?? "",
        docSize: json["docSize"] ?? "",
        lenderId: json['lender_id'] ?? '',
        docUrl: json["docUrl"] ?? "",
        itemId: json["item_id"] ?? "",
        forSingleChat: json["forSingleChat"] ?? "true",
        chatRoomId: json["chatRoomId"] ?? "",
        senderInfo: json["sender_info"] == null
            ? null
            : UserInfoModel.fromJson(json["sender_info"]),
        receiverInfo: json["receiver_info"] == null
            ? null
            : UserInfoModel.fromJson(json["receiver_info"]),
        messageType: json["docType"] != null
            ? GenericEnum<MessageType>().getEnumValue(
                defaultEnumValue: MessageType.Text,
                enumValues: MessageType.values,
                key: json["docType"],
              )
            : MessageType.Text, // json["docType"] ?? "text",
      );
    } catch (e, st) {
      debugPrint('error message model $e $st');
      return MessageModel(renterId: '', lenderId: '');
    }
  }

  Map<String, dynamic> toJson() => {
        "toSend": toSend,
        "start_date": startDate,
        "end_date": endDate,
        "sendBy": sendBy,
        "message": message,
        "time": time,
        "type": type,
        "renter_id": renterId,
        "lender_id": lenderId,
        "item_id": itemId,
        "image_url": imageUrl,
        "admin_direct": adminDirect,
        "docUrl": docUrl,
        "docName": docName,
        "docSize": docSize,
        "special_text": specialText,
        "docType": messageType.getEnumName,
        "chatRoomId": chatRoomId,
        "sender_info": senderInfo?.toMessageJson(),
        "receiver_info": receiverInfo?.toMessageJson(),
        "forSingleChat": forSingleChat,
      };


  String get getFormattedTime =>
      DateTime.fromMillisecondsSinceEpoch(time).toString().toDateFormat(
            incommingDateFormate: "yyyy-MM-dd HH:mm:ssz",
            requiredFormat: "hh:mm a",
          );

  String get getFormatedDateForHEader =>
      DateTime.fromMillisecondsSinceEpoch(time).toString().toDateFormat(
                    incommingDateFormate: "yyyy-MM-dd HH:mm:ssz",
                    requiredFormat: "dd MMMM yyyy",
                  ) ==
              DateTime.now().toString().toDateFormat(
                    requiredFormat: "dd MMMM yyyy",
                  )
          ? "Today"
          : DateTime.fromMillisecondsSinceEpoch(time).toString().toDateFormat(
                incommingDateFormate: "yyyy-MM-dd HH:mm:ssz",
                requiredFormat: "dd MMMM yyyy",
              );
}
