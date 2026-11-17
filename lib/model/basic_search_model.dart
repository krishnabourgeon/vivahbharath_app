// To parse this JSON data, do
//
//     final basicSearchModel = basicSearchModelFromJson(jsonString);

import 'dart:convert';

BasicSearchModel basicSearchModelFromJson(String str) => BasicSearchModel.fromJson(json.decode(str));

String basicSearchModelToJson(BasicSearchModel data) => json.encode(data.toJson());

class BasicSearchModel {
    bool success;
    Data data;

    BasicSearchModel({
        required this.success,
        required this.data,
    });

    factory BasicSearchModel.fromJson(Map<String, dynamic> json) => BasicSearchModel(
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
    Pagination pagination;

    Data({
        required this.profiles,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        profiles: List<Profile>.from(json["profiles"].map((x) => Profile.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "profiles": List<dynamic>.from(profiles.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Pagination {
    int page;
    int perPage;
    int total;
    int lastPage;

    Pagination({
        required this.page,
        required this.perPage,
        required this.total,
        required this.lastPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        lastPage: json["last_page"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "last_page": lastPage,
    };
}

class Profile {
    int id;
    String profileId;
    String name;
    bool isNameHidden;
    int age;
    String height;
    String profession;
    bool verified;
    String motherTongue;
    String? community;
    String location;
    String? imageUrl;
    bool isPhotoHidden;
    int? interestStatus;
    bool alreadyConnected;
    bool isShortlisted;

    Profile({
        required this.id,
        required this.profileId,
        required this.name,
        required this.isNameHidden,
        required this.age,
        required this.height,
        required this.profession,
        required this.verified,
        required this.motherTongue,
        required this.community,
        required this.location,
        required this.imageUrl,
        required this.isPhotoHidden,
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
        profession: json["profession"],
        verified: json["verified"],
        motherTongue: json["mother_tongue"],
        community: json["community"],
        location: json["location"],
        imageUrl: json["image_url"],
        isPhotoHidden: json["is_photo_hidden"],
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
        "profession": profession,
        "verified": verified,
        "mother_tongue": motherTongue,
        "community": community,
        "location": location,
        "image_url": imageUrl,
        "is_photo_hidden": isPhotoHidden,
        "interest_status": interestStatus,
        "already_connected": alreadyConnected,
        "is_shortlisted": isShortlisted,
    };
}
