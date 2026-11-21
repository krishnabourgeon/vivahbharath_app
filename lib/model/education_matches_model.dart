
import 'dart:convert';

EducationMatchesModel educationMatchesModelFromJson(String str) =>
    EducationMatchesModel.fromJson(json.decode(str));

String educationMatchesModelToJson(EducationMatchesModel data) =>
    json.encode(data.toJson());

class EducationMatchesModel {
  bool status;
  String message;
  Data data;

  EducationMatchesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EducationMatchesModel.fromJson(Map<String, dynamic> json) =>
      EducationMatchesModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  List<Profile> profiles;
  int offset;
  int limit;
  int count;

  Data({
    required this.profiles,
    required this.offset,
    required this.limit,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profiles: List<Profile>.from(
          (json["profiles"] ?? []).map((x) => Profile.fromJson(x)),
        ),
        offset: json["offset"] ?? 0,
        limit: json["limit"] ?? 0,
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "profiles": List<dynamic>.from(profiles.map((x) => x.toJson())),
        "offset": offset,
        "limit": limit,
        "count": count,
      };
}

class Profile {
  int id;
  String profileId;
  String name;
  bool isNameHidden;
  String? profilePhoto;
  bool isPhotoHidden;
  int age;
  String? gender;
  String? religion;
  String? education;
  String occupation;
  String? location;
  bool isOnline;
  DateTime? lastSeen;
  bool isFeatured;
  bool isVerified;
  bool isPaidMember;
  bool isShortlisted;
  bool isInterestSent;
  bool isInterestReceived;
  bool isHidden;
  Privacy privacy;

  Profile({
    required this.id,
    required this.profileId,
    required this.name,
    required this.isNameHidden,
    required this.profilePhoto,
    required this.isPhotoHidden,
    required this.age,
    required this.gender,
    required this.religion,
    required this.education,
    required this.occupation,
    required this.location,
    required this.isOnline,
    required this.lastSeen,
    required this.isFeatured,
    required this.isVerified,
    required this.isPaidMember,
    required this.isShortlisted,
    required this.isInterestSent,
    required this.isInterestReceived,
    required this.isHidden,
    required this.privacy,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] ?? 0,
        profileId: json["profile_id"] ?? "",
        name: json["name"] ?? "",
        isNameHidden: json["is_name_hidden"] ?? false,
        profilePhoto: json["profile_photo"],
        isPhotoHidden: json["is_photo_hidden"] ?? false,
        age: json["age"] ?? 0,
        gender: json["gender"],
        religion: json["religion"],
        education: json["education"],
        occupation: json["occupation"] ?? "",
        location: json["location"],
        isOnline: json["is_online"] ?? false,
        lastSeen: json["last_seen"] == null
            ? null
            : DateTime.tryParse(json["last_seen"].toString()),
        isFeatured: json["is_featured"] ?? false,
        isVerified: json["is_verified"] ?? false,
        isPaidMember: json["is_paid_member"] ?? false,
        isShortlisted: json["is_shortlisted"] ?? false,
        isInterestSent: json["is_interest_sent"] ?? false,
        isInterestReceived: json["is_interest_received"] ?? false,
        isHidden: json["is_hidden"] ?? false,
        privacy: Privacy.fromJson(json["privacy"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "name": name,
        "is_name_hidden": isNameHidden,
        "profile_photo": profilePhoto,
        "is_photo_hidden": isPhotoHidden,
        "age": age,
        "gender": gender,
        "religion": religion,
        "education": education,
        "occupation": occupation,
        "location": location,
        "is_online": isOnline,
        "last_seen": lastSeen?.toIso8601String(),
        "is_featured": isFeatured,
        "is_verified": isVerified,
        "is_paid_member": isPaidMember,
        "is_shortlisted": isShortlisted,
        "is_interest_sent": isInterestSent,
        "is_interest_received": isInterestReceived,
        "is_hidden": isHidden,
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
