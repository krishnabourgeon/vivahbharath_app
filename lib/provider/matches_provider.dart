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

  // "Don't show": the list comes from `matches/hidden` (the dontShow page).
  // Hiding / unhiding is only kept for this session on top of that list.
  // TODO: call the hide / unhide endpoints once the backend exposes them.

  /// Members hidden during this session, by [MatchProfile.key].
  final Map<String, MatchProfile> _hidden = {};

  /// Members unhidden during this session (overrides the server's list).
  final Set<String> _unhidden = {};

  MatchPage page(MatchTab tab) => _pages.putIfAbsent(tab, MatchPage.new);

  Set<String> get _serverHiddenKeys =>
      {for (final p in _pages[MatchTab.dontShow]?.items ?? const []) p.key};

  bool isHidden(MatchProfile p) =>
      !_unhidden.contains(p.key) &&
      (p.hidden ||
          _hidden.containsKey(p.key) ||
          _serverHiddenKeys.contains(p.key));

  /// Total members in "Marked as Don't Show" (server total + this session's
  /// hides that aren't in the loaded list yet).
  int get hiddenCount {
    final pg = page(MatchTab.dontShow);
    final server = pg.loaded ? (pg.total ?? pg.items.length) : 0;
    final serverKeys = _serverHiddenKeys;
    return server + _hidden.keys.where((k) => !serverKeys.contains(k)).length;
  }

  /// Rows to show for [tab]; hidden members are filtered out of every tab
  /// except "Marked as Don't Show", which lists only them.
  List<MatchProfile> visible(MatchTab tab) {
    if (tab == MatchTab.dontShow) {
      final serverRows = page(tab).items;
      final serverKeys = {for (final p in serverRows) p.key};
      return [
        // Hidden just now first, then the server's list.
        for (final p in _hidden.values)
          if (!serverKeys.contains(p.key)) p,
        ...serverRows.where((p) => !_unhidden.contains(p.key)),
      ];
    }
    return page(tab).items.where((p) => !isHidden(p)).toList(growable: false);
  }

  bool isSupported(MatchTab tab) => tab.endpoint != null;

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
      final hiddenTab = tab == MatchTab.dontShow;
      final profiles = [
        for (final e in list)
          if (e is Map)
            MatchProfile.fromJson(
              Map<String, dynamic>.from(e),
              shortlisted: shortlisted,
            )..hidden = hiddenTab || _bool(e['is_hidden']),
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
    // Ignore taps while this member's previous toggle is still in flight;
    // a second request would flip the server state back.
    if (!_shortlistBusy.add(p.key)) return p.shortlisted;
    final before = p.shortlisted;
    _setShortlisted(p, !before);

    try {
      final res = await _service.shorlist(id);
      if (res.isValue && res.asValue!.value is ShortListModel) {
        final now =
            (res.asValue!.value as ShortListModel).shortlisted ?? !before;
        _setShortlisted(p, now);
        _syncShortlistedByYou(p, now);
        return now;
      }
    } catch (e) {
      debugPrint('MatchesProvider: shortlist $id failed: $e');
    } finally {
      _shortlistBusy.remove(p.key);
    }
    _setShortlisted(p, before);
    return null;
  }

  final Set<String> _shortlistBusy = {};

  /// Keeps the "Shortlisted By You" tab in step with a toggle made anywhere:
  /// a removed member drops out of it at once; an added one shows up on the
  /// tab's next load.
  void _syncShortlistedByYou(MatchProfile p, bool shortlisted) {
    final pg = _pages[MatchTab.shortlistedByYou];
    if (pg == null) return;
    if (shortlisted) {
      _invalidate(MatchTab.shortlistedByYou);
      return;
    }
    final before = pg.items.length;
    pg.items.removeWhere((q) => q.key == p.key);
    final removed = before - pg.items.length;
    if (removed > 0 && pg.total != null) {
      pg.total = (pg.total! - removed).clamp(0, pg.total!);
    }
    notifyListeners();
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
    _unhidden.remove(p.key);
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
    // Was on the server's list: keep it out of "Don't show" from now on.
    final hiddenPg = _pages[MatchTab.dontShow];
    if (hiddenPg != null && hiddenPg.items.any((q) => q.key == p.key)) {
      _unhidden.add(p.key);
      final before = hiddenPg.items.length;
      hiddenPg.items.removeWhere((q) => q.key == p.key);
      final removed = before - hiddenPg.items.length;
      if (hiddenPg.total != null) {
        hiddenPg.total = (hiddenPg.total! - removed).clamp(0, hiddenPg.total!);
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
    _unhidden.clear();
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

  static bool _bool(dynamic v) =>
      v == true || v == 1 || v == '1' || v == 'true';

  static String? _bodyMessage(dynamic body) =>
      body is Map && body['message'] is String ? body['message'] : null;

  static String _message(Object e) => e is ErrorResponseModel
      ? (e.errorMessage ?? 'Could not load matches')
      : 'Could not load matches';
}
