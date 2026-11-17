import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
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
    this.showBottomNav = true,
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

  // TODO: load from your search API using [_c] and [_tab].
  final List<MatchProfile> _profiles = sampleMatches();

  bool get _isDontShow => _tab == MatchTab.dontShow;
  int get _hiddenCount => _profiles.where((p) => p.hidden).length;
  List<MatchProfile> get _visible => _profiles
      .where((p) => _isDontShow ? p.hidden : !p.hidden)
      .toList(growable: false);

  // ── Actions ────────────────────────────────────────────────────────────────
  void _toast(String msg, {VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(milliseconds: 3500),
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
    // TODO: reload results for the saved search.
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
    // TODO: reload results.
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
    final rows = _visible;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      bottomNavigationBar:
          widget.showBottomNav ? const AppBottomNav(currentIndex: 2) : null,
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
                onPick: (t) => setState(() => _tab = t),
                onMore: _openMore,
              ),
              const SizedBox(height: 6),

              Expanded(
                child: ListView(
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
                          : '${rows.length} profiles found',
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
                    if (rows.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'No profiles match these filters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textMuted),
                        ),
                      ),
                    for (final p in rows) ...[
                      MatchCard(
                        profile: p,
                        dontShowMode: _isDontShow,
                        onShortlist: () {
                          setState(() => p.shortlisted = !p.shortlisted);
                          _toast(p.shortlisted
                              ? 'Added to your shortlist'
                              : 'Removed from your shortlist');
                        },
                        onInterest: () {
                          setState(() => p.status = InterestStatus.awaiting);
                          _toast('Interest sent to ${p.name}');
                        },
                        onHide: () {
                          setState(() => p.hidden = true);
                          _toast('Hidden from your results',
                              onUndo: () => setState(() => p.hidden = false));
                        },
                        onUnhide: () {
                          setState(() => p.hidden = false);
                          _toast('${p.name} is back in your results');
                        },
                        onShare: () {/* TODO */},
                        onCall: () {/* TODO */},
                        onWhatsApp: () {/* TODO */},
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const ProfileDetailScreen())), // TODO: pass the member's data
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
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