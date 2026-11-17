import 'package:flutter/material.dart';
import 'package:vivahbharath_app/services/search_options.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';

// Options only used here (no API for these). Every other dropdown on this
// screen gets its options from the API — see _sources below.
const kPhysicalStatus = ['Normal', 'Physically challenged', "Doesn't matter"];
const kDosha = ["Doesn't matter", 'Yes', 'No'];

/// Sample saved preferences — replace with the member's data from your API.
Map<String, Object?> samplePartnerPreferences() => {
      'ageFrom': '24',
      'ageTo': '30',
      'heightFrom': '152 cm',
      'heightTo': '173 cm',
      'marital': {'Never married'},
      'religion': {'Hindu'},
      'caste': <String>{},
      'motherTongue': {'Malayalam'},
      'physical': "Doesn't matter",
      'diet': <String>{},
      'education': {'Bachelors Degree', 'Master Degree'},
      'occupation': <String>{},
      'income': 'Any',
      'employedIn': <String>{},
      'country': {'India'},
      'state': {'Kerala'},
      'city': <String>{},
      'citizenship': <String>{},
      'familyType': <String>{},
      'familyValues': <String>{},
      'birthStar': <String>{},
      'dosha': "Doesn't matter",
    };

class PartnerPreferencesScreen extends StatefulWidget {
  const PartnerPreferencesScreen({
    super.key,
    this.initial,
    this.onSave,
    this.showBottomNav = true,
  });

  final Map<String, Object?>? initial;

  /// TODO: send to your API.
  final Future<void> Function(Map<String, Object?> prefs)? onSave;
  final bool showBottomNav;

  @override
  State<PartnerPreferencesScreen> createState() =>
      _PartnerPreferencesScreenState();
}

class _PartnerPreferencesScreenState extends State<PartnerPreferencesScreen>
    with ApiOptionsState {
  late Map<String, Object?> _saved = _clone(widget.initial ?? samplePartnerPreferences());
  late Map<String, Object?> _p = _clone(_saved);
  bool _saving = false;

  /// Form key → API list (see SearchOptions). Dependent lists get a
  /// `pref.` key so they don't clash with the Search screen's.
  static const _sources = {
    'marital': 'marital',
    'religion': 'religion',
    'caste': 'pref.caste',
    'motherTongue': 'motherTongue',
    'diet': 'foodType',
    'education': 'education',
    'occupation': 'occupation',
    'income': 'income',
    'employedIn': 'employment',
    'country': 'country',
    'state': 'pref.state',
    'city': 'pref.city',
    'citizenship': 'country',
    'familyType': 'familyType',
    'familyValues': 'familyValues',
    'birthStar': 'birthStar',
  };

  static const _deps = {
    'caste': ('caste', 'religion'),
    'state': ('state', 'country'),
    'city': ('city', 'state'),
  };

  static const _parentLabels = {
    'caste': 'Religion',
    'state': 'Country',
    'city': 'State',
  };

  @override
  Map<String, String> get optionSources => _sources;

  @override
  Map<String, (String, String)> get optionDeps => _deps;

  @override
  Object? optionValue(String key) => _p[key];

  @override
  void setOptionValue(String key, Object? value) => _p[key] = value;

  static Map<String, Object?> _clone(Map<String, Object?> m) => {
        for (final e in m.entries)
          e.key: e.value is Set<String> ? {...(e.value as Set<String>)} : e.value,
      };

  void _set(String k, Object? v) {
    setState(() => _p[k] = v);
    optionPicked(k);
  }
  Set<String> _multi(String k) => (_p[k] as Set<String>?) ?? <String>{};
  String? _single(String k) => _p[k] as String?;

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

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave?.call(_clone(_p));
      if (!mounted) return;
      setState(() => _saved = _clone(_p));
      _snack('Partner preferences saved');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _reset() {
    setState(() => _p = _clone(_saved));
    syncOptionValues();
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
              const SearchTopBar(title: 'Partner Preferences'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    _intro(),
                    const SizedBox(height: 14),
                    SectionCard(
                      title: 'Basic preferences',
                      icon: Icons.person_outline_rounded,
                      iconName: 'basic',
                      tint: AppColors.blueTint,
                      accent: AppColors.link,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _range('Preferred age', 'ageFrom', 'ageTo',
                              kAgeOptions, ' yrs'),
                          _range('Preferred height', 'heightFrom', 'heightTo',
                              kHeightOptions, ''),
                          _multiField('Preferred marital status', 'marital'),
                          _multiField('Preferred religion', 'religion'),
                          _multiField('Preferred caste', 'caste'),
                          _multiField('Preferred mother tongue', 'motherTongue'),
                          _singleField('Preferred physical status', 'physical', options: kPhysicalStatus),
                          _multiField('Preferred diet', 'diet', last: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SectionCard(
                      title: 'Education & career',
                      icon: Icons.school_outlined,
                      iconName: 'education',
                      tint: AppColors.cream,
                      accent: AppColors.brown,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _multiField('Preferred education', 'education'),
                          _multiField('Preferred occupation', 'occupation'),
                          _singleField('Preferred annual income (minimum)', 'income'),
                          _multiField('Preferred employed in', 'employedIn', last: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SectionCard(
                      title: 'Location',
                      icon: Icons.location_on_outlined,
                      iconName: 'location',
                      tint: const Color(0xFFF1EEF9),
                      accent: AppColors.purple,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _multiField('Preferred country', 'country'),
                          _multiField('Preferred state', 'state'),
                          _multiField('Preferred city', 'city'),
                          _multiField('Preferred citizenship', 'citizenship', last: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SectionCard(
                      title: 'Family & horoscope',
                      icon: Icons.home_outlined,
                      iconName: 'family',
                      tint: const Color(0xFFFBF0EE),
                      accent: AppColors.coral,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _multiField('Preferred family type', 'familyType'),
                          _multiField('Preferred family values', 'familyValues'),
                          _multiField('Preferred birth star', 'birthStar'),
                          _singleField('Preferred dosha', 'dosha', options: kDosha, last: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(top: BorderSide(color: AppColors.blueTintBorder)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PillButton(
                        label: 'Reset',
                        icon: matchIcon(Icons.restart_alt_rounded, 'reset',
                            size: 17, color: AppColors.textMuted),
                        foreground: AppColors.textMuted,
                        background: Colors.white,
                        borderColor: AppColors.fieldBorder,
                        onTap: _reset,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: PillButton(
                        label: _saving ? 'Saving…' : 'Save preferences',
                        icon: matchIcon(Icons.check_rounded, 'check',
                            size: 18, color: Colors.white),
                        foreground: Colors.white,
                        gradient: kTealGradient,
                        onTap: _saving ? null : _save,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _intro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.sparkleGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: matchIcon(Icons.favorite_rounded, 'heart',
                size: 22, color: AppColors.goldDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Who you're looking for",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'We use these to choose your matches. Leave a field empty if it doesn’t matter to you.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _range(String label, String fromKey, String toKey, List<String> opts,
      String suffix) {
    final from = _single(fromKey);
    final to = _single(toKey);
    final fromIdx = from == null ? 0 : opts.indexOf(from).clamp(0, opts.length - 1);
    final toIdx =
        to == null ? opts.length - 1 : opts.indexOf(to).clamp(0, opts.length - 1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
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
              if (suffix.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(suffix.trim(),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Options for [key]: [fixed] when given, else the API list. Returns null
  /// (and [placeholder] shows instead) while an API list is empty.
  List<String>? _options(String key, List<String>? fixed) {
    if (fixed != null) return fixed;
    if (optionsFor(key).isEmpty) return null;
    // Minimum income also offers "Any".
    return key == 'income' ? ['Any', ...optionsFor(key)] : optionsFor(key);
  }

  Widget _placeholder(String key) => OptionsPlaceholderField(
        text: emptyOptionsText(key, parentLabel: _parentLabels[key]) ??
            'No options available',
        loading: optionsLoading(key),
      );

  Widget _multiField(String label, String key,
      {List<String>? options, bool last = false}) {
    final opts = _options(key, options);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldLabel(label),
          if (opts == null)
            _placeholder(key)
          else
            MultiSelectField(
              hint: 'Any',
              title: label,
              options: opts,
              values: _multi(key),
              onChanged: (v) => _set(key, v),
            ),
        ],
      ),
    );
  }

  Widget _singleField(String label, String key,
      {List<String>? options, bool last = false}) {
    final opts = _options(key, options);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldLabel(label),
          if (opts == null)
            _placeholder(key)
          else
            SelectField(
              hint: 'Any',
              title: label,
              options: opts,
              value: _single(key),
              onChanged: (v) => _set(key, v),
            ),
        ],
      ),
    );
  }
}