
import 'dart:convert';

ReligionMatchesModel religionMatchesModelFromJson(String str) =>
    ReligionMatchesModel.fromJson(json.decode(str));

String religionMatchesModelToJson(ReligionMatchesModel data) =>
    json.encode(data.toJson());

class ReligionMatchesModel {
  bool status;
  String message;
  Data data;

  ReligionMatchesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReligionMatchesModel.fromJson(Map<String, dynamic> json) =>
      ReligionMatchesModel(
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
        "profiles": profiles.map((x) => x.toJson()).toList(),
        "offset": offset,
        "limit": limit,
        "count": count,
      };
}

class Profile {
  int id;
  String profileId;
  String name;
  String? profilePhoto;
  int age;
  String gender;
  String religion;
  String education;
  String occupation;
  String location;
  bool isOnline;
  DateTime? lastSeen;
  bool isFeatured;
  bool isVerified;
  bool isPaidMember;
  bool isShortlisted;
  bool isInterestSent;
  bool isInterestReceived;
  bool isHidden;

  Profile({
    required this.id,
    required this.profileId,
    required this.name,
    required this.profilePhoto,
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
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] ?? 0,
        profileId: json["profile_id"] ?? "",
        name: json["name"] ?? "",
        profilePhoto: json["profile_photo"],
        age: json["age"] ?? 0,
        gender: json["gender"] ?? "",
        religion: json["religion"] ?? "",
        education: json["education"] ?? "",
        occupation: json["occupation"] ?? "",
        location: json["location"] ?? "",
        isOnline: json["is_online"] ?? false,
        lastSeen: json["last_seen"] == null
            ? null
            : DateTime.tryParse(json["last_seen"]),
        isFeatured: json["is_featured"] ?? false,
        isVerified: json["is_verified"] ?? false,
        isPaidMember: json["is_paid_member"] ?? false,
        isShortlisted: json["is_shortlisted"] ?? false,
        isInterestSent: json["is_interest_sent"] ?? false,
        isInterestReceived: json["is_interest_received"] ?? false,
        isHidden: json["is_hidden"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "name": name,
        "profile_photo": profilePhoto,
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
      };
}
