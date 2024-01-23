import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:renting_app_mobile/screen/chat/chat_stream.dart';
import 'package:renting_app_mobile/screen/chat/group_chat/group_wise_chat_list_screen.dart';
import 'package:renting_app_mobile/widgets/empty_screen_ui.dart';
import 'package:renting_app_mobile/widgets/spinner.dart';
import '/constants/img_font_color_string.dart';
import '/controller/auth_controller.dart';
import '/controller/chat_controller.dart';
import '/models/user_model.dart';

import '/widgets/cust_image.dart';
import '/widgets/custom_text.dart';

import '../../cards/chat_card.dart';
import '../../constants/text_style_decoration.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  ChatController get getChatController => Get.find<ChatController>();

  AuthController get getAuthController => Get.find<AuthController>();

  ChatStream dataService = ChatStream();

  final TextEditingController _searchController = TextEditingController();

  final ValueNotifier _searchNotifier = ValueNotifier(true);

  // final ValueNotifier _singleChatListNotifier = ValueNotifier(true);
  // final ValueNotifier _groupChatListNotifier = ValueNotifier(true);

  RxBool groupChatLoading = false.obs;
  RxBool singleChatListLoading = false.obs;

  final List<UserInfoModel> userList = [];
  final List<Tab> tabs = const <Tab>[
    Tab(text: "Rent"),
    Tab(text: "Lend"),
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);

    getChatController.fetchGroupList(nullSnapShots: true);
    getChatController.fetchSingleChats(nullSnapShots: true);

    // dataService.getGroupList().then((value) => dataService.getSingleChats());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: CustomText(
            txtTitle: "Conversations",
            style: TextStyleDecoration.appBarTitle,
          ),
          // actions: [
          //   Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           Get.toNamed("AppsUserListScreen");
          //           // Get.to(() => AppsUserListScreen());
          //         },
          //         child: Container(
          //           height: 32,
          //           width: 32,
          //           margin: const EdgeInsets.only(right: 20),
          //           decoration: BoxDecoration(
          //             color: custMaterialPrimaryColor,
          //             borderRadius: BorderRadius.circular(
          //               10,
          //             ),
          //           ),
          //           child: CustImage(
          //             imgURL: ImgName.add,
          //             height: 10,
          //             width: 10,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const SizedBox(
            //   height: 20,
            // ),

            /// Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchTextFormField(),
            ),
            const SizedBox(
              height: 30,
            ),

            ///Tab bar
            Container(
              height: 38,
              // width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: custBlack102339.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                unselectedLabelColor: custBlack102339WithOpacity,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BubbleTabIndicator(
                  padding: EdgeInsets.zero,
                  insets: EdgeInsets.zero,
                  indicatorRadius: 10.00,
                  indicatorHeight: 38.0,
                  indicatorColor: primaryColor,
                  tabBarIndicatorSize: TabBarIndicatorSize.label,
                ),
                tabs: const [
                  Tab(text: "Rent"),
                  Tab(text: "Lend"),
                ],
                onTap: (index) async {
                  switch (index) {
                    case 0:
                      // await dataService.getSingleChats();
                      getChatController.closeGroupListStream();
                      break;
                    case 1:
                      // await dataService.getGroupList();
                      getChatController.closeSingleChatListStream();
                      break;
                  }
                },
                // controller: _tabController,
              ),
            ),

            Expanded(
              child:
                  getAuthController.guest.value ?
                       const Center(child: Text('Sign in for using chat')) :
              ValueListenableBuilder(
                valueListenable: _searchNotifier,
                builder: (context, val, child) {
                  debugPrint('tab val is ${val}');
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      GetBuilder<ChatController>(
                        init: ChatController(),
                        builder: (chatController) {
                          List<UserInfoModel> list = [];
                          list = chatController.getSingleChatRecentList;

                          list = list
                              .where(
                                (element) =>
                                    element.name.toLowerCase().contains(
                                          _searchController.text.toLowerCase(),
                                        ),
                              )
                              .toList();

                          return chatController.loadSingleChatList.value
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
                                        await chatController.fetchSingleChats();
                                      },
                                      child: Obx(() {
                                        return LazyLoadScrollView(
                                          scrollOffset: 150,
                                          onEndOfPage: () async {
                                            await chatController
                                                .fetchSingleChats(
                                              forLazyLoad: true,
                                            );
                                          },
                                          child: ListView.builder(
                                            padding: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            itemCount: getChatController
                                                    .loadLazyLoadForSingleChat
                                                    .value
                                                ? list.length + 1
                                                : list.length,
                                            itemBuilder: (context, index) => (list
                                                            .length ==
                                                        index) &&
                                                    getChatController
                                                        .loadLazyLoadForSingleChat
                                                        .value
                                                ? Spinner()
                                                : ChatCard(
                                                    chatId: list[index].chatId,
                                                    isLender:
                                                        _tabController?.index ==
                                                                0
                                                            ? false
                                                            : true,
                                                    userInfoModel: list[index],
                                                    isForSingleChat: true,
                                                    // showCount: false,
                                                  ),
                                          ),
                                        );
                                      }),
                                    );
                        },
                      ),
                      GetBuilder<ChatController>(
                        init: ChatController(),
                        builder: (chatController) {
                          List<UserInfoModel> list = [];
                          list = chatController.getGroupRecentList;

                          list = list
                              .where(
                                (element) =>
                                    element.name.toLowerCase().contains(
                                          _searchController.text.toLowerCase(),
                                        ),
                              )
                              .toList();

                          return chatController.loadGroupList.value
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
                                        await chatController.fetchGroupList();
                                      },
                                      child: LazyLoadScrollView(
                                        scrollOffset: 150,
                                        onEndOfPage: () async {
                                          if (groupChatLoading.value) return;
                                          groupChatLoading.value = true;
                                          await getChatController
                                              .fetchGroupList(
                                            forLazyLoad: true,
                                          );

                                          groupChatLoading.value = false;
                                        },
                                        child: Obx(() {
                                          return ListView.builder(
                                            padding: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            itemCount: groupChatLoading.value
                                                ? list.length + 1
                                                : list.length,
                                            itemBuilder: (context, index) =>
                                                (list.length == index) &&
                                                        groupChatLoading.value
                                                    ? Spinner()
                                                    : ChatCard(
                                                  chatId: list[index].chatId,
                                                        isLender: true,
                                                        userInfoModel:
                                                            list[index],
                                                        onTap: () {
                                                          Get.toNamed(
                                                            "GroupWiseChatListScreen",
                                                            arguments:
                                                                list[index].id,
                                                          );
                                                        },

                                                        // showCount: false,
                                                      ),
                                          );
                                        }),
                                      ),
                                    );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            // StreamBuilder(
            //   stream: getChatController.getRecentChat(),
            //   //chatController.recentChatRef.snapshots(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
            //           snapshot) {
            //     List<UserInfoModel> list = [];
            //     snapshot.data?.docs.forEach((element) {
            //       List<dynamic> tempMemberList = element.data()["users"];

            //       list.add(UserInfoModel.fromJson(element.data()));

            //       int index = tempMemberList.indexWhere((element) {
            //         return element != getAuthController.getUserInfo.id;
            //       });

            //       if (index >= 0) {
            //         userList.add(UserInfoModel.fromJson(
            //             element.data()["${tempMemberList[index]}"]));
            //       }
            //     });

            //     return userList.isEmpty
            //         ? EmptyScreenUi(
            //             imgUrl: ImgName.noChatBg,
            //             height: 324.24,
            //             title: StaticString.nothingHere,
            //             description: StaticString.pickPerson,
            //           )
            //         : RefreshIndicator(
            //             onRefresh: () async {
            //               Get.find<ChatController>().getRecentChat();
            //             },
            //             child: ListView.builder(
            //               itemCount: userList.length,
            //               itemBuilder: (context, index) => ChatCard(
            //                 userInfoModel: userList[index],
            //                 // showCount: false,
            //               ),
            //             ),
            //           );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  /// Search Text Form Field
  Widget _buildSearchTextFormField() {
    return SizedBox(
      height: 38,
      child: TextFormField(
        controller: _searchController,
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
