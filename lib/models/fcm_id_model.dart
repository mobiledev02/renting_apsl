import 'dart:convert';

// FcmIdModel fcmIdModelFromJson(String str) => FcmIdModel.fromJson(
//       json.decode(
//         str,
//       ),
//     );

// String fcmIdModelToJson(FcmIdModel data) => json.encode(
//       data.toJson(),
//     );

// List<FcmIdModel> listOfFcmIdModelFromJson(String str) => List<FcmIdModel>.from(
//       json.decode(str).map(
//             (x) => FcmIdModel.fromJson(
//               x,
//             ),
//           ),
//     );

// String listOfFcmIdModelToJson(List<FcmIdModel> data) => json.encode(
//       List<dynamic>.from(
//         data.map(
//           (x) => x.toJson(),
//         ),
//       ),
//     );

List<Map<String, dynamic>> listOfFcmInMapFormate(List<FcmIdModel> modelList) =>
    List<Map<String, dynamic>>.from(
      modelList.map(
        (x) => x.toJson(),
      ),
    );

class FcmIdModel {
  FcmIdModel({
    this.token = "",
    this.deviceId = "",
  });

  String? token;
  String? deviceId;

  factory FcmIdModel.fromJson(Map<String, dynamic> json) => FcmIdModel(
        token: json["fcm_id"] ?? "",
        deviceId: json["device_id"] != null ? json['device_id'].toString() : "",
      );

  Map<String, dynamic> toJson() => {
        "fcm_id": token,
        "device_id": deviceId,
      };
}
