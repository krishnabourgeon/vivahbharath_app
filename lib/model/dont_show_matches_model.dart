// To parse this JSON data, do
//
//     final dontShowMatchesModel = dontShowMatchesModelFromJson(jsonString);

import 'dart:convert';

DontShowMatchesModel dontShowMatchesModelFromJson(String str) => DontShowMatchesModel.fromJson(json.decode(str));

String dontShowMatchesModelToJson(DontShowMatchesModel data) => json.encode(data.toJson());

class DontShowMatchesModel {
    List<Match> matches;
    int offset;
    int limit;
    int count;

    DontShowMatchesModel({
        required this.matches,
        required this.offset,
        required this.limit,
        required this.count,
    });

    factory DontShowMatchesModel.fromJson(Map<String, dynamic> json) => DontShowMatchesModel(
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
    int age;
    String height;
    dynamic motherTongue;
    String community;
    String location;
    String imageUrl;
    int interestStatus;
    bool alreadyConnected;

    Match({
        required this.id,
        required this.name,
        required this.age,
        required this.height,
        required this.motherTongue,
        required this.community,
        required this.location,
        required this.imageUrl,
        required this.interestStatus,
        required this.alreadyConnected,
    });

    factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json["id"],
        name: json["name"],
        age: json["age"],
        height: json["height"],
        motherTongue: json["mother_tongue"],
        community: json["community"],
        location: json["location"],
        imageUrl: json["image_url"],
        interestStatus: json["interest_status"],
        alreadyConnected: json["already_connected"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
        "height": height,
        "mother_tongue": motherTongue,
        "community": community,
        "location": location,
        "image_url": imageUrl,
        "interest_status": interestStatus,
        "already_connected": alreadyConnected,
    };
}
