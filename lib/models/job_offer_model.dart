import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/models/user_model.dart';
import 'package:renting_app_mobile/utils/custom_enum.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import '../widgets/generic_enum.dart';

class JobOfferModel {
  UserInfoModel renter;
  DateTime startDate;
  DateTime startTime;
  int maxHours;
  int id;
  OfferStatus status;
  String description;
  DateTime? loggedDate;
  DateTime? loggedStart;
  DateTime? loggedEnd;
  String? serviceId;
  String? chatId;
  ItemDetailModel? service;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? reviewed;
  UserInfoModel? serviceProvider;

  JobOfferModel(
      {required this.renter,
      required this.startTime,
      required this.startDate,
      required this.status,
      required this.id,
      required this.serviceProvider,
      required this.description,
      required this.maxHours,
      this.service,
      this.serviceId,
      this.reviewed,
      this.chatId,
      this.loggedDate,
      this.loggedEnd,
      this.loggedStart,
      this.createdAt,
      this.updatedAt});

  factory JobOfferModel.fromJson(Map<String, dynamic> json) {
    return JobOfferModel(
      chatId: json['chat_id'],

      renter: UserInfoModel.fromJson(json['renter']),
      description: json['description'],
      id: json['id'],
      maxHours: json['max_hours'],
      status: json['current_status'] != null
          ? GenericEnum<OfferStatus>().getEnumValue(
              key: json['current_status'],
              enumValues: OfferStatus.values,
              defaultEnumValue: OfferStatus.Pending,
            )
          : OfferStatus.None,
      serviceId: json['lend_item_service_id'].toString(),
      serviceProvider: json['service_provider'],
      startDate: DateTime.tryParse(json['start_date']) ?? DateTime.now(),
      startTime: DateTime.tryParse(json['start_time']) ?? DateTime.now(),
      service: json['service'] != null
          ? ItemDetailModel.fromFirebaseJson(json['service'])
          : null,
      // loggedDate: json['logged_date'],
      // loggedEnd: json['logged_end'],
      // loggedStart: json['logged_start']
    );
  }

  factory JobOfferModel.fromJsonLender(Map<String, dynamic> json) {
    return JobOfferModel(
      chatId: json['chat_id'],
      renter: UserInfoModel.fromJsonReviewerProfile(json['renter']),
      description: json['description'],
      maxHours: json['max_hours'],
      id: json['id'],
      status: json['current_status'] != null
          ? GenericEnum<OfferStatus>().getEnumValue(
              key: json['current_status'],
              enumValues: OfferStatus.values,
              defaultEnumValue: OfferStatus.Pending,
            )
          : OfferStatus.None,
      serviceId: json['lend_item_service_id'].toString(),
      serviceProvider: json['service_provider'],
      startDate: DateTime.tryParse(json['start_date']) ?? DateTime.now(),
      startTime: DateTime.tryParse(json['start_time']) ?? DateTime.now(),
      service: json['service'] != null
          ? ItemDetailModel.fromFirebaseJson(json['service'])
          : null,
      // loggedDate: json['logged_date'],
      // loggedEnd: json['logged_end'],
      // loggedStart: json['logged_start']
    );
  }

  factory JobOfferModel.fromFirebase(Map<String, dynamic> json, String id) {
    return JobOfferModel(
      chatId: json['chat_id'],
      renter: UserInfoModel.fromJsonReviewerProfile(json['renter']),
      description: json['description'],
      maxHours: json['max_hours'],
      id: int.parse(id),
      status: json['current_status'] != null
          ? GenericEnum<OfferStatus>().getEnumValue(
              key: json['current_status'],
              enumValues: OfferStatus.values,
              defaultEnumValue: OfferStatus.Pending,
            )
          : OfferStatus.None,
      serviceId: json['lend_item_service_id'].toString(),
      serviceProvider: json['service_provider'],
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      startTime: DateTime.tryParse(json['start_time'] ?? '') ?? DateTime.now(),
      service: json['service'] != null
          ? ItemDetailModel.fromFirebaseJson(json['service'])
          : null,
      createdAt:
          json['created_at'] != null ? json['created_at'].toDate() : null,
      updatedAt:
          json['updated_at'] != null ? json['updated_at'].toDate() : null,
      reviewed: json['reviewed'],
      loggedDate:
          json['logged_date'] != null ? json['logged_date'].toDate() : null,
      loggedEnd:
          json['logged_end'] != null ? json['logged_end'].toDate() : null,
      loggedStart:
          json['logged_start'] != null ? json['logged_start'].toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'renter': renter.toJson(),
        'start_date': startDate.toString(),
        'end_date': startTime.toString(),
        'max_hours': maxHours,
        'description': description,
        'chat_id': chatId,
        'service_provider': serviceProvider?.toJson()
      };

  Map<String, dynamic> toFirebaseJson() => {
        'renter': renter.toJson(),
        'start_date': startDate.toString(),
        'end_date': startTime.toString(),
        'max_hours': maxHours,
        'description': description,
        'service_provider': serviceProvider?.toJson(),
        'lend_item_service_id': serviceId,
        'service': service?.toFirebaseJson(),
        'current_status': status.getEnumName,
        'chat_id': chatId,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'reviewed': false,
      };
}
