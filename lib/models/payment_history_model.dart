import 'dart:convert';
import '../utils/custom_extension.dart';

PaymentHistoryModel paymentHistoryModelFromJson(String str) =>
    PaymentHistoryModel.fromJson(json.decode(str));

String paymentHistoryModelToJson(PaymentHistoryModel data) =>
    json.encode(data.toJson());

List<PaymentHistoryModel> listOfPaymentHistoryModelFromJson(String str) =>
    List<PaymentHistoryModel>.from(
      json.decode(str)["dataset"].map((x) => PaymentHistoryModel.fromJson(x)),
    );

String listOfPaymentHistoryModelToJson(List<PaymentHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentHistoryModel {
  PaymentHistoryModel({
    this.id,
    this.name = "",
    this.image = "",
    this.amount = "",
    this.safetyDeposit = "",
    this.status = "",
    this.color = "",
    this.date = "",
    this.lenderAmount = "",
    required this.type
  });

  int? id;
  String name;
  String image;
  String amount;
  String safetyDeposit;
  String status;
  String color;
  String date;
  String type;
  String lenderAmount;

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryModel(
          id: json["id"],
          name: json["name"] ?? "",
          image: json["image"] ?? "",
          amount: json["amount"] ?? "",
          status: json["status"] ?? "",
          color: json["color"] ?? "",
          type: json['type'],
          safetyDeposit: json["safety_deposit"] ?? "0",
          lenderAmount: json['lender_amount'],
          date: json["date"] ?? "");

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "amount": amount,
        "status": status,
        "color": color,
        "date": date,
        "type": type
      };

  String get getDate => date.toDateFormat(
        incommingDateFormate: "yyyy-MM-ddTHH:mm:ss",
        requiredFormat: "MMMM dd, yyyy",
      );
}
