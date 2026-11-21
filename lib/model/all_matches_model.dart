
import 'dart:convert';

AllMatchesModel allMatchesModelFromJson(String str) =>
    AllMatchesModel.fromJson(json.decode(str));

String allMatchesModelToJson(AllMatchesModel data) =>
    json.encode(data.toJson());

class AllMatchesModel {
  List<Match> matches;
  int total;
  int offset;
  int limit;

  AllMatchesModel({
    required this.matches,
    required this.total,
    required this.offset,
    required this.limit,
  });

  factory AllMatchesModel.fromJson(Map<String, dynamic> json) =>
      AllMatchesModel(
        matches: List<Match>.from(
          (json["matches"] ?? []).map((x) => Match.fromJson(x)),
        ),
        total: json["total"] ?? 0,
        offset: json["offset"] ?? 0,
        limit: json["limit"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
        "total": total,
        "offset": offset,
        "limit": limit,
      };
}

class Match {
  int id;
  String name;
  bool isNameHidden;
  int age;
  String? height;
  String? motherTongue;
  String? community;
  String? location;
  String? imageUrl;
  bool isPhotoHidden;
  dynamic interestStatus;
  bool alreadyConnected;
  Privacy privacy;

  Match({
    required this.id,
    required this.name,
    required this.isNameHidden,
    required this.age,
    required this.height,
    required this.motherTongue,
    required this.community,
    required this.location,
    required this.imageUrl,
    required this.isPhotoHidden,
    required this.interestStatus,
    required this.alreadyConnected,
    required this.privacy,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        isNameHidden: json["is_name_hidden"] ?? false,
        age: json["age"] ?? 0,
        height: json["height"],
        motherTongue: json["mother_tongue"],
        community: json["community"],
        location: json["location"],
        imageUrl: json["image_url"],
        isPhotoHidden: json["is_photo_hidden"] ?? false,
        interestStatus: json["interest_status"],
        alreadyConnected: json["already_connected"] ?? false,
        privacy: Privacy.fromJson(json["privacy"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_name_hidden": isNameHidden,
        "age": age,
        "height": height,
        "mother_tongue": motherTongue,
        "community": community,
        "location": location,
        "image_url": imageUrl,
        "is_photo_hidden": isPhotoHidden,
        "interest_status": interestStatus,
        "already_connected": alreadyConnected,
        "privacy": privacy.toJson(),
      };
}

class Privacy {
  bool hideName;
  bool hidePhoto;
  bool hideHoroscope;
  bool hideMobile;
  bool canViewName;
  bool canViewPhoto;
  bool canViewHoroscope;
  bool canViewMobile;

  Privacy({
    required this.hideName,
    required this.hidePhoto,
    required this.hideHoroscope,
    required this.hideMobile,
    required this.canViewName,
    required this.canViewPhoto,
    required this.canViewHoroscope,
    required this.canViewMobile,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
        hideName: json["hide_name"] ?? false,
        hidePhoto: json["hide_photo"] ?? false,
        hideHoroscope: json["hide_horoscope"] ?? false,
        hideMobile: json["hide_mobile"] ?? false,
        canViewName: json["can_view_name"] ?? false,
        canViewPhoto: json["can_view_photo"] ?? false,
        canViewHoroscope: json["can_view_horoscope"] ?? false,
        canViewMobile: json["can_view_mobile"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "hide_name": hideName,
        "hide_photo": hidePhoto,
        "hide_horoscope": hideHoroscope,
        "hide_mobile": hideMobile,
        "can_view_name": canViewName,
        "can_view_photo": canViewPhoto,
        "can_view_horoscope": canViewHoroscope,
        "can_view_mobile": canViewMobile,
      };
}
