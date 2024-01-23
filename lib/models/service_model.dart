import 'dart:convert';

List<ServiceModel> listOfServiceModelFromJson(String str) =>
    List<ServiceModel>.from(
      json.decode(str)["dataset"].map((x) => ServiceModel.fromJson(x)),
    );

String listOfServiceModelToJson(List<ServiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceModel {
  ServiceModel({
    this.id,
    this.name = "",
    this.price = "",
    this.userId,
    this.userName = "",
    this.userInfo = "",
    this.userStatus,
    this.jobDone = 0,
    this.userProfileImage = "",
    this.averageRating = 0,
  });

  int? id;
  String name;
  String price;
  int? userId;
  String userName;
  String userInfo;
  String? userStatus;
  int jobDone;
  String userProfileImage;
  double averageRating;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        name: json["name"] ?? "",
        price: json["price"] ?? "",
        userId: json["user_id"],
        userName: json["user_name"] ?? "",
        userInfo: json["user_info"] ?? "",
        userStatus: json['is_verified'] ?? "",
        jobDone: json["job_done"] ?? 0,
        userProfileImage: json["user_profile_image"] ?? "",
        averageRating: json["average_rating"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "user_id": userId,
        "user_name": userName,
        "user_info": userInfo,
        "job_done": jobDone,
        "user_profile_image": userProfileImage,
        "average_rating": averageRating,
      };

  String get getDoneJob => jobDone.toString() + " Job(s) Done";
  String get getAverageRating => "$averageRating Average Rating";
}
