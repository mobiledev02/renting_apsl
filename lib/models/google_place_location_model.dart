// To parse this JSON data, do
//
//     final googlePlaceLocationModel = googlePlaceLocationModelFromJson(jsonString);

import 'dart:convert';

GooglePlaceLocationModel googlePlaceLocationModelFromJson(String str) =>
    GooglePlaceLocationModel.fromJson(json.decode(str));

String googlePlaceLocationModelToJson(GooglePlaceLocationModel data) =>
    json.encode(data.toJson());

class GooglePlaceLocationModel {
  GooglePlaceLocationModel({
    this.description = "",
    this.matchedSubstrings,
    this.placeId = "",
    this.reference = "",
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  String description;
  List<MatchedSubstring>? matchedSubstrings;
  String placeId;
  String reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;

  factory GooglePlaceLocationModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceLocationModel(
        description: json["description"] ?? "",
        matchedSubstrings: json["matched_substrings"] == null
            ? null
            : List<MatchedSubstring>.from(json["matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        placeId: json["place_id"] ?? "",
        reference: json["reference"] ?? "",
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
        terms: json["terms"] == null
            ? null
            : List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
        types: json["types"] == null
            ? null
            : List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "matched_substrings":
            List<dynamic>.from(matchedSubstrings?.map((x) => x.toJson()) ?? []),
        "place_id": placeId,
        "reference": reference,
        "structured_formatting": structuredFormatting?.toJson(),
        "terms": List<dynamic>.from(terms?.map((x) => x.toJson()) ?? []),
        "types": List<dynamic>.from(types?.map((x) => x) ?? []),
      };
}

class MatchedSubstring {
  MatchedSubstring({
    this.length,
    this.offset,
  });

  int? length;
  int? offset;

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"] ?? 0,
        offset: json["offset"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    this.mainText = "",
    this.mainTextMatchedSubstrings,
    this.secondaryText = "",
  });

  String mainText;
  List<MatchedSubstring>? mainTextMatchedSubstrings;
  String secondaryText;

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"] ?? "",
        mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null
            ? null
            : List<MatchedSubstring>.from(json["main_text_matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": List<dynamic>.from(
            mainTextMatchedSubstrings?.map((x) => x.toJson()) ?? []),
        "secondary_text": secondaryText,
      };
}

class Term {
  Term({
    this.offset,
    this.value = "",
  });

  int? offset;
  String value;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json["offset"] ?? 0,
        value: json["value"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "value": value,
      };
}
