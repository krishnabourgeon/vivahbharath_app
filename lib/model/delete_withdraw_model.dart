// To parse this JSON data, do
//
//     final deleteWithdrawModel = deleteWithdrawModelFromJson(jsonString);

import 'dart:convert';

DeleteWithdrawModel deleteWithdrawModelFromJson(String str) => DeleteWithdrawModel.fromJson(json.decode(str));

String deleteWithdrawModelToJson(DeleteWithdrawModel data) => json.encode(data.toJson());

class DeleteWithdrawModel {
    bool success;
    String message;

    DeleteWithdrawModel({
        required this.success,
        required this.message,
    });

    factory DeleteWithdrawModel.fromJson(Map<String, dynamic> json) => DeleteWithdrawModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
