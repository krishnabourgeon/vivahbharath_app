// To parse this JSON data, do
//
//     final signUpVerifyOtpModel = signUpVerifyOtpModelFromJson(jsonString);

import 'dart:convert';

SignUpVerifyOtpModel signUpVerifyOtpModelFromJson(String str) => SignUpVerifyOtpModel.fromJson(json.decode(str));

String signUpVerifyOtpModelToJson(SignUpVerifyOtpModel data) => json.encode(data.toJson());

class SignUpVerifyOtpModel {
    bool status;
    String message;
    Data data;

    SignUpVerifyOtpModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory SignUpVerifyOtpModel.fromJson(Map<String, dynamic> json) => SignUpVerifyOtpModel(
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

    Data({
        required this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
