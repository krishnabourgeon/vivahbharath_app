// To parse this JSON data, do
//
//     final sendRequestModel = sendRequestModelFromJson(jsonString);

import 'dart:convert';

SendRequestModel sendRequestModelFromJson(String str) => SendRequestModel.fromJson(json.decode(str));

String sendRequestModelToJson(SendRequestModel data) => json.encode(data.toJson());

class SendRequestModel {
    bool success;
    String message;
    Data data;

    SendRequestModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SendRequestModel.fromJson(Map<String, dynamic> json) => SendRequestModel(
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
    int requestId;
    String requestType;
    int status;
    String statusLabel;
    int remaining;

    Data({
        required this.requestId,
        required this.requestType,
        required this.status,
        required this.statusLabel,
        required this.remaining,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        requestId: json["request_id"],
        requestType: json["request_type"],
        status: json["status"],
        statusLabel: json["status_label"],
        remaining: json["remaining"],
    );

    Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "request_type": requestType,
        "status": status,
        "status_label": statusLabel,
        "remaining": remaining,
    };
}
