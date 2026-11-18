// Response of `GET home` (the dashboard / home screen).
//
//     final dashboardModel = dashboardModelFromJson(jsonString);
//
// Every field is read leniently: a missing or mistyped value falls back to
// an empty default instead of throwing, so one odd field from the backend
// can't blank the whole home screen.

import 'dart:convert';

import 'package:vivahbharath_app/model/match_profile.dart';
import 'package:vivahbharath_app/services/app_config.dart';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  String greeting;
  Profile profile;
  ProfileCompletion profileCompletion;
  Stats stats;
  ActivityCounts activityCounts;
  Messages notifications;
  Messages messages;
  Subscription subscription;
  Recommendations recommendations;
  List<MatchProfile> dailyMatches;
  List<MatchProfile> newMatches;
  List<MatchProfile> premiumMatches;
  List<MatchProfile> recentVisited;
  List<MatchProfile> fromYourSearch;

  DashboardModel({
    required this.greeting,
    required this.profile,
    required this.profileCompletion,
    required this.stats,
    required this.activityCounts,
    required this.notifications,
    required this.messages,
    required this.subscription,
    required this.recommendations,
    required this.dailyMatches,
    required this.newMatches,
    required this.premiumMatches,
    required this.recentVisited,
    required this.fromYourSearch,
  });

  factory DashboardModel.fromJson(dynamic raw) {
    // Accept both `{...}` and `{data: {...}}`.
    var json = _map(raw);
    if (json['profile'] == null && json['data'] is Map) json = _map(json['data']);
    return DashboardModel(
      greeting: _str(json['greeting']) ?? '',
      profile: Profile.fromJson(_map(json['profile'])),
      profileCompletion: ProfileCompletion.fromJson(_map(json['profile_completion'])),
      stats: Stats.fromJson(_map(json['stats'])),
      activityCounts: ActivityCounts.fromJson(_map(json['activity_counts'])),
      notifications: Messages.fromJson(_map(json['notifications'])),
      messages: Messages.fromJson(_map(json['messages'])),
      subscription: Subscription.fromJson(_map(json['subscription'])),
      recommendations: Recommendations.fromJson(_map(json['recommendations'])),
      dailyMatches: dashboardProfiles(json['daily_matches']),
      newMatches: dashboardProfiles(json['new_matches']),
      premiumMatches: dashboardProfiles(json['premium_matches']),
      recentVisited: dashboardProfiles(json['recent_visited']),
      fromYourSearch: dashboardProfiles(json['from_your_search']),
    );
  }

  Map<String, dynamic> toJson() => {
        'greeting': greeting,
        'profile': profile.toJson(),
        'profile_completion': profileCompletion.toJson(),
        'stats': stats.toJson(),
        'activity_counts': activityCounts.toJson(),
        'notifications': notifications.toJson(),
        'messages': messages.toJson(),
        'subscription': subscription.toJson(),
        'recommendations': recommendations.toJson(),
      };
}

/// Parses a list of member cards from the dashboard into [MatchProfile]s,
/// the same model the Matches tab uses (so shortlist / interest state and
/// photo URL resolution behave identically).
List<MatchProfile> dashboardProfiles(dynamic v) {
  if (v is! List) return [];
  final out = <MatchProfile>[];
  for (final e in v) {
    if (e is! Map) continue;
    final j = Map<String, dynamic>.from(e);
    // The dashboard spells a few keys differently from `matches/*`.
    j['name_hidden'] ??= j['is_name_hidden'];
    j['is_hidden'] ??= false;
    j['interest_status'] = _interestStatus(j['interest_status']);
    out.add(MatchProfile.fromJson(j));
  }
  return out;
}

/// Dashboard sends `interest_status` as an int (null = not sent).
/// Assumed mapping: 0 pending, 1 accepted, 2 declined. Strings pass through.
dynamic _interestStatus(dynamic v) {
  final n = v is num ? v.toInt() : (v is String ? int.tryParse(v) : null);
  if (n == null) return v is String ? v : null;
  return switch (n) {
    0 => 'pending',
    1 => 'accepted',
    2 => 'declined',
    _ => null,
  };
}

class ActivityCounts {
  int whoViewedMe;
  int shortlistedMe;
  int myInterestAccepted;
  int myRequestApproved;
  int viewedByMe;
  int shortlistedByMe;
  int interestYouReceived;
  int requestYouReceived;
  int interestSent;
  int requestSent;

  ActivityCounts({
    this.whoViewedMe = 0,
    this.shortlistedMe = 0,
    this.myInterestAccepted = 0,
    this.myRequestApproved = 0,
    this.viewedByMe = 0,
    this.shortlistedByMe = 0,
    this.interestYouReceived = 0,
    this.requestYouReceived = 0,
    this.interestSent = 0,
    this.requestSent = 0,
  });

  factory ActivityCounts.fromJson(Map<String, dynamic> json) => ActivityCounts(
        whoViewedMe: _int(json['who_viewed_me']),
        shortlistedMe: _int(json['shortlisted_me']),
        myInterestAccepted: _int(json['my_interest_accepted']),
        myRequestApproved: _int(json['my_request_approved']),
        viewedByMe: _int(json['viewed_by_me']),
        shortlistedByMe: _int(json['shortlisted_by_me']),
        interestYouReceived: _int(json['interest_you_received']),
        requestYouReceived: _int(json['request_you_received']),
        interestSent: _int(json['interest_sent']),
        requestSent: _int(json['request_sent']),
      );

  Map<String, dynamic> toJson() => {
        'who_viewed_me': whoViewedMe,
        'shortlisted_me': shortlistedMe,
        'my_interest_accepted': myInterestAccepted,
        'my_request_approved': myRequestApproved,
        'viewed_by_me': viewedByMe,
        'shortlisted_by_me': shortlistedByMe,
        'interest_you_received': interestYouReceived,
        'request_you_received': requestYouReceived,
        'interest_sent': interestSent,
        'request_sent': requestSent,
      };
}

class Messages {
  int unreadCount;

  Messages({this.unreadCount = 0});

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(unreadCount: _int(json['unread_count']));

  Map<String, dynamic> toJson() => {'unread_count': unreadCount};
}

class Profile {
  int id;
  String name;
  String initial;
  String profileId;
  String? imageUrl;
  bool isPremium;

  Profile({
    this.id = 0,
    this.name = '',
    this.initial = '',
    this.profileId = '',
    this.imageUrl,
    this.isPremium = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final name = _str(json['name']) ?? '';
    return Profile(
      id: _int(json['id']),
      name: name,
      initial: _str(json['initial']) ?? (name.isEmpty ? '' : name[0].toUpperCase()),
      profileId: _str(json['profile_id']) ?? '',
      imageUrl: _photo(json['image_url']),
      isPremium: _bool(json['is_premium']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'initial': initial,
        'profile_id': profileId,
        'image_url': imageUrl,
        'is_premium': isPremium,
      };
}

class ProfileCompletion {
  int percentage;
  List<String> incompleteSections;

  ProfileCompletion({this.percentage = 0, this.incompleteSections = const []});

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) => ProfileCompletion(
        percentage: _int(json['percentage']).clamp(0, 100),
        incompleteSections: [
          if (json['incomplete_sections'] is List)
            for (final s in json['incomplete_sections'] as List)
              if (_str(s) != null) _str(s)!,
        ],
      );

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'incomplete_sections': incompleteSections,
      };
}

class Recommendations {
  String title;
  String subtitle;
  bool hasPartnerPreferences;
  List<MatchProfile> profiles;

  Recommendations({
    this.title = 'Recommendations for you',
    this.subtitle = 'Based on your partner preferences',
    this.hasPartnerPreferences = false,
    this.profiles = const [],
  });

  factory Recommendations.fromJson(Map<String, dynamic> json) => Recommendations(
        title: _str(json['title']) ?? 'Recommendations for you',
        subtitle: _str(json['subtitle']) ?? 'Based on your partner preferences',
        hasPartnerPreferences: _bool(json['has_partner_preferences']),
        profiles: dashboardProfiles(json['profiles']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'has_partner_preferences': hasPartnerPreferences,
      };
}

class Stats {
  int interestReceived;
  int interestAccepted;
  int contactsViewed;

  Stats({this.interestReceived = 0, this.interestAccepted = 0, this.contactsViewed = 0});

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        interestReceived: _int(json['interest_received']),
        interestAccepted: _int(json['interest_accepted']),
        contactsViewed: _int(json['contacts_viewed']),
      );

  Map<String, dynamic> toJson() => {
        'interest_received': interestReceived,
        'interest_accepted': interestAccepted,
        'contacts_viewed': contactsViewed,
      };
}

class Subscription {
  bool isPremium;
  String planName;

  Subscription({this.isPremium = false, this.planName = ''});

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        isPremium: _bool(json['is_premium']),
        planName: _str(json['plan_name']) ?? '',
      );

  Map<String, dynamic> toJson() => {'is_premium': isPremium, 'plan_name': planName};
}

// ── Lenient JSON readers ────────────────────────────────────────────────────

Map<String, dynamic> _map(dynamic v) => v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty || s == 'null' ? null : s;
}

int _int(dynamic v) => v is int ? v : (v is num ? v.round() : int.tryParse('${v ?? ''}') ?? 0);

bool _bool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) return const {'true', '1', 'yes'}.contains(v.toLowerCase());
  return false;
}

String? _photo(dynamic v) {
  final s = _str(v);
  if (s == null) return null;
  if (s.startsWith('http')) return s;
  final host = Uri.parse(AppConfig.baseUrl).replace(path: '/');
  return host.resolve(s.startsWith('/') ? s.substring(1) : s).toString();
}
