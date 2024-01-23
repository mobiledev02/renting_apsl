import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:renting_app_mobile/widgets/common_widgets.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';

import '../../../cards/chat_card.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../controller/chat_controller.dart';
import '../../../models/user_model.dart';
import '../../../widgets/cust_image.dart';
import '../../../widgets/empty_screen_ui.dart';

class GroupWiseChatListScreen extends GetView<ChatController> {
  final String eventId;

  GroupWiseChatListScreen(this.eventId, {Key? key}) {
    debugPrint('group wise chat gets called ${eventId}');
    controller.fetchEventWiseSingleChats(
        eventId: eventId, nullSnapReference: true);
  }

  ValueNotifier _searchNotifier = ValueNotifier(true);

  TextEditingController _searchEditingController = TextEditingController();

  RxBool lazyLoadInProgress = false.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustBackButton(
              backFunction: () {
                Get.back();
                controller.clearUserWiseSingleChatList();

                controller.closeEventWiseSingleChatStream();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSearchTextFormField(),
          ),
          ValueListenableBuilder(
            valueListenable: _searchNotifier,
            builder: (context, val, child) {
              return GetBuilder<ChatController>(builder: (context) {

                List<UserInfoModel> list = [];
                list = controller.getUserWiseSingleChat;

                print(list);

                list = list
                    .where(
                      (element) => element.name.toLowerCase().contains(
                            _searchEditingController.text.toLowerCase(),
                          ),
                    )
                    .toList();

                return Expanded(
                  child: controller.loadSingleEventWiseChatList.value
                      ? Spinner()
                      : list.isEmpty
                          ? EmptyScreenUi(
                              imgUrl: ImgName.noChatBg,
                              height: 324.24,
                              title: StaticString.nothingHere,
                              description: StaticString.pickPerson,
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await controller.fetchEventWiseSingleChats(
                                  eventId: eventId,
                                  showLoader: false,
                                );
                              },
                              child: LazyLoadScrollView(
                                scrollOffset: 150,
                                onEndOfPage: () async {
                                  if (lazyLoadInProgress.value) return;
                                  lazyLoadInProgress.value = true;

                                  await controller.fetchEventWiseSingleChats(
                                    eventId: eventId,
                                    forLazyLoad: true,
                                  );

                                  lazyLoadInProgress.value = false;
                                },
                                child: Obx(() {
                                  return ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    itemCount: lazyLoadInProgress.value
                                        ? list.length + 1
                                        : list.length,
                                    itemBuilder: (context, index) {
                                      debugPrint('group wisse chats ${list[index].toJson()}');
                                      debugPrint('group wise chat list chat id ${list[index].chatId}');
                                      if(    (list.length == index) &&
                                          lazyLoadInProgress.value) {
                                        return Spinner();
                                      } else {
                                        return ChatCard(
                                        chatId: list[index].chatId,
                                        isLender: true,
                                        userInfoModel: list[index],
                                        // showCount: true,
                                      );
                                      }
                                    }
                                  );
                                }),
                              ),
                            ),
                );
              });
            },
          )
        ],
      ),
    );
  }

  /// Search Text Form Field
  Widget _buildSearchTextFormField() {
    return SizedBox(
      height: 38,
      child: TextFormField(
        controller: _searchEditingController,
        onChanged: (value) {
          _searchNotifier.notifyListeners();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, color: Colors.transparent),
          ),
          filled: true,
          fillColor: custBlack102339.withOpacity(0.04),
          contentPadding: const EdgeInsets.only(
            // left: 10,
            right: 15,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
                // right: 0,
                ),
            child: CustImage(
              height: 16,
              width: 16,
              imgURL: ImgName.searchImage,
              errorImage: ImgName.imagePlacheHolderImage,
            ),
          ),
          hintText: StaticString.search,
        ),
      ),
    );
  }
}
