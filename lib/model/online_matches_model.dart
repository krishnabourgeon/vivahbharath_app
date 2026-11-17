// To parse this JSON data, do
//
//     final onlineMatchesModel = onlineMatchesModelFromJson(jsonString);

import 'dart:convert';

OnlineMatchesModel onlineMatchesModelFromJson(String str) => OnlineMatchesModel.fromJson(json.decode(str));

String onlineMatchesModelToJson(OnlineMatchesModel data) => json.encode(data.toJson());

class OnlineMatchesModel {
    bool status;
    String message;
    Data data;

    OnlineMatchesModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory OnlineMatchesModel.fromJson(Map<String, dynamic> json) => OnlineMatchesModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
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
        profiles: List<Profile>.from(json["profiles"].map((x) => Profile.fromJson(x))),
        offset: json["offset"],
        limit: json["limit"],
        count: json["count"],
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
    dynamic profilePhoto;
    int age;
    String gender;
    String religion;
    String education;
    String occupation;
    String location;
    bool isOnline;
    DateTime lastSeen;
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
        id: json["id"],
        profileId: json["profile_id"],
        name: json["name"],
        profilePhoto: json["profile_photo"],
        age: json["age"],
        gender: json["gender"],
        religion: json["religion"],
        education: json["education"],
        occupation: json["occupation"],
        location: json["location"],
        isOnline: json["is_online"],
        lastSeen: DateTime.parse(json["last_seen"]),
        isFeatured: json["is_featured"],
        isVerified: json["is_verified"],
        isPaidMember: json["is_paid_member"],
        isShortlisted: json["is_shortlisted"],
        isInterestSent: json["is_interest_sent"],
        isInterestReceived: json["is_interest_received"],
        isHidden: json["is_hidden"],
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
        "last_seen": lastSeen.toIso8601String(),
        "is_featured": isFeatured,
        "is_verified": isVerified,
        "is_paid_member": isPaidMember,
        "is_shortlisted": isShortlisted,
        "is_interest_sent": isInterestSent,
        "is_interest_received": isInterestReceived,
        "is_hidden": isHidden,
    };
}
