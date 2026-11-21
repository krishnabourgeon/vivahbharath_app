// To parse this JSON data, do
//
//     final inboxRequestModel = inboxRequestModelFromJson(jsonString);

import 'dart:convert';

InboxRequestModel inboxRequestModelFromJson(String str) => InboxRequestModel.fromJson(json.decode(str));

String inboxRequestModelToJson(InboxRequestModel data) => json.encode(data.toJson());

class InboxRequestModel {
    bool success;
    int currentPage;
    List<InboxRequest> data;
    String firstPageUrl;
    int from;
    int lastPage;
    String lastPageUrl;
    List<Link> links;
    dynamic nextPageUrl;
    String path;
    int perPage;
    dynamic prevPageUrl;
    int to;
    int total;
    StatusCounts statusCounts;

    InboxRequestModel({
        required this.success,
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        required this.nextPageUrl,
        required this.path,
        required this.perPage,
        required this.prevPageUrl,
        required this.to,
        required this.total,
        required this.statusCounts,
    });

    factory InboxRequestModel.fromJson(Map<String, dynamic> json) => InboxRequestModel(
        success: json["success"],
        currentPage: json["current_page"],
        data: List<InboxRequest>.from(json["data"].map((x) => InboxRequest.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
        statusCounts: StatusCounts.fromJson(json["status_counts"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
        "status_counts": statusCounts.toJson(),
    };
}

class InboxRequest {
    int id;
    String profileId;
    String name;
    bool isNameHidden;
    int age;
    String height;
    String religion;
    String caste;
    String? community;
    String motherTongue;
    String education;
    String occupation;
    String city;
    String state;
    String country;
    String location;
    String? imageUrl;
    bool isPhotoHidden;
    bool verified;
    bool isOnline;
    String lastSeen;
    bool isShortlisted;
    bool profileAvailable;
    dynamic unavailableMessage;
    Privacy privacy;
    bool emailVerify;
    bool mobileVerify;
    List<TrustBadge> trustBadges;
    int requestId;
    String requestType;
    String typeLabel;
    int requestStatus;
    String statusLabel;
    String direction;
    DateTime date;
    String timeAgo;
    dynamic respondedAt;
    dynamic logId;
    bool isRemoved;
    bool canRespond;
    bool canWithdraw;
    bool canDelete;

    InboxRequest({
        required this.id,
        required this.profileId,
        required this.name,
        required this.isNameHidden,
        required this.age,
        required this.height,
        required this.religion,
        required this.caste,
        required this.community,
        required this.motherTongue,
        required this.education,
        required this.occupation,
        required this.city,
        required this.state,
        required this.country,
        required this.location,
        required this.imageUrl,
        required this.isPhotoHidden,
        required this.verified,
        required this.isOnline,
        required this.lastSeen,
        required this.isShortlisted,
        required this.profileAvailable,
        required this.unavailableMessage,
        required this.privacy,
        required this.emailVerify,
        required this.mobileVerify,
        required this.trustBadges,
        required this.requestId,
        required this.requestType,
        required this.typeLabel,
        required this.requestStatus,
        required this.statusLabel,
        required this.direction,
        required this.date,
        required this.timeAgo,
        required this.respondedAt,
        required this.logId,
        required this.isRemoved,
        required this.canRespond,
        required this.canWithdraw,
        required this.canDelete,
    });

    factory InboxRequest.fromJson(Map<String, dynamic> json) => InboxRequest(
        id: json["id"],
        profileId: json["profile_id"],
        name: json["name"],
        isNameHidden: json["is_name_hidden"],
        age: json["age"],
        height: json["height"],
        religion: json["religion"],
        caste: json["caste"],
        community: json["community"],
        motherTongue: json["mother_tongue"],
        education: json["education"],
        occupation: json["occupation"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        location: json["location"],
        imageUrl: json["image_url"],
        isPhotoHidden: json["is_photo_hidden"],
        verified: json["verified"],
        isOnline: json["is_online"],
        lastSeen: json["last_seen"],
        isShortlisted: json["is_shortlisted"],
        profileAvailable: json["profile_available"],
        unavailableMessage: json["unavailable_message"],
        privacy: Privacy.fromJson(json["privacy"]),
        emailVerify: json["email_verify"],
        mobileVerify: json["mobile_verify"],
        trustBadges: List<TrustBadge>.from(json["trust_badges"].map((x) => TrustBadge.fromJson(x))),
        requestId: json["request_id"],
        requestType: json["request_type"],
        typeLabel: json["type_label"],
        requestStatus: json["request_status"],
        statusLabel: json["status_label"],
        direction: json["direction"],
        date: DateTime.parse(json["date"]),
        timeAgo: json["time_ago"],
        respondedAt: json["responded_at"],
        logId: json["log_id"],
        isRemoved: json["is_removed"],
        canRespond: json["can_respond"],
        canWithdraw: json["can_withdraw"],
        canDelete: json["can_delete"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "name": name,
        "is_name_hidden": isNameHidden,
        "age": age,
        "height": height,
        "religion": religion,
        "caste": caste,
        "community": community,
        "mother_tongue": motherTongue,
        "education": education,
        "occupation": occupation,
        "city": city,
        "state": state,
        "country": country,
        "location": location,
        "image_url": imageUrl,
        "is_photo_hidden": isPhotoHidden,
        "verified": verified,
        "is_online": isOnline,
        "last_seen": lastSeen,
        "is_shortlisted": isShortlisted,
        "profile_available": profileAvailable,
        "unavailable_message": unavailableMessage,
        "privacy": privacy.toJson(),
        "email_verify": emailVerify,
        "mobile_verify": mobileVerify,
        "trust_badges": List<dynamic>.from(trustBadges.map((x) => x.toJson())),
        "request_id": requestId,
        "request_type": requestType,
        "type_label": typeLabel,
        "request_status": requestStatus,
        "status_label": statusLabel,
        "direction": direction,
        "date": date.toIso8601String(),
        "time_ago": timeAgo,
        "responded_at": respondedAt,
        "log_id": logId,
        "is_removed": isRemoved,
        "can_respond": canRespond,
        "can_withdraw": canWithdraw,
        "can_delete": canDelete,
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

class TrustBadge {
    String type;
    String name;
    String status;
    bool isVerified;

    TrustBadge({
        required this.type,
        required this.name,
        required this.status,
        required this.isVerified,
    });

    factory TrustBadge.fromJson(Map<String, dynamic> json) => TrustBadge(
        type: json["type"],
        name: json["name"],
        status: json["status"],
        isVerified: json["is_verified"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "status": status,
        "is_verified": isVerified,
    };
}

class Link {
    String? url;
    String label;
    bool active;

    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}

class StatusCounts {
    int all;
    int pending;
    int accepted;
    int declined;
    int withdrawn;

    StatusCounts({
        required this.all,
        required this.pending,
        required this.accepted,
        required this.declined,
        required this.withdrawn,
    });

    factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
        all: json["all"],
        pending: json["pending"],
        accepted: json["accepted"],
        declined: json["declined"],
        withdrawn: json["withdrawn"],
    );

    Map<String, dynamic> toJson() => {
        "all": all,
        "pending": pending,
        "accepted": accepted,
        "declined": declined,
        "withdrawn": withdrawn,
    };
}
