import 'dart:convert';

import '../api/api_end_points.dart';
import '../utils/custom_extension.dart';

List<CustomUrl> customUrlListFromJson(String str) => str.isEmpty
    ? []
    : List<CustomUrl>.from(
        json.decode(str).map((x) => CustomUrl.fromJson(x)),
      );

String customUrListToJson(List<CustomUrl> data) => json.encode(
      List<dynamic>.from(
        data.map((x) => x.toJson()),
      ),
    );

class CustomUrl {
  CustomUrl({
    this.baseUrl = "",
    this.date = "",
    this.isActiveURL = false,
  });

  static const String currentlyInUse = "Currently in use";

  String baseUrl;
  String date;
  bool isActiveURL;

  factory CustomUrl.fromJson(Map<String, dynamic> json) => CustomUrl(
        baseUrl: json["base_url"] ?? "",
        date: json["date"] ?? "",
        isActiveURL: json["is_active_url"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "base_url": baseUrl,
        "date": date,
        "is_active_url": isActiveURL,
      };

  String get getBaseURLType {
    String type = "";
    switch (baseUrl) {
      case APISetup.productionURL:
        type = "Production";
        break;

      case APISetup.stagingURL:
        type = "Staging";

        break;

      case APISetup.localURL:
        type = "Local";

        break;
      default:
      // type = "Custom" + " (${date.toDateFormat()})";
    }

    return type;
  }
}
