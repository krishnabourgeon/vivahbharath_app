import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';

/// Dropdown options loaded from the API through the existing
/// [RegisterProvider] fetchers, keyed by a store key (`religion`, `caste`,
/// `profile.permState`…).
///
/// Used by the Search, Partner Preferences and Edit Profile screens. The
/// independent lists are fetched once per app run and shared; dependent lists
/// (castes of a religion, states of a country…) are stored per screen under
/// their own key so screens don't overwrite each other.
class SearchOptions extends ChangeNotifier {
  SearchOptions._();
  static final SearchOptions instance = SearchOptions._();

  /// Search-form field ids whose options come from the API (everything else
  /// on the search form keeps its static list).
  static const apiFields = <String>{
    'marital',
    'motherTongue',
    'languages',
    'education',
    'religion',
    'caste',
    'familyType',
    'familyStatus',
    'bodyType',
    'skinTone',
    'foodType',
    'drinking',
    'smoking',
    'gotra',
    'country',
    'state',
    'city',
    'employment',
    'occupation',
    'income',
    'familyProperty',
  };

  /// Search form: child field → parent field.
  static const parents = <String, String>{
    'caste': 'religion',
    'state': 'country',
    'city': 'state',
  };

  /// Lists that don't depend on another pick (loaded by [loadAll]).
  static const baseKeys = <String>[
    'marital',
    'motherTongue',
    'languages',
    'education',
    'religion',
    'familyType',
    'familyStatus',
    'familyValues',
    'bodyType',
    'skinTone',
    'bloodGroup',
    'foodType',
    'drinking',
    'smoking',
    'gotra',
    'country',
    'employment',
    'occupation',
    'income',
    'familyProperty',
    'residential',
    'birthStar',
    'hobbies',
  ];

  final Map<String, List<Opt>> _opts = {};
  final Set<String> _loading = {};
  final Map<String, int> _tokens = {};
  Future<void>? _initial;

  List<Opt> of(String key) => _opts[key] ?? const [];
  List<String> namesOf(String key) => of(key).names;
  bool isLoading(String key) => _loading.contains(key);

  /// True when at least one independent list came back empty.
  bool get hasFailures => baseKeys.any((k) => of(k).isEmpty);

  /// API ids of the picked [names] in list [key] (for building API requests).
  List<int> idsOf(String key, Iterable<String> names) => [
        for (final n in names) ?of(key).idOf(n),
      ];

  static List<Opt> _toOpts(Iterable<dynamic>? items) => (items ?? const [])
      .map<Opt>((e) => Opt(e.id as int, e.name as String))
      .toList();

  void _set(String key, List<Opt> opts) {
    _opts[key] = opts;
    _loading.remove(key);
  }

  /// Loads every independent list. Safe to call repeatedly: the lists are
  /// fetched once, unless [force] is true or a previous load came back empty.
  Future<void> loadAll(RegisterProvider rp, {bool force = false}) {
    if (_initial != null && !force && !hasFailures) return _initial!;
    return _initial = _loadAll(rp);
  }

  Future<void> _loadAll(RegisterProvider rp) async {
    _loading.addAll(baseKeys);
    notifyListeners();

    await Future.wait([
      rp.getMaritalStatuses(),
      rp.motherTongue(),
      rp.getEducations(),
      rp.getReligion(),
      rp.getFamilyTypes(),
      rp.getFamilyStatuses(),
      rp.getFamilyValues(),
      rp.getBodyTypes(),
      rp.getSkinTypes(),
      rp.getBloodGroups(),
      rp.getDiets(),
      rp.getChoices(),
      rp.getGotar(),
      rp.getCountries(),
      rp.getEmploymentTypes(),
      rp.getOccupations(),
      rp.getValueSlabs(),
      rp.getResidentialStatuses(),
      rp.getStars(),
      rp.getHobbies(),
    ]);

    final languages = _toOpts(rp.motherTongueModel?.languages);
    final choices = _toOpts(rp.choicesModel?.choices);
    _set('marital', _toOpts(rp.maritalStatusesModel?.maritalStatuses));
    _set('motherTongue', languages);
    _set('languages', languages);
    _set('education', _toOpts(rp.educationModel?.educations));
    _set('religion', _toOpts(rp.religionsModel?.religions));
    _set('familyType', _toOpts(rp.familyTypeModel?.familyTypes));
    _set('familyStatus', _toOpts(rp.familyStatusesModel?.familyStatuses));
    _set('familyValues', _toOpts(rp.familyValuesModel?.familyValues));
    _set('bodyType', _toOpts(rp.bodyTypeModel?.bodyTypes));
    _set('skinTone', _toOpts(rp.skinTypeModel?.skinTypes));
    _set('bloodGroup', _toOpts(rp.bloodGroupModel?.bloodGroups));
    _set('foodType', _toOpts(rp.dietsModel?.diets));
    _set('drinking', choices);
    _set('smoking', choices);
    _set('gotra', _toOpts(rp.gotrasModel?.gotras));
    _set('country', _toOpts(rp.countriesModel?.countries));
    _set('employment', _toOpts(rp.jobIndustriesModel?.jobIndustries));
    _set('occupation', _toOpts(rp.occupationsModel?.occupations));
    // Annual income and family property both use the value slabs API.
    final valueSlabs = _toOpts(rp.valueSlabModel?.valueSlabs);
    _set('income', valueSlabs);
    _set('familyProperty', valueSlabs);
    _set('residential', _toOpts(rp.residentialModel?.residentialStatuses));
    _set('birthStar', _toOpts(rp.starsModel?.stars));
    _set('hobbies', _toOpts(rp.hobbiesModel?.hobbies));
    _loading.removeAll(baseKeys);
    notifyListeners();
  }

  /// Fetches a dependent list into store [key].
  ///
  /// [kind] is `caste`, `subCaste`, `state` or `city`. [parentNames] are the
  /// picked parent values, looked up in list [parentKey] to get their ids;
  /// with several parents the results are merged.
  ///
  /// Returns the new option names, or null when a newer call for the same
  /// [key] superseded this one.
  Future<List<String>?> loadDependent(
    RegisterProvider rp, {
    required String key,
    required String kind,
    required String parentKey,
    required Iterable<String> parentNames,
  }) async {
    final parentIds = idsOf(parentKey, parentNames);
    final token = (_tokens[key] ?? 0) + 1;
    _tokens[key] = token;

    if (parentIds.isEmpty) {
      _set(key, const []);
      notifyListeners();
      return const [];
    }

    _loading.add(key);
    notifyListeners();

    final merged = <int, Opt>{};
    for (final id in parentIds) {
      final part = await _fetchQueued(rp, kind, id);
      if (_tokens[key] != token) return null;
      for (final o in part) {
        merged[o.id] = o;
      }
    }

    _set(key, merged.values.toList());
    notifyListeners();
    return namesOf(key);
  }

  final Map<String, Future<void>> _queues = {};

  /// The provider keeps one model per list (one `statesModel`, …), so two
  /// fetches of the same kind must not overlap or they read each other's
  /// result. Each kind gets its own queue.
  Future<List<Opt>> _fetchQueued(RegisterProvider rp, String kind, int id) {
    final done = Completer<List<Opt>>();
    _queues[kind] = (_queues[kind] ?? Future<void>.value()).then((_) async {
      try {
        done.complete(await _fetch(rp, kind, id));
      } catch (e, s) {
        done.completeError(e, s);
      }
    });
    return done.future;
  }

  static Future<List<Opt>> _fetch(
      RegisterProvider rp, String kind, int id) async {
    switch (kind) {
      case 'caste':
        rp.castModel = null;
        await rp.getCaste(id);
        return _toOpts(rp.castModel?.castes);
      case 'subCaste':
        rp.subcastesModel = null;
        await rp.getSubCast(id);
        return _toOpts(rp.subcastesModel?.subCastes);
      case 'state':
        rp.statesModel = null;
        await rp.getStates(id);
        return _toOpts(rp.statesModel?.states);
      case 'city':
        rp.districtModel = null;
        await rp.getDistrict(id);
        return _toOpts(rp.districtModel?.districts);
      default:
        throw ArgumentError.value(kind, 'kind');
    }
  }

  /// Search form shortcut for [loadDependent] using [parents].
  Future<List<String>?> loadChildren(
    RegisterProvider rp,
    String child,
    Iterable<String> parentNames,
  ) =>
      loadDependent(rp,
          key: child,
          kind: child,
          parentKey: parents[child]!,
          parentNames: parentNames);

  /// Drops the given dependent lists (and cancels their pending loads).
  void clear(Iterable<String> keys) {
    for (final k in keys) {
      _tokens[k] = (_tokens[k] ?? 0) + 1;
      _opts.remove(k);
      _loading.remove(k);
    }
    notifyListeners();
  }

  /// Clears the search form's dependent lists (used when it is reset).
  void clearChildren() => clear(parents.keys);
}

/// Shared wiring for a form whose dropdowns use [SearchOptions].
///
/// The screen says where each form key gets its options ([optionSources]),
/// which keys depend on another key ([optionDeps]) and how to read / write a
/// value. The mixin loads the lists, refetches dependent lists when a parent
/// is picked, and matches saved values to the API's spelling (dropping values
/// the API doesn't have).
mixin ApiOptionsState<T extends StatefulWidget> on State<T> {
  final SearchOptions options = SearchOptions.instance;
  late final RegisterProvider _optionsRp = context.read<RegisterProvider>();

  /// Form key → store key in [SearchOptions].
  Map<String, String> get optionSources;

  /// Dependent form key → (kind, parent form key). Kind is `caste`,
  /// `subCaste`, `state` or `city`.
  Map<String, (String, String)> get optionDeps => const {};

  /// Values that are not API options and must be kept (e.g. 'Any').
  Set<String> get keepValues => const {'Any', "Doesn't matter"};

  /// Current value of a form key: a `String`, a `Set<String>` or null.
  Object? optionValue(String key);

  /// Writes a form value (the mixin calls this inside setState).
  void setOptionValue(String key, Object? value);

  @override
  void initState() {
    super.initState();
    options.addListener(_onOptions);
    // After the first frame: the provider notifies listeners as soon as a
    // fetch starts, which must not happen while the tree is building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) loadOptions();
    });
  }

  @override
  void dispose() {
    options.removeListener(_onOptions);
    super.dispose();
  }

  void _onOptions() {
    if (mounted) setState(() {});
  }

  List<String> optionsFor(String key) => options.namesOf(optionSources[key]!);
  bool optionsLoading(String key) => options.isLoading(optionSources[key]!);

  /// Text for a dropdown with no options yet (loading / pick parent / failed),
  /// or null when it has options.
  String? emptyOptionsText(String key, {String? parentLabel}) {
    if (optionsFor(key).isNotEmpty) return null;
    if (optionsLoading(key)) return 'Loading…';
    if (optionDeps.containsKey(key)) {
      return 'Select ${(parentLabel ?? 'the field above').toLowerCase()} first';
    }
    return 'No options available';
  }

  Future<void> loadOptions({bool force = false}) async {
    await options.loadAll(_optionsRp, force: force);
    if (!mounted) return;
    await syncOptionValues();
    if (mounted && options.hasFailures) _showRetry();
  }

  /// Re-matches every value to the loaded lists and refetches dependent
  /// lists. Call after replacing the form values (Reset / Cancel).
  Future<void> syncOptionValues() async {
    for (final k in optionSources.keys) {
      if (!optionDeps.containsKey(k)) _normalize(k);
    }
    await Future.wait([
      for (final k in optionDeps.keys)
        if (!optionDeps.containsKey(optionDeps[k]!.$2)) _reload(k),
    ]);
  }

  /// Call after the user changes [key]: refetches the lists that depend on it.
  void optionPicked(String key) {
    for (final e in optionDeps.entries) {
      if (e.value.$2 == key) _reload(e.key);
    }
  }

  Future<void> _reload(String key) async {
    final (kind, parent) = optionDeps[key]!;
    final names = await options.loadDependent(
      _optionsRp,
      key: optionSources[key]!,
      kind: kind,
      parentKey: optionSources[parent]!,
      parentNames: _names(parent),
    );
    if (names == null || !mounted) return;
    _normalize(key);
    await Future.wait([
      for (final e in optionDeps.entries)
        if (e.value.$2 == key) _reload(e.key),
    ]);
  }

  Set<String> _names(String key) {
    final v = optionValue(key);
    if (v is Set<String>) return v;
    if (v is String) return {v};
    return const {};
  }

  void _normalize(String key) {
    final list = options.of(optionSources[key]!);
    // A failed independent load keeps what the member already had.
    if (list.isEmpty && !optionDeps.containsKey(key)) return;
    final v = optionValue(key);
    if (v is Set<String>) {
      final n = {
        for (final x in v)
          if (keepValues.contains(x)) x else ?list.match(x),
      };
      if (!setEquals(n, v)) setState(() => setOptionValue(key, n));
    } else if (v is String && !keepValues.contains(v)) {
      final m = list.match(v);
      if (m != v) setState(() => setOptionValue(key, m));
    }
  }

  void _showRetry() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: const Text('Could not load some options',
            style: TextStyle(fontSize: 13)),
        action: SnackBarAction(
          label: 'Retry',
          textColor: AppColors.gold,
          onPressed: () => loadOptions(force: true),
        ),
      ));
  }
}

/// Stand-in for a dropdown whose options are still loading, depend on another
/// pick (e.g. caste needs a religion), or failed to load.
class OptionsPlaceholderField extends StatelessWidget {
  const OptionsPlaceholderField(
      {super.key, required this.text, this.loading = false});

  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 14, right: 12),
      decoration: BoxDecoration(
        color: AppColors.fieldBorder.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.hint),
            ),
          ),
          if (loading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.tealMid),
            )
          else
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 20, color: AppColors.hint),
        ],
      ),
    );
  }
}
