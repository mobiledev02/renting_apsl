import 'package:flutter/cupertino.dart';
import 'package:renting_app_mobile/models/user_model.dart';

class ReviewModel {
  double rating;
  String text;
  int lenderId;
  int rentId;
  int renterId;
  String? email;
  String? itemServiceName;
  int? itemServiceId;
  String? name;
  UserInfoModel? givenBy;

  ReviewModel(
      {required this.rating,
      required this.text,
      this.givenBy,
      this.itemServiceId,
      this.itemServiceName,
      required this.renterId,
      required this.lenderId,
      required this.rentId});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'].toDouble(),
      text: json['review'],
      itemServiceId: json['item_id'],
      itemServiceName: json['item_service_name'],
      renterId: json['renter_id'],
      lenderId: json['lender_id'],
      rentId: json['item_service_rent_id'] ?? 0,
      givenBy: parseGivenBy(json['given_by']),
    );
  }

  static UserInfoModel? parseGivenBy(Map<String, dynamic> json) {
    try {
      debugPrint('user $json');
      final UserInfoModel user = UserInfoModel.fromJsonReviewerProfile(json);
      // debugPrint('given by profile ${user.}');
      return user;
    } catch (e, st) {
      debugPrint('error fetching user info in review $e $st');
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'review': text,
        'lender_id': lenderId,
        'rent_id': rentId,
      };
}
