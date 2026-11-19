// To parse this JSON data, do
//
//     final advancedSearchModel = advancedSearchModelFromJson(jsonString);

import 'dart:convert';

AdvancedSearchModel advancedSearchModelFromJson(String str) => AdvancedSearchModel.fromJson(json.decode(str));

String advancedSearchModelToJson(AdvancedSearchModel data) => json.encode(data.toJson());

class AdvancedSearchModel {
    bool success;
    Data data;

    AdvancedSearchModel({
        required this.success,
        required this.data,
    });

    factory AdvancedSearchModel.fromJson(Map<String, dynamic> json) => AdvancedSearchModel(
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
    List<dynamic> profiles;
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
        profiles: List<dynamic>.from(json["profiles"].map((x) => x)),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "search_criteria": searchCriteria.toJson(),
        "saved_search": savedSearch,
        "sort_by": sortBy,
        "total": total,
        "profiles": List<dynamic>.from(profiles.map((x) => x)),
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
