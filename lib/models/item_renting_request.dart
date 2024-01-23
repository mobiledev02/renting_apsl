import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import '../utils/custom_enum.dart';
import '../widgets/generic_enum.dart';

class ItemRentingRequest {
  ItemDetailModel itemDetail;
  ItemRequestStatus itemRequestStatus;
  String lenderId;
  String renterId;
  String itemId;
  ItemOrService type;
  String chatId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ItemRentingRequest({
    required this.type,
    required this.itemDetail,
    this.createdAt,
    this.updatedAt,
    required this.itemId,
    required this.chatId,
    required this.lenderId,
    required this.itemRequestStatus,
    required this.renterId,
  });

  factory ItemRentingRequest.fromJson(Map<String, dynamic> json) {
    return ItemRentingRequest(
        type: GenericEnum<ItemOrService>().getEnumValue(
          key: json["type"], // ItemOrService,
          enumValues: ItemOrService.values,
          defaultEnumValue: ItemOrService.item,
        ),
        itemRequestStatus: GenericEnum<ItemRequestStatus>().getEnumValue(
          key: json['item_request_status'],
          enumValues: ItemRequestStatus.values,
          defaultEnumValue: ItemRequestStatus.Sent,
        ),
        itemDetail: ItemDetailModel.fromFirebaseJson(json['item_detail']),
        chatId: json['chat_id'],
        lenderId: json['lender_id'],
        renterId: json['renter_id'],
        itemId: json['item_id'],
        createdAt:
            json['created_at'] != null ? json['created_at'].toDate() : null,
        updatedAt:
            json['updated_at'] != null ? json['updated_at'].toDate() : null);
  }

  Map<String, Object> toJson() => {
        'type': type.getEnumName,
        'chat_id': chatId,
        'item_request_status': itemRequestStatus.getEnumName,
        'renter_id': renterId,
        'item_detail': itemDetail.toFirebaseJson(),
        'lender_id': lenderId,
        'item_id': itemId,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      };
}
