
import 'dart:convert';

PaymentRequestModel paymentRequestModelFromJson(String str) =>
    PaymentRequestModel.fromJson(json.decode(str));

String paymentRequestModelToJson(PaymentRequestModel data) =>
    json.encode(data.toJson());

class PaymentRequestModel {
  PaymentRequestModel({
    this.lendItemServiceId = "",
    this.startDate = "",
    this.endDate = "",
    this.startTime = "",
    this.endTime = "",
    this.paymentId = "",
    this.totalPayment = "",
    this.nonce = "",
    this.deviceData = "",
    this.paymentMethod = "",
  });

  String lendItemServiceId;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String totalPayment;
  String nonce;
  String deviceData;
  String paymentId;
  String paymentMethod;

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) =>
      PaymentRequestModel(
        lendItemServiceId: json["lend_item_service_id"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
        paymentId: json["payment_id"] ?? "",
        totalPayment: json["total_payment"] ?? "",
        nonce: json["nonce"] ?? "",
        deviceData: json["device_data"] ?? "",
        paymentMethod: json["payment_method"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "lend_item_service_id": lendItemServiceId,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "total_payment": totalPayment,
        "nonce": nonce,
        "device_data": deviceData,
        "payment_method": paymentMethod,
        "payment_id": paymentId,
      };
}
