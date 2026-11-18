// To parse this JSON data, do
//
//     final shortListModel = shortListModelFromJson(jsonString);

import 'dart:convert';

ShortListModel shortListModelFromJson(String str) =>
    ShortListModel.fromJson(json.decode(str));

String shortListModelToJson(ShortListModel data) => json.encode(data.toJson());

class ShortListModel {
  /// New shortlist state returned by `matches/{id}/shortlist`, or null when
  /// the response doesn't say (callers then assume the toggle succeeded).
  bool? shortlisted;
  String? message;

  ShortListModel({this.shortlisted, this.message});

  /// Accepts `{shortlisted: true}`, `{data: {shortlisted: 1}}`,
  /// `{is_shortlisted: "true"}` …
  factory ShortListModel.fromJson(dynamic json) {
    if (json is! Map) return ShortListModel();
    final data = json['data'];
    final value =
        json['shortlisted'] ??
        json['is_shortlisted'] ??
        (data is Map ? data['shortlisted'] ?? data['is_shortlisted'] : null);
    return ShortListModel(
      shortlisted: _bool(value),
      message: json['message'] is String ? json['message'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "shortlisted": shortlisted,
    "message": message,
  };

  static bool? _bool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == 'true' || s == '1' || s == 'yes') return true;
      if (s == 'false' || s == '0' || s == 'no') return false;
    }
    return null;
  }
}
