import 'package:vivahbharath_app/services/app_config.dart';

/// Interest state shown on a match card's action button.
enum InterestStatus { send, awaiting, resend, accepted }

enum MatchTab {
  all('All Matches', endpoint: 'matches'),
  newlyJoined('Newly Joined', endpoint: 'matches/new'),
  shortlistedYou('Shortlisted You', endpoint: 'matches/shortlisted-you'),
  viewedYou('Viewed You', endpoint: 'matches/viewed-me'),
  shortlistedByYou(
    'Shortlisted By You',
    endpoint: 'matches/shortlisted-by-you',
  ),
  viewedByYou('Viewed By You', endpoint: 'matches/viewed-by-me'),
  online('Online', endpoint: 'matches/online'),
  professionMatches('Profession Matches', endpoint: 'matches/profession'),
  // Shown under "More"
  educationMatches(
    'Education Matches',
    inMore: true,
    endpoint: 'matches/education',
  ),
  familyMatches('Family Matches', inMore: true, endpoint: 'matches/family'),
  religiousMatches(
    'Religious Matches',
    inMore: true,
    endpoint: 'matches/religion',
  ),
  dontShow("Marked as Don't Show", inMore: true, endpoint: 'matches/hidden');

  const MatchTab(this.label, {this.inMore = false, this.endpoint});
  final String label;
  final bool inMore;

  /// API path for this tab's list, relative to [AppConfig.baseUrl].
  final String? endpoint;
}

class MatchProfile {
  MatchProfile({
    required this.id,
    required this.name,
    required this.lastSeen,
    required this.age,
    required this.height,
    required this.caste,
    required this.education,
    required this.profession,
    required this.city,
    this.apiId,
    this.photoUrl,
    this.nameHidden = false,
    this.verified = true,
    this.featured = false,
    this.shortlisted = false,
    this.photoRequested = false,
    this.status = InterestStatus.send,
    this.hidden = false,
  });

  /// Numeric member id used by the API (`matches/{id}/shortlist`, …).
  final int? apiId;

  /// Display id, e.g. "VBM26532747M".
  final String id;
  final String name;
  final String lastSeen;
  final int? age;
  final String height;
  final String caste;
  final String education;
  final String profession;
  final String city;
  final String? photoUrl;
  final bool nameHidden;
  final bool verified;
  final bool featured;

  // Mutable UI state
  bool shortlisted;
  bool photoRequested;
  InterestStatus status;
  bool hidden;

  /// Stable key for de-duplicating a member across tabs.
  String get key => apiId?.toString() ?? id;

  /// Builds a profile from any of the `matches/*` list item shapes.
  ///
  /// The endpoints don't share one schema (`matches` sends `image_url` and
  /// `community`, `matches/online` sends `profile_photo`, `profile_id`,
  /// `is_shortlisted` …), so every field is read leniently.
  factory MatchProfile.fromJson(
    Map<String, dynamic> j, {
    bool shortlisted = false,
  }) {
    final apiId = _int(j['id']);
    final online = _bool(j['is_online']) ?? false;
    final interestSent = _bool(j['is_interest_sent']) ?? false;
    final connected = _bool(j['already_connected']) ?? false;

    return MatchProfile(
      apiId: apiId,
      id:
          _str(j['profile_id']) ??
          _str(j['member_id']) ??
          (apiId == null ? '' : 'VB$apiId'),
      name: _str(j['name']) ?? 'Member',
      nameHidden: _bool(j['name_hidden']) ?? false,
      lastSeen: online ? 'Online now' : _lastSeen(j['last_seen']),
      age: _int(j['age']),
      height: _str(j['height']) ?? '',
      caste:
          _str(j['community']) ??
          _str(j['caste']) ??
          _str(j['religion']) ??
          _str(j['mother_tongue']) ??
          '',
      education: _str(j['education']) ?? '',
      profession: _str(j['occupation']) ?? _str(j['profession']) ?? '',
      city: _str(j['location']) ?? _str(j['city']) ?? '',
      photoUrl: _photo(j['image_url'] ?? j['profile_photo'] ?? j['photo']),
      verified: _bool(j['is_verified']) ?? _bool(j['verified']) ?? false,
      featured: _bool(j['is_featured']) ?? _bool(j['featured']) ?? false,
      shortlisted: _bool(j['is_shortlisted']) ?? shortlisted,
      hidden: _bool(j['is_hidden']) ?? false,
      status: connected
          ? InterestStatus.accepted
          : _interest(j['interest_status'], sent: interestSent),
    );
  }

  // ── Lenient JSON readers ──────────────────────────────────────────────────
  static String? _str(dynamic v) {
    if (v == null) return null;
    if (v is Map) return _str(v['name'] ?? v['title'] ?? v['value']);
    final s = v.toString().trim();
    return s.isEmpty || s == 'null' ? null : s;
  }

  static int? _int(dynamic v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('${v ?? ''}'));

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

  static String? _photo(dynamic v) {
    final s = _str(v);
    if (s == null) return null;
    if (s.startsWith('http')) return s;
    // Relative path: resolve against the API host.
    final host = Uri.parse(AppConfig.baseUrl).replace(path: '/');
    return host.resolve(s.startsWith('/') ? s.substring(1) : s).toString();
  }

  static InterestStatus _interest(dynamic v, {required bool sent}) {
    final s = (_str(v) ?? '').toLowerCase();
    if (s.contains('accept') || s.contains('connect')) {
      return InterestStatus.accepted;
    }
    if (s.contains('declin') || s.contains('reject') || s.contains('expire')) {
      return InterestStatus.resend;
    }
    if (s.isNotEmpty && s != 'none' && s != 'not_sent') {
      return InterestStatus.awaiting; // pending / sent / awaiting …
    }
    return sent ? InterestStatus.awaiting : InterestStatus.send;
  }

  static String _lastSeen(dynamic v) {
    final at = DateTime.tryParse(_str(v) ?? '');
    if (at == null) return _str(v) ?? '';
    final d = DateTime.now().difference(at.toLocal());
    String ago(int n, String unit) => '$n $unit${n == 1 ? '' : 's'} ago';
    if (d.inMinutes < 5) return 'Online recently';
    if (d.inHours < 1) return 'Last seen ${ago(d.inMinutes, 'minute')}';
    if (d.inDays < 1) return 'Last seen ${ago(d.inHours, 'hour')}';
    if (d.inDays < 30) return 'Last seen ${ago(d.inDays, 'day')}';
    if (d.inDays < 365) {
      return 'Last seen ${ago(d.inDays ~/ 30, 'month')}';
    }
    return 'Recently no activity';
  }
}
