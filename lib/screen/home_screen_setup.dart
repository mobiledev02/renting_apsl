// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/widgets/common_widgets.dart';

import '/controller/auth_controller.dart';
import '/screen/chat/chat_list_screen.dart';
import '/screen/payment/payment_list_screen.dart';
import '/constants/img_font_color_string.dart';
import '/controller/chat_controller.dart';
import '/controller/item_controller.dart';
import '/main.dart';
import '/models/item_detail_model.dart';
import '/models/notification_model.dart';
import '/models/user_model.dart';
import '/utils/custom_enum.dart';
import '/utils/push_notification.dart';
import '/widgets/cust_image.dart';
import '/widgets/generic_enum.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/main_chat_counter.dart';
import '/widgets/statusbar_content_style.dart';
import 'chat/chat_screen.dart';
import 'lend/lend_home_screen.dart';
import 'rent/browse_to_rent_items_screen.dart';

class HomeSetUpScreen extends StatefulWidget {
  HomeSetUpScreen({Key? key});

  @override
  State<HomeSetUpScreen> createState() => _HomeSetUpScreenState();
}

class _HomeSetUpScreenState extends State<HomeSetUpScreen>
    with WidgetsBindingObserver {
//   @override
  BottomBarOption _selectedOption = BottomBarOption.Rent;

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  AuthController authController = Get.find<AuthController>();

  ValueNotifier _valueNotifier = ValueNotifier(true);
  Map<String, dynamic> tempNotificationData = {"code": "", "id": 0};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    initialApiCall();
    debugPrint('home setup initialized');

    if (authController.getUserInfo.id != "") {
      Get.find<ChatController>()
          .createUser(userInfoModel: authController.getUserInfo);
    }
  }

  // bool _isGranted = false;
  Future<void> initialApiCall() async {
    // checkIsUpdateAvailable();

    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }
      await authController.fetchMyProfile(context: getContext);
      debugPrint('set up started');
      locationDialogueIfLocationIsDisale(forcefullyStopDialogue: true);

      // Push notification setup...
      PushNotification.instance.pushNotificationsMethodsSetup();
      // Handle notification redirection...
      //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      PushNotification.instance.onMessageReceived = redirectToScreen;

      PushNotification.instance.refreshToken();
    } catch (e) {
      print(e);
      // showAlert(context: context, message: e);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, () {
        //  showLocatiPopup();
      });
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    debugPrint("Handling a background message: ${message.messageId}");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (authController.getUserInfo.address.isEmpty) {
        authController.fetchMyProfile(context: getContext).then(
              (value) => locationDialogueIfLocationIsDisale(
                forcefullyStopDialogue: true,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusbarContentStyle(
      statusbarContentColor: StatusbarContentColor.Black,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, val, child) {
            return SafeArea(
              top: _selectedOption != BottomBarOption.Chat,
              child: _buildScreens(_selectedOption),
            );
          },
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   getChatController!.createUser(userInfoModel: authController.getUserInfo);
        // },),
        bottomNavigationBar: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, val, child) {
                return _buildBottomNavigationBar();
              }),
        ),
      ),
    );
  }

  /// change screen by index
  Widget _buildScreens(BottomBarOption selectedOption) {
    Widget child = Container();

    switch (selectedOption) {
      case BottomBarOption.Rent:
        // child = const LendNewItemFormScreen(
        //   lendNewItemFormScreenType: LendNewItemForm.item,
        // );
        child = BrowseToRentItemsScreen();
        break;
      case BottomBarOption.Lend:
        child = LendHomeScreen();
        break;
      case BottomBarOption.Transactions:
        child = PaymentHistoryScreen();
        break;
      case BottomBarOption.Chat:
        child = ChatListScreen();
        break;
      default:
        BrowseToRentItemsScreen();
        break;
    }
    return child;
  }

  //BuildBottomNavigation
  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedItemColor: primaryColor,
      unselectedItemColor: custBlack102339.withOpacity(0.5),
      currentIndex: _selectedOption.index,
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      onTap: (newIndex) {
        if (_selectedOption == BottomBarOption.values[newIndex]) {
          return;
        }

        if (_selectedOption != BottomBarOption.Rent) {
          Get.find<ItemController>().setSelectedMiles = "";
        }

        // setState(() {
        _selectedOption = BottomBarOption.values[newIndex];

        _valueNotifier.notifyListeners();

        // });
      },
      items: BottomBarOption.values
          .map(
            (option) => BottomNavigationBarItem(
              label: describeEnum(option),
              icon: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: CustImage(
                        imgURL: ImgName.bottomBarImage(option),
                        height: 20,
                        width: 20,
                        imgColor: _selectedOption.index == option.index
                            ? primaryColor
                            : custBlack102339.withOpacity(0.5),
                      ),
                    ),
                  ),
                  if (option == BottomBarOption.Chat)
                    const Positioned(
                      right: 12,
                      child: HomeChatCounter(),
                    )
                  else
                    const SizedBox()
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  void redirectToScreen(
    RemoteMessage notificationModel,
    NotificationType notificationType,
  ) {
    debugPrint('remote notification working');
    switch (notificationType) {
      case NotificationType.background:
        onLaunchNotification(notificationModel.data);
        break;
      case NotificationType.terminated:
        onLaunchNotification(notificationModel.data);
        break;
      case NotificationType.forground:
        onMessageReceive(notificationModel);
        break;
    }
  }

  // ------- Notification`s Helper method -------------
  Future<void> onMessageReceive(RemoteMessage message) async {
    final Map<String, dynamic> data = message.data;
    //TODO: check for data received though the notification and perform background action
    debugPrint(
        'onMessageReceive data ${message.notification} ${message.data} kkkk');
    debugPrint(data.toString());
    debugPrint(message.data.toString());
    if (data['room_id'] != null) {
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 2),
          borderRadius: 20,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          snackPosition: SnackPosition.TOP,
          backgroundColor: custMaterialPrimaryColor,
          title: data["notification_title"],
          message: data["notification_body"],
          onTap: (getSnack) {
            Get.to(
              () => ChatScreen(
                //TODO: make isLender according to what data is coming from the server
                isLender: !(data["is_single_chat"] == "true"),
                userInfoModel: UserInfoModel(
                  authType: AuthType.None,
                  chatRoomId: data["room_id"],
                  id: data["user_id"],
                  name: data["name"] ?? "",
                  itemDetailModel: ItemDetailModel(
                    id: int.parse(data["item_id"] ?? "0"),
                  ),
                ),
                isSingleChat: data["is_single_chat"] == "true",
              ),
            );
          },
        ),
      );
    }
    if (data["chatRoomId"] != null) {
      bool chattingWithSame = await Get.find<ChatController>()
          .checkCurrentUserIsChattingWithGivenUser(userId: data["id"]);

      if (chattingWithSame) return;

      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 2),
          borderRadius: 20,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          snackPosition: SnackPosition.TOP,
          backgroundColor: custMaterialPrimaryColor,
          title: data["notification_title"],
          message: data["notification_body"],
          onTap: (getSnack) {
            Get.to(
              () => ChatScreen(
                //TODO: make isLender according to what data is coming from the server (testing needed)

                isLender: Get.find<AuthController>().getUserInfo.id ==
                    data['lender_id'],
                userInfoModel: UserInfoModel(
                  authType: AuthType.None,
                  chatRoomId: data["chatRoomId"],
                  id: data["id"],
                  name: data["name"],
                  itemDetailModel: ItemDetailModel(
                    id: int.parse(data["item_id"] ?? "0"),
                  ),
                ),
                isSingleChat: data["isSingleChat"] == "true",
              ),
            );
          },
        ),
      );

      return;
    }

    NotificationModel notificationModel = NotificationModel(
      requestId: int.parse(data["request_item_id"] ?? "0"),
      title: message.notification?.title ?? 'reLend',
      message: message.notification?.body ??
          (data["notification"] == null
              ? "reLend"
              : json.decode(data["notification"])["message"]),
      type: GenericEnum<ItemOrService>().getEnumValue(
        key: message.messageType ??
            ((data["notification"] == null
                    ? "item"
                    : json.decode(data["notification"])["type"]) ??
                "item"),
        enumValues: ItemOrService.values,
        defaultEnumValue: ItemOrService.service,
      ),
      itemServiceId: data["notification"] == null
          ? 0
          : json.decode(data["notification"])["item_service_id"] ?? 0,
    );

    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 2),
        borderRadius: 20,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        snackPosition: SnackPosition.TOP,
        backgroundColor: custMaterialPrimaryColor,
        title: notificationModel.title,
        message: notificationModel.message,
        onTap: (getSnack) {
          if ((notificationModel.requestId ?? -1) > 0) {
            // Get.toNamed("RequestItemScreen");
            debugPrint("Request notification tapped");
          } else if ((notificationModel.itemServiceId ?? -1) > 0) {
            notificationModel.type == ItemOrService.item
                ? Get.toNamed(
                    "ItemDetailScreen",
                    arguments: notificationModel.itemServiceId,
                  )
                : Get.toNamed(
                    "ServiceDetailScreen",
                    arguments: notificationModel.itemServiceId,
                  );
          }
        },
      ),
    );
  }

  void onLaunchNotification(Map<String, dynamic> data) async {
    // final Map<String, dynamic> data = message!.data;
    debugPrint('data that is coming $data');
    if (data['room_id'] != null) {
      Get.to(
        () => ChatScreen(
          //TODO: make isLender according to what data is coming from the server
          isLender: !(data["is_single_chat"] == "true"),
          userInfoModel: UserInfoModel(
            authType: AuthType.None,
            chatRoomId: data["room_id"],
            id: data["user_id"],
            name: data["name"] ?? "",
            itemDetailModel: ItemDetailModel(
              id: int.parse(data["item_id"] ?? "0"),
            ),
          ),
          isSingleChat: data["is_single_chat"] == "true",
        ),
      );
    }
    if (data["chatRoomId"] != null) {
      Get.to(
        () => ChatScreen(
          //TODO: make isLender according to what data is coming from the server
          isLender:
              Get.find<AuthController>().getUserInfo.id == data['lender_id'],
          userInfoModel: UserInfoModel(
            authType: AuthType.None,
            chatRoomId: data["chatRoomId"],
            id: data["id"],
            name: data["name"],
            itemDetailModel: ItemDetailModel(
              id: int.parse(data["item_id"] ?? "0"),
            ),
          ),
          isSingleChat: data["isSingleChat"] == "true",
        ),
      );

      return;
    }

    if (data["notification"] == null) return;

    NotificationModel notificationModel = NotificationModel(
      requestId: int.parse(data["request_item_id"] ?? "0"),
      type: GenericEnum<ItemOrService>().getEnumValue(
        key: data["notification"] == null
            ? "item"
            : json.decode(data["notification"])["type"],
        enumValues: ItemOrService.values,
        defaultEnumValue: ItemOrService.service,
      ),
      itemServiceId: data["notification"] == null
          ? 0
          : json.decode(data["notification"])["item_service_id"] ?? 0,
    );

    if ((notificationModel.requestId ?? -1) > 0) {
      // Get.toNamed("RequestItemScreen");
    } else if ((notificationModel.itemServiceId ?? -1) > 0) {
      notificationModel.type == ItemOrService.item
          ? Get.toNamed(
              "ItemDetailScreen",
              arguments: notificationModel.itemServiceId,
            )
          : Get.toNamed(
              "ServiceDetailScreen",
              arguments: notificationModel.itemServiceId,
            );
    }

    // NotificationModel notificationModel =
    //     notificationModelFromJson(data.toString());

    // if (notificationModel.requestId != null) {
    //   Get.toNamed("RequestItemScreen");
    // } else if (notificationModel.itemServiceId != null) {
    //   notificationModel.type == ItemOrService.item
    //       ? Get.toNamed(
    //           "ItemDetailScreen",
    //           arguments: notificationModel.itemServiceId,
    //         )
    //       : Get.toNamed(
    //           "ServiceDetailScreen",
    //           arguments: notificationModel.itemServiceId,
    //         );
    // } else if (notificationModel.itemServiceRentsId != null) {}

    // if (!controller.isUserLoggedIn.value) {
    //   return;
    // } else {
    //   if (PlatformCheck.isIOS) {
    //     FlutterAppBadger.removeBadge();
    //   }
    //   NotificationObj notificationObj = notificationObjFromJson(data);

    //   switch (notificationObj.code) {
    //     case "AC200":
    //       Get.toNamed("RateAndReviewScreen", arguments: [notificationObj.data]);

    //       break;
    //     case "VNS200":
    //       Get.toNamed("ServiceDetailscreen",
    //           arguments: [notificationObj.serviceId]);

    //       break;

    //     default:
    //   }
    // }
  }
}
