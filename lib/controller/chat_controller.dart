// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_final_fields

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_middleware.dart';
import '../main.dart';
import '../models/fcm_id_model.dart';
import '../utils/custom_enum.dart';

import '../api/api_end_points.dart';
import '../constants/img_font_color_string.dart';
import '../controller/auth_controller.dart';
import '../models/item_detail_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/url_switcher_screen.dart';

class ChatController extends GetxController {
  String get userCollection => StaticString.userCollection;

  String get recentChatCollection => StaticString.recentChatCollection;

  String get chatCollection => StaticString.chatCollection;

  String get messageCollection => StaticString.messageCollection;

  String get groupChatsCollection => StaticString.groupChatsCollection;

  String get singleChatsCollection => StaticString.singleChatsCollection;
  RxInt totalUsers = 0.obs;
  AuthController authController = Get.find<AuthController>();
  bool stopGroupLazyLoad = false,
      stopSingleChatLazyLoad = false,
      stopGroupSingleChatLazyLoad = false;

  DocumentSnapshot? lastDocSnapForGroup,
      lastDocSnapForSingleChatList,
      lastDocSnapForSingleChatForGroupList;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? singleChatListStream,
      groupListStream,
      eventWiseSingleChatStream;

  void closeSingleChatListStream() {
    singleChatListStream?.cancel();
  }

  void closeGroupListStream() {
    groupListStream?.cancel();
  }

  void closeEventWiseSingleChatStream() {
    eventWiseSingleChatStream?.cancel();
  }

  // bool loadSingleEventWiseChatList = false;
  RxBool loadGroupList = false.obs,
      loadSingleChatList = false.obs,
      loadSingleEventWiseChatList = false.obs,
      loadLazyLoadForSingleChat = false.obs;

  RxString isUserBlockedByMe = "".obs;

  final List<UserInfoModel> _groupDataList = [],
      _singleDataList = [],
      _userWiseSingleChat = [];

  clearData() {
    _groupDataList.clear();
    _singleDataList.clear();
    _userWiseSingleChat.clear();
  }

  String get getUserCollectionKey => "staging_$userCollection";

  String get getRecentChatCollectionKey => "staging_$recentChatCollection";

  String get getMessageCollectionKey => "staging_$messageCollection";

  CollectionReference<Map<String, dynamic>> get userRef =>
      FirebaseFirestore.instance.collection("staging_$userCollection");

  CollectionReference<Map<String, dynamic>> get recentChatRef =>
      FirebaseFirestore.instance.collection("staging_$recentChatCollection");

  CollectionReference<Map<String, dynamic>> get messageRef =>
      FirebaseFirestore.instance.collection("staging_$messageCollection");

  // String get getUserCollectionKey =>
  //     ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //         ? "local_$userCollection"
  //         : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //             ? "staging_$userCollection"
  //             : "production_$userCollection";
  //
  // String get getRecentChatCollectionKey =>
  //     ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //         ? "local_$recentChatCollection"
  //         : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //             ? "staging_$recentChatCollection"
  //             : "production_$recentChatCollection";
  //
  // String get getMessageCollectionKey =>
  //     ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //         ? "local_$messageCollection"
  //         : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //             ? "staging_$messageCollection"
  //             : "production_$messageCollection";
  //
  // CollectionReference<Map<String, dynamic>> get userRef =>
  //     FirebaseFirestore.instance.collection(
  //       ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //           ? "local_$userCollection"
  //           : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //               ? "staging_$userCollection"
  //               : "production_$userCollection",
  //     );
  //
  // CollectionReference<Map<String, dynamic>> get recentChatRef =>
  //     FirebaseFirestore.instance.collection(
  //       ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //           ? "local_$recentChatCollection"
  //           : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //               ? "staging_$recentChatCollection"
  //               : "production_$recentChatCollection",
  //     );
  //
  // CollectionReference<Map<String, dynamic>> get messageRef =>
  //     FirebaseFirestore.instance.collection(
  //       ProductionStagingURL.getCustomBaseURL == APISetup.localURL
  //           ? "local_$messageCollection"
  //           : ProductionStagingURL.getCustomBaseURL == APISetup.stagingURL
  //               ? "staging_$messageCollection"
  //               : "production_$messageCollection",
  //     );

  DocumentReference<Map<String, dynamic>> userDocumentById(String userId) {
    return userRef.doc(userId);
  }

  CollectionReference<Map<String, dynamic>> recentChatCollectonForEventWise(
      {required String userId, required String eventId}) {
    return userRef
        .doc(userId)
        .collection(StaticString.groupChatsCollection)
        .doc(eventId)
        .collection(getRecentChatCollectionKey);
  }

  bool loadMoreGroupList = false, loadMoreSingleChatList = false;

  List<UserInfoModel> get getGroupRecentList => _groupDataList;

  List<UserInfoModel> get getSingleChatRecentList => _singleDataList;

  List<UserInfoModel> get getUserWiseSingleChat => _userWiseSingleChat;

  clearUserWiseSingleChatList() {
    _userWiseSingleChat.clear();

    update();
  }

  String getGroupId(List<String> ab) {
    // ab.sort((a, b) => a.compareTo(b));
    // return ab.reduce((value, element) => value + element);

    return '${ab[0]}${ab[1]}${ab[2]}';
  }

  String getGroupId2(lenderId, renterId, itemServiceId) {
    return 's';
  }

  String userIdWithTag(String id) {
    return id; //+ "U";
  }

  String lenderIdWithTag(String id) {
    return id;
  }

  String eventServiceWithTag(String id) {
    return id + "ES";
  }

  UserInfoModel? _otherUserModel;

  UserInfoModel? get getOtherUserModel => _otherUserModel;

  ///create user table
  Future<void> createUser({UserInfoModel? userInfoModel}) async {
    userRef
        .doc(userIdWithTag(userInfoModel?.id ?? ""))
        .get()
        .then((value) async {
      print("Come to create user ${value.id}");
      if (!value.exists) {
        print("USER IS NOT EXISTS");
        await userRef
            .doc(
              userIdWithTag(
                userInfoModel?.id ?? "",
              ),
            )
            .set(
              userInfoModel?.toFirebaseJson(userInfoModel) ?? {},
            );
      } else {
        Get.find<ChatController>()
            .updateFcmIdList(userInfoModel: userInfoModel);
      }
    });
    // await getExitingFcmIDListFromUserTable(userInfoModel: userInfoModel);
  }

  ///create user table
  Future<void> createChatInFirebase({
    required ItemDetailModel itemDetailModel,
    String? docId,
  }) async {
    debugPrint('doc id in chat $docId');
    DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
        collectionReferenceGroupChat;
    AuthController authController = Get.find<AuthController>();
    // String groupId = getGroupId([
    //   authController.getUserInfo.id,
    //   (itemDetailModel.lenderInfoModel?.id.toString() ?? "")
    // ]);

    // Add recent chat to group

    // Document reference to the indicate lender`s id
    collectionReferenceGroupChat = userRef
        .doc(
          userIdWithTag(itemDetailModel.lenderInfoModel?.id.toString() ?? ""),
        )
        .collection(groupChatsCollection)
        .doc(
          eventServiceWithTag(
            itemDetailModel.id.toString(),
          ),
        );
    // .collection(StaticString.recentChatCollection);

    // Set the event info to the firebase
    collectionReferenceGroupChat
        .collection(getRecentChatCollectionKey)
        .doc(docId)
        .get()
        .then((value) async {
      if (!value.exists) {
        collectionReferenceGroupChat.set(
          itemDetailModel.toFirebaseCreateLendJson(),
        );
        await collectionReferenceGroupChat
            .collection(getRecentChatCollectionKey)
            .doc(docId)
            .set({
          "item_detail": itemDetailModel.toFirebaseCreateLendJson(),
          "img_url": "",
          "chat_id": docId,
          StaticString.unreadMessageCount: 0,
          "time": DateTime.now().toUtc().millisecondsSinceEpoch,
          "users": [
            authController.getUserInfo.id,
            itemDetailModel.lenderInfoModel?.id.toString()
          ],
          'renter_id': authController.getUserInfo.id,
          'item_id': itemDetailModel.id.toString(),
          'lender_id': itemDetailModel.lenderInfoModel?.id ?? "",
          StaticString.blockBy: "",
          authController.getUserInfo.id: authController.getUserInfo.toJson(),
          "other_user_id": itemDetailModel.lenderInfoModel?.id,
          "chat_created_at": FieldValue.serverTimestamp()
        });
      }
    });

    //  RecentChatModel(
    //                 time: DateTime.now().toUtc().millisecondsSinceEpoch,
    //                 blockBy: "",
    //                 imgUrl: "",
    //                 otherUserId: itemDetailModel.lenderInfoModel?.id ?? "",
    //                 unreadMessageCount: 0,
    //                 users: [
    //                   authController.getUserInfo.id,
    //                   itemDetailModel.lenderInfoModel?.id.toString() ?? ""
    //                 ],
    //                 itemDetailModel: itemDetailModel,
    //                 currentUserModel: authController.getUserInfo)

    //! Continue from here
    // Entry to single Chat
    collectionReferenceSingleChat = userRef
        .doc(
          userIdWithTag(
            getAuthController?.getUserInfo.id ?? "",
          ),
        )
        .collection(singleChatsCollection)
        .doc(docId);

    collectionReferenceSingleChat.get().then((value) async {
      if (!value.exists) {
        await collectionReferenceSingleChat.set({
          "item_detail": itemDetailModel.toFirebaseCreateLendJson(),
          "chat_id": docId,
          "img_url": "",
          StaticString.unreadMessageCount: 0,
          "time": DateTime.now().toUtc().millisecondsSinceEpoch,
          "users": [
            authController.getUserInfo.id,
            itemDetailModel.lenderInfoModel?.id.toString() ?? ""
          ],
          'renter_id': authController.getUserInfo.id,
          'item_id': itemDetailModel.id.toString(),
          'lender_id': itemDetailModel.lenderInfoModel?.id ?? "",
          StaticString.blockBy: "",
          authController.getUserInfo.id: authController.getUserInfo.toJson(),
          "other_user_id": itemDetailModel.lenderInfoModel?.id,
          "chat_created_at": FieldValue.serverTimestamp()
        });
      }
    });

    // RecentChatModel(
    //             time: DateTime.now().toUtc().millisecondsSinceEpoch,
    //             blockBy: "",
    //             imgUrl: "",
    //             otherUserId: itemDetailModel.lenderInfoModel?.id ?? "",
    //             unreadMessageCount: 0,
    //             users: [
    //               authController.getUserInfo.id,
    //               itemDetailModel.lenderInfoModel?.id.toString() ?? ""
    //             ],
    //             itemDetailModel: itemDetailModel,
    //             currentUserModel: authController.getUserInfo)
  }

  ///update status of chat
  Future<void> updateChatStatus({
    required ItemDetailModel itemDetailModel,
    required String docId,
  }) async {
    debugPrint('doc id in chat $docId');
    DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
        collectionReferenceGroupChat;
    AuthController authController = Get.find<AuthController>();


    // Document reference to the indicate lender`s id
    collectionReferenceGroupChat = userRef
        .doc(
      userIdWithTag(itemDetailModel.lenderInfoModel?.id.toString() ?? ""),
    )
        .collection(groupChatsCollection)
        .doc(
      eventServiceWithTag(
        itemDetailModel.id.toString(),
      ),
    );
    // .collection(StaticString.recentChatCollection);

    // Set the event info to the firebase
    collectionReferenceGroupChat
        .collection(getRecentChatCollectionKey)
        .doc(docId)
         .update({'chat_status': 'In Progress'});

    collectionReferenceSingleChat = userRef
        .doc(
      userIdWithTag(
        getAuthController?.getUserInfo.id ?? "",
      ),
    )
        .collection(singleChatsCollection)
        .doc(docId);

    collectionReferenceSingleChat.update({'chat_status': 'In Progress'});

  }

  // await getExitingFcmIDListFromUserTable(userInfoModel: userInfoModel);
  // }

  Future<void> fetchGroupList({
    bool forLazyLoad = false,
    bool nullSnapShots = false,
  }) async {
    if (nullSnapShots) {
      lastDocSnapForGroup = null;
    }

    UserInfoModel _userInfoModel = Get.find<AuthController>().getUserInfo;

    // if (!stopGroupLazyLoad) {
    Query<Map<String, dynamic>> queryString = lastDocSnapForGroup == null
        ? userDocumentById(_userInfoModel.id)
            .collection(StaticString.groupChatsCollection)
            .orderBy("time", descending: true)
            .limit(APISetup.lazyLoadLimit)
        : userDocumentById(_userInfoModel.id)
            .collection(StaticString.groupChatsCollection)
            .orderBy("time", descending: true)
            .limit(APISetup.lazyLoadLimit)
            .startAfterDocument(lastDocSnapForGroup!);
    debugPrint('group chat is also being listened');
    groupListStream = queryString.snapshots().listen((snap) async {
      try {
        loadGroupList.value = true;

        List<ItemDetailModel> itemDetailList = [];
        List<UserInfoModel> _userList = [];

        for (int i = 0; i <= snap.docs.length - 1; i++) {
          // debugPrint('data is ${snap.docs[i].data()}');
          itemDetailList.add(
            ItemDetailModel.fromJson(
              snap.docs[i].data(),
            ),
          );
        }

        if (itemDetailList.isNotEmpty) {
          lastDocSnapForGroup = await userDocumentById(_userInfoModel.id)
              .collection(StaticString.groupChatsCollection)
              .doc(snap.docs.last.id)
              .get();
        }

        for (int i = 0; i <= itemDetailList.length - 1; i++) {
          _userList.add(
            UserInfoModel(
              authType: AuthType.None,
              itemDetailModel: itemDetailList[i],
              name: itemDetailList[i].name,
              id: itemDetailList[i].id.toString(),
              unreadMessageCount:
                  snap.docs[i].data()[StaticString.unreadMessageCount] ?? 0,
            ),
          );
        }

        if (_userList.isNotEmpty) {
          lastDocSnapForSingleChatList =
              await userDocumentById(_userInfoModel.id)
                  .collection(StaticString.singleChatsCollection)
                  .doc(snap.docs.last.id)
                  .get();
        }

        if (_userList.length < APISetup.lazyLoadLimit) {
          stopGroupLazyLoad = true;
        }

        // loadMoreGroupList = tempChats.length < 15;
        // _groupDataList.addAll(tempChats);

        if (!forLazyLoad) {
          _groupDataList.clear();
        }

        _groupDataList.addAll(_userList);

        update();
      } catch (e) {
        rethrow;
      } finally {
        loadGroupList.value = false;
      }
    });
    // }
  }

  Future<void> fetchSingleChats(
      {bool forLazyLoad = false, bool nullSnapShots = false}) async {
    if (nullSnapShots) {
      lastDocSnapForSingleChatList = null;
    }
    if (loadLazyLoadForSingleChat.value || loadSingleChatList.value) return;
    // if (!stopSingleChatLazyLoad) {
    if (forLazyLoad) {
      loadLazyLoadForSingleChat.value = true;
    } else {
      loadSingleChatList.value = true;
    }

    UserInfoModel _userInfoModel = Get.find<AuthController>().getUserInfo;
    debugPrint('is last doc null for chat $lastDocSnapForSingleChatList');
    Query<Map<String, dynamic>> queryString =
        lastDocSnapForSingleChatList == null
            ? userDocumentById(_userInfoModel.id)
                .collection(StaticString.singleChatsCollection)
                .orderBy("time", descending: true)
                .limit(APISetup.lazyLoadLimit)
            : userDocumentById(_userInfoModel.id)
                .collection(StaticString.singleChatsCollection)
                .orderBy("time", descending: true)
                .limit(APISetup.lazyLoadLimit)
                .startAfterDocument(lastDocSnapForSingleChatList!);

    singleChatListStream = queryString.snapshots().listen(
      (snap) async {
        debugPrint('single chat snap length is ${snap.docs.length}');
        try {
          final List<UserInfoModel> tempChats = [];
          for (int i = 0; i <= snap.docs.length - 1; i++) {
            log('Single chat data ${snap.docs[i].data()['other_user_id']}');
            DocumentSnapshot<Map<String, dynamic>> snapShot =
                await userDocumentById(
                        snap.docs[i].data()["other_user_id"].toString())
                    .get();

            debugPrint('got the other user ${snapShot.id}');
            if (snapShot.data() != null) {
              UserInfoModel _userInfo = UserInfoModel(authType: AuthType.None);
              _userInfo = UserInfoModel.fromJson(snapShot.data()!);
              _userInfo.chatId = snap.docs[i].data()['chat_id'] ?? "";
              _userInfo.chatStatus =
                  snap.docs[i].data()['chat_status'] ?? "Pending";
              _userInfo.chatCreatedDate =
                  snap.docs[i].data()['chat_created_at'] != null
                      ? snap.docs[i].data()['chat_created_at'].toDate()
                      : null;
              _userInfo.lastMessage = snap.docs[i].data()['last_message'] ?? "";
              _userInfo.itemDetailModel =
                  ItemDetailModel.fromJson(snap.docs[i].data()["item_detail"]);
              _userInfo.unreadMessageCount =
                  snap.docs[i].data()[StaticString.unreadMessageCount];

              tempChats.add(_userInfo);

              debugPrint('single chat list ${tempChats.length}');

              if (tempChats.isNotEmpty) {
                lastDocSnapForSingleChatList =
                    await userDocumentById(_userInfoModel.id)
                        .collection(StaticString.singleChatsCollection)
                        .doc(snap.docs.last.id)
                        .get();
              }
            }
          }

          debugPrint('single chat data is null');

          // loadMoreGroupList = tempChats.length < 15;
          // _singleDataList.addAll(tempChats);

          if (tempChats.length < APISetup.lazyLoadLimit) {
            stopSingleChatLazyLoad = true;
          }

          if (!forLazyLoad) {
            _singleDataList.clear();
          }

          _singleDataList.addAll(tempChats);

          update();
        } catch (e, st) {
          // ignore: avoid_print
          debugPrint('fetchSingleChats error $e $st');
        } finally {
          if (forLazyLoad) {
            loadLazyLoadForSingleChat.value = false;
          } else {
            loadSingleChatList.value = false;
          }
        }
      },
    );
    // }
  }

  Future<bool> fetchEventWiseSingleChats({
    required String eventId,
    bool showLoader = true,
    bool forLazyLoad = false,
    bool nullSnapReference = false,
  }) async {
    // if (!stopGroupSingleChatLazyLoad) {

    if (nullSnapReference) {
      lastDocSnapForSingleChatForGroupList = null;
    }

    UserInfoModel _userInfoModel = Get.find<AuthController>().getUserInfo;

    try {
      loadSingleEventWiseChatList.value = showLoader;

      // update();
      debugPrint(
          'last group document $lastDocSnapForSingleChatForGroupList event id $eventId');
      Query<Map<String, dynamic>> queryString =
          lastDocSnapForSingleChatForGroupList == null
              ?
              // Initial list
              userDocumentById(_userInfoModel.id)
                  .collection(StaticString.groupChatsCollection)
                  .doc(eventServiceWithTag(eventId))
                  .collection(getRecentChatCollectionKey)
                  .orderBy("time", descending: true)
                  .limit(APISetup.lazyLoadLimit)
              :
              // For lazy Loading
              userDocumentById(_userInfoModel.id)
                  .collection(StaticString.groupChatsCollection)
                  .doc(eventServiceWithTag(eventId))
                  .collection(getRecentChatCollectionKey)
                  .orderBy("time", descending: true)
                  .limit(APISetup.lazyLoadLimit)
                  .startAfterDocument(lastDocSnapForSingleChatForGroupList!);

      eventWiseSingleChatStream = queryString.snapshots().listen(
        (snap) async {
          debugPrint('event wise snap data ${snap.docs.length}');
          List<UserInfoModel> tempChats = [];

          for (int i = 0; i <= snap.docs.length - 1; i++) {
            DocumentSnapshot<Map<String, dynamic>> snapShot =
                await userDocumentById(
              snap.docs[i].data()["users"][0].toString(),
            ).get();
            log('user data in chat ${snapShot.data()}');
            // .then((value) {
            if (snapShot.data() != null) {
              UserInfoModel _userInfo = UserInfoModel(authType: AuthType.None);
              _userInfo = UserInfoModel.fromJson(snapShot.data()!);
              _userInfo.chatId = snap.docs[i].data()['chat_id'] ?? '';
              _userInfo.chatStatus =
                  snap.docs[i].data()['chat_status'] ?? "Pending";
              _userInfo.chatCreatedDate =
                  snap.docs[i].data()['chat_created_at'] != null
                      ? snap.docs[i].data()['chat_created_at'].toDate()
                      : null;
              _userInfo.lastMessage = snap.docs[i].data()['last_message'] ?? "";
              if (snap.docs[i].data()["item_detail"] != null) {
                _userInfo.itemDetailModel = ItemDetailModel.fromJson(
                    snap.docs[i].data()["item_detail"]);

                _userInfo.unreadMessageCount =
                    snap.docs[i].data()[StaticString.unreadMessageCount];
              }

              tempChats.add(_userInfo);

              if (tempChats.isNotEmpty) {
                lastDocSnapForSingleChatForGroupList =
                    await userDocumentById(_userInfoModel.id)
                        .collection(StaticString.groupChatsCollection)
                        .doc(eventServiceWithTag(eventId))
                        .collection(getRecentChatCollectionKey)
                        .doc(snap.docs.last.id)
                        .get();
              }
            }
            // });
          }

          await Future.delayed(
            const Duration(seconds: 1),
          );

          // loadMoreGroupList = tempChats.length < 15;

          tempChats.sort((a, b) => a.time.compareTo(b.time));

          if (_singleDataList.length < APISetup.lazyLoadLimit) {
            stopGroupSingleChatLazyLoad = true;
          }

          if (!forLazyLoad) {
            _userWiseSingleChat.clear();
          }

          _userWiseSingleChat.addAll(tempChats);
          loadSingleEventWiseChatList.value = false;

          update();
        },
      );
    } catch (e, st) {
      // ignore: avoid_print
      debugPrint('fetchEventWiseSingleChats single chat error $e $st');
      loadSingleEventWiseChatList.value = false;
      rethrow;
    } finally {
      return true;
    }
    // }
    // return true;
  }

  //! ============================================================================

  Future<void> updateFcmIdList({
    UserInfoModel? userInfoModel,
    bool isLogout = false,
  }) async {
    List<FcmIdModel> existingList = [];

    await userRef
        .where("id", isEqualTo: userIdWithTag(userInfoModel?.id ?? ""))
        .get()
        .then(
          (users) => users.docs.forEach(
            (user) {
              if (user.exists) {
                if (user.data() != null) {
                  if (user.data()["fcm_id_list"] != null) {
                    user.data()["fcm_id_list"] =
                        listOfFcmInMapFormate(existingList);

                    userRef.doc(userIdWithTag(userInfoModel?.id ?? "")).set(
                          user.data(),
                        );
                  }
                }
              }

              existingList =
                  ((user.data()["fcm_id_list"] ?? []) as List<dynamic>)
                      .map((e) => FcmIdModel.fromJson(e))
                      .toList();
              // List<FcmIdModel>.from(user.data()["fcm_id_list"] ?? []);
            },
          ),
        );

    if (isLogout) {
      print(ApiMiddleware.deviceUUID);

      existingList.removeWhere(
        (element) => element.deviceId == ApiMiddleware.deviceUUID,
      );
    } else {
      int index = existingList.indexWhere(
        (element) => element.deviceId == ApiMiddleware.deviceUUID,
      );
      if (index >= 0) {
        existingList[index].token =
            authController.getUserInfo.userDevice?.fcmId;
      } else {
        existingList.add(
          FcmIdModel(
            deviceId: ApiMiddleware.deviceUUID,
            token: authController.getUserInfo.userDevice?.fcmId,
          ),
        );
      }
    }

    await userRef.doc(userIdWithTag(userInfoModel?.id ?? "")).update(
      {
        "email": userInfoModel?.email,
        "name": userInfoModel?.name,
        "profile_image": userInfoModel?.profileImage,
        "fcm_id_list": listOfFcmInMapFormate(existingList),
      },
    );
  }

  int getTotalUsers() {
    userRef.get().then((value) {
      totalUsers.value = value.docs.length;
    });
    return totalUsers.value;
  }

  Future<void> setRecentChat(UserInfoModel otherUserInfoModel) async {
    // String groupId = getGroupId([
    //   authController.getUserInfo.id,
    //   otherUserInfoModel.id,
    //   eventServiceWithTag(
    //       otherUserInfoModel.itemDetailModel?.id.toString() ?? "")
    // ]);
    /// setting renter id first and then id
    String groupId = getGroupId([
      otherUserInfoModel.id,
      authController.getUserInfo.id,
      eventServiceWithTag(
          otherUserInfoModel.itemDetailModel?.id.toString() ?? "")
    ]);

    debugPrint('recent chat ref $groupId');

    recentChatRef.doc(groupId).get().then((value) async {
      if (!value.exists) {
        await recentChatRef.doc(groupId).set({
          "item_detail":
              otherUserInfoModel.itemDetailModel?.toFirebaseCreateLendJson(),
          "img_url": "",
          StaticString.unreadMessageCount: 0,
          "time": DateTime.now().toUtc().millisecondsSinceEpoch,
          "users": [authController.getUserInfo.id, otherUserInfoModel.id],
          StaticString.blockBy: "",
          authController.getUserInfo.id: authController.getUserInfo.toJson(),
          otherUserInfoModel.id: otherUserInfoModel.toJson()
        });
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChat() {
    AuthController authController = Get.find<AuthController>();

    return recentChatRef
        .where("users", arrayContains: authController.getUserInfo.id)
        .orderBy("time", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTheUsersList() {
    return userRef
        .where("id", isNotEqualTo: Get.find<AuthController>().getUserInfo.id)
        .snapshots();
  }

  Future<void> sendMessage({
    required MessageModel messageModel,
  }) async {
    await messageRef
        .doc(messageModel.chatRoomId)
        .collection(chatCollection)
        .add(messageModel.toJson());
  }

  Future<void> updateChattingWithKeyOfPerticulerUser({
    required String receiversId,
  }) async {
    debugPrint('receiver\'s id is $receiversId');
    final String currentUserId = Get.find<AuthController>().getUserInfo.id;

    await userRef.doc(currentUserId).update(
      {
        StaticString.chattingWith: receiversId,
      },
    );
  }

  // For update unread message count
  Future<bool> checkGivenUserIsChattingWithCurrentUser(
      {required String userId}) async {
    debugPrint(
        'checkGivenUserIsChattingWithCurrentUser id : $userId ${getAuthController?.getUserInfo.id}');
    return userRef.doc(userId).get().then((value) => value.data() == null
        ? false
        : value.data()![StaticString.chattingWith].toString().trim() ==
            getAuthController?.getUserInfo.id.toString().trim());
  }

  Future<bool> checkCurrentUserIsChattingWithGivenUser(
      {required String userId}) async {
    return await userRef
        .doc(getAuthController?.getUserInfo.id.toString().trim())
        .get()
        .then((value) => value.data() == null
            ? false
            : value.data()![StaticString.chattingWith].toString().trim() ==
                userId);
  }

  Future<void> resetUnreadMessageCountOfCurrentUser(
      {required UserInfoModel oppositeUserInfoModel,
      required bool isFromSingleChat,
      required String chatId}) async {
    debugPrint('reset counts');
    DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
        collectionReferenceGroupChat;

    // String chatRoomId = getGroupId([
    //   // Current User Id
    //   userIdWithTag(
    //     getAuthController?.getUserInfo.id ?? "",
    //   ),
    //
    //   lenderIdWithTag(oppositeUserInfoModel.id.toString()),
    //
    //   // Event service Id
    //   eventServiceWithTag(
    //     oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
    //   )
    // ]);

    if (!isFromSingleChat) {
      // Update count on group chat
      debugPrint('reset count not from single chat chat id $chatId');

      collectionReferenceGroupChat = userRef
          .doc(
            userIdWithTag(getAuthController?.getUserInfo.id ?? ""),
          )
          .collection(groupChatsCollection)
          .doc(
            eventServiceWithTag(
              oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
            ),
          );

      collectionReferenceGroupChat
          .collection(getRecentChatCollectionKey)
          .doc(chatId)
          .get()
          .then((value) async {
        debugPrint('here is the document value ${value.data()}');
        if (value.data() != null) {
          int countThatNeedToRemove =
              value.data()![StaticString.unreadMessageCount];

          // Update unread message count to Group level
          collectionReferenceGroupChat.get().then((value) async {
            if (value.data() != null) {
              int count = value.data()![StaticString.unreadMessageCount] ?? 0;
              await collectionReferenceGroupChat.update({
                StaticString.unreadMessageCount:
                    (count - countThatNeedToRemove) < 0
                        ? 0
                        : count - countThatNeedToRemove,
              });
              // resetUnreadMessagesAllChat(
              //     authController.getUserInfo, countThatNeedToRemove);
            }
          });

          await collectionReferenceGroupChat
              .collection(getRecentChatCollectionKey)
              .doc(chatId)
              .update({
            StaticString.unreadMessageCount: 0,
          });
          resetUnreadMessagesAllChat(
              authController.getUserInfo, countThatNeedToRemove);
        }
      });
    } else {
      // Update count to single chat on opposite user

      collectionReferenceSingleChat = userRef
          .doc(
            userIdWithTag(
              getAuthController?.getUserInfo.id ?? "",
            ),
          )
          .collection(singleChatsCollection)
          .doc(chatId);

      await collectionReferenceSingleChat.get().then((value) async {
        if (value.data() != null) {
          int countThatNeedToRemove =
              value.data()![StaticString.unreadMessageCount];
          collectionReferenceSingleChat.update({
            StaticString.unreadMessageCount: 0,
          });
          resetUnreadMessagesAllChat(
              authController.getUserInfo, countThatNeedToRemove);
        }
      });
    }
  }

  // Block the specific user
  Future<void> blockTheUser({
    required UserInfoModel oppositeUserInfoModel,
    required bool comeFromSingleChat,
    required bool blockUser,
  }) async {
    DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
        collectionReferenceGroupChat;

    String chatRoomId = getGroupId([
      // Current User Id
      userIdWithTag(
        getAuthController?.getUserInfo.id ?? "",
      ),

      lenderIdWithTag(oppositeUserInfoModel.id.toString()),

      // Event service Id
      eventServiceWithTag(
        oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
      )
    ]);

    if (comeFromSingleChat) {
      // Update to group Chat
      collectionReferenceGroupChat = userRef
          .doc(
            userIdWithTag(oppositeUserInfoModel.id),
          )
          .collection(groupChatsCollection)
          .doc(
            eventServiceWithTag(
              oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
            ),
          );

      collectionReferenceGroupChat
          .collection(getRecentChatCollectionKey)
          .doc(getAuthController?.getUserInfo.id)
          .update({
        StaticString.blockBy: blockUser ? getAuthController?.getUserInfo.id : ""
      });

      // Update for single chat
      collectionReferenceSingleChat = userRef
          .doc(
            userIdWithTag(
              getAuthController?.getUserInfo.id ?? "",
            ),
          )
          .collection(singleChatsCollection)
          .doc(chatRoomId);

      collectionReferenceSingleChat.update({
        StaticString.blockBy: blockUser ? getAuthController?.getUserInfo.id : ""
      });

      isUserBlockedByMe.value = blockUser ? "Y" : "";
    } else {
      // Update to hroup Chat
      collectionReferenceGroupChat = userRef
          .doc(
            userIdWithTag(getAuthController?.getUserInfo.id ?? ""),
          )
          .collection(groupChatsCollection)
          .doc(
            eventServiceWithTag(
              oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
            ),
          );

      collectionReferenceGroupChat
          .collection(getRecentChatCollectionKey)
          .doc(oppositeUserInfoModel.id)
          .update({
        StaticString.blockBy: blockUser ? getAuthController?.getUserInfo.id : ""
      });

      // Update for single chat
      collectionReferenceSingleChat = userRef
          .doc(
            userIdWithTag(
              oppositeUserInfoModel.id,
            ),
          )
          .collection(singleChatsCollection)
          .doc(chatRoomId);

      collectionReferenceSingleChat.update({
        StaticString.blockBy: blockUser ? getAuthController?.getUserInfo.id : ""
      });

      isUserBlockedByMe.value = blockUser ? "Y" : "";
    }
  }

  // Check who bloack the user
  Future<String> checkBlockByMe({
    required UserInfoModel oppositeUserInfoModel,
    required bool comeFromSingleChat,
  }) async {
    // bool? blockByMe;
    DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
        collectionReferenceGroupChat;

    final String chatRoomId = getGroupId([
      // Current User Id
      userIdWithTag(getAuthController?.getUserInfo.id ?? ""),
      lenderIdWithTag(oppositeUserInfoModel.id),
      // Event service Id
      eventServiceWithTag(
        oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
      )
    ]);

    if (!comeFromSingleChat) {
      collectionReferenceGroupChat = userRef
          .doc(
            userIdWithTag(getAuthController?.getUserInfo.id ?? ""),
          )
          .collection(groupChatsCollection)
          .doc(
            eventServiceWithTag(
              oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
            ),
          );

      DocumentSnapshot<Map<String, dynamic>> value =
          await collectionReferenceGroupChat
              .collection(getRecentChatCollectionKey)
              .doc(oppositeUserInfoModel.id)
              .get();
      // .then((value) async {
      if (value.data() != null) {
        final String blockedBy =
            value.data()![StaticString.blockBy]?.toString() ?? "";

        if (blockedBy.isNotEmpty) {
          isUserBlockedByMe.value =
              blockedBy.trim() == getAuthController?.getUserInfo.id ? "Y" : "N";
        } else {
          isUserBlockedByMe.value = "";
        }
      } else {
        isUserBlockedByMe.value = "";
      }
      // });
    } else {
      collectionReferenceSingleChat = userRef
          .doc(
            userIdWithTag(
              getAuthController?.getUserInfo.id ?? "",
            ),
          )
          .collection(singleChatsCollection)
          .doc(chatRoomId);

      DocumentSnapshot<Map<String, dynamic>> value =
          await collectionReferenceSingleChat.get();
      // .then((value) {
      if (value.data() != null) {
        final String blockedBy =
            value.data()![StaticString.blockBy]?.toString() ?? "";

        if (blockedBy.isNotEmpty) {
          isUserBlockedByMe.value =
              blockedBy.trim() == getAuthController?.getUserInfo.id ? "Y" : "N";
        } else {
          isUserBlockedByMe.value = "";
        }
      }
      // });
    }

    return isUserBlockedByMe.value;
  }

  Future<void> updateUnreadMessageCountOfReceiverUser({
    required UserInfoModel oppositeUserInfoModel,
    required bool isFromSingleChat,
    String chatId = "",
    String message = "",
  }) async {
    bool currentlyDoingChatWithSameUser = false;
    debugPrint('opposite user id ${oppositeUserInfoModel.id}');
    currentlyDoingChatWithSameUser =
        await checkGivenUserIsChattingWithCurrentUser(
      userId: oppositeUserInfoModel.id,
    );
    debugPrint(
        'if chatting with same user: $currentlyDoingChatWithSameUser is from single chat $isFromSingleChat');

    if (!currentlyDoingChatWithSameUser) {
      DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
          collectionReferenceGroupChat;
      debugPrint('yes passed');
      // String chatRoomId = getGroupId([
      //   // Current User Id
      //   userIdWithTag(
      //     getAuthController?.getUserInfo.id ?? "",
      //   ),
      //
      //   lenderIdWithTag(oppositeUserInfoModel.id.toString()),
      //
      //   // Event service Id
      //   eventServiceWithTag(
      //     oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
      //   )
      // ]);

      if (isFromSingleChat) {
        // Update count on group chat
        debugPrint('yes single chat ');
        collectionReferenceGroupChat = userRef
            .doc(
              userIdWithTag(oppositeUserInfoModel.id.toString()),
            )
            .collection(groupChatsCollection)
            .doc(
              eventServiceWithTag(
                oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
              ),
            );
        debugPrint(
            'collection reference ${oppositeUserInfoModel.id} ${oppositeUserInfoModel.itemDetailModel?.id}, ${chatId}');

        // Update unread message count to user level
        collectionReferenceGroupChat
            .collection(getRecentChatCollectionKey)
            .doc(chatId)
            .get()
            .then((value) async {
          debugPrint('other group data received ${value.data()}');
          if (value.data() != null) {
            int count = value.data()![StaticString.unreadMessageCount];

            await collectionReferenceGroupChat
                .collection(getRecentChatCollectionKey)
                .doc(chatId)
                .update({
              'last_message': message,
              StaticString.unreadMessageCount: count + 1,
            });
            //     updateOverAllChatCount(oppositeUserInfoModel);
          }
        });

        // Update unread message count to Group level
        collectionReferenceGroupChat.get().then((value) async {
          if (value.data() != null) {
            int count = value.data()![StaticString.unreadMessageCount] ?? 0;

            await collectionReferenceGroupChat.update({
              'last_message': message,
              StaticString.unreadMessageCount: count + 1,
            });
            updateOverAllChatCount(oppositeUserInfoModel);
          }
        });
      } else {
        debugPrint('else is entered');
        // Update count to single chat on opposite user

        collectionReferenceSingleChat = userRef
            .doc(
              userIdWithTag(
                oppositeUserInfoModel.id,
              ),
            )
            .collection(singleChatsCollection)
            .doc(chatId);

        await collectionReferenceSingleChat.get().then((value) async {
          debugPrint('value of rhe document unread count is ${value.data()}');
          if (value.data() != null) {
            int count = int.parse(
                (value.data()![StaticString.unreadMessageCount]).toString());

            collectionReferenceSingleChat.update({
              'last_message': message,
              StaticString.unreadMessageCount: count + 1,
            });
            updateOverAllChatCount(oppositeUserInfoModel);
          }
        });
      }
    }

    updateTimeToFirebase(
      oppositeUserInfoModel: oppositeUserInfoModel,
      isFromSingleChat: isFromSingleChat,
    );
  }

  Future<void> updateOverAllChatCount(UserInfoModel receiver) async {
    debugPrint('overall chat receiver id ${receiver.id}');
    final counterRef =
        FirebaseFirestore.instance.collection(StaticString.chatCounterCollection).doc(receiver.id);
    counterRef.set(
        {'unreadMessages': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  Future<void> resetUnreadMessagesAllChat(
    UserInfoModel currentUser,
    int counts,
  ) async {
    try {
      final counterRef = FirebaseFirestore.instance
          .collection(StaticString.chatCounterCollection)
          .doc(currentUser.id);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final DocumentSnapshot counterSnapshot =
            await transaction.get(counterRef);
        final data = counterSnapshot.data();
        if (data != null) {
          data as Map;
          final int currentCounter = data['unreadMessages'];

          if (currentCounter > 0) {
            int newCounter = currentCounter - counts;
            if (newCounter < 0) {
              newCounter = 0;
            }
            transaction.update(counterRef, {'unreadMessages': newCounter});
          }
        }
      });
    } catch (e, st) {
      debugPrint('resetUnreadMessages error $e $st');
    }
  }

  Future<void> updateTimeToFirebase({
    required UserInfoModel oppositeUserInfoModel,
    required bool isFromSingleChat,
  }) async {
    DocumentReference<Map<String, dynamic>> collectionReferenceSingleChat,
        collectionReferenceGroupChat;

    String chatRoomId = getGroupId([
      // Current User Id
      userIdWithTag(
        getAuthController?.getUserInfo.id ?? "",
      ),

      lenderIdWithTag(oppositeUserInfoModel.id.toString()),

      // Event service Id
      eventServiceWithTag(
        oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
      )
    ]);

    if (isFromSingleChat) {
      // Update count on group chat

      collectionReferenceGroupChat = userRef
          .doc(
            userIdWithTag(oppositeUserInfoModel.id.toString()),
          )
          .collection(groupChatsCollection)
          .doc(
            eventServiceWithTag(
              oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
            ),
          );

      // Update unread message count to user level
      collectionReferenceGroupChat
          .collection(getRecentChatCollectionKey)
          .doc(getAuthController?.getUserInfo.id)
          .get()
          .then((value) async {
        if (value.data() != null) {
          await collectionReferenceGroupChat
              .collection(getRecentChatCollectionKey)
              .doc(getAuthController?.getUserInfo.id)
              .update({
            "time": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });

      // Update unread message count to Group level
      collectionReferenceGroupChat.get().then((value) async {
        if (value.data() != null) {
          await collectionReferenceGroupChat.update({
            "time": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });

      collectionReferenceSingleChat = userRef
          .doc(
            userIdWithTag(
              getAuthController?.getUserInfo.id ?? "",
            ),
          )
          .collection(singleChatsCollection)
          .doc(chatRoomId);

      await collectionReferenceSingleChat.get().then((value) async {
        if (value.data() != null) {
          collectionReferenceSingleChat.update({
            "time": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });
    } else {
      collectionReferenceGroupChat = userRef
          .doc(
            userIdWithTag(getAuthController?.getUserInfo.id ?? ""),
          )
          .collection(groupChatsCollection)
          .doc(
            eventServiceWithTag(
              oppositeUserInfoModel.itemDetailModel?.id.toString() ?? "",
            ),
          );

      // Update unread message count to user level
      collectionReferenceGroupChat
          .collection(getRecentChatCollectionKey)
          .doc(oppositeUserInfoModel.id)
          .get()
          .then((value) async {
        if (value.data() != null) {
          await collectionReferenceGroupChat
              .collection(getRecentChatCollectionKey)
              .doc(oppositeUserInfoModel.id)
              .update({
            "time": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });

      // Update unread message count to Group level
      collectionReferenceGroupChat.get().then((value) async {
        if (value.data() != null) {
          await collectionReferenceGroupChat.update({
            "time": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });

      // Update count to single chat on opposite user

      collectionReferenceSingleChat = userRef
          .doc(
            userIdWithTag(
              oppositeUserInfoModel.id,
            ),
          )
          .collection(singleChatsCollection)
          .doc(chatRoomId);

      await collectionReferenceSingleChat.get().then((value) async {
        if (value.data() != null) {
          int count = int.parse(
              (value.data()![StaticString.unreadMessageCount]).toString());

          collectionReferenceSingleChat.update({
            "time": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });
    }
  }
}
