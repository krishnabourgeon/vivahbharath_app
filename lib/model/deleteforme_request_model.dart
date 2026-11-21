// To parse this JSON data, do
//
//     final deleteformeRequestModel = deleteformeRequestModelFromJson(jsonString);

import 'dart:convert';

DeleteformeRequestModel deleteformeRequestModelFromJson(String str) => DeleteformeRequestModel.fromJson(json.decode(str));

String deleteformeRequestModelToJson(DeleteformeRequestModel data) => json.encode(data.toJson());

class DeleteformeRequestModel {
    bool success;
    String message;
    Data data;

    DeleteformeRequestModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory DeleteformeRequestModel.fromJson(Map<String, dynamic> json) => DeleteformeRequestModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Counts counts;

    Data({
        required this.counts,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        counts: Counts.fromJson(json["counts"]),
    );

    Map<String, dynamic> toJson() => {
        "counts": counts.toJson(),
    };
}

class ByType {
    Counts name;
    Counts photo;
    Counts number;
    Counts horoscope;

    ByType({
        required this.name,
        required this.photo,
        required this.number,
        required this.horoscope,
    });

    factory ByType.fromJson(Map<String, dynamic> json) => ByType(
        name: Counts.fromJson(json["name"]),
        photo: Counts.fromJson(json["photo"]),
        number: Counts.fromJson(json["number"]),
        horoscope: Counts.fromJson(json["horoscope"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name.toJson(),
        "photo": photo.toJson(),
        "number": number.toJson(),
        "horoscope": horoscope.toJson(),
    };
}

class Counts {
    Received total;
    Received received;
    Received sent;
    ByType? byType;

    Counts({
        required this.total,
        required this.received,
        required this.sent,
        this.byType,
    });

    factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        total: Received.fromJson(json["total"]),
        received: Received.fromJson(json["received"]),
        sent: Received.fromJson(json["sent"]),
        byType: json["by_type"] == null ? null : ByType.fromJson(json["by_type"]),
    );

    Map<String, dynamic> toJson() => {
        "total": total.toJson(),
        "received": received.toJson(),
        "sent": sent.toJson(),
        "by_type": byType?.toJson(),
    };
}

class Received {
    int all;
    int pending;
    int accepted;
    int declined;
    int? withdrawn;

    Received({
        required this.all,
        required this.pending,
        required this.accepted,
        required this.declined,
        this.withdrawn,
    });

    factory Received.fromJson(Map<String, dynamic> json) => Received(
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
