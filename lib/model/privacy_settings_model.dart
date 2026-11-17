// To parse this JSON data, do
//
//     final privacySettingsModel = privacySettingsModelFromJson(jsonString);

import 'dart:convert';

PrivacySettingsModel privacySettingsModelFromJson(String str) => PrivacySettingsModel.fromJson(json.decode(str));

String privacySettingsModelToJson(PrivacySettingsModel data) => json.encode(data.toJson());

class PrivacySettingsModel {
    bool success;
    String message;
    Data data;

    PrivacySettingsModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) => PrivacySettingsModel(
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
    bool hideName;
    bool hidePhoto;
    bool hideHoroscope;
    bool hideMobile;
    bool horoscopeAvailable;

    Data({
        required this.hideName,
        required this.hidePhoto,
        required this.hideHoroscope,
        required this.hideMobile,
        required this.horoscopeAvailable,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        hideName: json["hide_name"],
        hidePhoto: json["hide_photo"],
        hideHoroscope: json["hide_horoscope"],
        hideMobile: json["hide_mobile"],
        horoscopeAvailable: json["horoscope_available"],
    );

    Map<String, dynamic> toJson() => {
        "hide_name": hideName,
        "hide_photo": hidePhoto,
        "hide_horoscope": hideHoroscope,
        "hide_mobile": hideMobile,
        "horoscope_available": horoscopeAvailable,
    };
}
