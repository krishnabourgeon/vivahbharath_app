// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());

class SubscriptionModel {
    bool success;
    String message;
    List<Subscription> subscriptions;

    SubscriptionModel({
        required this.success,
        required this.message,
        required this.subscriptions,
    });

    factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
        success: json["success"],
        message: json["message"],
        subscriptions: List<Subscription>.from(json["subscriptions"].map((x) => Subscription.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "subscriptions": List<dynamic>.from(subscriptions.map((x) => x.toJson())),
    };
}

class Subscription {
    int id;
    String name;
    String? description;
    String rate;
    String? strikeRate;
    int contactViewLimit;
    int chatLimit;
    int nameLimit;
    int interestLimit;
    int requestLimit;
    int shortlist;
    int profileView;
    int validity;
    int level;
    int status;
    DateTime createdAt;
    DateTime updatedAt;
    int nameRequestLimit;
    int photoRequestLimit;
    int horoscopeRequestLimit;
    int numberRequestLimit;
    /// True when this plan accepts a promo code — the app then asks for one
    /// (promo code popup) before choosing the plan.
    bool hasPromocode;

    Subscription({
        required this.id,
        required this.name,
        required this.description,
        required this.rate,
        required this.strikeRate,
        required this.contactViewLimit,
        required this.chatLimit,
        required this.nameLimit,
        required this.interestLimit,
        required this.requestLimit,
        required this.shortlist,
        required this.profileView,
        required this.validity,
        required this.level,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.nameRequestLimit,
        required this.photoRequestLimit,
        required this.horoscopeRequestLimit,
        required this.numberRequestLimit,
        this.hasPromocode = false,
    });

    /// Accepts true / 1 / "1" / "true", or a non-empty promo code string.
    static bool _flag(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final t = v.trim().toLowerCase();
        return t.isNotEmpty && t != '0' && t != 'false' && t != 'null';
      }
      return false;
    }

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        rate: json["rate"],
        strikeRate: json["strike_rate"],
        contactViewLimit: json["contact_view_limit"],
        chatLimit: json["chat_limit"],
        nameLimit: json["name_limit"],
        interestLimit: json["interest_limit"],
        requestLimit: json["request_limit"],
        shortlist: json["shortlist"],
        profileView: json["profile_view"],
        validity: json["validity"],
        level: json["level"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        nameRequestLimit: json["name_request_limit"],
        photoRequestLimit: json["photo_request_limit"],
        horoscopeRequestLimit: json["horoscope_request_limit"],
        numberRequestLimit: json["number_request_limit"],
        hasPromocode: _flag(json["has_promocode"] ??
            json["is_promocode"] ??
            json["promocode_available"] ??
            json["promocode"] ??
            json["promo_code"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "rate": rate,
        "strike_rate": strikeRate,
        "contact_view_limit": contactViewLimit,
        "chat_limit": chatLimit,
        "name_limit": nameLimit,
        "interest_limit": interestLimit,
        "request_limit": requestLimit,
        "shortlist": shortlist,
        "profile_view": profileView,
        "validity": validity,
        "level": level,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name_request_limit": nameRequestLimit,
        "photo_request_limit": photoRequestLimit,
        "horoscope_request_limit": horoscopeRequestLimit,
        "number_request_limit": numberRequestLimit,
        "has_promocode": hasPromocode,
    };
}
