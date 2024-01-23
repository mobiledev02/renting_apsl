import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '/models/message_model.dart';

class Chat with ChangeNotifier {
  Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

  String chatToJson(Chat data) => json.encode(data.toJson());

  String chatDate;
  List<MessageModel> messageObjList;

  Chat({
    this.chatDate = "",
    required this.messageObjList,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatDate: json["chatDate"] ?? "",
        messageObjList: json["messageObjList"] == null
            ? []
            : List<MessageModel>.from(
                json["messageObjList"].map(
                  (x) => MessageModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "chatDate": chatDate,
        "messageObjList": List<dynamic>.from(
          messageObjList.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
