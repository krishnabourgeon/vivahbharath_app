import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/search_options.dart';
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

/// One dropdown on the form. Fields listed in [SearchOptions.apiFields] get
/// their options from the API; the rest use the static [fallback] list.
class SearchField {
  const SearchField(this.id, this.label, this.hint,
      [this.fallback = const [], this.multi = true]);
  final String id;
  final String label;
  final String hint;
  final List<String> fallback;

  /// True: pick several (e.g. many cities). False: pick one.
  final bool multi;

  bool get fromApi => SearchOptions.apiFields.contains(id);

  List<String> get options =>
      fromApi ? SearchOptions.instance.namesOf(id) : fallback;

  SearchField relabel(String label) =>
      SearchField(id, label, hint, fallback, multi);
}

// Ranges are generated locally (the API filters by number).
final kAgeOptions = [for (var a = 18; a <= 60; a++) '$a'];
/// 131 – 210 cm, every cm.
final kHeightOptions = [for (var h = 131; h <= 210; h++) '$h cm'];

/// 35 – 150 kg, every kg.
final kWeightOptions = [for (var w = 35; w <= 150; w++) '$w kg'];

/// Number part of a "170 cm" / "60 kg" option, for API requests.
int? measureValue(String? option) =>
    option == null ? null : int.tryParse(option.split(' ').first);

// Options for every field without a static list come from the API
// (see SearchOptions.apiFields).
const kBasicFields = <SearchField>[
  SearchField('marital', 'Marital Status', 'Select marital status'),
  SearchField('disability', 'Disability Status', 'Select',
      ['Yes', 'No']),
  SearchField('motherTongue', 'Mother Tongue', 'Select mother tongue'),
  SearchField('education', 'Education', 'Select education'),
  SearchField('religion', 'Religion', 'Select religion'),
  SearchField('caste', 'Caste', 'Select caste'),
  SearchField('familyType', 'Family Type', 'Select family type'),
];

SearchField _basic(String id) => kBasicFields.firstWhere((f) => f.id == id);

// ── Advanced search (matches the web "Advanced Search" form) ────────────────
const _kYesNoAny = ['Yes', 'No'];

const kAdvLifestyleFields = <SearchField>[
  SearchField('familyStatus', 'Family Status', 'Select family status'),
  SearchField('bodyType', 'Body Type', 'Select body type'),
  // motherTongue → from kBasicFields
  SearchField('skinTone', 'Body Skin Tone', 'Select body skin tone'),
  // familyType → from kBasicFields
  SearchField('foodType', 'Food Type', 'Select food type'),
  SearchField('drinking', 'Drinking Habits', 'Select'),
  SearchField('smoking', 'Smoking Habits', 'Select'),
];

const kAdvGotra = SearchField('gotra', 'Gotra', 'Select gotra');

const kAdvLocationFields = <SearchField>[
  SearchField('country', 'Country', 'Select country'),
  SearchField('state', 'State', 'Select state'),
  SearchField('city', 'City', 'Select city'),
];

const kAdvCareerFields = <SearchField>[
  // education (Qualification) → from kBasicFields
  SearchField('employment', 'Employment Type', 'Select employment type'),
  SearchField('occupation', 'Occupation', 'Select occupation'),
  SearchField('income', 'Annual Income', 'Select annual income'),
  SearchField('languages', 'Languages Known', 'Select languages'),
  SearchField('familyProperty', 'Family Property', 'Select family property'),
];

const kAdvHoroscopeFields = <SearchField>[
  SearchField(
      'sudha', 'Profile with Sudha Jathakam', 'Select', _kYesNoAny, false),
  SearchField(
      'dosha', 'Profile with Dosha Jathakam', 'Select', _kYesNoAny, false),
];

const kSortField = SearchField('sortBy', 'Sort by', 'Select',
    ['Best match', 'Newest first', 'Recently active', 'Premium first'], false);

const kCreatedWithin = ['All', 'Today', 'One week', 'One month'];

/// Every dropdown on both forms (used to build the criteria tags).
final kAllSearchFields = <SearchField>[
  ...kBasicFields,
  ...kAdvLifestyleFields,
  kAdvGotra,
  ...kAdvLocationFields,
  ...kAdvCareerFields,
  ...kAdvHoroscopeFields,
  kSortField,
];

// const kQuickToggles = <(String, String, IconData)>[
//   ('withPhoto', 'With photo', Icons.photo_camera_outlined),
//   ('verified', 'Verified', Icons.verified_user_outlined),
//   ('online', 'Online now', Icons.wifi_rounded),
//   ('premium', 'Premium', Icons.workspace_premium_outlined),
// ];

/// One removable tag in the "Your search criteria" box.
class CriteriaTag {
  const CriteriaTag(this.label, this.value, this.keys, {this.only});
  final String label;
  final String value;
  final List<String> keys; // value keys / toggle ids this tag clears

  /// For multi-select fields: remove just this one option.
  final String? only;
}

class SearchCriteria {
  SearchCriteria({
    Map<String, String>? values,
    Map<String, Set<String>>? multi,
    Set<String>? toggles,
    this.type = SearchType.basic,
  })  : values = {...?values},
        multi = {
          for (final e in (multi ?? const <String, Set<String>>{}).entries)
            if (e.value.isNotEmpty) e.key: {...e.value},
        },
        toggles = {...?toggles};

  /// Single values (ranges, sort, Yes/No…).
  final Map<String, String> values;

  /// Multi-select values (cities, states, castes…).
  final Map<String, Set<String>> multi;
  final Set<String> toggles;
  SearchType type;

  SearchCriteria copy() => SearchCriteria(
      values: values, multi: multi, toggles: toggles, type: type);

  bool get isEmpty => values.isEmpty && multi.isEmpty && toggles.isEmpty;

  void setMulti(String key, Set<String> v) {
    if (v.isEmpty) {
      multi.remove(key);
    } else {
      multi[key] = {...v};
    }
  }

  void remove(CriteriaTag tag) {
    if (tag.only != null) {
      final set = multi[tag.keys.first];
      set?.remove(tag.only);
      if (set != null && set.isEmpty) multi.remove(tag.keys.first);
      return;
    }
    for (final k in tag.keys) {
      values.remove(k);
      multi.remove(k);
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
    for (final f in kAllSearchFields) {
      final v = values[f.id];
      if (v != null) out.add(CriteriaTag(f.label, v, [f.id]));
      // One tag per picked option, so each can be removed on its own.
      for (final m in multi[f.id] ?? const <String>{}) {
        out.add(CriteriaTag(f.label, m, [f.id], only: m));
      }
    }
    final surgery = values['surgery'];
    if (surgery != null) {
      out.add(CriteriaTag('Surgery / transplant', surgery, ['surgery']));
    }
    final created = values['createdWithin'];
    if (created != null && created != 'All') {
      out.add(CriteriaTag('Joined', created, ['createdWithin']));
    }
    final kw = values['keyword'];
    if (kw != null) out.add(CriteriaTag('Keywords', kw, ['keyword']));
    // for (final t in kQuickToggles) {
    //   if (toggles.contains(t.$1)) out.add(CriteriaTag(t.$2, 'Yes', [t.$1]));
    // }
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
      values: {'ageFrom': '24', 'ageTo': '30'},
      multi: {
        'motherTongue': {'Malayalam'},
        'religion': {'Hindu'},
        'city': {'Kozhikode', 'Kochi'},
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
    this.showBottomNav = true,
  });

  final SearchType initialType;
  final bool showBottomNav;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchType _type = widget.initialType;
  SearchCriteria _c = SearchCriteria();
  final _idCtrl = TextEditingController();
  final _kwCtrl = TextEditingController();

  bool get _isForm => _type == SearchType.basic || _type == SearchType.advanced;

  final _opts = SearchOptions.instance;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  @override
  void initState() {
    super.initState();
    _opts.addListener(_onOptions);
    // After the first frame: the provider notifies listeners as soon as a
    // fetch starts, which must not happen while the tree is building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadOptions();
    });
  }

  @override
  void dispose() {
    _opts.removeListener(_onOptions);
    _idCtrl.dispose();
    _kwCtrl.dispose();
    super.dispose();
  }

  void _onOptions() {
    if (mounted) setState(() {});
  }

  Future<void> _loadOptions({bool force = false}) async {
    await _opts.loadAll(_rp, force: force);
    if (!mounted) return;
    // Lists the user had already picked from may have changed on reload.
    // Top-level parents only (religion, country); _reloadChildren cascades.
    for (final parent in SearchOptions.parents.values.toSet()) {
      if (SearchOptions.parents.containsKey(parent)) continue;
      if (_c.multi[parent]?.isNotEmpty ?? false) await _reloadChildren(parent);
    }
    final failed = SearchOptions.apiFields
        .where((f) => !SearchOptions.parents.containsKey(f))
        .any((f) => _opts.of(f).isEmpty);
    if (failed && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.navy,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: const Text('Could not load some search options',
              style: TextStyle(fontSize: 13)),
          action: SnackBarAction(
            label: 'Retry',
            textColor: AppColors.gold,
            onPressed: () => _loadOptions(force: true),
          ),
        ));
    }
  }

  /// Picks in a multi-select field. When a parent (religion / country / state)
  /// changes, its dependent list is refetched and stale picks are dropped.
  void _setMulti(String field, Set<String> v) {
    setState(() => _c.setMulti(field, v));
    if (SearchOptions.parents.containsValue(field)) _reloadChildren(field);
  }

  Future<void> _reloadChildren(String parent) async {
    final child = SearchOptions.parents.entries
        .firstWhere((e) => e.value == parent)
        .key;
    final names = await _opts.loadChildren(
        _rp, child, _c.multi[parent] ?? const <String>{});
    if (names == null || !mounted) return; // superseded by a newer pick
    final picked = _c.multi[child];
    if (picked != null) {
      final kept = picked.where(names.contains).toSet();
      if (kept.length != picked.length) {
        setState(() => _c.setMulti(child, kept));
      }
    }
    // Cascade (country → state → city).
    if (SearchOptions.parents.containsValue(child)) {
      await _reloadChildren(child);
    }
  }

  void _set(String key, String? v) => setState(() {
        if (v == null) {
          _c.values.remove(key);
        } else {
          _c.values[key] = v;
        }
      });

  void _reset() {
    _opts.clearChildren();
    setState(() {
      _c = SearchCriteria(type: _c.type);
      _kwCtrl.clear();
      _idCtrl.clear();
    });
  }

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
  Widget _selects(List<SearchField> fields) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final f in fields) ...[
            FieldLabel(f.label),
            if (f.fromApi && f.options.isEmpty)
              OptionsPlaceholderField(
                loading: _opts.isLoading(f.id),
                text: _opts.isLoading(f.id)
                    ? 'Loading…'
                    : SearchOptions.parents.containsKey(f.id)
                        ? 'Select ${_fieldLabel(SearchOptions.parents[f.id]!).toLowerCase()} first'
                        : 'No options available',
              )
            else if (f.multi)
              MultiSelectField(
                hint: f.hint,
                title: f.label,
                options: f.options,
                values: _c.multi[f.id] ?? const {},
                onChanged: (v) => _setMulti(f.id, v),
              )
            else
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

  String _fieldLabel(String id) =>
      kAllSearchFields.firstWhere((f) => f.id == id).label;

  Widget _form({required bool advanced}) =>
      advanced ? _advancedForm() : _basicForm();

  Widget _basicForm() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
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
          child: _selects(kBasicFields),
        ),
      ],
    );
  }

  Widget _advancedForm() {
    const gap = SizedBox(height: 14);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        // Personal & lifestyle
        SectionCard(
          title: 'Personal & lifestyle',
          icon: Icons.accessibility_new_rounded,
          iconName: 'physical',
          tint: AppColors.blueTint,
          accent: AppColors.link,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _range('Age', 'ageFrom', 'ageTo', kAgeOptions),
              _range('Height', 'heightFrom', 'heightTo', kHeightOptions),
              _range('Weight', 'weightFrom', 'weightTo', kWeightOptions),
              _selects([_basic('marital'), _basic('disability')]),
              const FieldLabel(
                  'Are you preferring persons who have undergone major surgery or organ transplantation?'),
              _RadioRow(
                options: const ['Yes', 'No'],
                value: _c.values['surgery'],
                onChanged: (v) => _set('surgery', v),
              ),
              const SizedBox(height: 12),
              _selects([
                kAdvLifestyleFields[0], // Family Status
                kAdvLifestyleFields[1], // Body Type
                _basic('motherTongue'),
                kAdvLifestyleFields[2], // Body Skin Tone
                _basic('familyType'),
                kAdvLifestyleFields[3], // Food Type
                kAdvLifestyleFields[4], // Drinking
                kAdvLifestyleFields[5], // Smoking
              ]),
            ],
          ),
        ),
        gap,
        SectionCard(
          title: 'Religious details',
          icon: Icons.temple_hindu_outlined,
          iconName: 'religion',
          tint: const Color(0xFFFBF0EE),
          accent: AppColors.coral,
          child: _selects([_basic('religion'), _basic('caste'), kAdvGotra]),
        ),
        gap,
        SectionCard(
          title: 'Location details',
          icon: Icons.location_on_outlined,
          iconName: 'location',
          tint: AppColors.purple.withValues(alpha: 0.08),
          accent: AppColors.purple,
          child: _selects(kAdvLocationFields),
        ),
        gap,
        SectionCard(
          title: 'Education & professional details',
          icon: Icons.school_outlined,
          iconName: 'education',
          tint: AppColors.cream,
          accent: AppColors.brown,
          child: _selects([
            _basic('education').relabel('Qualification'),
            ...kAdvCareerFields,
          ]),
        ),
        gap,
        SectionCard(
          title: 'Horoscope details',
          icon: Icons.auto_awesome_outlined,
          iconName: 'horoscope',
          tint: const Color(0xFFFBF0EE),
          accent: AppColors.coral,
          child: _selects(kAdvHoroscopeFields),
        ),
        gap,
        SectionCard(
          title: 'Profiles type',
          icon: Icons.people_outline_rounded,
          iconName: 'profiles',
          tint: AppColors.blueTint,
          accent: AppColors.tealMid,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FieldLabel('Profiles based on created date'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final o in kCreatedWithin)
                    FilterPill(
                      label: o,
                      selected: (_c.values['createdWithin'] ?? 'All') == o,
                      onTap: () =>
                          _set('createdWithin', o == 'All' ? null : o),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.blueTintBorder),
              const SizedBox(height: 10),
              const FieldLabel('Profiles with Photo'),
              _CheckRow(
                label: 'Matches who have added photos',
                value: _c.toggles.contains('withPhoto'),
                onChanged: (v) => setState(() => v
                    ? _c.toggles.add('withPhoto')
                    : _c.toggles.remove('withPhoto')),
              ),
            ],
          ),
        ),
        gap,
        SectionCard(
          title: 'Sort and filter',
          icon: Icons.sort_rounded,
          iconName: 'sort',
          tint: AppColors.blueTint,
          accent: AppColors.link,
          child: _selects([kSortField]),
        ),
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


/// Single-choice radio options in a row (e.g. Yes / No).
class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        for (final o in options)
          Semantics(
            inMutuallyExclusiveGroup: true,
            checked: o == value,
            child: Material(
              color: o == value
                  ? AppColors.tealMid.withValues(alpha: 0.08)
                  : Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                    color:
                        o == value ? AppColors.tealMid : AppColors.fieldBorder),
              ),
              child: InkWell(
                customBorder: const StadiumBorder(),
                // Tap again to clear.
                onTap: () => onChanged(o == value ? null : o),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      matchIcon(
                        o == value
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        'radio',
                        size: 18,
                        color: o == value ? AppColors.tealMid : AppColors.hint,
                      ),
                      const SizedBox(width: 6),
                      Text(o,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: o == value
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: AppColors.navy)),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Tick box with a label.
class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: value ? AppColors.tealMid : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: value ? AppColors.tealMid : AppColors.fieldBorder,
                    width: 1.6,
                  ),
                ),
                child: value
                    ? Center(
                        child: matchIcon(Icons.check_rounded, 'check',
                            size: 16, color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style:
                        const TextStyle(fontSize: 14, color: AppColors.navy)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Multi-select dropdown: opens a list with tick boxes.
/// Long lists (cities, castes…) get a search box and Select all / Clear.
/// Used by Search, Edit Profile and Partner Preferences.
class MultiSelectField extends StatelessWidget {
  const MultiSelectField({
    super.key,
    required this.hint,
    required this.title,
    required this.options,
    required this.values,
    required this.onChanged,
  });

  final String hint;
  final String title;
  final List<String> options;
  final Set<String> values;
  final ValueChanged<Set<String>> onChanged;

  static const _maxChips = 3;

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<Set<String>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MultiSelectSheet(
        title: title,
        options: options,
        initial: values,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final has = values.isNotEmpty;
    final shown = values.take(_maxChips).toList();
    final extra = values.length - shown.length;

    return Semantics(
      button: true,
      label: title,
      value: has ? values.join(', ') : null,
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: has
                        ? Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final v in shown) _chip(v),
                              if (extra > 0) _chip('+$extra more', muted: true),
                            ],
                          )
                        : Text(hint,
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.hint)),
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

  Widget _chip(String v, {bool muted = false}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: muted
              ? AppColors.bgTop
              : AppColors.tealMid.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          v,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: muted ? AppColors.textMuted : AppColors.tealMid,
          ),
        ),
      );
}

class _MultiSelectSheet extends StatefulWidget {
  const _MultiSelectSheet({
    required this.title,
    required this.options,
    required this.initial,
  });

  final String title;
  final List<String> options;
  final Set<String> initial;

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _sel = {...widget.initial};
  String _q = '';

  bool get _long => widget.options.length > 8;

  List<String> get _visible => _q.isEmpty
      ? widget.options
      : widget.options
          .where((o) => o.toLowerCase().contains(_q.toLowerCase()))
          .toList();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final visible = _visible;
    final allVisibleSelected =
        visible.isNotEmpty && visible.every(_sel.contains);

    return Padding(
      // Keep the sheet above the keyboard while searching.
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.8),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    Text(
                      _sel.isEmpty ? 'Any' : '${_sel.length} selected',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
                if (_long) ...[
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (v) => setState(() => _q = v.trim()),
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                    decoration: searchInputDecoration(
                            'Search ${widget.title.toLowerCase()}')
                        .copyWith(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 6),
                        child: matchIcon(Icons.search_rounded, 'search',
                            size: 20, color: AppColors.textMuted),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    TextButton(
                      onPressed: visible.isEmpty
                          ? null
                          : () => setState(() => allVisibleSelected
                              ? _sel.removeAll(visible)
                              : _sel.addAll(visible)),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.tealMid),
                      child: Text(
                        allVisibleSelected ? 'Unselect all' : 'Select all',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed:
                          _sel.isEmpty ? null : () => setState(_sel.clear),
                      style:
                          TextButton.styleFrom(foregroundColor: AppColors.coral),
                      child: const Text('Clear',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Flexible(
                  child: visible.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No matches',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textMuted)),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: visible.length,
                          itemBuilder: (_, i) {
                            final o = visible[i];
                            final on = _sel.contains(o);
                            return Semantics(
                              checked: on,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => setState(
                                    () => on ? _sel.remove(o) : _sel.add(o)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 11),
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 120),
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: on
                                              ? AppColors.tealMid
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: on
                                                ? AppColors.tealMid
                                                : AppColors.fieldBorder,
                                            width: 1.6,
                                          ),
                                        ),
                                        child: on
                                            ? Center(
                                                child: matchIcon(
                                                    Icons.check_rounded,
                                                    'check',
                                                    size: 15,
                                                    color: Colors.white),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          o,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: on
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                PillButton(
                  label: _sel.isEmpty ? 'Done' : 'Done (${_sel.length})',
                  icon: matchIcon(Icons.check_rounded, 'check',
                      size: 18, color: Colors.white),
                  foreground: Colors.white,
                  gradient: kTealGradient,
                  onTap: () => Navigator.pop(context, _sel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
