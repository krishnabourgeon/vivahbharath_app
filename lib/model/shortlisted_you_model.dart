// To parse this JSON data, do
//
//     final shortlistedYouMatchesModel = shortlistedYouMatchesModelFromJson(jsonString);

import 'dart:convert';

ShortlistedYouMatchesModel shortlistedYouMatchesModelFromJson(String str) => ShortlistedYouMatchesModel.fromJson(json.decode(str));

String shortlistedYouMatchesModelToJson(ShortlistedYouMatchesModel data) => json.encode(data.toJson());

class ShortlistedYouMatchesModel {
    List<Match> matches;
    int offset;
    int limit;
    int count;

    ShortlistedYouMatchesModel({
        required this.matches,
        required this.offset,
        required this.limit,
        required this.count,
    });

    factory ShortlistedYouMatchesModel.fromJson(Map<String, dynamic> json) => ShortlistedYouMatchesModel(
        matches: List<Match>.from(json["matches"].map((x) => Match.fromJson(x))),
        offset: json["offset"],
        limit: json["limit"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
        "offset": offset,
        "limit": limit,
        "count": count,
    };
}

class Match {
    int id;
    String name;
    bool isNameHidden;
    int age;
    dynamic height;
    String motherTongue;
    String community;
    String location;
    dynamic imageUrl;
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
        id: json["id"],
        name: json["name"],
        isNameHidden: json["is_name_hidden"],
        age: json["age"],
        height: json["height"],
        motherTongue: json["mother_tongue"],
        community: json["community"],
        location: json["location"],
        imageUrl: json["image_url"],
        isPhotoHidden: json["is_photo_hidden"],
        interestStatus: json["interest_status"],
        alreadyConnected: json["already_connected"],
        privacy: Privacy.fromJson(json["privacy"]),
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
        hideName: json["hide_name"],
        hidePhoto: json["hide_photo"],
        hideHoroscope: json["hide_horoscope"],
        hideMobile: json["hide_mobile"],
        canViewName: json["can_view_name"],
        canViewPhoto: json["can_view_photo"],
        canViewHoroscope: json["can_view_horoscope"],
        canViewMobile: json["can_view_mobile"],
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
