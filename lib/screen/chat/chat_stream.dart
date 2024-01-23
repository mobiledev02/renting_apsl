import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';
import '../../utils/url_switcher_screen.dart';
import '/api/api_end_points.dart';
import '/models/message_model.dart';

import '../../controller/auth_controller.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';

class ChatStream {
  String get messageCollection => "staging_messages";

  /// Complex way of getting message collection
  // String get messageCollection =>
  //     ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //         ? "local_messages"
  //         : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //             ? "staging_messages"
  //             : "production_messages";

  String get chatCollection => "chats";
  final controller = StreamController<List<Chat>>();

  // var groupController = StreamController<List<UserInfoModel>>();
  // var singleController = StreamController<List<UserInfoModel>>();
  Stream<List<Chat>> get getStreamRef => controller.stream;

  // Stream<List<UserInfoModel>> get getGroupStreamRef =>
  //     groupController.stream.asBroadcastStream();
  // Stream<List<UserInfoModel>> get getSingleStreamRef =>
  //     singleController.stream.asBroadcastStream();
  final List<MessageModel> _data = [];

  // final List<UserInfoModel> _groupDataList = [];
  // final List<UserInfoModel> _singleDataList = [];
  AuthController get authController => Get.find<AuthController>();
  bool loadMoreMessage = false;

  UserInfoModel? get currentUserModel => authController.getUserInfo;
  DocumentSnapshot? lastDocSnap;

  Future<void> getChats(String chatId) async {
    FirebaseFirestore.instance
        .collection(messageCollection)
        .doc(chatId)
        .collection(chatCollection)
        .orderBy("time", descending: true)
        .limit(APISetup.lazyLoadLimit)
        .snapshots()
        .listen((snap) async {
      print("get Chats stream wise");
      try {
        List<MessageModel> tempChats =
            messageModelListFromJson(snap.docs.map((e) => e.data()).toList());
        if (tempChats.isNotEmpty) {
          lastDocSnap = await FirebaseFirestore.instance
              .collection(messageCollection)
              .doc(chatId)
              .collection(chatCollection)
              .doc(snap.docs.last.id)
              .get();
        }

        loadMoreMessage = tempChats.length == APISetup.lazyLoadLimit;

        _data.addAll(tempChats);
        _data.clear();
        _data.addAll(tempChats);
        notifyStream();
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    });
  }

  // Future<void> getGroupList() async {
  //   UserInfoModel _userInfoModel = Get.find<AuthController>().getUserInfo;

  //   FirebaseFirestore.instance
  //       .collection(StaticString.userCollection)
  //       .doc(_userInfoModel.id)
  //       .collection(StaticString.groupChatsCollection)
  //       .doc("1L")
  //       .collection(StaticString.recentChatCollection)
  //       // .orderBy("time", descending: true)
  //       .limit(APISetup.lazyLoadLimit)
  //       .snapshots()
  //       .listen((snap) async {
  //     try {
  //       List<UserInfoModel> tempChats = listOfUserInfoModelFromJson(
  //           snap.docs.map((e) => e.data()).toList());
  //       // if (tempChats.isNotEmpty) {
  //       //   lastDocSnap = await FirebaseFirestore.instance
  //       //       .collection(StaticString.userCollection)
  //       //       .doc(_userInfoModel.id)
  //       //       .collection(StaticString.groupChatsCollection)
  //       //       .doc(snap.docs.last.id)
  //       //       .get();
  //       // }
  //       loadMoreMessage = tempChats.length < 15;
  //       _groupDataList.addAll(tempChats);
  //       _groupDataList.clear();
  //       _groupDataList.addAll(tempChats);
  //       notifyGroupStream();
  //     } catch (e) {
  //       // ignore: avoid_print
  //       print(e);
  //     }
  //   });
  // }

  // Future<void> getSingleChats() async {
  //   UserInfoModel _userInfoModel = Get.find<AuthController>().getUserInfo;
  //   FirebaseFirestore.instance
  //       .collection(StaticString.userCollection)
  //       .doc(_userInfoModel.id)
  //       .collection(StaticString.singleChatsCollection)
  //       // .orderBy("time", descending: true)
  //       .limit(APISetup.lazyLoadLimit)
  //       .snapshots()
  //       .listen((snap) async {
  //     try {
  //       List<UserInfoModel> tempChats = listOfUserInfoModelFromJson(
  //           snap.docs.map((e) => e.data()).toList());
  //       // if (tempChats.isNotEmpty) {
  //       //   lastDocSnap = await FirebaseFirestore.instance
  //       //       .collection(StaticString.userCollection)
  //       //       .doc(_userInfoModel.id)
  //       //       .collection(StaticString.singleChatsCollection)
  //       //       .doc(snap.docs.last.id)
  //       //       .get();
  //       // }
  //       loadMoreMessage = tempChats.length < 15;
  //       _singleDataList.addAll(tempChats);
  //       _singleDataList.clear();
  //       _singleDataList.addAll(tempChats);
  //       notifysingleChatStream();
  //     } catch (e) {
  //       // ignore: avoid_print
  //       print(e);
  //     }
  //   });
  // }

  Future<void> getChatsAddToTop(String chatId) async {
    if (!loadMoreMessage) {
      return;
    } else {
      if (lastDocSnap != null) {
        await FirebaseFirestore.instance
            .collection(messageCollection)
            .doc(chatId)
            .collection(chatCollection)
            .orderBy("time", descending: true)
            .startAfterDocument(lastDocSnap!)
            .limit(APISetup.lazyLoadLimit)
            .get()
            .then((snap) async {
          print("Get Chats on lazy loading");
          try {
            List<MessageModel> tempChats = messageModelListFromJson(
                snap.docs.map((e) => e.data()).toList());
            if (tempChats.isNotEmpty) {
              lastDocSnap = await FirebaseFirestore.instance
                  .collection(messageCollection)
                  .doc(chatId)
                  .collection(chatCollection)
                  .doc(snap.docs.last.id)
                  .get();
            }
            loadMoreMessage = tempChats.length == APISetup.lazyLoadLimit;

            _data.addAll(tempChats);
            notifyStream();
          } catch (e) {
            // ignore: avoid_print
            print(e);
          }
        });
      }
    }
  }

  // Notify new data...
  notifyStream() {
    List<Chat> chatList = [];
    if (_data.isNotEmpty) {
      for (int i = 0; i < _data.length; i++) {
        String chatDate = _data[i].getFormatedDateForHEader;
        int index =
            chatList.indexWhere((element) => element.chatDate == chatDate);
        if (index < 0) {
          chatList.add(Chat(chatDate: chatDate, messageObjList: [_data[i]]));
        } else {
          chatList[index].messageObjList.add(_data[i]);
        }
      }
    }

    controller.add(chatList);
  }

  // notifyGroupStream() {
  //   List<UserInfoModel> chatList = [];
  //   // if (_data.isNotEmpty) {
  //   //   for (int i = 0; i < _data.length; i++) {
  //   //     String chatDate = DateFormat("EE, MMMM dd, yyyy")
  //   //         .format(DateTime.fromMillisecondsSinceEpoch(_data[i].time,
  //   //             isUtc: false))
  //   //         .toString();
  //   //     int index =
  //   //         chatList.indexWhere((element) => element.chatDate == chatDate);
  //   //     if (index < 0) {
  //   //       chatList.add(Chat(chatDate: chatDate, messageObjList: [_data[i]]));
  //   //     } else {
  //   //       chatList[index].messageObjList.add(_data[i]);
  //   //     }
  //   //   }
  //   // }

  //   groupController.add(_groupDataList);
  // }

  // notifysingleChatStream() {
  //   List<UserInfoModel> chatList = [];
  //   // if (_data.isNotEmpty) {
  //   //   for (int i = 0; i < _data.length; i++) {
  //   //     String chatDate = DateFormat("EE, MMMM dd, yyyy")
  //   //         .format(DateTime.fromMillisecondsSinceEpoch(_data[i].time,
  //   //             isUtc: false))
  //   //         .toString();
  //   //     int index =
  //   //         chatList.indexWhere((element) => element.chatDate == chatDate);
  //   //     if (index < 0) {
  //   //       chatList.add(Chat(chatDate: chatDate, messageObjList: [_data[i]]));
  //   //     } else {
  //   //       chatList[index].messageObjList.add(_data[i]);
  //   //     }
  //   //   }
  //   // }

  //   singleController.add(_singleDataList);
  // }

  // Dispose Stream...
  Future<void> closeStream() {
    return controller.close();
  }

// // Dispose Stream...
// Future<void> closeGroupStream() {
//   // singleController = StreamController<List<UserInfoModel>>();
//   return groupController.close();
// }

// // Dispose Stream...
// Future<void> closeSingleChatStream() {
//   // groupController = StreamController<List<UserInfoModel>>();
//   return singleController.close();
// }
}
