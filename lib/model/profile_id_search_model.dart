// To parse this JSON data, do
//
//     final profileIdSearchModel = profileIdSearchModelFromJson(jsonString);

import 'dart:convert';

ProfileIdSearchModel profileIdSearchModelFromJson(String str) => ProfileIdSearchModel.fromJson(json.decode(str));

String profileIdSearchModelToJson(ProfileIdSearchModel data) => json.encode(data.toJson());

class ProfileIdSearchModel {
    bool success;
    Data data;

    ProfileIdSearchModel({
        required this.success,
        required this.data,
    });

    factory ProfileIdSearchModel.fromJson(Map<String, dynamic> json) => ProfileIdSearchModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    List<Profile> profiles;

    Data({
        required this.profiles,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        profiles: List<Profile>.from(json["profiles"].map((x) => Profile.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "profiles": List<dynamic>.from(profiles.map((x) => x.toJson())),
    };
}

class Profile {
    int id;
    String profileId;
    String name;
    bool isNameHidden;
    int age;
    String height;
    String heightText;
    String profession;
    String education;
    bool verified;
    bool isVerified;
    bool isIdVerified;
    String motherTongue;
    dynamic community;
    String city;
    String location;
    String imageUrl;
    bool isPhotoHidden;
    int photoCount;
    bool isOnline;
    String lastSeen;
    bool isPremium;
    bool isFeatured;
    int interestStatus;
    bool alreadyConnected;
    bool isShortlisted;

    Profile({
        required this.id,
        required this.profileId,
        required this.name,
        required this.isNameHidden,
        required this.age,
        required this.height,
        required this.heightText,
        required this.profession,
        required this.education,
        required this.verified,
        required this.isVerified,
        required this.isIdVerified,
        required this.motherTongue,
        required this.community,
        required this.city,
        required this.location,
        required this.imageUrl,
        required this.isPhotoHidden,
        required this.photoCount,
        required this.isOnline,
        required this.lastSeen,
        required this.isPremium,
        required this.isFeatured,
        required this.interestStatus,
        required this.alreadyConnected,
        required this.isShortlisted,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        profileId: json["profile_id"],
        name: json["name"],
        isNameHidden: json["is_name_hidden"],
        age: json["age"],
        height: json["height"],
        heightText: json["height_text"],
        profession: json["profession"],
        education: json["education"],
        verified: json["verified"],
        isVerified: json["is_verified"],
        isIdVerified: json["is_id_verified"],
        motherTongue: json["mother_tongue"],
        community: json["community"],
        city: json["city"],
        location: json["location"],
        imageUrl: json["image_url"],
        isPhotoHidden: json["is_photo_hidden"],
        photoCount: json["photo_count"],
        isOnline: json["is_online"],
        lastSeen: json["last_seen"],
        isPremium: json["is_premium"],
        isFeatured: json["is_featured"],
        interestStatus: json["interest_status"],
        alreadyConnected: json["already_connected"],
        isShortlisted: json["is_shortlisted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "name": name,
        "is_name_hidden": isNameHidden,
        "age": age,
        "height": height,
        "height_text": heightText,
        "profession": profession,
        "education": education,
        "verified": verified,
        "is_verified": isVerified,
        "is_id_verified": isIdVerified,
        "mother_tongue": motherTongue,
        "community": community,
        "city": city,
        "location": location,
        "image_url": imageUrl,
        "is_photo_hidden": isPhotoHidden,
        "photo_count": photoCount,
        "is_online": isOnline,
        "last_seen": lastSeen,
        "is_premium": isPremium,
        "is_featured": isFeatured,
        "interest_status": interestStatus,
        "already_connected": alreadyConnected,
        "is_shortlisted": isShortlisted,
    };
}
