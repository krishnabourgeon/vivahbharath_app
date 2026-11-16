// To parse this JSON data, do
//
//     final verifyOtpModel = verifyOtpModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
    String message;
    String token;
    Customer customer;

    VerifyOtpModel({
        required this.message,
        required this.token,
        required this.customer,
    });

    // Supports both the old flat reply ({message, token, customer}) and the
    // wrapped one ({status, message, data: {token, customer}}).
    factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
        final body = json["data"] is Map<String, dynamic>
            ? json["data"] as Map<String, dynamic>
            : json;
        return VerifyOtpModel(
            message: (json["message"] ?? body["message"] ?? '').toString(),
            token: (body["token"] ?? body["access_token"] ?? '').toString(),
            customer: Customer.fromJson(
                (body["customer"] ?? body["user"] ?? <String, dynamic>{})
                    as Map<String, dynamic>),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "customer": customer.toJson(),
    };
}

class Customer {
    int id;
    String name;
    String mobileNumber;
    // Not always sent by the API; used to pick the default avatar.
    dynamic gender;

    Customer({
        required this.id,
        required this.name,
        required this.mobileNumber,
        this.gender,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"] ?? 0,
        name: (json["name"] ?? '').toString(),
        mobileNumber: (json["mobile_number"] ?? json["mobile"] ?? '').toString(),
        gender: json["gender"] ?? json["gender_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile_number": mobileNumber,
        if (gender != null) "gender": gender,
    };
}
