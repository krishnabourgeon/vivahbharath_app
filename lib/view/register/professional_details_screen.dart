// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/register/personal_physical_screen.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_options.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class ProfessionalDetailsScreen extends StatefulWidget {
//   const ProfessionalDetailsScreen({super.key, required this.data});

//   final SignUpData data;

//   @override
//   State<ProfessionalDetailsScreen> createState() =>
//       _ProfessionalDetailsScreenState();
// }

// class _ProfessionalDetailsScreenState
//     extends State<ProfessionalDetailsScreen> {
//   SignUpData get d => widget.data;

//   late final _eduDetailCtrl =
//       TextEditingController(text: d.educationDetail);

//   @override
//   void dispose() {
//     _eduDetailCtrl.dispose();
//     super.dispose();
//   }

//   void _toggleLanguage(String lang) => setState(() =>
//       d.languages.contains(lang) ? d.languages.remove(lang) : d.languages.add(lang));

//   void _onContinue() {
//     FocusScope.of(context).unfocus();
//     d.educationDetail = _eduDetailCtrl.text.trim();
//     // TODO: validate required fields
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => PersonalPhysicalScreen(data: d)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 3,
//       title: 'Professional details',
//       subtitle: 'Your education, work and income.',
//       primaryLabel: 'Continue',
//       onPrimary: _onContinue,
//       note: 'You can edit all of this later from your dashboard.',
//       children: [
//         FormCard(title: 'Education', children: [
//           DropdownField(
//             label: 'Highest education',
//             required: true,
//             value: d.education,
//             items: SignUpOptions.educations,
//             onChanged: (v) => setState(() => d.education = v),
//           ),
//           LabeledField(
//             label: 'Education in detail',
//             child: AppTextInput(
//               controller: _eduDetailCtrl,
//               hint: 'e.g. B.Tech in Computer Science, NIT Calicut',
//               maxLines: 3,
//               maxLength: 255,
//             ),
//           ),
//           LabeledField(
//             label: 'Languages known',
//             child: ChoiceChips(
//               options: SignUpOptions.languages,
//               isSelected: d.languages.contains,
//               onTap: _toggleLanguage,
//             ),
//           ),
//         ]),
//         FormCard(title: 'Work', children: [
//           LabeledField(
//             label: 'Employment type',
//             child: ChoiceChips(
//               options: SignUpOptions.employmentTypes,
//               isSelected: (o) => o == d.employmentType,
//               onTap: (o) => setState(() => d.employmentType = o),
//             ),
//           ),
//           DropdownField(
//             label: 'Occupation',
//             required: true,
//             value: d.occupation,
//             items: SignUpOptions.occupations,
//             onChanged: (v) => setState(() => d.occupation = v),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Working country',
//               value: d.workCountry,
//               items: SignUpOptions.countries,
//               onChanged: (v) => setState(() => d.workCountry = v),
//             ),
//             right: DropdownField(
//               label: 'Working state',
//               value: d.workState,
//               items: SignUpOptions.states,
//               onChanged: (v) => setState(() => d.workState = v),
//             ),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Working city',
//               value: d.workCity,
//               items: SignUpOptions.cities,
//               onChanged: (v) => setState(() => d.workCity = v),
//             ),
//             right: DropdownField(
//               label: 'Residential status',
//               value: d.residentialStatus,
//               items: SignUpOptions.residentialStatuses,
//               onChanged: (v) => setState(() => d.residentialStatus = v),
//             ),
//           ),
//         ]),
//         FormCard(title: 'Annual income', children: [
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: DropdownField(
//                   value: d.currency,
//                   items: SignUpOptions.currencies,
//                   onChanged: (v) => setState(() => d.currency = v!),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 flex: 4,
//                 child: DropdownField(
//                   value: d.income,
//                   items: SignUpOptions.incomeRanges,
//                   onChanged: (v) => setState(() => d.income = v),
//                 ),
//               ),
//             ],
//           ),
//         ]),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/register/personal_physical_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  const ProfessionalDetailsScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<ProfessionalDetailsScreen> createState() =>
      _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState
    extends State<ProfessionalDetailsScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  late final _eduDetailCtrl =
      TextEditingController(text: d.educationDetail);

  bool _busy = false;

  List<Opt> _educations = [];
  List<Opt> _languages = [];
  List<Opt> _employmentTypes = [];
  List<Opt> _occupations = [];
  List<Opt> _countries = [];
  List<Opt> _workStates = [];
  List<Opt> _workCities = []; // the API calls these districts
  List<Opt> _residentialStatuses = [];
  List<Opt> _currencies = [];
  List<Opt> _incomes = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_init);
  }

  @override
  void dispose() {
    _eduDetailCtrl.dispose();
    super.dispose();
  }

  List<Opt> _opts(Iterable<dynamic>? items) =>
      (items ?? const []).map<Opt>((e) => Opt(e.id as int, e.name as String)).toList();

  Future<void> _init() async {
    setState(() => _busy = true);
    final rp = _rp;
    await Future.wait([
      rp.getEducations(),
      rp.getEmploymentTypes(),
      rp.getOccupations(),
      rp.getResidentialStatuses(),
      rp.getCurrencies(),
      rp.getCountries(),
      rp.motherTongue(),
    ]);
    if (!mounted) return;
    _educations = _opts(rp.educationModel?.educations);
    _employmentTypes = _opts(rp.jobIndustriesModel?.jobIndustries);
    _occupations = _opts(rp.occupationsModel?.occupations);
    _residentialStatuses = _opts(rp.residentialModel?.residentialStatuses);
    _currencies = _opts(rp.currenciesModel?.currencies);
    _countries = _opts(rp.countriesModel?.countries);
    _languages = _opts(rp.motherTongueModel?.languages);

    // The old static default was '₹ INR'; use the API's INR (else the first).
    if (_currencies.valid(d.currency) == null && _currencies.isNotEmpty) {
      d.currency = _currencies
          .firstWhere((c) => c.name.toUpperCase().contains('INR'),
              orElse: () => _currencies.first)
          .name;
    }
    _incomes = await _fetchIncomes(d.currency);
    _workStates = await _fetchStates(d.workCountry);
    _workCities = await _fetchDistricts(d.workState);
    if (!mounted) return;
    setState(() => _busy = false);
    if (_educations.isEmpty || _occupations.isEmpty) {
      showMsg('Could not load the form options. Please check your connection.');
    }
  }

  Future<List<Opt>> _fetchIncomes(String? currency) async {
    final id = _currencies.idOf(currency);
    if (id == null) return [];
    final rp = _rp;
    rp.incomeModel = null;
    await rp.getIncomes(id);
    return _opts(rp.incomeModel?.incomes);
  }

  Future<List<Opt>> _fetchStates(String? country) async {
    final id = _countries.idOf(country);
    if (id == null) return [];
    final rp = _rp;
    rp.statesModel = null;
    await rp.getStates(id);
    return _opts(rp.statesModel?.states);
  }

  Future<List<Opt>> _fetchDistricts(String? state) async {
    final id = _workStates.idOf(state);
    if (id == null) return [];
    final rp = _rp;
    rp.districtModel = null;
    await rp.getDistrict(id);
    return _opts(rp.districtModel?.districts);
  }

  Future<void> _run(Future<void> Function() job) async {
    setState(() => _busy = true);
    await job();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _onCurrency(String? v) async {
    setState(() {
      d.currency = v ?? d.currency;
      d.income = null;
      _incomes = [];
    });
    await _run(() async => _incomes = await _fetchIncomes(d.currency));
  }

  Future<void> _onWorkCountry(String? v) async {
    setState(() {
      d.workCountry = v;
      d.workState = null;
      d.workCity = null;
      _workStates = [];
      _workCities = [];
    });
    await _run(() async => _workStates = await _fetchStates(v));
  }

  Future<void> _onWorkState(String? v) async {
    setState(() {
      d.workState = v;
      d.workCity = null;
      _workCities = [];
    });
    await _run(() async => _workCities = await _fetchDistricts(v));
  }

  void _toggleLanguage(String lang) => setState(() =>
      d.languages.contains(lang) ? d.languages.remove(lang) : d.languages.add(lang));

  Future<void> _onContinue() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;
    d.educationDetail = _eduDetailCtrl.text.trim();

    final educationId = _educations.idOf(d.education);
    final occupationId = _occupations.idOf(d.occupation);
    if (educationId == null) return showMsg('Please select your highest education');
    if (occupationId == null) return showMsg('Please select your occupation');

    final languageIds = d.languages
        .map(_languages.idOf)
        .whereType<int>()
        .toList();

    final rp = _rp;
    setState(() => _busy = true);
    // Optional dropdowns the user left empty are sent as 0.
    final ok = await rp.professionalDetails(
      highestEducationId: educationId,
      educationDesc: d.educationDetail,
      jobIndustryId: _employmentTypes.idOf(d.employmentType) ?? 0,
      occupationId: occupationId,
      workingCountryId: _countries.idOf(d.workCountry) ?? 0,
      workingStateId: _workStates.idOf(d.workState) ?? 0,
      workingDistrictId: _workCities.idOf(d.workCity) ?? 0,
      residentialStatusId: _residentialStatuses.idOf(d.residentialStatus) ?? 0,
      currencyId: _currencies.idOf(d.currency) ?? 0,
      incomeSlabId: _incomes.idOf(d.income) ?? 0,
      languages: languageIds,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(
          rp.professionalError ?? 'Something went wrong. Please try again');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PersonalPhysicalScreen(data: d)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 3,
        title: 'Professional details',
        subtitle: 'Your education, work and income.',
        primaryLabel: 'Continue',
        onPrimary: _onContinue,
        note: 'After Completing the registration you can edit the profile form your personal dashboard',
        children: [
          FormCard(title: 'Education', children: [
            DropdownField(
              label: 'Highest education',
              required: true,
              value: _educations.valid(d.education),
              items: _educations.names,
              onChanged: (v) => setState(() => d.education = v),
            ),
            LabeledField(
              label: 'Education in detail',
              child: AppTextInput(
                controller: _eduDetailCtrl,
                //hint: 'e.g. B.Tech in Computer Science, NIT Calicut',
                maxLines: 3,
                maxLength: 255,
              ),
            ),
            LabeledField(
              label: 'Languages known',
              child: ChoiceChips(
                options: _languages.names,
                isSelected: d.languages.contains,
                onTap: _toggleLanguage,
              ),
            ),
          ]),
          FormCard(title: 'Work', children: [
            LabeledField(
              label: 'Employment type',
              child: ChoiceChips(
                options: _employmentTypes.names,
                isSelected: (o) => o == d.employmentType,
                onTap: (o) => setState(() => d.employmentType = o),
              ),
            ),
            DropdownField(
              label: 'Occupation',
              required: true,
              value: _occupations.valid(d.occupation),
              items: _occupations.names,
              onChanged: (v) => setState(() => d.occupation = v),
            ),
            TwoColumn(
              left: DropdownField(
                label: 'Working country',
                value: _countries.valid(d.workCountry),
                items: _countries.names,
                onChanged: _onWorkCountry,
              ),
              right: DropdownField(
                label: 'Working state',
                value: _workStates.valid(d.workState),
                items: _workStates.names,
                onChanged: _onWorkState,
              ),
            ),
            TwoColumn(
              left: DropdownField(
                label: 'Working city',
                value: _workCities.valid(d.workCity),
                items: _workCities.names,
                onChanged: (v) => setState(() => d.workCity = v),
              ),
              right: DropdownField(
                label: 'Residential status',
                value: _residentialStatuses.valid(d.residentialStatus),
                items: _residentialStatuses.names,
                onChanged: (v) => setState(() => d.residentialStatus = v),
              ),
            ),
          ]),
          FormCard(title: 'Annual income', children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownField(
                    value: _currencies.valid(d.currency),
                    items: _currencies.names,
                    onChanged: _onCurrency,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 4,
                  child: DropdownField(
                    value: _incomes.valid(d.income),
                    items: _incomes.names,
                    onChanged: (v) => setState(() => d.income = v),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}