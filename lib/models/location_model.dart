// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.name = "",
    this.street = "",
    this.placeId = "",
    this.isoCountryCode = "",
    this.country = "",
    this.postalCode = "",
    this.administrativeArea = "",
    this.subAdministrativeArea = "",
    this.locality = "",
    this.subLocality = "",
    this.thoroughfare = "",
    this.subThoroughfare = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  String name;
  String street;
  String placeId;
  String isoCountryCode;
  String country;
  String postalCode;
  String administrativeArea;
  String subAdministrativeArea;
  String locality;
  String subLocality;
  String thoroughfare;
  String subThoroughfare;
  double latitude;
  double longitude;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json["name"] ?? "",
      street: json["street"] ?? "",
      isoCountryCode: json["isoCountryCode"] ?? "",
      country: json["country"] ?? "",
      postalCode:
          json["postalCode"] != null ? json["postalCode"].toString() : "",
      administrativeArea: json["administrativeArea"] ?? "",
      subAdministrativeArea: json["subAdministrativeArea"] ?? "",
      locality: json["locality"] ?? "",
      subLocality: json["subLocality"] ?? "",
      thoroughfare: json["thoroughfare"] ?? "",
      subThoroughfare: json["subThoroughfare"] == null
          ? ""
          : json["subThoroughfare"].toString(),
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "isoCountryCode": isoCountryCode,
        "postalCode": postalCode,
        "administrativeArea": administrativeArea,
        "locality": locality,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
      };

  Map<String, dynamic> toSignUpJson() => {
        "address": name,
        "city": locality,
        "state": administrativeArea,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "pin_code": postalCode,
      };
}
