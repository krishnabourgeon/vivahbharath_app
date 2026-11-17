// To parse this JSON data, do
//
//     final basicSearchBody = basicSearchBodyFromJson(jsonString);

import 'dart:convert';

BasicSearchBody basicSearchBodyFromJson(String str) => BasicSearchBody.fromJson(json.decode(str));

String basicSearchBodyToJson(BasicSearchBody data) => json.encode(data.toJson());

class BasicSearchBody {
    int ageFrom;
    int ageTo;
    int heightFrom;
    int heightTo;
    int religionId;
    int motherTongueId;
    int maritalStatusId;
    int page;
    int perPage;

    BasicSearchBody({
        required this.ageFrom,
        required this.ageTo,
        required this.heightFrom,
        required this.heightTo,
        required this.religionId,
        required this.motherTongueId,
        required this.maritalStatusId,
        required this.page,
        required this.perPage,
    });

    factory BasicSearchBody.fromJson(Map<String, dynamic> json) => BasicSearchBody(
        ageFrom: json["age_from"],
        ageTo: json["age_to"],
        heightFrom: json["height_from"],
        heightTo: json["height_to"],
        religionId: json["religion_id"],
        motherTongueId: json["mother_tongue_id"],
        maritalStatusId: json["marital_status_id"],
        page: json["page"],
        perPage: json["per_page"],
    );

    Map<String, dynamic> toJson() => {
        "age_from": ageFrom,
        "age_to": ageTo,
        "height_from": heightFrom,
        "height_to": heightTo,
        "religion_id": religionId,
        "mother_tongue_id": motherTongueId,
        "marital_status_id": maritalStatusId,
        "page": page,
        "per_page": perPage,
    };
}
