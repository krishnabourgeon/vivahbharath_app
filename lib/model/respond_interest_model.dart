// Response of the interest actions (respond / withdraw / delete):
//
// {
//   "success": true,
//   "message": "Interest accepted",
//   "data": {
//     "interest_id": 12, "status": 1, "status_label": "Accepted",
//     "counts": { "total": {...}, "received": {...}, "sent": {...} }
//   }
// }
//
//     final respondInterestModel = respondInterestModelFromJson(jsonString);

import 'dart:convert';

import 'package:vivahbharath_app/model/inbox_interest_model.dart';

RespondInterestModel respondInterestModelFromJson(String str) =>
    RespondInterestModel.fromJson(json.decode(str));

Map<String, dynamic> _map(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : const {};

class RespondInterestModel {
  RespondInterestModel({required this.success, this.message, this.data});

  final bool success;
  final String? message;
  final Data? data;

  factory RespondInterestModel.fromJson(Map<String, dynamic> json) =>
      RespondInterestModel(
        success: json['success'] != false,
        message: json['message']?.toString(),
        data: json['data'] is Map ? Data.fromJson(_map(json['data'])) : null,
      );
}

class Data {
  Data({
    required this.interestId,
    required this.status,
    required this.statusLabel,
    this.counts,
  });

  final int interestId;
  final int status;
  final String statusLabel;
  final Counts? counts;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        interestId: int.tryParse('${json['interest_id']}') ?? 0,
        status: int.tryParse('${json['status']}') ?? 0,
        statusLabel: json['status_label']?.toString() ?? '',
        counts: json['counts'] is Map ? Counts.fromJson(_map(json['counts'])) : null,
      );
}

class Counts {
  Counts({required this.total, required this.received, required this.sent});

  final StatusCounts total;
  final StatusCounts received;
  final StatusCounts sent;

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        total: StatusCounts.fromJson(_map(json['total'])),
        received: StatusCounts.fromJson(_map(json['received'])),
        sent: StatusCounts.fromJson(_map(json['sent'])),
      );
}
