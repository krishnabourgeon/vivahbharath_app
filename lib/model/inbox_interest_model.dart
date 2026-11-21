// Response of `GET inbox/interests?direction=&status=&page=`.
//
//     final inboxInterestModel = inboxInterestModelFromJson(jsonString);
//
// Parsing is null-tolerant: pending interests have no `responded_at`, hidden
// profiles may send null name/photo fields, and booleans may arrive as 0/1.

import 'dart:convert';

InboxInterestModel inboxInterestModelFromJson(String str) =>
    InboxInterestModel.fromJson(json.decode(str));

String _s(dynamic v) => v == null ? '' : v.toString();
bool _b(dynamic v) => v == true || v == 1 || v == '1' || v == 'true';
int _i(dynamic v) => v is int ? v : int.tryParse(_s(v)) ?? 0;
DateTime? _d(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());
List<Map<String, dynamic>> _maps(dynamic v) => v is List
    ? [for (final x in v) if (x is Map) Map<String, dynamic>.from(x)]
    : const [];
Map<String, dynamic> _map(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : const {};

/// Interest status, as the app uses it.
enum InterestState { pending, accepted, declined, withdrawn }

/// Values sent as the `direction` query param.
enum InterestDirection { received, sent }

class InboxInterestModel {
  InboxInterestModel({
    required this.success,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.data,
    required this.statusCounts,
    this.nextPageUrl,
  });

  final bool success;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final List<Interest> data;
  final StatusCounts statusCounts;

  factory InboxInterestModel.fromJson(Map<String, dynamic> json) =>
      InboxInterestModel(
        success: json['success'] == null ? true : _b(json['success']),
        currentPage: _i(json['current_page'] ?? 1),
        lastPage: _i(json['last_page'] ?? 1),
        perPage: _i(json['per_page']),
        total: _i(json['total']),
        nextPageUrl: json['next_page_url']?.toString(),
        data: [for (final m in _maps(json['data'])) Interest.fromJson(m)],
        statusCounts: StatusCounts.fromJson(_map(json['status_counts'])),
      );
}

class Interest {
  Interest({
    required this.id,
    required this.profileId,
    required this.name,
    required this.isNameHidden,
    required this.age,
    required this.height,
    required this.religion,
    required this.caste,
    required this.community,
    required this.motherTongue,
    required this.education,
    required this.occupation,
    required this.city,
    required this.state,
    required this.country,
    required this.location,
    required this.imageUrl,
    required this.isPhotoHidden,
    required this.verified,
    required this.isOnline,
    required this.lastSeen,
    required this.isShortlisted,
    required this.profileAvailable,
    required this.unavailableMessage,
    required this.privacy,
    required this.emailVerify,
    required this.mobileVerify,
    required this.trustBadges,
    required this.interestId,
    required this.interestStatus,
    required this.statusLabel,
    required this.direction,
    required this.date,
    required this.timeAgo,
    required this.respondedAt,
    required this.logId,
    required this.isRemoved,
    required this.canRespond,
    required this.canWithdraw,
    required this.canDelete,
  });

  /// The other member's user id (used for shortlist, chat, profile).
  final int id;
  final String profileId;
  final String name;
  final bool isNameHidden;
  final int age;
  final String height;
  final String religion;
  final String caste;
  final String community;
  final String motherTongue;
  final String education;
  final String occupation;
  final String city;
  final String state;
  final String country;
  final String location;
  final String imageUrl;
  final bool isPhotoHidden;
  final bool verified;
  final bool isOnline;
  final String lastSeen;
  bool isShortlisted;
  final bool profileAvailable;
  final String? unavailableMessage;
  final Privacy privacy;
  final bool emailVerify;
  final bool mobileVerify;
  final List<TrustBadge> trustBadges;

  /// The interest's own id (used for respond / withdraw / delete).
  final int interestId;
  final int interestStatus;
  final String statusLabel;
  final String direction;
  final DateTime? date;
  final String timeAgo;
  final DateTime? respondedAt;
  final dynamic logId;
  final bool isRemoved;
  final bool canRespond;
  final bool canWithdraw;
  final bool canDelete;

  bool get isSent => direction.toLowerCase() == 'sent';

  /// Status from `status_label`, falling back to the numeric
  /// `interest_status` (0 pending, 1 accepted, 2 declined, 3 withdrawn).
  InterestState get status {
    final l = statusLabel.toLowerCase();
    if (l.contains('withdraw')) return InterestState.withdrawn;
    if (l.contains('accept')) return InterestState.accepted;
    if (l.contains('declin') || l.contains('reject')) {
      return InterestState.declined;
    }
    if (l.contains('pend')) return InterestState.pending;
    return switch (interestStatus) {
      1 => InterestState.accepted,
      2 => InterestState.declined,
      3 => InterestState.withdrawn,
      _ => InterestState.pending,
    };
  }

  /// "28 Yrs · 5'4" · Hindu · Nair"
  String get line1 => [
        if (age > 0) '$age Yrs',
        height,
        religion,
        caste.isNotEmpty ? caste : community,
      ].where((e) => e.trim().isNotEmpty).join(' · ');

  /// "Bachelors Degree · Software Engineer"
  String get line2 =>
      [education, occupation].where((e) => e.trim().isNotEmpty).join(' · ');

  /// "Kozhikode · Kerala · India"
  String get line3 {
    final parts =
        [city, state, country].where((e) => e.trim().isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(' · ') : location;
  }

  String? get photo => isPhotoHidden || imageUrl.isEmpty ? null : imageUrl;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: _i(json['id']),
        profileId: _s(json['profile_id']),
        name: _s(json['name']),
        isNameHidden: _b(json['is_name_hidden']),
        age: _i(json['age']),
        height: _s(json['height']),
        religion: _s(json['religion']),
        caste: _s(json['caste']),
        community: _s(json['community']),
        motherTongue: _s(json['mother_tongue']),
        education: _s(json['education']),
        occupation: _s(json['occupation']),
        city: _s(json['city']),
        state: _s(json['state']),
        country: _s(json['country']),
        location: _s(json['location']),
        imageUrl: _s(json['image_url']),
        isPhotoHidden: _b(json['is_photo_hidden']),
        verified: _b(json['verified']),
        isOnline: _b(json['is_online']),
        lastSeen: _s(json['last_seen']),
        isShortlisted: _b(json['is_shortlisted']),
        profileAvailable: json['profile_available'] == null
            ? true
            : _b(json['profile_available']),
        unavailableMessage: json['unavailable_message']?.toString(),
        privacy: Privacy.fromJson(_map(json['privacy'])),
        emailVerify: _b(json['email_verify']),
        mobileVerify: _b(json['mobile_verify']),
        trustBadges: [
          for (final m in _maps(json['trust_badges'])) TrustBadge.fromJson(m)
        ],
        interestId: _i(json['interest_id']),
        interestStatus: _i(json['interest_status']),
        statusLabel: _s(json['status_label']),
        direction: _s(json['direction']),
        date: _d(json['date']),
        timeAgo: _s(json['time_ago']),
        respondedAt: _d(json['responded_at']),
        logId: json['log_id'],
        isRemoved: _b(json['is_removed']),
        canRespond: _b(json['can_respond']),
        canWithdraw: _b(json['can_withdraw']),
        canDelete: _b(json['can_delete']),
      );
}

class Privacy {
  Privacy({
    required this.hideName,
    required this.hidePhoto,
    required this.hideHoroscope,
    required this.hideMobile,
    required this.canViewName,
    required this.canViewPhoto,
    required this.canViewHoroscope,
    required this.canViewMobile,
  });

  final bool hideName;
  final bool hidePhoto;
  final bool hideHoroscope;
  final bool hideMobile;
  final bool canViewName;
  final bool canViewPhoto;
  final bool canViewHoroscope;
  final bool canViewMobile;

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
        hideName: _b(json['hide_name']),
        hidePhoto: _b(json['hide_photo']),
        hideHoroscope: _b(json['hide_horoscope']),
        hideMobile: _b(json['hide_mobile']),
        canViewName: _b(json['can_view_name']),
        canViewPhoto: _b(json['can_view_photo']),
        canViewHoroscope: _b(json['can_view_horoscope']),
        canViewMobile: _b(json['can_view_mobile']),
      );
}

class TrustBadge {
  TrustBadge({
    required this.type,
    required this.name,
    required this.status,
    required this.isVerified,
  });

  final String type;
  final String name;
  final String status;
  final bool isVerified;

  factory TrustBadge.fromJson(Map<String, dynamic> json) => TrustBadge(
        type: _s(json['type']),
        name: _s(json['name']),
        status: _s(json['status']),
        isVerified: _b(json['is_verified']),
      );
}

class StatusCounts {
  StatusCounts({
    this.all = 0,
    this.pending = 0,
    this.accepted = 0,
    this.declined = 0,
    this.withdrawn = 0,
  });

  final int all;
  final int pending;
  final int accepted;
  final int declined;
  final int withdrawn;

  int of(InterestState s) => switch (s) {
        InterestState.pending => pending,
        InterestState.accepted => accepted,
        InterestState.declined => declined,
        InterestState.withdrawn => withdrawn,
      };

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
        all: _i(json['all']),
        pending: _i(json['pending']),
        accepted: _i(json['accepted']),
        declined: _i(json['declined']),
        withdrawn: _i(json['withdrawn']),
      );
}
