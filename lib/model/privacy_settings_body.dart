// To parse this JSON data, do
//
//     final privacySettingsBody = privacySettingsBodyFromJson(jsonString);

import 'dart:convert';

PrivacySettingsBody privacySettingsBodyFromJson(String str) => PrivacySettingsBody.fromJson(json.decode(str));

String privacySettingsBodyToJson(PrivacySettingsBody data) => json.encode(data.toJson());

class PrivacySettingsBody {
    bool hideName;
    bool hidePhoto;
    bool hideHoroscope;
    bool hideMobile;

    PrivacySettingsBody({
        required this.hideName,
        required this.hidePhoto,
        required this.hideHoroscope,
        required this.hideMobile,
    });

    factory PrivacySettingsBody.fromJson(Map<String, dynamic> json) => PrivacySettingsBody(
        hideName: json["hide_name"],
        hidePhoto: json["hide_photo"],
        hideHoroscope: json["hide_horoscope"],
        hideMobile: json["hide_mobile"],
    );

    Map<String, dynamic> toJson() => {
        "hide_name": hideName,
        "hide_photo": hidePhoto,
        "hide_horoscope": hideHoroscope,
        "hide_mobile": hideMobile,
    };
}
