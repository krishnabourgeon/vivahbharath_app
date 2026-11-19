// To parse this JSON data, do
//
//     final advancedSearchBody = advancedSearchBodyFromJson(jsonString);

import 'dart:convert';

AdvancedSearchBody advancedSearchBodyFromJson(String str) => AdvancedSearchBody.fromJson(json.decode(str));

String advancedSearchBodyToJson(AdvancedSearchBody data) => json.encode(data.toJson());

class AdvancedSearchBody {
    int ageFrom;
    int ageTo;
    int religionId;
    List<int> casteIds;
    List<int> stateIds;
    List<int> cityIds;
    List<int> qualificationIds;
    List<int> occupationIds;
    List<int> languagesKnownIds;
    String drinking;
    String smoking;
    bool acceptMajorSurgeryOrTransplant;
    bool withPhotoOnly;
    String profileCreated;
    String sortBy;
    int page;
    int perPage;

    AdvancedSearchBody({
        required this.ageFrom,
        required this.ageTo,
        required this.religionId,
        required this.casteIds,
        required this.stateIds,
        required this.cityIds,
        required this.qualificationIds,
        required this.occupationIds,
        required this.languagesKnownIds,
        required this.drinking,
        required this.smoking,
        required this.acceptMajorSurgeryOrTransplant,
        required this.withPhotoOnly,
        required this.profileCreated,
        required this.sortBy,
        required this.page,
        required this.perPage,
    });

    factory AdvancedSearchBody.fromJson(Map<String, dynamic> json) => AdvancedSearchBody(
        ageFrom: json["age_from"],
        ageTo: json["age_to"],
        religionId: json["religion_id"],
        casteIds: List<int>.from(json["caste_ids"].map((x) => x)),
        stateIds: List<int>.from(json["state_ids"].map((x) => x)),
        cityIds: List<int>.from(json["city_ids"].map((x) => x)),
        qualificationIds: List<int>.from(json["qualification_ids"].map((x) => x)),
        occupationIds: List<int>.from(json["occupation_ids"].map((x) => x)),
        languagesKnownIds: List<int>.from(json["languages_known_ids"].map((x) => x)),
        drinking: json["drinking"],
        smoking: json["smoking"],
        acceptMajorSurgeryOrTransplant: json["accept_major_surgery_or_transplant"],
        withPhotoOnly: json["with_photo_only"],
        profileCreated: json["profile_created"],
        sortBy: json["sort_by"],
        page: json["page"],
        perPage: json["per_page"],
    );

    Map<String, dynamic> toJson() => {
        "age_from": ageFrom,
        "age_to": ageTo,
        "religion_id": religionId,
        "caste_ids": List<dynamic>.from(casteIds.map((x) => x)),
        "state_ids": List<dynamic>.from(stateIds.map((x) => x)),
        "city_ids": List<dynamic>.from(cityIds.map((x) => x)),
        "qualification_ids": List<dynamic>.from(qualificationIds.map((x) => x)),
        "occupation_ids": List<dynamic>.from(occupationIds.map((x) => x)),
        "languages_known_ids": List<dynamic>.from(languagesKnownIds.map((x) => x)),
        "drinking": drinking,
        "smoking": smoking,
        "accept_major_surgery_or_transplant": acceptMajorSurgeryOrTransplant,
        "with_photo_only": withPhotoOnly,
        "profile_created": profileCreated,
        "sort_by": sortBy,
        "page": page,
        "per_page": perPage,
    };
}
