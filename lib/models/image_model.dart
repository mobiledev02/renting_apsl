import 'dart:convert';

List<ImageModel> listOfImageModelFromJson(String str) =>
    List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String listOfImageModelToJson(List<ImageModel> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class ImageModel {
  ImageModel({
    this.id,
    this.imageUrl = "",
    this.thumbnailImageUrl = "",
    this.temporaryUrl = "",
  });

  int? id;
  String imageUrl;
  String thumbnailImageUrl;
  String temporaryUrl;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        imageUrl: json["image_url"] ?? "",
        thumbnailImageUrl: json["thumbnail_image_url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "thumbnail_image_url": thumbnailImageUrl,
      };
}
