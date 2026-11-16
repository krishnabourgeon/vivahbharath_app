// To parse this JSON data, do
//
//     final basicInfoModel = basicInfoModelFromJson(jsonString);

import 'dart:convert';

BasicInfoModel basicInfoModelFromJson(String str) => BasicInfoModel.fromJson(json.decode(str));

String basicInfoModelToJson(BasicInfoModel data) => json.encode(data.toJson());

class BasicInfoModel {
    String message;
    Data data;

    BasicInfoModel({
        required this.message,
        required this.data,
    });

    factory BasicInfoModel.fromJson(Map<String, dynamic> json) => BasicInfoModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int customerId;
    String email;
    String uniqueCode;
    DateTime dob;
    int genderId;

    Data({
        required this.customerId,
        required this.email,
        required this.uniqueCode,
        required this.dob,
        required this.genderId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        customerId: json["customer_id"],
        email: json["email"],
        uniqueCode: json["unique_code"],
        dob: _parseDob(json["dob"]),
        genderId: json["gender_id"],
    );

    Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "email": email,
        "unique_code": uniqueCode,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "gender_id": genderId,
    };
}

// Accepts "yyyy-MM-dd" (ISO) and "dd-MM-yyyy" (the API's d-m-Y).
DateTime _parseDob(dynamic value) {
    final s = (value ?? '').toString();
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    final p = s.split(RegExp(r'[-/]'));
    if (p.length == 3) {
        final d = int.tryParse(p[0]), m = int.tryParse(p[1]), y = int.tryParse(p[2]);
        if (d != null && m != null && y != null) return DateTime(y, m, d);
    }
    return DateTime(1970);
}
