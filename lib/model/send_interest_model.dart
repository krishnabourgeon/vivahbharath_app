// To parse this JSON data, do
//
//     final sendInterestModel = sendInterestModelFromJson(jsonString);

import 'dart:convert';

SendInterestModel sendInterestModelFromJson(String str) => SendInterestModel.fromJson(json.decode(str));

String sendInterestModelToJson(SendInterestModel data) => json.encode(data.toJson());

class SendInterestModel {
    bool success;
    String message;
    Data data;

    SendInterestModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SendInterestModel.fromJson(Map<String, dynamic> json) => SendInterestModel(
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
    int interestId;
    int status;

    Data({
        required this.interestId,
        required this.status,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        interestId: json["interest_id"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "interest_id": interestId,
        "status": status,
    };
}
