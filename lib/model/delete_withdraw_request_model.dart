// To parse this JSON data, do
//
//     final deleteWithdrawRequestModel = deleteWithdrawRequestModelFromJson(jsonString);

import 'dart:convert';

DeleteWithdrawRequestModel deleteWithdrawRequestModelFromJson(String str) => DeleteWithdrawRequestModel.fromJson(json.decode(str));

String deleteWithdrawRequestModelToJson(DeleteWithdrawRequestModel data) => json.encode(data.toJson());

class DeleteWithdrawRequestModel {
    bool success;
    String message;

    DeleteWithdrawRequestModel({
        required this.success,
        required this.message,
    });

    factory DeleteWithdrawRequestModel.fromJson(Map<String, dynamic> json) => DeleteWithdrawRequestModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
