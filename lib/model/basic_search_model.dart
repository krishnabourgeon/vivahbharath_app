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
    SearchCriteria searchCriteria;
    dynamic savedSearch;
    String sortBy;
    int total;
    List<Profile> profiles;
    Pagination pagination;

    Data({
        required this.searchCriteria,
        required this.savedSearch,
        required this.sortBy,
        required this.total,
        required this.profiles,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        searchCriteria: SearchCriteria.fromJson(json["search_criteria"]),
        savedSearch: json["saved_search"],
        sortBy: json["sort_by"],
        total: json["total"],
        profiles: List<Profile>.from(json["profiles"].map((x) => Profile.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "search_criteria": searchCriteria.toJson(),
        "saved_search": savedSearch,
        "sort_by": sortBy,
        "total": total,
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
    String heightText;
    String profession;
    String education;
    bool verified;
    bool isVerified;
    bool isIdVerified;
    String motherTongue;
    String? community;
    String city;
    String location;
    String? imageUrl;
    bool isPhotoHidden;
    int photoCount;
    bool isOnline;
    String? lastSeen;
    bool isPremium;
    bool isFeatured;
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

class SearchCriteria {
    String type;
    String title;
    int filterCount;
    List<Filter> filters;

    SearchCriteria({
        required this.type,
        required this.title,
        required this.filterCount,
        required this.filters,
    });

    factory SearchCriteria.fromJson(Map<String, dynamic> json) => SearchCriteria(
        type: json["type"],
        title: json["title"],
        filterCount: json["filter_count"],
        filters: List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "filter_count": filterCount,
        "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
    };
}

class Filter {
    String label;
    String value;
    List<String> keys;

    Filter({
        required this.label,
        required this.value,
        required this.keys,
    });

    factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        label: json["label"],
        value: json["value"],
        keys: List<String>.from(json["keys"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "keys": List<dynamic>.from(keys.map((x) => x)),
    };
}
