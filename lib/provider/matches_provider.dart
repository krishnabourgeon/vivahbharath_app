import 'package:flutter/foundation.dart';
import 'package:vivahbharath_app/model/error_response_model.dart';
import 'package:vivahbharath_app/model/match_profile.dart';
import 'package:vivahbharath_app/model/shortlist_model.dart';
import 'package:vivahbharath_app/services/service_config.dart';

/// One tab's list plus its paging / loading state.
class MatchPage {
  final List<MatchProfile> items = [];
  int? total;
  bool loading = false;
  bool loadingMore = false;
  bool hasMore = true;
  bool loaded = false;
  String? error;
}

/// Data for the Matches screen: one cached, paged list per [MatchTab].
///
/// Never call the loaders from `build` or synchronously from `initState`;
/// they notify listeners immediately (see `CommonFunctions.afterInit`).
class MatchesProvider extends ChangeNotifier {
  MatchesProvider({ServiceConfig? service})
    : _service = service ?? ServiceConfig();

  final ServiceConfig _service;
  static const pageSize = 20;

  final Map<MatchTab, MatchPage> _pages = {};

  /// Members hidden with "Don't show" during this session, by [MatchProfile.key].
  // TODO: persist once the backend exposes a hide / unhide endpoint.
  final Map<String, MatchProfile> _hidden = {};

  MatchPage page(MatchTab tab) => _pages.putIfAbsent(tab, MatchPage.new);

  bool isHidden(MatchProfile p) => p.hidden || _hidden.containsKey(p.key);
  int get hiddenCount => _hidden.length;

  /// Rows to show for [tab]; hidden members are filtered out of every tab
  /// except "Marked as Don't Show", which lists only them.
  List<MatchProfile> visible(MatchTab tab) {
    if (tab == MatchTab.dontShow) {
      return _hidden.values.toList(growable: false);
    }
    return page(tab).items.where((p) => !isHidden(p)).toList(growable: false);
  }

  bool isSupported(MatchTab tab) =>
      tab == MatchTab.dontShow || tab.endpoint != null;

  // ── Loading ───────────────────────────────────────────────────────────────
  /// Loads the first page of [tab] unless it's already loaded.
  Future<void> load(MatchTab tab, {bool refresh = false}) async {
    final endpoint = tab.endpoint;
    final pg = page(tab);
    if (endpoint == null || pg.loading) return;
    if (pg.loaded && !refresh && pg.error == null) return;

    pg
      ..loading = true
      ..error = null;
    notifyListeners();

    final result = await _fetch(tab, endpoint, offset: 0);
    pg.loading = false;
    if (result != null) {
      pg.items
        ..clear()
        ..addAll(result.$1);
      pg.total = result.$2;
      pg.hasMore = result.$1.length >= pageSize;
      pg.loaded = true;
    }
    notifyListeners();
  }

  /// Appends the next page of [tab] (infinite scroll).
  Future<void> loadMore(MatchTab tab) async {
    final endpoint = tab.endpoint;
    final pg = page(tab);
    if (endpoint == null ||
        !pg.loaded ||
        !pg.hasMore ||
        pg.loading ||
        pg.loadingMore) {
      return;
    }
    pg.loadingMore = true;
    notifyListeners();

    final result = await _fetch(tab, endpoint, offset: pg.items.length);
    pg.loadingMore = false;
    if (result != null) {
      final seen = pg.items.map((p) => p.key).toSet();
      final fresh = result.$1.where((p) => seen.add(p.key)).toList();
      pg.items.addAll(fresh);
      pg.total = result.$2 ?? pg.total;
      pg.hasMore = result.$1.length >= pageSize && fresh.isNotEmpty;
    } else {
      pg.hasMore = false; // stop retrying on scroll; pull to refresh retries
    }
    notifyListeners();
  }

  /// Returns (profiles, total) or null on failure (error stored on the page).
  Future<(List<MatchProfile>, int?)?> _fetch(
    MatchTab tab,
    String endpoint, {
    required int offset,
  }) async {
    final pg = page(tab);
    try {
      final res = await _service.getMatchList(
        endpoint,
        offset: offset,
        limit: pageSize,
      );
      if (res.isError) {
        pg.error = _message(res.asError!.error);
        return null;
      }
      final body = res.asValue!.value;
      final list = _findList(body);
      if (list == null) {
        pg.error = _bodyMessage(body) ?? 'Could not load matches';
        return null;
      }
      final shortlisted = tab == MatchTab.shortlistedByYou;
      final profiles = [
        for (final e in list)
          if (e is Map)
            MatchProfile.fromJson(
              Map<String, dynamic>.from(e),
              shortlisted: shortlisted,
            ),
      ];
      return (profiles, _findTotal(body));
    } catch (e) {
      debugPrint('MatchesProvider: ${tab.endpoint} failed: $e');
      pg.error = 'Could not load matches. Please try again';
      return null;
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  /// Toggles the shortlist flag via `matches/{id}/shortlist`.
  /// Updates the UI immediately and reverts if the call fails.
  /// Returns the new state, or null on failure.
  Future<bool?> toggleShortlist(MatchProfile p) async {
    final id = p.apiId;
    if (id == null) return null;
    final before = p.shortlisted;
    _setShortlisted(p, !before);

    try {
      final res = await _service.shorlist(id);
      if (res.isValue && res.asValue!.value is ShortListModel) {
        final now =
            (res.asValue!.value as ShortListModel).shortlisted ?? !before;
        _setShortlisted(p, now);
        _invalidate(MatchTab.shortlistedByYou);
        return now;
      }
    } catch (e) {
      debugPrint('MatchesProvider: shortlist $id failed: $e');
    }
    _setShortlisted(p, before);
    return null;
  }

  /// Marks the same member shortlisted/unshortlisted in every loaded tab.
  void _setShortlisted(MatchProfile p, bool value) {
    p.shortlisted = value;
    for (final pg in _pages.values) {
      for (final q in pg.items) {
        if (q.key == p.key) q.shortlisted = value;
      }
    }
    notifyListeners();
  }

  // TODO: call the send-interest endpoint once the backend exposes one;
  // until then this only updates the card for the current session.
  void markInterestSent(MatchProfile p) {
    for (final pg in _pages.values) {
      for (final q in pg.items) {
        if (q.key == p.key) q.status = InterestStatus.awaiting;
      }
    }
    p.status = InterestStatus.awaiting;
    notifyListeners();
  }

  void hide(MatchProfile p) {
    _hidden[p.key] = p;
    notifyListeners();
  }

  void unhide(MatchProfile p) {
    _hidden.remove(p.key);
    p.hidden = false;
    for (final pg in _pages.values) {
      for (final q in pg.items) {
        if (q.key == p.key) q.hidden = false;
      }
    }
    notifyListeners();
  }

  /// Forces [tab] to reload the next time it's shown.
  void _invalidate(MatchTab tab) => _pages[tab]?.loaded = false;

  /// Drops every cached list (e.g. on logout).
  void clear() {
    _pages.clear();
    _hidden.clear();
    notifyListeners();
  }

  // ── Response helpers ──────────────────────────────────────────────────────
  static const _listKeys = ['matches', 'profiles', 'data', 'results', 'items'];

  /// Finds the profile list in `{matches: […]}`, `{data: {profiles: […]}}`,
  /// a Laravel paginator `{data: […]}`, or a bare list.
  static List<dynamic>? _findList(dynamic body, [int depth = 0]) {
    if (body is List) return body;
    if (body is! Map || depth > 2) return null;
    for (final k in _listKeys) {
      final v = body[k];
      if (v is List) return v;
    }
    for (final k in _listKeys) {
      final v = body[k];
      if (v is Map) {
        final found = _findList(v, depth + 1);
        if (found != null) return found;
      }
    }
    return null;
  }

  static int? _findTotal(dynamic body) {
    if (body is! Map) return null;
    for (final k in ['total', 'count']) {
      final v = body[k];
      if (v is int) return v;
    }
    final data = body['data'];
    return data is Map ? _findTotal(data) : null;
  }

  static String? _bodyMessage(dynamic body) =>
      body is Map && body['message'] is String ? body['message'] : null;

  static String _message(Object e) => e is ErrorResponseModel
      ? (e.errorMessage ?? 'Could not load matches')
      : 'Could not load matches';
}
