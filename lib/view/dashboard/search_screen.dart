import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_result_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Search model
// ─────────────────────────────────────────────────────────────────────────────
enum SearchType {
  basic('Basic'),
  advanced('Advanced'),
  saved('Saved'),
  profileId('Profile ID'),
  keyword('Keyword');

  const SearchType(this.label);
  final String label;
}

/// One dropdown on the form. Replace the sample [options] with your API data.
class SearchField {
  const SearchField(this.id, this.label, this.hint, this.options);
  final String id;
  final String label;
  final String hint;
  final List<String> options;
}

// Sample option lists — swap for values from your backend.
final kAgeOptions = [for (var a = 18; a <= 60; a++) '$a'];
final kHeightOptions = [
  for (var i = 48; i <= 84; i++) "${i ~/ 12}'${i % 12}\"",
];
final kWeightOptions = [for (var w = 40; w <= 120; w += 5) '$w kg'];

const kBasicFields = <SearchField>[
  SearchField('marital', 'Marital Status', 'Select marital status', [
    'Never married',
    'Divorced',
    'Widow / Widower',
    'Awaiting divorce',
    'Annulled',
  ]),
  SearchField('disability', 'Disability Status', 'Select',
      ['None', 'Physically challenged']),
  SearchField('motherTongue', 'Mother Tongue', 'Select mother tongue', [
    'Malayalam',
    'English',
    'Hindi',
    'Tamil',
    'Kannada',
    'Telugu',
    'Arabic',
  ]),
  SearchField('education', 'Education', 'Select education', [
    'Higher Secondary',
    'Diploma',
    'Bachelors Degree',
    'Master Degree',
    'Doctorate',
  ]),
  SearchField('religion', 'Religion', 'Select religion',
      ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist']),
  SearchField('caste', 'Caste', 'Select caste',
      ['Nair', 'Thiyya', 'Ezhava', 'Other']),
  SearchField('familyType', 'Family Type', 'Select family type',
      ['Nuclear family', 'Joint family']),
];

const kAdvancedFields = <SearchField>[
  SearchField('occupation', 'Occupation', 'Select occupation', [
    'Software Engineer',
    'Software Developer',
    'Doctor',
    'Teacher',
    'Government / PSU',
    'Business',
  ]),
  SearchField('income', 'Annual Income', 'Select income range', [
    'Below ₹3 Lakh',
    '₹3 – 5 Lakh',
    '₹5 – 10 Lakh',
    '₹10 – 20 Lakh',
    'Above ₹20 Lakh',
  ]),
  SearchField('location', 'Country / State / City', 'Select location', [
    'India · Kerala · Kozhikode',
    'India · Kerala · Malappuram',
    'India · Kerala · Thrissur',
    'India · Kerala · Kochi',
    'India · Kerala · Kannur',
  ]),
  SearchField('diet', 'Diet', 'Select diet',
      ['Vegetarian', 'Non-vegetarian', 'Eggetarian']),
];

const kQuickToggles = <(String, String, IconData)>[
  ('withPhoto', 'With photo', Icons.photo_camera_outlined),
  ('verified', 'Verified', Icons.verified_user_outlined),
  ('online', 'Online now', Icons.wifi_rounded),
  ('premium', 'Premium', Icons.workspace_premium_outlined),
];

/// One removable tag in the "Your search criteria" box.
class CriteriaTag {
  const CriteriaTag(this.label, this.value, this.keys);
  final String label;
  final String value;
  final List<String> keys; // value keys / toggle ids this tag clears
}

class SearchCriteria {
  SearchCriteria({
    Map<String, String>? values,
    Set<String>? toggles,
    this.type = SearchType.basic,
  })  : values = {...?values},
        toggles = {...?toggles};

  final Map<String, String> values;
  final Set<String> toggles;
  SearchType type;

  SearchCriteria copy() =>
      SearchCriteria(values: values, toggles: toggles, type: type);

  bool get isEmpty => values.isEmpty && toggles.isEmpty;

  void remove(CriteriaTag tag) {
    for (final k in tag.keys) {
      values.remove(k);
      toggles.remove(k);
    }
  }

  List<CriteriaTag> get tags {
    final out = <CriteriaTag>[];
    void range(String label, String from, String to, [String suffix = '']) {
      final a = values[from], b = values[to];
      if (a == null && b == null) return;
      out.add(CriteriaTag(
          label, '${a ?? 'Any'} – ${b ?? 'Any'}$suffix', [from, to]));
    }

    range('Age', 'ageFrom', 'ageTo', ' yrs');
    range('Height', 'heightFrom', 'heightTo');
    range('Weight', 'weightFrom', 'weightTo');
    for (final f in [...kBasicFields, ...kAdvancedFields]) {
      final v = values[f.id];
      if (v != null) out.add(CriteriaTag(f.label, v, [f.id]));
    }
    final kw = values['keyword'];
    if (kw != null) out.add(CriteriaTag('Keywords', kw, ['keyword']));
    for (final t in kQuickToggles) {
      if (toggles.contains(t.$1)) out.add(CriteriaTag(t.$2, 'Yes', [t.$1]));
    }
    return out;
  }

  /// "Age 24–30 · Malayalam · Hindu" style one-line summary.
  String get summary => tags.map((t) => t.value).join(' · ');
}

class SavedSearch {
  SavedSearch(this.name, this.criteria);
  final String name;
  final SearchCriteria criteria;
}

/// In-memory saved searches shared by the form and the results screen.
/// TODO: load from / save to your API.
final savedSearchStore = ValueNotifier<List<SavedSearch>>([
  SavedSearch(
    'Filter 1',
    SearchCriteria(
      values: {
        'ageFrom': '24',
        'ageTo': '30',
        'motherTongue': 'Malayalam',
        'religion': 'Hindu',
      },
      toggles: {'withPhoto'},
    ),
  ),
]);

void addSavedSearch(String name, SearchCriteria c) {
  savedSearchStore.value = [
    ...savedSearchStore.value,
    SavedSearch(name, c.copy()),
  ];
}

/// Asks for a name and returns it (null if cancelled).
Future<String?> askSearchName(BuildContext context) {
  final ctrl = TextEditingController(
      text: 'Filter ${savedSearchStore.value.length + 1}');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Save this search',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy),
      ),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: searchInputDecoration('Search name'),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.textMuted)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.tealMid),
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

InputDecoration searchInputDecoration(String hint) {
  OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 14, color: AppColors.hint),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: b(AppColors.fieldBorder),
    enabledBorder: b(AppColors.fieldBorder),
    focusedBorder: b(AppColors.tealMid, 1.4),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Search screen
// ─────────────────────────────────────────────────────────────────────────────
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialType = SearchType.basic,
  });

  final SearchType initialType;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchType _type = widget.initialType;
  SearchCriteria _c = SearchCriteria();
  final _idCtrl = TextEditingController();
  final _kwCtrl = TextEditingController();

  bool get _isForm => _type == SearchType.basic || _type == SearchType.advanced;

  @override
  void dispose() {
    _idCtrl.dispose();
    _kwCtrl.dispose();
    super.dispose();
  }

  void _set(String key, String? v) => setState(() {
        if (v == null) {
          _c.values.remove(key);
        } else {
          _c.values[key] = v;
        }
      });

  void _reset() => setState(() {
        _c = SearchCriteria(type: _c.type);
        _kwCtrl.clear();
        _idCtrl.clear();
      });

  Future<void> _save() async {
    if (_c.isEmpty) {
      _snack('Pick at least one filter to save this search');
      return;
    }
    final name = await askSearchName(context);
    if (name == null || name.isEmpty || !mounted) return;
    addSavedSearch(name, _c..type = _type);
    _snack('Saved as "$name"');
  }

  Future<void> _showResults(SearchCriteria c, {String? savedName}) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(criteria: c, savedName: savedName),
      ),
    );
    // "New Search" picked in the results dropdown → come back with a clean form.
    if (result == SearchResultsScreen.newSearch && mounted) {
      setState(() => _type = SearchType.basic);
      _reset();
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
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
                title: 'Search',
                trailing: CircleIconButton(
                  tooltip: 'Saved searches',
                  background: Colors.white,
                  borderColor: AppColors.fieldBorder,
                  icon: matchIcon(Icons.bookmark_border_rounded, 'bookmark',
                      size: 20, color: AppColors.navy),
                  onTap: () => setState(() => _type = SearchType.saved),
                ),
              ),
              _TypeTabs(
                current: _type,
                onPick: (t) => setState(() => _type = t),
              ),
              const SizedBox(height: 10),
              Expanded(child: _body()),
              if (_isForm)
                _FormActions(
                  onReset: _reset,
                  onSave: _save,
                  onSearch: () => _showResults((_c..type = _type).copy()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    switch (_type) {
      case SearchType.basic:
      case SearchType.advanced:
        return _form(advanced: _type == SearchType.advanced);
      case SearchType.saved:
        return _savedList();
      case SearchType.profileId:
        return _profileId();
      case SearchType.keyword:
        return _keyword();
    }
  }

  // ── Basic / Advanced ───────────────────────────────────────────────────────
  Widget _form({required bool advanced}) {
    Widget selects(List<SearchField> fields) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final f in fields) ...[
              FieldLabel(f.label),
              SelectField(
                hint: f.hint,
                title: f.label,
                options: f.options,
                value: _c.values[f.id],
                onChanged: (v) => _set(f.id, v),
              ),
              const SizedBox(height: 12),
            ],
          ],
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in kQuickToggles)
              _TogglePill(
                label: t.$2,
                icon: t.$3,
                selected: _c.toggles.contains(t.$1),
                onTap: () => setState(() => _c.toggles.contains(t.$1)
                    ? _c.toggles.remove(t.$1)
                    : _c.toggles.add(t.$1)),
              ),
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Physical',
          icon: Icons.accessibility_new_rounded,
          iconName: 'physical',
          tint: AppColors.blueTint,
          accent: AppColors.link,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _range('Age', 'ageFrom', 'ageTo', kAgeOptions),
              _range('Height', 'heightFrom', 'heightTo', kHeightOptions),
              _range('Weight', 'weightFrom', 'weightTo', kWeightOptions,
                  last: true),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Background & Lifestyle',
          icon: Icons.home_work_outlined,
          iconName: 'background',
          tint: AppColors.purple.withValues(alpha: 0.08),
          accent: AppColors.purple,
          child: selects(kBasicFields),
        ),
        if (advanced) ...[
          const SizedBox(height: 14),
          SectionCard(
            title: 'Career & Location',
            icon: Icons.work_outline_rounded,
            iconName: 'career',
            tint: AppColors.cream,
            accent: AppColors.brown,
            child: selects(kAdvancedFields),
          ),
        ],
      ],
    );
  }

  Widget _range(String label, String fromKey, String toKey, List<String> opts,
      {bool last = false}) {
    final from = _c.values[fromKey];
    final to = _c.values[toKey];
    final fromIdx = from == null ? 0 : opts.indexOf(from);
    final toIdx = to == null ? opts.length - 1 : opts.indexOf(to);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldLabel(label),
          Row(
            children: [
              Expanded(
                child: SelectField(
                  hint: 'From',
                  title: '$label from',
                  options: opts.sublist(0, toIdx + 1),
                  value: from,
                  onChanged: (v) => _set(fromKey, v),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('to',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.textMuted)),
              ),
              Expanded(
                child: SelectField(
                  hint: 'To',
                  title: '$label to',
                  options: opts.sublist(fromIdx),
                  value: to,
                  onChanged: (v) => _set(toKey, v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Saved ──────────────────────────────────────────────────────────────────
  Widget _savedList() {
    return ValueListenableBuilder<List<SavedSearch>>(
      valueListenable: savedSearchStore,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const _EmptyNote(
            'No saved searches yet. Set filters on Basic or Advanced and tap Save.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Tap a saved search to see its latest matches.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ),
            for (final s in list) ...[
              _SavedSearchTile(
                search: s,
                onTap: () =>
                    _showResults(s.criteria.copy(), savedName: s.name),
                onDelete: () => savedSearchStore.value =
                    list.where((x) => x != s).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }

  // ── Profile ID ─────────────────────────────────────────────────────────────
  Widget _profileId() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        SectionCard(
          title: 'Profile ID search',
          icon: Icons.badge_outlined,
          iconName: 'profile_id',
          tint: AppColors.blueTint,
          accent: AppColors.link,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FieldLabel('Profile ID'),
              TextField(
                controller: _idCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: searchInputDecoration('e.g. VBM26532747M'),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the ID shown on a member's profile to open it directly.",
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              PillButton(
                label: 'Open profile',
                icon: matchIcon(Icons.person_search_rounded, 'search',
                    size: 18, color: Colors.white),
                foreground: Colors.white,
                gradient: kTealGradient,
                onTap: () {
                  if (_idCtrl.text.trim().isEmpty) {
                    _snack('Enter a profile ID');
                    return;
                  }
                  // TODO: open profile by ID
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Keyword ────────────────────────────────────────────────────────────────
  Widget _keyword() {
    const popular = [
      'Software engineer',
      'Doctor',
      'Teacher',
      'Kozhikode',
      'Thrissur',
      'Vegetarian',
      'Family-oriented',
      'Loves travel',
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        SectionCard(
          title: 'Keyword search',
          icon: Icons.manage_search_rounded,
          iconName: 'keyword',
          tint: AppColors.cream,
          accent: AppColors.brown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FieldLabel('Keywords'),
              TextField(
                controller: _kwCtrl,
                decoration: searchInputDecoration('e.g. Doctor, Kozhikode'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Search names, professions, places or interests. '
                'Separate keywords with commas.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              const FieldLabel('Popular keywords'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final k in popular)
                    FilterPill(
                      label: k,
                      selected: false,
                      onTap: () {
                        final t = _kwCtrl.text.trim();
                        _kwCtrl.text = t.isEmpty ? k : '$t, $k';
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              PillButton(
                label: 'Search',
                icon: matchIcon(Icons.search_rounded, 'search',
                    size: 18, color: Colors.white),
                foreground: Colors.white,
                gradient: kTealGradient,
                onTap: () {
                  final kw = _kwCtrl.text.trim();
                  if (kw.isEmpty) {
                    _snack('Type at least one keyword');
                    return;
                  }
                  _showResults(SearchCriteria(
                      values: {'keyword': kw}, type: SearchType.keyword));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
class SearchTopBar extends StatelessWidget {
  const SearchTopBar({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          CircleIconButton(
            tooltip: 'Back',
            icon: matchIcon(Icons.chevron_left_rounded, 'back',
                size: 26, color: AppColors.goldDark),
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _TypeTabs extends StatelessWidget {
  const _TypeTabs({required this.current, required this.onPick});

  final SearchType current;
  final ValueChanged<SearchType> onPick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: SearchType.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final t = SearchType.values[i];
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

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.navy;
    return Semantics(
      toggled: selected,
      child: Material(
        color: selected ? AppColors.tealMid : Colors.white,
        shape: StadiumBorder(
          side: BorderSide(
              color: selected ? AppColors.tealMid : AppColors.fieldBorder),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                matchIcon(icon, label.toLowerCase(), size: 16, color: fg),
                const SizedBox(width: 6),
                Text(label,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconName,
    required this.tint,
    required this.accent,
    required this.child,
  });

  final String title;
  final IconData icon;
  final String iconName;
  final Color tint;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, tint],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: matchIcon(icon, iconName, size: 19, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
    );
  }
}

/// A dropdown field that opens a bottom-sheet list (better than a native
/// dropdown for long lists like caste or location).
class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.hint,
    required this.options,
    required this.value,
    required this.onChanged,
    this.title,
  });

  final String hint;
  final String? title;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  static const _clear = '\u0000clear';

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title ?? hint,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    if (value != null)
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, _clear),
                        child: const Text('Clear',
                            style: TextStyle(color: AppColors.coral)),
                      ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                  itemCount: options.length,
                  itemBuilder: (_, i) {
                    final o = options[i];
                    final sel = o == value;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      selected: sel,
                      selectedTileColor:
                          AppColors.tealMid.withValues(alpha: 0.08),
                      title: Text(
                        o,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? AppColors.tealMid : AppColors.navy,
                        ),
                      ),
                      trailing: sel
                          ? matchIcon(Icons.check_rounded, 'check',
                              size: 20, color: AppColors.tealMid)
                          : null,
                      onTap: () => Navigator.pop(ctx, o),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked == null) return;
    onChanged(picked == _clear ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final has = value != null;
    return Semantics(
      button: true,
      label: title ?? hint,
      value: value,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
              color: has ? AppColors.tealMid : AppColors.fieldBorder),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _pick(context),
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value ?? hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: has ? FontWeight.w600 : FontWeight.w400,
                        color: has ? AppColors.navy : AppColors.hint,
                      ),
                    ),
                  ),
                  matchIcon(Icons.keyboard_arrow_down_rounded, 'arrow_down',
                      size: 20, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormActions extends StatelessWidget {
  const _FormActions({
    required this.onReset,
    required this.onSave,
    required this.onSearch,
  });

  final VoidCallback onReset;
  final VoidCallback onSave;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.blueTintBorder)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: PillButton(
              label: 'Reset',
              icon: matchIcon(Icons.restart_alt_rounded, 'reset',
                  size: 17, color: AppColors.textMuted),
              foreground: AppColors.textMuted,
              background: Colors.white,
              borderColor: AppColors.fieldBorder,
              onTap: onReset,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: PillButton(
              label: 'Save',
              icon: matchIcon(Icons.bookmark_border_rounded, 'bookmark',
                  size: 17, color: AppColors.goldDark),
              foreground: AppColors.goldDark,
              gradient: const LinearGradient(
                colors: [AppColors.loginA, AppColors.loginB],
              ),
              borderColor: AppColors.goldBorder,
              onTap: onSave,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: PillButton(
              label: 'Show matches',
              icon: matchIcon(Icons.search_rounded, 'search',
                  size: 18, color: Colors.white),
              foreground: Colors.white,
              gradient: kTealGradient,
              onTap: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedSearchTile extends StatelessWidget {
  const _SavedSearchTile({
    required this.search,
    required this.onTap,
    required this.onDelete,
  });

  final SavedSearch search;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.blueTintBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.toggleBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: matchIcon(Icons.bookmark_rounded, 'bookmark',
                    size: 20, color: AppColors.goldDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      search.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      search.criteria.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete saved search',
                onPressed: onDelete,
                icon: matchIcon(Icons.delete_outline_rounded, 'delete',
                    size: 20, color: AppColors.textMuted),
              ),
              matchIcon(Icons.chevron_right_rounded, 'arrow_right',
                  size: 20, color: AppColors.hint),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
      ),
    );
  }
}