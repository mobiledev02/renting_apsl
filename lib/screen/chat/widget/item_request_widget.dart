import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/request_controller.dart';
import 'package:renting_app_mobile/controller/item_controller.dart';
import 'package:renting_app_mobile/models/item_renting_request.dart';
import 'package:renting_app_mobile/models/message_model.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';
import 'package:renting_app_mobile/widgets/custom_alert.dart';
import 'package:renting_app_mobile/widgets/custom_short_button.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';
import '../../../constants/img_font_color_string.dart';
import '../../../widgets/item_return_dialog.dart';

class ItemRequestWidget extends StatefulWidget {
  final String requestId;
  final bool isLender;

  const ItemRequestWidget(
      {Key? key, required this.requestId, required this.isLender})
      : super(key: key);

  @override
  State<ItemRequestWidget> createState() => _ItemRequestWidgetState();
}

class _ItemRequestWidgetState extends State<ItemRequestWidget> {
  Stream<DocumentSnapshot>? _requestStream;

  @override
  void initState() {
    super.initState();
    debugPrint('item request widget request id ${widget.requestId}');
    _requestStream = FirebaseFirestore.instance
        .collection(StaticString.itemRequestsCollection)
        .doc(widget.requestId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _requestStream,
      builder: (context, snapshot) {
        debugPrint('content is being updated');
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        print(snapshot.data?.data());
        if (snapshot.data != null && snapshot.data?.data() != null) {
          final itemRentingRequest = ItemRentingRequest.fromJson(
            snapshot.data!.data()! as Map<String, dynamic>,
          );
          debugPrint('object data ${itemRentingRequest.itemRequestStatus}');
          if (itemRentingRequest.itemRequestStatus ==
              ItemRequestStatus.RenterRejected) {
            return const Text('Renter declined to obtain item');
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Process Steps',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                            text: const TextSpan(
                                                text: 'Step 1: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      'Item is rented. This step is completed after the Renter confirms and pays to rent the item.',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ])),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: const TextSpan(
                                            text: 'Step 2: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      'Item is now with the Renter. This step is completed after the Renter has submitted a photo, confirming that the item has been delivered / picked up',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: const TextSpan(
                                            text: 'Step 3: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Item has been returned to the Lender. This step is completed after the Renter has submitted a photo, confirming that the item has been returned on time and in reasonable condition.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close'))
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                color: itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.Rented ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.RenterObtained ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.LenderCompleted ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.LenderDisputed ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.Completed
                                    ? requestProgressColor
                                    : custGrey,
                              ),
                              child: const Center(
                                child: CustomText(
                                  txtTitle: '1',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 3,
                            color: itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.RenterObtained ||
                                    itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.LenderCompleted ||
                                    itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.LenderDisputed ||
                                    itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.Completed
                                ? requestProgressColor
                                : custGrey,
                          )),
                          ClipOval(
                            child: Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                color: itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.RenterObtained ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.LenderCompleted ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.LenderDisputed ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.Completed
                                    ? requestProgressColor
                                    : custGrey,
                              ),
                              child: const Center(
                                  child: CustomText(
                                txtTitle: '2',
                              )),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 3,
                            color: itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.LenderCompleted ||
                                    itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.LenderDisputed ||
                                    itemRentingRequest.itemRequestStatus ==
                                        ItemRequestStatus.Completed
                                ? requestProgressColor
                                : custGrey,
                          )),
                          ClipOval(
                            child: Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                color: itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.LenderCompleted ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.LenderDisputed ||
                                        itemRentingRequest.itemRequestStatus ==
                                            ItemRequestStatus.Completed
                                    ? requestProgressColor
                                    : custGrey,
                              ),
                              child: const Center(
                                child: CustomText(
                                  txtTitle: '3',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.Sent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomShortButton(
                          text: 'Accept',
                          onTap: () {
                            showAlert(
                              context: context,
                              showCustomContent: true,
                              title: 'Alert',
                              signleBttnOnly: false,
                              content: CustomText(
                                  txtTitle:
                                      'Are you sure you want to accept the request of lending ${itemRentingRequest.itemDetail.name} from ${itemRentingRequest.itemDetail.getStartDate} to ${itemRentingRequest.itemDetail.getEndtDate}'),
                              leftBttnTitle: 'Accept',
                              rigthBttnTitle: 'Cancel',
                              onRightAction: () {},
                              onLeftAction: () {
                                Get.find<RequestController>().acceptRequest(
                                    itemRentingRequest.chatId,
                                    itemRentingRequest.itemId,
                                    itemRentingRequest.lenderId,
                                    itemRentingRequest.renterId);
                              },
                            );
                          },
                          backgroundColor: primaryColor,
                        ),
                        CustomShortButton(
                          text: 'Decline',
                          onTap: () {
                            showAlert(
                              context: context,
                              showCustomContent: true,
                              title: 'Alert',
                              signleBttnOnly: false,
                              content: const CustomText(
                                txtTitle:
                                    'Are you sure you want to decline this request?',
                              ),
                              leftBttnTitle: 'Decline',
                              rigthBttnTitle: 'Cancel',
                              onRightAction: () {},
                              onLeftAction: () {
                                Get.find<RequestController>()
                                    .declineRequest(itemRentingRequest.chatId);
                              },
                            );
                          },
                          backgroundColor: declineColor,
                        ),
                      ],
                    )
                  else if (widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderAccepted)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle:
                            'You have accepted this offer. Waiting for renter to accept...',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: primaryColor),
                      ),
                    )
                  else if (widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderDeclined)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle: 'You have declined this offer',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: declineColor),
                      ),
                    )
                  else if (widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: CustomShortButton(
                        text: 'Dispute',
                        onTap: () {
                          showAlert(
                            context: context,
                            showCustomContent: true,
                            title: 'Alert',
                            signleBttnOnly: false,
                            content: const CustomText(
                              txtTitle: 'Are you sure you want to dispute?',
                            ),
                            leftBttnTitle: 'Dispute',
                            rigthBttnTitle: 'Cancel',
                            onRightAction: () {},
                            onLeftAction: () async {
                              final check24Hours = 
                              await Get.find<ItemController>().
                                          checkDisputeIsValid(context, itemRentingRequest.chatId);
                              debugPrint("Checker $check24Hours");
                              if (check24Hours) {
                                showDialog(
                                    context: context,
                                    builder: (context) => ItemReturnDialog(
                                          roomId: itemRentingRequest.chatId,
                                          renter: itemRentingRequest.renterId,
                                          messageModel: MessageModel(
                                              lenderId:
                                                  itemRentingRequest.lenderId,
                                              renterId:
                                                  itemRentingRequest.renterId,),
                                        ));
                              } else {
                                Get.showSnackbar(const GetSnackBar(
                                  message: "Disputes are only supported up to 24 hours after the item is returned. Please contact support@re-lend.com if you have concerns about your lent item.",
                                  duration: Duration(seconds: 5),
                                ));
                              }
                            },
                          );
                        },
                        backgroundColor: declineColor,
                      ),
                    )
                  else if (widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.Completed)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle: 'Transaction has been completed',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: declineColor),
                      ),
                    )
                  else if (widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderDisputed)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle: 'You have disputed this rental',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: declineColor),
                      ),
                    )
                  else if (!widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderDeclined)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle: 'Offer is declined by the lender',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: declineColor),
                      ),
                    )
                  else if (!widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderAccepted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomShortButton(
                          text: 'Adjust dates',
                          onTap: () {
                            Get.back();
                            Get.toNamed(
                              "ItemDetailScreen",
                              arguments: itemRentingRequest.itemDetail.id,
                            );
                          },
                          backgroundColor: primaryColor,
                        ),
                        CustomShortButton(
                          text: 'Rent item',
                          onTap: () {
                            Get.toNamed("CheckoutScreen", arguments: [
                              itemRentingRequest.itemDetail,
                              itemRentingRequest.chatId
                            ]);
                          },
                          backgroundColor: primaryColor,
                        ),
                      ],
                    )
                  else if (!widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.Sent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomShortButton(
                          text: 'Adjust dates',
                          onTap: () {
                            Get.back();
                            Get.toNamed(
                              "ItemDetailScreen",
                              arguments: itemRentingRequest.itemDetail.id,
                            );
                          },
                          backgroundColor: primaryColor,
                        ),
                        CustomShortButton(
                          text: 'Rent item',
                          onTap: () {},
                          backgroundColor: custGrey,
                        ),
                      ],
                    )
                  else if (!widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.Completed)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle: 'Transaction has been completed',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: declineColor),
                      ),
                    )
                  else if (!widget.isLender &&
                      itemRentingRequest.itemRequestStatus ==
                          ItemRequestStatus.LenderDisputed)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CustomText(
                        txtTitle: 'This rental has been disputed by the lender',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: declineColor),
                      ),
                    )
                  else
                    const SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  void dispose() {
    _requestStream = null;
    super.dispose();
  }
}
