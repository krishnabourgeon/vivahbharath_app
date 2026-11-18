// To parse this JSON data, do
//
//     final signInVerifyOtpModel = signInVerifyOtpModelFromJson(jsonString);

import 'dart:convert';

import 'package:vivahbharath_app/model/sign_in_model.dart'
    show subscriptionChosenFromJson;

SignInVerifyOtpModel signInVerifyOtpModelFromJson(String str) => SignInVerifyOtpModel.fromJson(json.decode(str));

String signInVerifyOtpModelToJson(SignInVerifyOtpModel data) => json.encode(data.toJson());

class SignInVerifyOtpModel {
    bool status;
    String message;
    Data data;

    SignInVerifyOtpModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory SignInVerifyOtpModel.fromJson(Map<String, dynamic> json) => SignInVerifyOtpModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String token;
    String tokenType;
    User user;
    bool isApproved;
    String approvalStatus;
    String approvalMessage;
    dynamic approvalRemark;
    bool registrationCompleted;
    /// See [subscriptionChosenFromJson]; null = API didn't say.
    bool? subscriptionChosen;

    Data({
        required this.token,
        required this.tokenType,
        required this.user,
        required this.isApproved,
        required this.approvalStatus,
        required this.approvalMessage,
        required this.approvalRemark,
        required this.registrationCompleted,
        this.subscriptionChosen,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        tokenType: json["token_type"],
        user: User.fromJson(json["user"]),
        isApproved: json["is_approved"],
        approvalStatus: json["approval_status"],
        approvalMessage: json["approval_message"],
        approvalRemark: json["approval_remark"],
        registrationCompleted: json["registration_completed"],
        subscriptionChosen: subscriptionChosenFromJson(json),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "token_type": tokenType,
        "user": user.toJson(),
        "is_approved": isApproved,
        "approval_status": approvalStatus,
        "approval_message": approvalMessage,
        "approval_remark": approvalRemark,
        "registration_completed": registrationCompleted,
    };
}

class User {
    int id;
    String name;
    String mobile;

    User({
        required this.id,
        required this.name,
        required this.mobile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
    };
}
