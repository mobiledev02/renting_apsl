import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/utils/date_time_util.dart';
import '/constants/img_font_color_string.dart';
import '/controller/chat_controller.dart';
import '/models/user_model.dart';
import '/screen/chat/chat_screen.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_text.dart';
import '../constants/text_style_decoration.dart';

class ChatCard extends StatelessWidget {
  final UserInfoModel userInfoModel;
  final String chatId;
  final bool isForSingleChat;
  final bool showCount;
  final bool isLender;
  final Function()? onTap;

  const ChatCard({
    Key? key,
    required this.chatId,
    required this.userInfoModel,
    this.showCount = true,
    this.onTap,
    this.isForSingleChat = false,
    required this.isLender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('chat card chat id is $chatId');
    debugPrint(
      'user info model passed ${userInfoModel.id}, ${userInfoModel.itemDetailModel?.getFirstImageModel?.imageUrl} ${userInfoModel.itemDetailModel?.unreadMessages}',
    );
    return InkWell(
      onTap: onTap ??
          () async {
            await Get.find<ChatController>().setRecentChat(
              userInfoModel,
            );
            // Get.toNamed("ChatScreen");

            Get.to(
              () => ChatScreen(
                chatId: chatId,
                isLender: isLender,
                userInfoModel: userInfoModel,
                isSingleChat: isForSingleChat,
              ),
            );
            debugPrint('chat card receiver id ${userInfoModel.id}');
            await Get.find<ChatController>()
                .updateChattingWithKeyOfPerticulerUser(
              receiversId: userInfoModel.id,
            );
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CustImage(
                imgURL: isForSingleChat
                    ? userInfoModel.profileImage.isEmpty
                        ? ImgName.noUser
                        : userInfoModel.profileImage
                    : userInfoModel
                            .itemDetailModel?.getFirstImageModel?.imageUrl ??
                        ImgName.noUser,
                boxfit: BoxFit.cover,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: isForSingleChat
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              txtTitle: userInfoModel.name,
                              style: TextStyleDecoration.font12semiBold,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (isForSingleChat)
                              CustomText(
                                txtTitle:
                                    '(${userInfoModel.chatStatus ?? 'Pending'})',
                                style: TextStyleDecoration.font12semiBold
                                    .copyWith(fontWeight: FontWeight.normal),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        CustomText(
                          txtTitle: userInfoModel.itemDetailModel?.name,
                          style: TextStyleDecoration.font12semiBold
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        CustomText(
                          txtTitle: userInfoModel.lastMessage,
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 1,
                          style: TextStyleDecoration.font12semiBold.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              txtTitle: userInfoModel.name,
                              style: TextStyleDecoration.font12semiBold,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (isForSingleChat)
                              CustomText(
                                txtTitle:
                                    '(${userInfoModel.chatStatus ?? 'Pending'})',
                                style: TextStyleDecoration.font12semiBold
                                    .copyWith(fontWeight: FontWeight.normal),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        CustomText(
                          txtTitle: userInfoModel.lastMessage,
                          textOverflow: TextOverflow.ellipsis,
                          maxLine: 1,
                          style: TextStyleDecoration.font12semiBold.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,),
                        ),
                      ],
                    ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (userInfoModel.chatCreatedDate != null)
                    Text(
                      formatDateDDMMYYYY(userInfoModel.chatCreatedDate),
                      style: TextStyle(
                        color: custBlack102339WithOpacity,
                        fontSize: 9,
                      ),
                    )
                  else
                    const SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible:
                        showCount && (userInfoModel.unreadMessageCount > 0),
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: custRedFC5A59,
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        txtTitle: userInfoModel.unreadMessageCount.toString(),
                        align: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustImage(
              imgURL: ImgName.rightAerrow,
              height: 10,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
