import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/model/view_request.dart';
import 'package:vivahbharath_app/provider/matches_provider.dart';
import 'package:vivahbharath_app/provider/search_provider.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/interest_actions.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'profile_detail_screen.dart';
import 'search_screen.dart';

/// Search results: back + title, the "New or Saved Search" dropdown, the
/// match filters, your search criteria and the profile cards.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.criteria,
    this.savedName,
    this.showBottomNav = false,
  });

  /// Value this screen pops with when the user picks "New Search".
  static const newSearch = 'new-search';

  final SearchCriteria criteria;

  /// Name of the saved search being shown, if any.
  final String? savedName;
  final bool showBottomNav;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late SearchCriteria _c = widget.criteria.copy();
  late String? _savedName = widget.savedName;
  MatchTab _tab = MatchTab.all;

  final _api = SearchApi();
  final _scroll = ScrollController();
  final List<MatchProfile> _profiles = [];
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  int _page = 1;
  int? _lastPage;
  int? _total;
  int _request = 0; // drops responses from superseded searches

  bool get _hasMore =>
      _c.type != SearchType.profileId &&
      (_lastPage == null ? _profiles.length >= SearchApi.perPage * _page
          : _page < _lastPage!);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.hasClients && _scroll.position.extentAfter < 400) _loadMore();
  }

  /// (Re)runs the search from page 1.
  Future<void> _load() async {
    final req = ++_request;
    setState(() {
      _loading = true;
      _loadingMore = false;
      _error = null;
      _profiles.clear();
      _page = 1;
      _lastPage = null;
      _total = null;
    });
    try {
      final r = await _api.run(_c, page: 1);
      if (!mounted || req != _request) return;
      setState(() {
        _profiles.addAll(r.profiles);
        _total = r.total;
        _lastPage = r.lastPage;
      });
    } on SearchException catch (e) {
      if (mounted && req == _request) setState(() => _error = e.message);
    } catch (e) {
      debugPrint('Search failed: $e');
      if (mounted && req == _request) {
        setState(() => _error = 'Could not load search results. Please try again');
      }
    } finally {
      if (mounted && req == _request) setState(() => _loading = false);
    }
    if (mounted && req == _request) _fillTab();
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || _error != null || !_hasMore) return;
    final req = _request;
    setState(() => _loadingMore = true);
    try {
      final r = await _api.run(_c, page: _page + 1);
      if (!mounted || req != _request) return;
      final seen = _profiles.map((p) => p.key).toSet();
      final fresh = r.profiles.where((p) => seen.add(p.key)).toList();
      setState(() {
        _page++;
        _profiles.addAll(fresh);
        _total = r.total ?? _total;
        _lastPage = r.lastPage ?? _lastPage;
        if (fresh.isEmpty) _lastPage = _page; // nothing new: stop paging
      });
    } catch (e) {
      debugPrint('Search load more failed: $e');
      if (mounted && req == _request) setState(() => _lastPage = _page);
    } finally {
      if (mounted && req == _request) setState(() => _loadingMore = false);
    }
    if (mounted && req == _request) _fillTab();
  }

  Future<void> _sendViewRequest(MatchProfile p, ViewRequestType t) async {
    final error = await context.read<MatchesProvider>().sendViewRequest(p, t);
    if (!mounted) return;
    setState(() {});
    _toast(error ?? '${t.label} request sent to ${p.name}');
  }

  /// Hides / unhides [p] via `profiles/{id}/dont-show`.
  Future<void> _setHidden(MatchProfile p, {required bool hide}) async {
    final error =
        await context.read<MatchesProvider>().setHidden(p, hide: hide);
    if (!mounted) return;
    if (error != null) {
      _toast(error);
      return;
    }
    setState(() => p.hidden = hide);
    if (hide) {
      _toast('Hidden from your results',
          onUndo: () => _setHidden(p, hide: false));
    } else {
      _toast('${p.name} is back in your results');
    }
  }

  Future<void> _toggleShortlist(MatchProfile p) async {
    final now = await context.read<MatchesProvider>().toggleShortlist(p);
    if (!mounted) return;
    setState(() {});
    _toast(now == null
        ? 'Could not update your shortlist. Please try again'
        : now
            ? 'Added to your shortlist'
            : 'Removed from your shortlist');
  }

  bool get _isDontShow => _tab == MatchTab.dontShow;
  int get _hiddenCount => _profiles.where((p) => p.hidden).length;

  /// Tabs that narrow the search results to the members of a `matches/*` list.
  bool get _isListTab => _tab != MatchTab.all && !_isDontShow;

  /// Tab lists already (re)fetched while this screen is open.
  final Set<MatchTab> _tabsFetched = {};
  final Set<MatchTab> _tabsLoading = {};
  bool get _tabLoading => _tabsLoading.contains(_tab);

  /// Search results for the current tab: "All" shows every result, the other
  /// tabs only the results that are also in that tab's list.
  List<MatchProfile> _visibleFor(MatchesProvider mp) {
    if (_isDontShow) {
      return _profiles.where((p) => p.hidden).toList(growable: false);
    }
    final shown = _profiles.where((p) => !p.hidden);
    if (!_isListTab) return shown.toList(growable: false);
    final keys = {for (final p in mp.page(_tab).items) p.key};
    return shown
        .where((p) =>
            keys.contains(p.key) || (_tab == MatchTab.online && p.online))
        .toList(growable: false);
  }

  void _pickTab(MatchTab t) {
    setState(() => _tab = t);
    _loadTabList();
  }

  /// Loads the member list behind [_tab] (once per screen), then makes sure
  /// enough search pages are loaded to fill the filtered list.
  Future<void> _loadTabList() async {
    final tab = _tab;
    if (tab == MatchTab.all || tab == MatchTab.dontShow) return;
    if (_tabsFetched.contains(tab) || _tabsLoading.contains(tab)) {
      _fillTab();
      return;
    }
    setState(() => _tabsLoading.add(tab));
    await context.read<MatchesProvider>().loadAll(tab, refresh: true);
    if (!mounted) return;
    setState(() {
      _tabsLoading.remove(tab);
      if (context.read<MatchesProvider>().page(tab).error == null) {
        _tabsFetched.add(tab);
      }
    });
    _fillTab();
  }

  /// A tab may keep only a few of the loaded search results; fetch more
  /// search pages until it has enough rows or the search runs out.
  void _fillTab() {
    if (!mounted || !_isListTab || _tabLoading) return;
    final rows = _visibleFor(context.read<MatchesProvider>());
    if (rows.length < 10 && _hasMore) _loadMore();
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  Future<void> _sendInterest(MatchProfile p) async {
    final status = interestStatusOf(p);
    if (status == InterestStatus.awaiting ||
        status == InterestStatus.accepted) {
      return;
    }
    final mp = context.read<MatchesProvider>();
    final error = await sendInterestApi(p.apiId);
    if (error == null) mp.markInterestSent(p);
    if (!mounted) return;
    _toast(error ?? 'Interest sent to ${p.name}');
  }

  void _toast(String msg, {VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 5),
        // A snackbar with an action (Undo) stays open by default.
        persist: false,
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                textColor: AppColors.goldBorder,
                onPressed: onUndo,
              ),
      ));
  }

  void _newSearch() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop(SearchResultsScreen.newSearch);
    } else {
      nav.pushReplacement(
          MaterialPageRoute(builder: (_) => const SearchScreen()));
    }
  }

  void _applySaved(SavedSearch s) {
    setState(() {
      _c = s.criteria.copy();
      _savedName = s.name;
      _tab = MatchTab.all;
    });
    _load();
  }

  Future<void> _saveSearch() async {
    final name = await askSearchName(context);
    if (name == null || name.isEmpty || !mounted) return;
    addSavedSearch(name, _c);
    setState(() => _savedName = name);
    _toast('Saved as "$name"');
  }

  void _removeTag(CriteriaTag t) {
    setState(() {
      _c.remove(t);
      _savedName = null; // criteria changed, no longer the saved one
    });
    _load();
  }

  Future<void> _openMore() async {
    final picked = await showModalBottomSheet<MatchTab>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.fieldBorder,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 10),
                child: Text(
                  'More',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              _SheetOption(
                icon: Icons.visibility_off_outlined,
                iconName: 'eye_off',
                label: "Marked As Don't show",
                count: _hiddenCount,
                selected: _isDontShow,
                onTap: () => Navigator.pop(ctx, MatchTab.dontShow),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _tab = picked);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final rows = _visibleFor(context.watch<MatchesProvider>());
    final busy = _loading || (_isListTab && _tabLoading);

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      // No bottom bar here: this screen opens inside the Search tab of
      // DashboardShell, which already shows the app's bottom bar.
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
            stops: [0, 0.4],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchTopBar(
                title: 'Search results',
                trailing: CircleIconButton(
                  tooltip: 'Edit search',
                  background: Colors.white,
                  borderColor: AppColors.fieldBorder,
                  icon: matchIcon(Icons.tune_rounded, 'filter',
                      size: 20, color: AppColors.tealMid),
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),

              // New or Saved Search dropdown
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SavedSearchDropdown(
                  currentName: _savedName,
                  onNewSearch: _newSearch,
                  onPick: _applySaved,
                ),
              ),

              // Filter chips
              _ResultChips(
                current: _tab,
                onPick: _pickTab,
                onMore: _openMore,
              ),
              const SizedBox(height: 6),

              Expanded(
                child: RefreshIndicator(
                 color: AppColors.tealMid,
                 onRefresh: _load,
                 child: ListView(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    if (!_isDontShow) ...[
                      _CriteriaCard(
                        criteria: _c,
                        isSaved: _savedName != null,
                        onEdit: () => Navigator.of(context).maybePop(),
                        onRemove: _removeTag,
                        onSave: _saveSearch,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      _isDontShow
                          ? "Marked As Don't show · ${rows.length}"
                          : busy
                              ? 'Searching…'
                              : _isListTab
                                  ? '${_tab.label} · ${rows.length}${_hasMore ? '+' : ''} '
                                      '${rows.length == 1 ? 'profile' : 'profiles'}'
                                  : '${_total ?? rows.length} ${(_total ?? rows.length) == 1 ? 'profile' : 'profiles'} found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_isDontShow) ...[
                      const DontShowInfo(),
                      const SizedBox(height: 14),
                    ],
                    if (busy)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.tealMid),
                        ),
                      )
                    else if (_error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: _load,
                              icon: const Icon(Icons.refresh_rounded,
                                  color: AppColors.tealMid),
                              label: const Text(
                                'Try again',
                                style: TextStyle(
                                  color: AppColors.tealMid,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_isListTab &&
                        context.read<MatchesProvider>().page(_tab).error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            Text(
                              context.read<MatchesProvider>().page(_tab).error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: _loadTabList,
                              icon: const Icon(Icons.refresh_rounded,
                                  color: AppColors.tealMid),
                              label: const Text(
                                'Try again',
                                style: TextStyle(
                                  color: AppColors.tealMid,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (rows.isEmpty && !_loadingMore)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          _c.type == SearchType.profileId
                              ? 'No profile found with ID ${_c.values['profileId'] ?? ''}.'
                              : _isListTab
                                  ? 'None of your search results are in ${_tab.label}.'
                                  : 'No profiles match these filters.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textMuted),
                        ),
                      ),
                    for (final p in busy ? const <MatchProfile>[] : rows) ...[
                      MatchCard(
                        profile: p,
                        dontShowMode: _isDontShow,
                        onShortlist: () => _toggleShortlist(p),
                        onInterest: () => _sendInterest(p),
                        onHide: () => _setHidden(p, hide: true),
                        onUnhide: () => _setHidden(p, hide: false),
                        onShare: () {/* TODO */},
                        onCall: () {/* TODO */},
                        onWhatsApp: () {/* TODO */},
                        onRequest: (t) => _sendViewRequest(p, t),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfileDetailScreen(
                                  profile: MemberProfile.fromMatch(p),
                                  onDontShow: () async {
                                    final error = await context
                                        .read<MatchesProvider>()
                                        .setHidden(p, hide: true);
                                    if (error == null && mounted) {
                                      setState(() => p.hidden = true);
                                    }
                                    return error;
                                  },
                                  onRequestAccess: (t) async {
                                    final error = await context
                                        .read<MatchesProvider>()
                                        .sendViewRequest(p, t);
                                    if (mounted) setState(() {});
                                    return error;
                                  },
                                ))),
                      ),
                      const SizedBox(height: 18),
                    ],
                    if (_loadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.4, color: AppColors.tealMid),
                          ),
                        ),
                      ),
                  ],
                 ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  "New or Saved Search" dropdown
// ─────────────────────────────────────────────────────────────────────────────
class SavedSearchDropdown extends StatelessWidget {
  const SavedSearchDropdown({
    super.key,
    required this.currentName,
    required this.onNewSearch,
    required this.onPick,
  });

  final String? currentName;
  final VoidCallback onNewSearch;
  final ValueChanged<SavedSearch> onPick;

  static const _new = Object();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SavedSearch>>(
      valueListenable: savedSearchStore,
      builder: (context, saved, _) {
        return LayoutBuilder(
          builder: (context, box) => PopupMenuButton<Object>(
            tooltip: 'New or saved search',
            position: PopupMenuPosition.under,
            offset: const Offset(0, 6),
            constraints: BoxConstraints(
                minWidth: box.maxWidth, maxWidth: box.maxWidth),
            color: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.blueTintBorder),
            ),
            onSelected: (v) {
              if (identical(v, _new)) {
                onNewSearch();
              } else if (v is SavedSearch) {
                onPick(v);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem<Object>(
                value: _new,
                height: 48,
                child: Row(
                  children: [
                    matchIcon(Icons.add_circle_outline_rounded, 'add',
                        size: 20, color: AppColors.tealMid),
                    const SizedBox(width: 10),
                    const Text(
                      'New Search',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tealMid,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<Object>(
                enabled: false,
                height: 32,
                child: Text(
                  'SAVED SEARCHES',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              if (saved.isEmpty)
                const PopupMenuItem<Object>(
                  enabled: false,
                  child: Text(
                    'No saved searches yet',
                    style: TextStyle(fontSize: 14, color: AppColors.hint),
                  ),
                ),
              for (final s in saved)
                PopupMenuItem<Object>(
                  value: s,
                  height: 52,
                  child: Row(
                    children: [
                      matchIcon(Icons.bookmark_border_rounded, 'bookmark',
                          size: 20, color: AppColors.goldDark),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                            Text(
                              s.criteria.summary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      if (s.name == currentName)
                        matchIcon(Icons.check_rounded, 'check',
                            size: 20, color: AppColors.tealMid),
                    ],
                  ),
                ),
            ],
            child: Container(
              height: 48,
              padding: const EdgeInsets.only(left: 14, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.tealMid, width: 1.2),
              ),
              child: Row(
                children: [
                  matchIcon(
                    currentName == null
                        ? Icons.bookmarks_outlined
                        : Icons.bookmark_rounded,
                    'bookmark',
                    size: 18,
                    color: AppColors.tealMid,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentName ?? 'New or Saved Search',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  matchIcon(Icons.keyboard_arrow_down_rounded, 'arrow_down',
                      size: 22, color: AppColors.tealMid),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
class _ResultChips extends StatelessWidget {
  const _ResultChips({
    required this.current,
    required this.onPick,
    required this.onMore,
  });

  final MatchTab current;
  final ValueChanged<MatchTab> onPick;
  final VoidCallback onMore;

  // Same filters as the web results page (Profession etc. aren't shown here).
  static const _tabs = [
    MatchTab.all,
    MatchTab.newlyJoined,
    MatchTab.shortlistedYou,
    MatchTab.viewedYou,
    MatchTab.shortlistedByYou,
    MatchTab.viewedByYou,
    MatchTab.online,
  ];

  @override
  Widget build(BuildContext context) {
    final moreActive = current == MatchTab.dontShow;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == _tabs.length) {
            return FilterPill(
              label: moreActive ? "Don't show" : 'More',
              selected: moreActive,
              trailing: Icons.keyboard_arrow_down_rounded,
              onTap: onMore,
            );
          }
          final t = _tabs[i];
          return FilterPill(
            label: t.label,
            selected: t == current,
            onTap: () => onPick(t),
          );
        },
      ),
    );
  }
}

class _CriteriaCard extends StatelessWidget {
  const _CriteriaCard({
    required this.criteria,
    required this.isSaved,
    required this.onEdit,
    required this.onRemove,
    required this.onSave,
  });

  final SearchCriteria criteria;
  final bool isSaved;
  final VoidCallback onEdit;
  final ValueChanged<CriteriaTag> onRemove;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final tags = criteria.tags;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.blueTint],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your search criteria',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${criteria.type.label} search · ${tags.length} '
                      '${tags.length == 1 ? 'filter' : 'filters'}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 84,
                child: PillButton(
                  label: 'Edit',
                  icon: matchIcon(Icons.edit_outlined, 'edit',
                      size: 16, color: AppColors.goldDark),
                  foreground: AppColors.goldDark,
                  gradient: const LinearGradient(
                    colors: [AppColors.loginA, AppColors.loginB],
                  ),
                  borderColor: AppColors.goldBorder,
                  onTap: onEdit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tags.isEmpty)
            const Text(
              'No filters — showing all profiles.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in tags)
                  _TagChip(tag: t, onRemove: () => onRemove(t)),
              ],
            ),
          if (!isSaved && tags.isNotEmpty)
            TextButton.icon(
              onPressed: onSave,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                foregroundColor: AppColors.link,
              ),
              icon: matchIcon(Icons.bookmark_border_rounded, 'bookmark',
                  size: 18, color: AppColors.link),
              label: const Text(
                'Save this search',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            )
          else
            const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag, required this.onRemove});

  final CriteriaTag tag;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: '${tag.label}  ',
              style: const TextStyle(color: AppColors.textMuted),
              children: [
                TextSpan(
                  text: tag.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 12),
          ),
          IconButton(
            tooltip: 'Remove ${tag.label}',
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: matchIcon(Icons.close_rounded, 'close',
                size: 15, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.iconName,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String iconName;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
            color: selected ? AppColors.tealMid : AppColors.blueTintBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.tealMid.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: matchIcon(icon, iconName,
                      size: 19, color: AppColors.tealMid),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (count > 0)
                  Container(
                    height: 24,
                    constraints: const BoxConstraints(minWidth: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.toggleBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldDark,
                      ),
                    ),
                  ),
                if (selected) ...[
                  const SizedBox(width: 6),
                  matchIcon(Icons.check_rounded, 'check',
                      size: 20, color: AppColors.tealMid),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}