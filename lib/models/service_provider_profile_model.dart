// To parse this JSON data, do
//
//     final serviceProviderProfileModel = serviceProviderProfileModelFromJson(jsonString);

import 'dart:convert';

ServiceProviderProfileModel serviceProviderProfileModelFromJson(String str) =>
    ServiceProviderProfileModel.fromJson(json.decode(str)["data"]);

String serviceProviderProfileModelToJson(ServiceProviderProfileModel data) =>
    json.encode(data.toJson());

class ServiceProviderProfileModel {
  ServiceProviderProfileModel({
    this.id,
    this.name = "",
    this.price = "",
    this.jobDone = 0,
    this.userId,
    this.userName = "",
    this.userEmail = "",
    this.userInfo = "",
    this.userAddress = "",
    this.userProfileImage = "",
    this.images,
    this.averageRating = 0,
  });

  int? id;
  String name;
  String price;
  int jobDone;
  int? userId;
  String userName;
  String userEmail;
  String userInfo;
  String userAddress;
  String userProfileImage;
  List<String>? images;
  double averageRating;

  factory ServiceProviderProfileModel.fromJson(Map<String, dynamic> json) =>
      ServiceProviderProfileModel(
        id: json["id"],
        name: json["name"] ?? "",
        price: json["price"] ?? "",
        jobDone: json["job_done"] ?? 0,
        userId: json["user_id"],
        userName: json["user_name"] ?? "",
        userEmail: json["user_email"] ?? "",
        userInfo: json["user_info"] ?? "",
        userAddress: json["user_address"] ?? "",
        userProfileImage: json["user_profile_image"] ?? "",
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"].map((x) => x)),
        averageRating: json["average_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "job_done": jobDone,
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_info": userInfo,
        "user_address": userAddress,
        "user_profile_image": userProfileImage,
        "images": List<dynamic>.from((images ?? []).map((x) => x)),
        "average_rating": averageRating,
      };

  String get getDoneJob => "$jobDone Jobs Done 2222";

  String get getProductsFirstImage =>
      (images?.isNotEmpty ?? false) ? images![0] : "";

  String get getProductsSecondImage =>
      ((images?.length ?? 0) >= 2) ? images![1] : "";
  String get getAverageRating => "$averageRating Average Rating";
}
