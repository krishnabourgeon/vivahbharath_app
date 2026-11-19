import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:vivahbharath_app/model/match_profile.dart';
import 'package:vivahbharath_app/services/app_exceptions.dart';
import 'package:vivahbharath_app/services/base_client.dart';
import 'package:vivahbharath_app/services/search_options.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';

/// One page of search results.
class SearchPageResult {
  SearchPageResult(this.profiles, {this.total, this.lastPage});
  final List<MatchProfile> profiles;
  final int? total;
  final int? lastPage;
}

/// Thrown by [SearchApi] with a message that can be shown to the user.
class SearchException implements Exception {
  SearchException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Basic / Advanced / Keyword / Profile ID search against the API.
///
/// Turns the form's [SearchCriteria] (option names) into request bodies
/// (option ids from [SearchOptions]) and reads the profiles leniently with
/// [MatchProfile.fromJson].
class SearchApi {
  static const perPage = 20;

  static const basicPath = 'search/basic';
  static const advancedPath = 'search/advanced';

  // ── Searches ──────────────────────────────────────────────────────────────
  /// Runs the search described by [c] and returns page [page] (1-based).
  ///
  /// A [SearchType.profileId] search returns every match in one page.
  Future<SearchPageResult> run(SearchCriteria c, {int page = 1}) async {
    if (c.type == SearchType.profileId) {
      final id = c.values['profileId'] ?? '';
      final list = await byProfileId(id);
      return SearchPageResult(list, total: list.length, lastPage: 1);
    }
    final advanced = c.type == SearchType.advanced;
    final path = advanced ? advancedPath : basicPath;
    final body = advanced
        ? advancedBody(c, page: page)
        : basicBody(c, page: page);
    debugPrint('SearchApi: $path $body');
    final res = await _call(
      () => BaseClient.post(path, body: body),
      fallback: 'Could not load search results. Please try again',
    );
    return _parsePage(res);
  }

  /// Members whose profile ID matches [profileId] (`search/profile/{id}`).
  Future<List<MatchProfile>> byProfileId(String profileId) async {
    final id = profileId.trim().toUpperCase();
    if (id.isEmpty) throw SearchException('Enter a profile ID');
    final res = await _call(
      () => BaseClient.get('search/profile/${Uri.encodeComponent(id)}'),
      fallback: 'No profile found with ID $id',
    );
    return _parsePage(res).profiles;
  }

  /// Runs a [BaseClient] request and returns the decoded JSON body, or throws
  /// a [SearchException] with the API's message.
  static Future<dynamic> _call(
    Future<dynamic> Function() request, {
    required String fallback,
  }) async {
    final dynamic res;
    try {
      res = await request();
    } on AppException catch (e) {
      debugPrint('SearchApi error: ${e.message}');
      throw SearchException(_bodyMessage(e.message) ?? fallback);
    }
    if (res is! Result || res.isError) throw SearchException(fallback);
    final body = res.asValue!.value;
    // 401 / 403 come back as values with `success: false`.
    if (body is Map && body['success'] == false) {
      throw SearchException(
          body['message'] is String ? body['message'] as String : fallback);
    }
    return body;
  }

  /// Message from an error body like `{"message": "..."}` or
  /// `{"errors": {"field": ["..."]}}`; null if there isn't one.
  static String? _bodyMessage(String? raw) {
    if (raw == null || raw.trimLeft().startsWith('<')) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      for (final key in const ['errors', 'error']) {
        final v = decoded[key];
        if (v is String && v.trim().isNotEmpty) return v;
        if (v is Map) {
          final msgs = [
            for (final x in v.values)
              if (x is List) ...x.whereType<String>() else if (x is String) x,
          ];
          if (msgs.isNotEmpty) return msgs.join('\n');
        }
      }
      final m = decoded['message'];
      if (m is String && m.trim().isNotEmpty) return m;
    } catch (_) {
      final t = raw.trim();
      if (t.isNotEmpty && t.length <= 200) return t;
    }
    return null;
  }

  // ── Request bodies ────────────────────────────────────────────────────────
  static final _opts = SearchOptions.instance;

  static int? _int(String? v) => v == null ? null : measureValue(v);

  static List<int> _ids(SearchCriteria c, String field) =>
      _opts.idsOf(field, c.multi[field] ?? const <String>{});

  /// Adds `<key>_ids` (all picks) and `<key>_id` (first pick) for [field].
  static void _putIds(Map<String, dynamic> b, SearchCriteria c, String field,
      String key) {
    final ids = _ids(c, field);
    if (ids.isEmpty) return;
    b['${key}_id'] = ids.first;
    b['${key}_ids'] = ids;
  }

  static void _putRange(Map<String, dynamic> b, SearchCriteria c,
      String fromKey, String toKey, String apiFrom, String apiTo) {
    final from = _int(c.values[fromKey]);
    final to = _int(c.values[toKey]);
    if (from != null) b[apiFrom] = from;
    if (to != null) b[apiTo] = to;
  }

  /// Age is always sent (the API expects it); defaults to the full range.
  static void _putAge(Map<String, dynamic> b, SearchCriteria c) {
    b['age_from'] = _int(c.values['ageFrom']) ?? int.parse(kAgeOptions.first);
    b['age_to'] = _int(c.values['ageTo']) ?? int.parse(kAgeOptions.last);
  }

  /// Body for `search/basic` (also used for keyword search).
  static Map<String, dynamic> basicBody(SearchCriteria c, {int page = 1}) {
    final b = <String, dynamic>{};
    _putAge(b, c);
    _putRange(b, c, 'heightFrom', 'heightTo', 'height_from', 'height_to');
    _putRange(b, c, 'weightFrom', 'weightTo', 'weight_from', 'weight_to');
    _putIds(b, c, 'religion', 'religion');
    _putIds(b, c, 'motherTongue', 'mother_tongue');
    _putIds(b, c, 'marital', 'marital_status');
    _putIds(b, c, 'caste', 'caste');
    _putIds(b, c, 'education', 'education');
    _putIds(b, c, 'familyType', 'family_type');
    final disability = c.values['disability'] ??
        c.multi['disability']?.firstOrNull;
    if (disability != null) b['disability'] = disability == 'Yes';
    final kw = c.values['keyword'];
    if (kw != null && kw.trim().isNotEmpty) b['keyword'] = kw.trim();
    b['page'] = page;
    b['per_page'] = perPage;
    return b;
  }

  /// Body for `search/advanced`.
  static Map<String, dynamic> advancedBody(SearchCriteria c, {int page = 1}) {
    final b = <String, dynamic>{};
    _putAge(b, c);
    _putRange(b, c, 'heightFrom', 'heightTo', 'height_from', 'height_to');
    _putRange(b, c, 'weightFrom', 'weightTo', 'weight_from', 'weight_to');

    final religion = _ids(c, 'religion');
    if (religion.isNotEmpty) {
      b['religion_id'] = religion.first;
      b['religion_ids'] = religion;
    }
    b['caste_ids'] = _ids(c, 'caste');
    b['state_ids'] = _ids(c, 'state');
    b['city_ids'] = _ids(c, 'city');
    b['qualification_ids'] = _ids(c, 'education');
    b['occupation_ids'] = _ids(c, 'occupation');
    b['languages_known_ids'] = _ids(c, 'languages');

    // Extra filters from the form (the API ignores ones it doesn't know).
    b['country_ids'] = _ids(c, 'country');
    b['marital_status_ids'] = _ids(c, 'marital');
    b['mother_tongue_ids'] = _ids(c, 'motherTongue');
    b['gotra_ids'] = _ids(c, 'gotra');
    b['family_status_ids'] = _ids(c, 'familyStatus');
    b['family_type_ids'] = _ids(c, 'familyType');
    b['body_type_ids'] = _ids(c, 'bodyType');
    b['skin_tone_ids'] = _ids(c, 'skinTone');
    b['diet_ids'] = _ids(c, 'foodType');
    b['employment_type_ids'] = _ids(c, 'employment');
    b['income_ids'] = _ids(c, 'income');
    b['family_property_ids'] = _ids(c, 'familyProperty');
    b.removeWhere((k, v) => v is List && v.isEmpty && !_requiredLists.contains(k));

    final drinking = c.multi['drinking']?.firstOrNull;
    final smoking = c.multi['smoking']?.firstOrNull;
    if (drinking != null) b['drinking'] = drinking;
    if (smoking != null) b['smoking'] = smoking;
    final disability = c.values['disability'] ??
        c.multi['disability']?.firstOrNull;
    if (disability != null) b['disability'] = disability == 'Yes';
    final sudha = c.values['sudha'];
    if (sudha != null) b['sudha_jathakam'] = sudha == 'Yes';
    final dosha = c.values['dosha'];
    if (dosha != null) b['dosha_jathakam'] = dosha == 'Yes';

    b['accept_major_surgery_or_transplant'] = c.values['surgery'] == 'Yes';
    b['with_photo_only'] = c.toggles.contains('withPhoto');
    b['profile_created'] =
        _createdWithin[c.values['createdWithin'] ?? 'All'] ?? 'all';
    b['sort_by'] = _sortBy[c.values['sortBy'] ?? ''] ?? 'best_match';
    b['page'] = page;
    b['per_page'] = perPage;
    return b;
  }

  /// List keys the advanced API documents; always sent, even when empty.
  static const _requiredLists = {
    'caste_ids',
    'state_ids',
    'city_ids',
    'qualification_ids',
    'occupation_ids',
    'languages_known_ids',
  };

  static const _createdWithin = {
    'All': 'all',
    'Today': 'today',
    'One week': 'week',
    'One month': 'month',
  };

  static const _sortBy = {
    'Best match': 'best_match',
    'Newest first': 'newest',
    'Recently active': 'recently_active',
    'Premium first': 'premium',
  };

  // ── Response helpers ──────────────────────────────────────────────────────
  static SearchPageResult _parsePage(dynamic body) {
    final list = _findList(body) ?? const [];
    final profiles = <MatchProfile>[
      for (final e in list)
        if (e is Map) MatchProfile.fromJson(Map<String, dynamic>.from(e)),
    ];
    final data = body is Map && body['data'] is Map ? body['data'] as Map : body;
    final pagination = data is Map && data['pagination'] is Map
        ? data['pagination'] as Map
        : null;
    int? asInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}');
    return SearchPageResult(
      profiles,
      total: asInt(data is Map ? data['total'] : null) ??
          asInt(pagination?['total']),
      lastPage: asInt(pagination?['last_page']),
    );
  }

  static const _listKeys = ['profiles', 'matches', 'data', 'results', 'items'];

  static List<dynamic>? _findList(dynamic body, [int depth = 0]) {
    if (body is List) return body;
    if (body is! Map || depth > 2) return null;
    for (final k in _listKeys) {
      if (body[k] is List) return body[k] as List;
    }
    // A single profile object, e.g. {data: {profile: {...}}}.
    if (body['profile'] is Map) return [body['profile']];
    for (final k in _listKeys) {
      final v = body[k];
      if (v is Map) {
        final found = _findList(v, depth + 1);
        if (found != null) return found;
      }
    }
    return null;
  }

}
