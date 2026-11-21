// To parse this JSON data, do
//
//     final dontShowModel = dontShowModelFromJson(jsonString);

import 'dart:convert';

DontShowModel dontShowModelFromJson(String str) => DontShowModel.fromJson(json.decode(str));

String dontShowModelToJson(DontShowModel data) => json.encode(data.toJson());

/// Response of `POST profiles/{id}/dont-show`.
class DontShowModel {
    bool? success;
    String? message;
    Data? data;

    DontShowModel({
        this.success,
        this.message,
        this.data,
    });

    factory DontShowModel.fromJson(Map<String, dynamic> json) => DontShowModel(
        success: _bool(json["success"]),
        message: json["message"]?.toString(),
        data: json["data"] is Map
            ? Data.fromJson(Map<String, dynamic>.from(json["data"]))
            : null,
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? customerId;
    bool? isHidden;
    bool? profileAvailable;

    Data({
        this.customerId,
        this.isHidden,
        this.profileAvailable,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        customerId: json["customer_id"] is int
            ? json["customer_id"]
            : int.tryParse('${json["customer_id"]}'),
        isHidden: _bool(json["is_hidden"]),
        profileAvailable: _bool(json["profile_available"]),
    );

    Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "is_hidden": isHidden,
        "profile_available": profileAvailable,
    };
}

bool? _bool(dynamic v) {
    if (v == null) return null;
    return v == true || v == 1 || v == '1' || v == 'true';
}
