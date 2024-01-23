import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart' as lazyLoad;
import 'package:renting_app_mobile/main.dart';
import 'package:renting_app_mobile/screen/chat/widget/item_request_widget.dart';
import 'package:renting_app_mobile/screen/chat/widget/service_request_widget.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import 'package:renting_app_mobile/widgets/rich_text.dart';
import 'package:uuid/uuid.dart';
import '../../models/item_detail_model.dart';
import '/utils/custom_enum.dart';
import '../../controller/auth_controller.dart';
import '../../controller/chat_controller.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../screen/chat/chat_stream.dart';
import '../../utils/permissions.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_indicator.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../cards/message_card.dart';
import '../../constants/img_font_color_string.dart';
import '../../constants/text_style_decoration.dart';
import '../../models/chat_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/spinner.dart';
import 'package:path/path.dart' as p;

class ChatScreen extends StatefulWidget {
  /// user info model here is lender info model mostly
  final UserInfoModel userInfoModel;
  final bool isLender;
  final ItemDetailModel? service;
  final String? chatId;
  final bool isSingleChat;

  const ChatScreen(
      {required this.userInfoModel,
      this.isSingleChat = false,
      required this.isLender,
      this.service,
      this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  ChatStream dataService = ChatStream();

  ChatController controller = Get.find<ChatController>();

  List<Chat> chatList = [];

  final bool _isLazyLoading = false;

  TextEditingController textEditingController = TextEditingController();

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  final LoadingIndicatorNotifier _imageLoading = LoadingIndicatorNotifier();

  String chatRoomId = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    scrollToBottom();

    // Check user block status
    controller.checkBlockByMe(
      oppositeUserInfoModel: widget.userInfoModel,
      comeFromSingleChat: widget.isSingleChat,
    );

    // Reset Unread message count
    controller.resetUnreadMessageCountOfCurrentUser(
        oppositeUserInfoModel: widget.userInfoModel,
        isFromSingleChat: widget.isSingleChat,
        chatId: widget.chatId ?? "");

    if (widget.isLender) {
      chatRoomId = widget.userInfoModel.chatRoomId.isNotEmpty
          ? widget.userInfoModel.chatRoomId
          : controller.lenderIdWithTag(
                widget.userInfoModel.id,
              ) +
              controller
                  .userIdWithTag(Get.find<AuthController>().getUserInfo.id) +
              controller.eventServiceWithTag(
                widget.service != null
                    ? widget.service!.id.toString()
                    : widget.userInfoModel.itemDetailModel?.id.toString() ?? "",
              );
    } else {
      chatRoomId = widget.userInfoModel.chatRoomId.isNotEmpty
          ? widget.userInfoModel.chatRoomId
          : controller
                  .userIdWithTag(Get.find<AuthController>().getUserInfo.id) +
              controller.lenderIdWithTag(
                widget.userInfoModel.id,
              ) +
              controller.eventServiceWithTag(
                widget.service != null
                    ? widget.service!.id.toString()
                    : widget.userInfoModel.itemDetailModel?.id.toString() ?? "",
              );
    }

    if (widget.chatId != null) {
      chatRoomId = widget.chatId!;
      debugPrint('this is set $chatRoomId');
    }

    debugPrint('room id is $chatRoomId');

    /// generate complex id with this function
    // : getGroupId(
    //     [
    //       // Current User Id
    //       controller.userIdWithTag(
    //         Get.find<AuthController>().getUserInfo.id,
    //       ),
    //
    //       controller.lenderIdWithTag(
    //         widget.userInfoModel.id,
    //       ),
    //
    //       // Event service Id
    //       controller.eventServiceWithTag(
    //         widget.userInfoModel.itemDetailModel?.id.toString() ?? "",
    //       ),
    //     ],
    //   );

    dataService.getChats(chatRoomId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      controller.updateChattingWithKeyOfPerticulerUser(receiversId: "");
    } else if (state == AppLifecycleState.resumed) {
      controller.updateChattingWithKeyOfPerticulerUser(
        receiversId: widget.userInfoModel.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustBackButton(
                backFunction: () {
                  controller.updateChattingWithKeyOfPerticulerUser(
                    receiversId: "",
                  );

                  // controller.fetchEventWiseSingleChats(
                  //   eventId: userInfoModel.itemDetailModel?.id.toString() ?? "",
                  //   showLoader: false,
                  // );
                },
              ),
            ],
          ),
          titleSpacing: 0,
          title: CustomText(
            align: TextAlign.start,
            txtTitle: widget.userInfoModel.name,
            style: TextStyleDecoration.appBarTitle,
          ),
          centerTitle: false,
          actions: [
            Obx(() {
              return controller.isUserBlockedByMe.isEmpty
                  ? IconButton(
                      onPressed: () {
                        showAlert(
                            context: context,
                            signleBttnOnly: false,
                            leftBttnTitle: "Cancel",
                            rigthBttnTitle: "Block",
                            onRightAction: () {
                              controller.blockTheUser(
                                oppositeUserInfoModel: widget.userInfoModel,
                                blockUser: true,
                                comeFromSingleChat: widget.isSingleChat,
                              );
                            },
                            title: "Block User",
                            message:
                                "Are you sure you want to block ${widget.userInfoModel.name}?");
                      },
                      icon: const Icon(
                        Icons.cancel_presentation_sharp,
                      ),
                    )
                  : const SizedBox();
            })
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              ItemRequestWidget(
                requestId: chatRoomId,
                isLender: widget.isLender,
              ),
              ServiceRequestWidget(
                  requestId: chatRoomId, isLender: widget.isLender,),
              // Message UI
              buildMessageList(),
              ValueListenableBuilder<LoadingStatus>(
                  builder: (context, status, _) =>
                      _imageLoading.statusNotifier.value == LoadingStatus.Show
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all(8),
                                child: Spinner(),
                              ),
                            )
                          : SizedBox(
                              height: 0,
                              width: 0,
                            ),
                  valueListenable: _imageLoading.statusNotifier),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: LoadingIndicatorWithNotifier(
              //     indicatorType: LoadingIndicatorType.Spinner,
              //     customLoadingIndicator: Container(
              //       height: 30,
              //       width: 30,
              //       margin: EdgeInsets.only(right: 20, bottom: 20),
              //       alignment: Alignment.centerRight,
              //       child: Spinner(),
              //     ),
              //     loadingStatusNotifier: _imageLoading.statusNotifier,
              //     child: Container(
              //       height: 0,
              //       width: 0,
              //     ),
              //   ),
              // ),

              // Message Text Field
              Obx(() {
                return (controller.isUserBlockedByMe.value == "Y")
                    ? Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        child: CustomRichText(
                          title:
                              "${widget.userInfoModel.name} is blocked by you. #Unblock",
                          fancyTextStyle:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: custMaterialPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                          onTap: (val) async {
                            await controller.blockTheUser(
                              oppositeUserInfoModel: widget.userInfoModel,
                              blockUser: false,
                              comeFromSingleChat: widget.isSingleChat,
                            );
                          },
                        ),
                      )
                    : (controller.isUserBlockedByMe.value == "N")
                        ? Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            child: CustomText(
                              txtTitle: "You have been blocked.",
                            ),
                          )
                        : _buildTextFieldPortion();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildTextFieldPortion() {
    return Container(
      color: cust263238.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 12,
          ),
          InkWell(
            onTap: cameraGalleryButtonAction,
            child: CustImage(
              imgURL: ImgName.camera,
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: TextFormField(
              controller: textEditingController,
              minLines: 1,
              maxLines: 5,
              onTap: () {},
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Write Message",
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: custBlack102339.withOpacity(
                    0.3,
                  ),
                ),
                filled: true,
                fillColor: custLightGreyF2F3F3,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: custBlack102339.withOpacity(0.10),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: custBlack102339.withOpacity(0.10),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: custBlack102339.withOpacity(0.10),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: custBlack102339.withOpacity(0.10),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: custBlack102339.withOpacity(0.10),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: custBlack102339.withOpacity(0.10),
                  ),
                ),
              ),
            ),
          ),
          CustomText(
            onPressed: () async {
              if (textEditingController.text.trim().isEmpty) {
                textEditingController.clear();
                return;
              }

              scrollToBottom();

              String isBlockedByAnyUser = await controller.checkBlockByMe(
                comeFromSingleChat: widget.isSingleChat,
                oppositeUserInfoModel: widget.userInfoModel,
              );

              if (isBlockedByAnyUser.isNotEmpty) {
                return;
              }

              controller.updateUnreadMessageCountOfReceiverUser(
                  oppositeUserInfoModel: widget.userInfoModel,
                  isFromSingleChat: widget.isSingleChat,
                  chatId: chatRoomId,
                  message: textEditingController.text.trim());

              controller.sendMessage(
                messageModel: MessageModel(
                  chatRoomId: chatRoomId,
                  message: textEditingController.text.trim(),
                  forSingleChat: (!widget.isSingleChat).toString(),
                  lenderId: widget.isLender
                      ? Get.find<AuthController>().getUserInfo.id
                      : widget.userInfoModel.id,
                  renterId: widget.isLender
                      ? widget.userInfoModel.id
                      : Get.find<AuthController>().getUserInfo.id,
                  itemId:
                      widget.userInfoModel.itemDetailModel?.id.toString() ?? "",
                  eventServiceId: widget
                          .userInfoModel.itemDetailModel?.category?.id
                          .toString() ??
                      "",
                  senderInfo: Get.find<AuthController>().getUserInfo,
                  receiverInfo: widget.userInfoModel,
                  toSend: widget.userInfoModel.id,
                  time: DateTime.now().millisecondsSinceEpoch,
                  sendBy: Get.find<AuthController>().getUserInfo.id,
                ),
              );

              textEditingController.clear();
            },
            txtTitle: StaticString.send,
            style: const TextStyle(
                fontSize: 14,
                color: custMaterialPrimaryColor,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  Widget buildMessageList() {
    return StreamBuilder(
        stream: dataService.getStreamRef,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: Spinner(
                progressColor: custF7F7F7,
              ),
            );
          } else {
            if (snapshot.data != null) {
              chatList = snapshot.data as List<Chat>;
            }

            return lazyLoad.LazyLoadScrollView(
                scrollOffset: 150,
                onEndOfPage: () async {
                  try {
                    if (_loadingIndicatorNotifier.statusNotifier.value ==
                        LoadingStatus.Show) return;

                    _loadingIndicatorNotifier.show();

                    await dataService.getChatsAddToTop(chatRoomId);
                  } catch (e) {
                    print("Lazy loading error in chat screen $e");
                  } finally {
                    _loadingIndicatorNotifier.hide();
                  }
                },
                child: chatList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: CustomText(
                            txtTitle: "No chats found",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ValueListenableBuilder<LoadingStatus>(
                          valueListenable:
                              _loadingIndicatorNotifier.statusNotifier,
                          builder: (context, loadinStatus, _) =>
                              ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _loadingIndicatorNotifier
                                        .statusNotifier.value ==
                                    LoadingStatus.Show
                                ? chatList.length + 1
                                : chatList.length,
                            itemBuilder: (context, index) {
                              // List<MessageModel> msgObjList = [];

                              // if (index != chatList.length) {
                              //   msgObjList = chatList[index].messageObjList;
                              // }

                              return index == chatList.length &&
                                      _loadingIndicatorNotifier
                                              .statusNotifier.value ==
                                          LoadingStatus.Show
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                            10,
                                          ),
                                          height: 50,
                                          width: 50,
                                          child: Spinner(),
                                        ),
                                      ],
                                    )
                                  : chatList.isEmpty
                                      ? Container()
                                      : StickyHeader(
                                          header: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD0D1D5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6,
                                                ),
                                              ),
                                              child: CustomText(
                                                align: TextAlign.center,
                                                txtTitle:
                                                    chatList[index].chatDate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          content: ListView.builder(
                                              reverse: true,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                bottom: 5,
                                              ),
                                              itemCount: chatList[index]
                                                  .messageObjList
                                                  .length,
                                              itemBuilder: (context, i) {
                                                return MessageCard(
                                                  lenderInfo: widget.isLender
                                                      ? Get.find<
                                                              AuthController>()
                                                          .getUserInfo
                                                      : widget.userInfoModel,
                                                  renterInfo: widget.isLender
                                                      ? widget.userInfoModel
                                                      : Get.find<
                                                              AuthController>()
                                                          .getUserInfo,
                                                  chatRoomId: chatRoomId,
                                                  receiverProfileUrl: widget
                                                      .userInfoModel
                                                      .profileImage,
                                                  aboveMessageIsReceivers: (i >=
                                                          1)
                                                      ? chatList[index]
                                                              .messageObjList[i]
                                                              .toSend !=
                                                          chatList[index]
                                                              .messageObjList[
                                                                  i - 1]
                                                              .toSend
                                                      : false,
                                                  messageModel: chatList[index]
                                                      .messageObjList[i],
                                                );
                                              }),
                                        );
                            },
                          ),
                        ),
                      ));
          }
        });
  }

  Future<List<String>> imagePicker() async {
    bool _isGalleryGranted = await checkGalleryPermission();
    bool _isCameraPermission = await checkCameraPermission();
    final ImagePicker _picker = ImagePicker();
    List<XFile> resultList = [];

    if (!_isGalleryGranted || !_isCameraPermission) return [];

    resultList = await _picker.pickMultiImage();

    // MultiImagePicker.pickImages(
    //   maxImages: 300,
    //   enableCamera: true,
    //   selectedAssets: [],
    //   cupertinoOptions: const CupertinoOptions(
    //     takePhotoIcon: "chat",
    //     doneButtonTitle: "Select",
    //   ),
    //   materialOptions: const MaterialOptions(
    //     actionBarColor: "#abcdef",
    //     actionBarTitle: "Example App",
    //     allViewTitle: "All Photos",
    //     useDetailsView: false,
    //     selectCircleStrokeColor: "#000000",
    //   ),
    // );

    if (resultList.isEmpty) return [];

    _imageLoading.show();

    // List<String> filePaths =
    //     await filePathFromAsset(selectedAssets: resultList);

    final List<String> filePaths = resultList.map((e) => e.path).toList();

    final List<String> files = await pickAndUploadImageAsMessage(filePaths);

    return files;
  }

  // Pick - upload and fetch download url of Document
  Future<List<String>> pickAndUploadImageAsMessage(
    List<String> documentList,
  ) async {
    if (documentList.isEmpty) return [];

    List<String> downlaodedUrls = [];
    try {
      for (final String document in documentList) {
        // String fileName = document.split("/").last;
        const uuid = Uuid();
        final String extension = p.extension(document);
        final String fileName = '${chatRoomId}${uuid.v4()}.$extension';

        final Reference firebaseStorage =
            FirebaseStorage.instance.ref().child(fileName);

        final UploadTask uploadTask = firebaseStorage.putFile(
          File(document), // File path
        );

        await uploadTask.then(
          (p0) async {
            if (kDebugMode) {
              print('Task Uploaded');
            }

            final String temp = await p0.ref.getDownloadURL();

            downlaodedUrls.add(temp);
          },
        );
      }
    } catch (e) {
      rethrow;
    }

    return downlaodedUrls;
  }

  //! --------------------------- Button Actions ----------------------
  Future<void> cameraGalleryButtonAction() async {
    try {
      String isBlockedByAnyUser = await controller.checkBlockByMe(
        comeFromSingleChat: widget.isSingleChat,
        oppositeUserInfoModel: widget.userInfoModel,
      );

      if (isBlockedByAnyUser.isNotEmpty) {
        return;
      }

      List<String> pickedFilePathList = [];

      pickedFilePathList = await imagePicker();

      if (pickedFilePathList.isEmpty) return;

      for (int i = 0; i < pickedFilePathList.length; i++) {
        await controller.sendMessage(
          messageModel: MessageModel(
            lenderId: widget.isLender
                ? widget.userInfoModel.id
                : Get.find<AuthController>().getUserInfo.id,
            renterId: widget.isLender
                ? Get.find<AuthController>().getUserInfo.id
                : widget.userInfoModel.id,
            chatRoomId: chatRoomId,
            toSend: widget.userInfoModel.id,
            forSingleChat: (!widget.isSingleChat).toString(),
            sendBy: Get.find<AuthController>().getUserInfo.id,
            senderInfo: Get.find<AuthController>().getUserInfo,
            receiverInfo: widget.userInfoModel,
            itemId: widget.userInfoModel.itemDetailModel?.id.toString() ?? "",
            eventServiceId: (widget.userInfoModel.itemDetailModel?.category?.id
                    .toString() ??
                ""),
            messageType: MessageType.Image,
            docUrl: pickedFilePathList[i],
            time: DateTime.now().millisecondsSinceEpoch,
            message: "Image",
          ),
        );
      }
    } catch (e) {
      if (e.toString() != "The user has cancelled the selection") {
        showAlert(context: getContext, message: e);
      }
    } finally {
      _imageLoading.hide();
    }
  }
}
