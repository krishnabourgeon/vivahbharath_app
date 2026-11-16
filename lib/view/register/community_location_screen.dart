// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:vivahbharath_app/view/register/professional_details_screen.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_options.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class CommunityLocationScreen extends StatefulWidget {
//   const CommunityLocationScreen({super.key, required this.data});

//   final SignUpData data;

//   @override
//   State<CommunityLocationScreen> createState() =>
//       _CommunityLocationScreenState();
// }

// class _CommunityLocationScreenState extends State<CommunityLocationScreen> {
//   SignUpData get d => widget.data;

//   late final _pincodeCtrl = TextEditingController(text: d.pincode);
//   late final _addressCtrl = TextEditingController(text: d.homeAddress);
//   late final _currentCtrl = TextEditingController(text: d.currentAddress);

//   @override
//   void dispose() {
//     _pincodeCtrl.dispose();
//     _addressCtrl.dispose();
//     _currentCtrl.dispose();
//     super.dispose();
//   }

//   String get _permanentSummary {
//     final place = [d.permDistrict, d.permState, d.permCountry]
//         .whereType<String>()
//         .join(', ');
//     final pin = _pincodeCtrl.text.trim();
//     return pin.isEmpty ? place : '$place · $pin';
//   }

//   void _onContinue() {
//     FocusScope.of(context).unfocus();
//     d.pincode = _pincodeCtrl.text.trim();
//     d.homeAddress = _addressCtrl.text.trim();
//     d.currentAddress = _currentCtrl.text.trim();
//     // TODO: validate required fields
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => ProfessionalDetailsScreen(data: d)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 2,
//       title: 'Community & location',
//       subtitle: 'Your community and where you live.',
//       primaryLabel: 'Continue',
//       onPrimary: _onContinue,
//       children: [
//         FormCard(title: 'Community', children: [
//           TwoColumn(
//             left: DropdownField(
//               label: 'Religion',
//               required: true,
//               value: d.religion,
//               items: SignUpOptions.religions,
//               onChanged: (v) => setState(() => d.religion = v),
//             ),
//             right: DropdownField(
//               label: 'Caste',
//               required: true,
//               value: d.caste,
//               items: SignUpOptions.castes,
//               onChanged: (v) => setState(() => d.caste = v),
//             ),
//           ),
//           YesNoToggle(
//             question: 'Open to matches from other castes?',
//             value: d.openToOtherCastes,
//             onChanged: (v) => setState(() => d.openToOtherCastes = v),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Sub caste',
//               value: d.subCaste,
//               items: SignUpOptions.subCastes,
//               onChanged: (v) => setState(() => d.subCaste = v),
//             ),
//             right: DropdownField(
//               label: 'Gotra',
//               value: d.gotra,
//               items: SignUpOptions.gotras,
//               onChanged: (v) => setState(() => d.gotra = v),
//             ),
//           ),
//         ]),
//         FormCard(title: 'Native place', children: [
//           DropdownField(
//             label: 'Country',
//             value: d.nativeCountry,
//             items: SignUpOptions.countries,
//             onChanged: (v) => setState(() => d.nativeCountry = v),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'State',
//               value: d.nativeState,
//               items: SignUpOptions.states,
//               onChanged: (v) => setState(() => d.nativeState = v),
//             ),
//             right: DropdownField(
//               label: 'District',
//               value: d.nativeDistrict,
//               items: SignUpOptions.districts,
//               onChanged: (v) => setState(() => d.nativeDistrict = v),
//             ),
//           ),
//         ]),
//         FormCard(title: 'Permanent residence', required: true, children: [
//           TwoColumn(
//             left: DropdownField(
//               label: 'Country',
//               value: d.permCountry,
//               items: SignUpOptions.countries,
//               onChanged: (v) => setState(() => d.permCountry = v),
//             ),
//             right: DropdownField(
//               label: 'State',
//               value: d.permState,
//               items: SignUpOptions.states,
//               onChanged: (v) => setState(() => d.permState = v),
//             ),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'District',
//               value: d.permDistrict,
//               items: SignUpOptions.districts,
//               onChanged: (v) => setState(() => d.permDistrict = v),
//             ),
//             right: LabeledField(
//               label: 'Pincode',
//               child: AppTextInput(
//                 controller: _pincodeCtrl,
//                 hint: 'Pincode',
//                 keyboardType: TextInputType.number,
//                 maxLength: 6,
//                 counter: false,
//                 formatters: [FilteringTextInputFormatter.digitsOnly],
//                 onChanged: (_) => setState(() {}),
//               ),
//             ),
//           ),
//           LabeledField(
//             label: 'Home address',
//             required: true,
//             child: AppTextInput(
//               controller: _addressCtrl,
//               hint: 'House name, street, locality',
//               maxLines: 3,
//             ),
//           ),
//         ]),
//         FormCard(
//           title: 'Current residence',
//           trailing: SameAsChip(
//             value: d.currentSameAsPermanent,
//             onChanged: (v) => setState(() => d.currentSameAsPermanent = v),
//           ),
//           children: [
//             LabeledField(
//               child: d.currentSameAsPermanent
//                   ? InfoBox(
//                       icon: Icons.location_on_outlined,
//                       text: _permanentSummary,
//                     )
//                   : AppTextInput(
//                       controller: _currentCtrl,
//                       hint: '',
//                       maxLines: 3,
//                     ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/register/professional_details_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class CommunityLocationScreen extends StatefulWidget {
  const CommunityLocationScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<CommunityLocationScreen> createState() =>
      _CommunityLocationScreenState();
}

class _CommunityLocationScreenState extends State<CommunityLocationScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  late final _pincodeCtrl = TextEditingController(text: d.pincode);
  late final _addressCtrl = TextEditingController(text: d.homeAddress);
  late final _currentCtrl = TextEditingController(text: d.currentAddress);
  late final _curPincodeCtrl = TextEditingController(text: d.currentPincode);

  // Pre-selected for every location block when nothing is picked yet.
  static const _defaultCountry = 'India';
  static const _defaultState = 'Kerala';

  bool _busy = false;

  // Options from the API. The provider keeps only ONE states list and ONE
  // districts list, so each location block copies its result into its own
  // list straight after loading.
  List<Opt> _religions = [];
  List<Opt> _castes = [];
  List<Opt> _subCastes = [];
  List<Opt> _gotras = [];
  List<Opt> _countries = [];
  List<Opt> _nativeStates = [];
  List<Opt> _nativeDistricts = [];
  List<Opt> _permStates = [];
  List<Opt> _permDistricts = [];
  List<Opt> _curStates = [];
  List<Opt> _curDistricts = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_init);
  }

  @override
  void dispose() {
    _pincodeCtrl.dispose();
    _addressCtrl.dispose();
    _currentCtrl.dispose();
    _curPincodeCtrl.dispose();
    super.dispose();
  }

  /* ───────────────────────── API loading ───────────────────────── */

  Future<void> _init() async {
    setState(() => _busy = true);
    final rp = _rp;
    await Future.wait([rp.getReligion(), rp.getGotar(), rp.getCountries()]);
    if (!mounted) return;
    _religions = (rp.religionsModel?.religions ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();
    _gotras = (rp.gotrasModel?.gotras ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();
    _countries = (rp.countriesModel?.countries ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();

    // Default every location block to India / Kerala when nothing is picked.
    final india = _countries.match(_defaultCountry);
    d.nativeCountry ??= india;
    d.permCountry ??= india;
    d.curCountry ??= india;

    // Coming back to this step: rebuild the dependent lists for what was picked.
    _castes = await _fetchCastes(d.religion);
    _subCastes = await _fetchSubCastes(d.caste);

    _nativeStates = await _fetchStates(d.nativeCountry);
    d.nativeState ??= _nativeStates.match(_defaultState);
    _nativeDistricts = await _fetchDistricts(d.nativeState, _nativeStates);

    _permStates = await _fetchStates(d.permCountry);
    d.permState ??= _permStates.match(_defaultState);
    _permDistricts = await _fetchDistricts(d.permState, _permStates);

    _curStates = await _fetchStates(d.curCountry);
    d.curState ??= _curStates.match(_defaultState);
    _curDistricts = await _fetchDistricts(d.curState, _curStates);
    if (!mounted) return;
    setState(() => _busy = false);
    if (_religions.isEmpty || _countries.isEmpty) {
      showMsg('Could not load the form options. Please check your connection.');
    }
  }

  Future<List<Opt>> _fetchCastes(String? religion) async {
    final id = _religions.idOf(religion);
    if (id == null) return [];
    final rp = _rp;
    rp.castModel = null;
    await rp.getCaste(id);
    return (rp.castModel?.castes ?? []).map((e) => Opt(e.id, e.name)).toList();
  }

  Future<List<Opt>> _fetchSubCastes(String? caste) async {
    final id = _castes.idOf(caste);
    if (id == null) return [];
    final rp = _rp;
    rp.subcastesModel = null;
    await rp.getSubCast(id);
    return (rp.subcastesModel?.subCastes ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();
  }

  Future<List<Opt>> _fetchStates(String? country) async {
    final id = _countries.idOf(country);
    if (id == null) return [];
    final rp = _rp;
    rp.statesModel = null;
    await rp.getStates(id);
    return (rp.statesModel?.states ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();
  }

  Future<List<Opt>> _fetchDistricts(String? state, List<Opt> states) async {
    final id = states.idOf(state);
    if (id == null) return [];
    final rp = _rp;
    rp.districtModel = null;
    await rp.getDistrict(id);
    return (rp.districtModel?.districts ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();
  }

  /// Runs [job] with the loading overlay on.
  Future<void> _run(Future<void> Function() job) async {
    setState(() => _busy = true);
    await job();
    if (mounted) setState(() => _busy = false);
  }

  /* ───────────────────────── change handlers ───────────────────────── */

  Future<void> _onReligion(String? v) async {
    setState(() {
      d.religion = v;
      d.caste = null;
      d.subCaste = null;
      _castes = [];
      _subCastes = [];
    });
    await _run(() async => _castes = await _fetchCastes(v));
  }

  Future<void> _onCaste(String? v) async {
    setState(() {
      d.caste = v;
      d.subCaste = null;
      _subCastes = [];
    });
    await _run(() async => _subCastes = await _fetchSubCastes(v));
  }

  Future<void> _onNativeCountry(String? v) async {
    setState(() {
      d.nativeCountry = v;
      d.nativeState = null;
      d.nativeDistrict = null;
      _nativeStates = [];
      _nativeDistricts = [];
    });
    await _run(() async => _nativeStates = await _fetchStates(v));
  }

  Future<void> _onNativeState(String? v) async {
    setState(() {
      d.nativeState = v;
      d.nativeDistrict = null;
      _nativeDistricts = [];
    });
    await _run(
      () async => _nativeDistricts = await _fetchDistricts(v, _nativeStates),
    );
  }

  Future<void> _onPermCountry(String? v) async {
    setState(() {
      d.permCountry = v;
      d.permState = null;
      d.permDistrict = null;
      _permStates = [];
      _permDistricts = [];
    });
    await _run(() async => _permStates = await _fetchStates(v));
  }

  Future<void> _onPermState(String? v) async {
    setState(() {
      d.permState = v;
      d.permDistrict = null;
      _permDistricts = [];
    });
    await _run(
      () async => _permDistricts = await _fetchDistricts(v, _permStates),
    );
  }

  Future<void> _onCurCountry(String? v) async {
    setState(() {
      d.curCountry = v;
      d.curState = null;
      d.curDistrict = null;
      _curStates = [];
      _curDistricts = [];
    });
    await _run(() async => _curStates = await _fetchStates(v));
  }

  Future<void> _onCurState(String? v) async {
    setState(() {
      d.curState = v;
      d.curDistrict = null;
      _curDistricts = [];
    });
    await _run(
      () async => _curDistricts = await _fetchDistricts(v, _curStates),
    );
  }

  /* ───────────────────────── submit ───────────────────────── */

  String get _permanentSummary {
    final place = [
      d.permDistrict,
      d.permState,
      d.permCountry,
    ].whereType<String>().join(', ');
    final pin = _pincodeCtrl.text.trim();
    return pin.isEmpty ? place : '$place · $pin';
  }

  Future<void> _onContinue() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;
    d.pincode = _pincodeCtrl.text.trim();
    d.homeAddress = _addressCtrl.text.trim();
    d.currentAddress = _currentCtrl.text.trim();
    d.currentPincode = _curPincodeCtrl.text.trim();

    final religionId = _religions.idOf(d.religion);
    final casteId = _castes.idOf(d.caste);
    final permCountryId = _countries.idOf(d.permCountry);
    final permStateId = _permStates.idOf(d.permState);
    final permDistrictId = _permDistricts.idOf(d.permDistrict);

    if (religionId == null) return showMsg('Please select your religion');
    if (casteId == null) return showMsg('Please select your caste');
    if (permCountryId == null ||
        permStateId == null ||
        permDistrictId == null) {
      return showMsg(
        'Please select your permanent country, state and district',
      );
    }
    if (d.pincode.isNotEmpty && d.pincode.length != 6) {
      return showMsg('Please provide a valid 6-digit pincode');
    }
    if (d.homeAddress.isEmpty) return showMsg('Please enter your home address');

    // Optional fields: the API wants an id for each, so fall back to
    // "same as permanent" for native place and 0 for sub caste / gotra.
    final nativeCountryId = _countries.idOf(d.nativeCountry) ?? permCountryId;
    final nativeStateId = _nativeStates.idOf(d.nativeState) ?? permStateId;
    final nativeDistrictId =
        _nativeDistricts.idOf(d.nativeDistrict) ?? permDistrictId;

    // Current residence: copy permanent, or validate its own fields.
    final same = d.currentSameAsPermanent;
    final curCountryId = same ? permCountryId : _countries.idOf(d.curCountry);
    final curStateId = same ? permStateId : _curStates.idOf(d.curState);
    final curDistrictId = same
        ? permDistrictId
        : _curDistricts.idOf(d.curDistrict);
    if (curCountryId == null || curStateId == null || curDistrictId == null) {
      return showMsg('Please select your current country, state and district');
    }
    if (!same && d.currentPincode.isNotEmpty && d.currentPincode.length != 6) {
      return showMsg('Please provide a valid 6-digit current pincode');
    }
    if (!same && d.currentAddress.isEmpty) {
      return showMsg('Please enter your current address');
    }
    final currentAddress = same ? d.homeAddress : d.currentAddress;
    final currentPincode = same ? d.pincode : d.currentPincode;

    final rp = _rp;
    setState(() => _busy = true);
    final ok = await rp.communityAndLocation(
      nativeCountryId: nativeCountryId,
      nativeStateId: nativeStateId,
      nativeDistrictId: nativeDistrictId,
      nativeDescription: '',
      permanentCountryId: permCountryId,
      permanentStateId: permStateId,
      permanentDistrictId: permDistrictId,
      permanentAddress: d.homeAddress,
      permanentPincode: d.pincode,
      currentCountryId: curCountryId,
      currentStateId: curStateId,
      currentDistrictId: curDistrictId,
      currentAddress: currentAddress,
      currentPincode: currentPincode,
      religionId: religionId,
      casteId: casteId,
      subCasteId: _subCastes.idOf(d.subCaste) ?? 0,
      gotraId: _gotras.idOf(d.gotra) ?? 0,
      casteMatch: d.openToOtherCastes ? 'yes' : 'no',
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(
        rp.communityLocationError ?? 'Something went wrong. Please try again',
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfessionalDetailsScreen(data: d)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 2,
        title: 'Community & location',
        subtitle: 'Your community and where you live.',
        primaryLabel: 'Continue',
        onPrimary: _onContinue,
        children: [
          FormCard(
            title: 'Community',
            children: [
              TwoColumn(
                left: DropdownField(
                  label: 'Religion',
                  required: true,
                  value: _religions.valid(d.religion),
                  items: _religions.names,
                  onChanged: _onReligion,
                ),
                right: DropdownField(
                  label: 'Caste',
                  required: true,
                  value: _castes.valid(d.caste),
                  items: _castes.names,
                  onChanged: _onCaste,
                ),
              ),
              YesNoToggle(
                question: 'Open to matches from other castes?',
                value: d.openToOtherCastes,
                onChanged: (v) => setState(() => d.openToOtherCastes = v),
              ),
              TwoColumn(
                left: DropdownField(
                  label: 'Sub caste',
                  value: _subCastes.valid(d.subCaste),
                  items: _subCastes.names,
                  onChanged: (v) => setState(() => d.subCaste = v),
                ),
                right: DropdownField(
                  label: 'Gotra',
                  value: _gotras.valid(d.gotra),
                  items: _gotras.names,
                  onChanged: (v) => setState(() => d.gotra = v),
                ),
              ),
            ],
          ),
          FormCard(
            title: 'Native place',
            children: [
              DropdownField(
                label: 'Country',
                value: _countries.valid(d.nativeCountry),
                items: _countries.names,
                onChanged: _onNativeCountry,
              ),
              TwoColumn(
                left: DropdownField(
                  label: 'State',
                  value: _nativeStates.valid(d.nativeState),
                  items: _nativeStates.names,
                  onChanged: _onNativeState,
                ),
                right: DropdownField(
                  label: 'District',
                  value: _nativeDistricts.valid(d.nativeDistrict),
                  items: _nativeDistricts.names,
                  onChanged: (v) => setState(() => d.nativeDistrict = v),
                ),
              ),
            ],
          ),
          FormCard(
            title: 'Permanent residence',
            required: true,
            children: [
              TwoColumn(
                left: DropdownField(
                  label: 'Country',
                  value: _countries.valid(d.permCountry),
                  items: _countries.names,
                  onChanged: _onPermCountry,
                ),
                right: DropdownField(
                  label: 'State',
                  value: _permStates.valid(d.permState),
                  items: _permStates.names,
                  onChanged: _onPermState,
                ),
              ),
              TwoColumn(
                left: DropdownField(
                  label: 'District',
                  value: _permDistricts.valid(d.permDistrict),
                  items: _permDistricts.names,
                  onChanged: (v) => setState(() => d.permDistrict = v),
                ),
                right: LabeledField(
                  label: 'Pincode',
                  child: AppTextInput(
                    controller: _pincodeCtrl,
                    hint: 'Pincode',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    counter: false,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
              LabeledField(
                label: 'Home address',
                required: true,
                child: AppTextInput(
                  controller: _addressCtrl,
                  hint: 'House name, street, locality',
                  maxLines: 3,
                ),
              ),
            ],
          ),
          FormCard(
            title: 'Current residence',
            trailing: SameAsChip(
              value: d.currentSameAsPermanent,
              onChanged: (v) => setState(() => d.currentSameAsPermanent = v),
            ),
            children: d.currentSameAsPermanent
                ? [
                    LabeledField(
                      child: InfoBox(
                        icon: Icons.location_on_outlined,
                        text: _permanentSummary,
                      ),
                    ),
                  ]
                : [
                    TwoColumn(
                      left: DropdownField(
                        label: 'Country',
                        required: true,
                        value: _countries.valid(d.curCountry),
                        items: _countries.names,
                        onChanged: _onCurCountry,
                      ),
                      right: DropdownField(
                        label: 'State',
                        required: true,
                        value: _curStates.valid(d.curState),
                        items: _curStates.names,
                        onChanged: _onCurState,
                      ),
                    ),
                    TwoColumn(
                      left: DropdownField(
                        label: 'District',
                        required: true,
                        value: _curDistricts.valid(d.curDistrict),
                        items: _curDistricts.names,
                        onChanged: (v) => setState(() => d.curDistrict = v),
                      ),
                      right: LabeledField(
                        label: 'Pincode',
                        child: AppTextInput(
                          controller: _curPincodeCtrl,
                          hint: 'Pincode',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          counter: false,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ),
                    LabeledField(
                      label: 'Address',
                      required: true,
                      child: AppTextInput(
                        controller: _currentCtrl,
                        hint: 'House name, street, locality',
                        maxLines: 3,
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
