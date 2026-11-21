// To parse this JSON data, do
//
//     final withdrawModel = withdrawModelFromJson(jsonString);

import 'dart:convert';

WithdrawModel withdrawModelFromJson(String str) => WithdrawModel.fromJson(json.decode(str));

String withdrawModelToJson(WithdrawModel data) => json.encode(data.toJson());

class WithdrawModel {
    bool success;
    String message;
    Data data;

    WithdrawModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory WithdrawModel.fromJson(Map<String, dynamic> json) => WithdrawModel(
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
    List<int> withdrawnLogIds;
    Counts counts;

    Data({
        required this.withdrawnLogIds,
        required this.counts,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        withdrawnLogIds: List<int>.from(json["withdrawn_log_ids"].map((x) => x)),
        counts: Counts.fromJson(json["counts"]),
    );

    Map<String, dynamic> toJson() => {
        "withdrawn_log_ids": List<dynamic>.from(withdrawnLogIds.map((x) => x)),
        "counts": counts.toJson(),
    };
}

class Counts {
    Received total;
    Received received;
    Received sent;

    Counts({
        required this.total,
        required this.received,
        required this.sent,
    });

    factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        total: Received.fromJson(json["total"]),
        received: Received.fromJson(json["received"]),
        sent: Received.fromJson(json["sent"]),
    );

    Map<String, dynamic> toJson() => {
        "total": total.toJson(),
        "received": received.toJson(),
        "sent": sent.toJson(),
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
