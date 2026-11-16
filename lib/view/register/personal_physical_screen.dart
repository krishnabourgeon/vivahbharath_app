// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/register/photos_about_screen.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_options.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class PersonalPhysicalScreen extends StatefulWidget {
//   const PersonalPhysicalScreen({super.key, required this.data});

//   final SignUpData data;

//   @override
//   State<PersonalPhysicalScreen> createState() => _PersonalPhysicalScreenState();
// }

// class _PersonalPhysicalScreenState extends State<PersonalPhysicalScreen> {
//   SignUpData get d => widget.data;

//   void _onSubmitNow() {
//     // TODO: save the partial profile (widget.data) and leave the flow
//   }

//   void _onContinue() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => PhotosAboutScreen(data: d)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 4,
//       title: 'Personal & physical',
//       subtitle: 'A little about you and your lifestyle.',
//       primaryLabel: 'Continue',
//       onPrimary: _onContinue,
//       secondaryLabel: 'Submit now',
//       onSecondary: _onSubmitNow,
//       note: 'Submit now to finish later, or continue to complete your profile.',
//       children: [
//         FormCard(title: 'Marital status', children: [
//           LabeledField(
//             child: ChoiceChips(
//               options: SignUpOptions.maritalStatuses,
//               isSelected: (o) => o == d.maritalStatus,
//               onTap: (o) => setState(() => d.maritalStatus = o),
//             ),
//           ),
//           CounterTile(
//             label: 'Number of children',
//             value: d.children,
//             onChanged: (v) => setState(() => d.children = v),
//           ),
//         ]),
//         FormCard(title: 'Physical details', children: [
//           TwoColumn(
//             left: DropdownField(
//               label: 'Height',
//               value: d.height,
//               items: SignUpOptions.heights,
//               onChanged: (v) => setState(() => d.height = v),
//             ),
//             right: DropdownField(
//               label: 'Weight',
//               value: d.weight,
//               items: SignUpOptions.weights,
//               onChanged: (v) => setState(() => d.weight = v),
//             ),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Body type',
//               value: d.bodyType,
//               items: SignUpOptions.bodyTypes,
//               onChanged: (v) => setState(() => d.bodyType = v),
//             ),
//             right: DropdownField(
//               label: 'Complexion',
//               value: d.complexion,
//               items: SignUpOptions.complexions,
//               onChanged: (v) => setState(() => d.complexion = v),
//             ),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Blood group',
//               value: d.bloodGroup,
//               items: SignUpOptions.bloodGroups,
//               onChanged: (v) => setState(() => d.bloodGroup = v),
//             ),
//             right: DropdownField(
//               label: 'Disability',
//               value: d.disability,
//               items: SignUpOptions.disabilities,
//               onChanged: (v) => setState(() => d.disability = v),
//             ),
//           ),
//           YesNoToggle(
//             question: 'Any major surgery or organ transplant?',
//             value: d.surgery,
//             onChanged: (v) => setState(() => d.surgery = v),
//           ),
//         ]),
//         FormCard(title: 'Lifestyle', children: [
//           DropdownField(
//             label: 'Diet',
//             value: d.diet,
//             items: SignUpOptions.diets,
//             onChanged: (v) => setState(() => d.diet = v),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Smoking',
//               value: d.smoking,
//               items: SignUpOptions.habits,
//               onChanged: (v) => setState(() => d.smoking = v),
//             ),
//             right: DropdownField(
//               label: 'Drinking',
//               value: d.drinking,
//               items: SignUpOptions.habits,
//               onChanged: (v) => setState(() => d.drinking = v),
//             ),
//           ),
//           YesNoToggle(
//             question: 'Do you have pets?',
//             value: d.pets,
//             onChanged: (v) => setState(() => d.pets = v),
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
import 'package:vivahbharath_app/view/register/photos_about_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_options.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class PersonalPhysicalScreen extends StatefulWidget {
  const PersonalPhysicalScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<PersonalPhysicalScreen> createState() => _PersonalPhysicalScreenState();
}

class _PersonalPhysicalScreenState extends State<PersonalPhysicalScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  bool _busy = false;

  List<Opt> _maritalStatuses = [];
  List<Opt> _bodyTypes = [];
  List<Opt> _complexions = []; // the API calls these skin types
  List<Opt> _bloodGroups = [];
  List<Opt> _diets = [];
  List<Opt> _choices = []; // smoking / drinking answers

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_init);
  }

  List<Opt> _opts(Iterable<dynamic>? items) => (items ?? const [])
      .map<Opt>((e) => Opt(e.id as int, e.name as String))
      .toList();

  Future<void> _init() async {
    setState(() => _busy = true);
    final rp = _rp;
    await Future.wait([
      rp.getMaritalStatuses(),
      rp.getBodyTypes(),
      rp.getSkinTypes(),
      rp.getBloodGroups(),
      rp.getDiets(),
      rp.getChoices(),
    ]);
    if (!mounted) return;
    setState(() {
      _maritalStatuses = _opts(rp.maritalStatusesModel?.maritalStatuses);
      _bodyTypes = _opts(rp.bodyTypeModel?.bodyTypes);
      _complexions = _opts(rp.skinTypeModel?.skinTypes);
      _bloodGroups = _opts(rp.bloodGroupModel?.bloodGroups);
      _diets = _opts(rp.dietsModel?.diets);
      _choices = _opts(rp.choicesModel?.choices);
      // keep the old 'Never married' default if the API spells it the same way
      d.maritalStatus =
          _maritalStatuses.match(d.maritalStatus) ?? d.maritalStatus;
      _busy = false;
    });
    if (_maritalStatuses.isEmpty) {
      showMsg('Could not load the form options. Please check your connection.');
    }
  }

  /// "168 cm" -> 168
  int? _heightCm(String? label) {
    if (label == null) return null;
    final m = RegExp(r'(\d+)\s*cm').firstMatch(label);
    return m == null ? null : int.tryParse(m.group(1)!);
  }

  /// "70 kg" -> 70
  int? _weightKg(String? label) {
    if (label == null) return null;
    final m = RegExp(r'(\d+)').firstMatch(label);
    return m == null ? null : int.tryParse(m.group(1)!);
  }

  /// Sends this step. Returns true when the server accepted it.
  Future<bool> _save() async {
    // Marital status is optional: sent as 0 when not picked.
    final maritalId = _maritalStatuses.idOf(d.maritalStatus) ?? 0;

    // Every field on this screen is optional: anything left empty is sent as 0.
    final height = _heightCm(d.height);
    final weight = _weightKg(d.weight);
    final bodyTypeId = _bodyTypes.idOf(d.bodyType);
    final skinTypeId = _complexions.idOf(d.complexion);
    final bloodGroupId = _bloodGroups.idOf(d.bloodGroup);
    final dietId = _diets.idOf(d.diet);
    final smokingId = _choices.idOf(d.smoking);
    final drinkingId = _choices.idOf(d.drinking);

    // String? missing;
    // if (height == null) {
    //   missing = 'height';
    // } else if (weight == null) {
    //   missing = 'weight';
    // } else if (bodyTypeId == null) {
    //   missing = 'body type';
    // } else if (skinTypeId == null) {
    //   missing = 'skin color';
    // } else if (bloodGroupId == null) {
    //   missing = 'blood group';
    // } else if (d.disability == null) {
    //   missing = 'disability';
    // } else if (dietId == null) {
    //   missing = 'diet';
    // } else if (smokingId == null) {
    //   missing = 'smoking habit';
    // } else if (drinkingId == null) {
    //   missing = 'drinking habit';
    // }
    // if (missing != null) {
    //   showMsg('Please select your $missing');
    //   return false;
    // }

    final hasDisability = d.disability == 'Yes';

    final rp = _rp;
    setState(() => _busy = true);
    final ok = await rp.personalDetails(
      maritalStatusId: maritalId,
      childCount: d.children,
      height: height ?? 0,
      weight: weight ?? 0,
      skinTypeId: skinTypeId ?? 0,
      bodyTypeId: bodyTypeId ?? 0,
      bloodGroupId: bloodGroupId ?? 0,
      disabilityStatus: hasDisability ? 1 : 0,
      disabilityDesc: hasDisability ? d.disability! : '',
      majorSurgery: d.surgery ? 1 : 0,
      dietId: dietId ?? 0,
      drinkingHabitId: drinkingId ?? 0,
      smokingHabitId: smokingId ?? 0,
      havePet: d.pets ? 1 : 0,
    );
    if (!mounted) return false;
    setState(() => _busy = false);

    if (!ok) {
      showMsg(rp.personalError ?? 'Something went wrong. Please try again');
    }
    return ok;
  }

  Future<void> _onSubmitNow() async {
    if (_busy) return;
    if (await _save() && mounted) await finishRegistration(context);
  }

  Future<void> _onContinue() async {
    if (_busy) return;
    if (!await _save() || !mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhotosAboutScreen(data: d)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 4,
        title: 'Personal & physical',
        subtitle: 'A little about you and your lifestyle.',
        primaryLabel: 'Continue',
        onPrimary: _onContinue,
        secondaryLabel: 'Submit now',
        onSecondary: _onSubmitNow,
        //note: 'Submit now to finish later, or continue to complete your profile.',
        children: [
          FormCard(
            title: 'Marital status',
            children: [
              LabeledField(
                child: ChoiceChips(
                  options: _maritalStatuses.names,
                  isSelected: (o) => o == d.maritalStatus,
                  onTap: (o) => setState(() => d.maritalStatus = o),
                ),
              ),
              CounterTile(
                label: 'Number of children',
                value: d.children,
                onChanged: (v) => setState(() => d.children = v),
              ),
            ],
          ),
          FormCard(
            title: 'Physical details',
            children: [
              TwoColumn(
                left: DropdownField(
                  label: 'Height',
                  value: d.height,
                  items: SignUpOptions.heights,
                  onChanged: (v) => setState(() => d.height = v),
                ),
                right: DropdownField(
                  label: 'Weight',
                  value: d.weight,
                  items: SignUpOptions.weights,
                  onChanged: (v) => setState(() => d.weight = v),
                ),
              ),
              TwoColumn(
                left: DropdownField(
                  label: 'Body type',
                  value: _bodyTypes.valid(d.bodyType),
                  items: _bodyTypes.names,
                  onChanged: (v) => setState(() => d.bodyType = v),
                ),
                right: DropdownField(
                  label: 'Skin Color',
                  value: _complexions.valid(d.complexion),
                  items: _complexions.names,
                  onChanged: (v) => setState(() => d.complexion = v),
                ),
              ),
              TwoColumn(
                left: DropdownField(
                  label: 'Blood group',
                  value: _bloodGroups.valid(d.bloodGroup),
                  items: _bloodGroups.names,
                  onChanged: (v) => setState(() => d.bloodGroup = v),
                ),
                right: DropdownField(
                  label: 'Disability',
                  value: d.disability,
                  items: SignUpOptions.disabilities,
                  onChanged: (v) => setState(() => d.disability = v),
                ),
              ),
              YesNoToggle(
                question: 'Any major surgery or organ transplant?',
                value: d.surgery,
                onChanged: (v) => setState(() => d.surgery = v),
              ),
            ],
          ),
          FormCard(
            title: 'Lifestyle',
            children: [
              DropdownField(
                label: 'Diet',
                value: _diets.valid(d.diet),
                items: _diets.names,
                onChanged: (v) => setState(() => d.diet = v),
              ),
              TwoColumn(
                left: DropdownField(
                  label: 'Smoking',
                  value: _choices.valid(d.smoking),
                  items: _choices.names,
                  onChanged: (v) => setState(() => d.smoking = v),
                ),
                right: DropdownField(
                  label: 'Drinking',
                  value: _choices.valid(d.drinking),
                  items: _choices.names,
                  onChanged: (v) => setState(() => d.drinking = v),
                ),
              ),
              YesNoToggle(
                question: 'Do you have pets?',
                value: d.pets,
                onChanged: (v) => setState(() => d.pets = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
