// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:vivahbharath_app/view/register/hobbies_screen.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_options.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class FamilyDetailsScreen extends StatefulWidget {
//   const FamilyDetailsScreen({super.key, required this.data});

//   final SignUpData data;

//   @override
//   State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
// }

// class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
//   SignUpData get d => widget.data;

//   late final _phoneCtrl = TextEditingController(text: d.secondContact);

//   @override
//   void dispose() {
//     _phoneCtrl.dispose();
//     super.dispose();
//   }

//   void _goNext() {
//     FocusScope.of(context).unfocus();
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => HobbiesScreen(data: d)),
//     );
//   }

//   void _onContinue() {
//     d.secondContact = _phoneCtrl.text.trim();
//     _goNext();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 6,
//       title: 'Family details',
//       subtitle: 'Tell matches about your family.',
//       primaryLabel: 'Continue',
//       onPrimary: _onContinue,
//       secondaryLabel: 'Skip',
//       onSecondary: _goNext,
//       note: 'Next you can add your hobbies and interests.',
//       children: [
//         FormCard(title: 'Family background', children: [
//           TwoColumn(
//             left: DropdownField(
//               label: 'Family status',
//               value: d.familyStatus,
//               items: SignUpOptions.familyStatuses,
//               onChanged: (v) => setState(() => d.familyStatus = v),
//             ),
//             right: DropdownField(
//               label: 'Family type',
//               value: d.familyType,
//               items: SignUpOptions.familyTypes,
//               onChanged: (v) => setState(() => d.familyType = v),
//             ),
//           ),
//           TwoColumn(
//             left: DropdownField(
//               label: 'Family values',
//               value: d.familyValues,
//               items: SignUpOptions.familyValues,
//               onChanged: (v) => setState(() => d.familyValues = v),
//             ),
//             right: DropdownField(
//               label: 'Family members',
//               value: d.familyMembers,
//               items: SignUpOptions.familyMemberCounts,
//               onChanged: (v) => setState(() => d.familyMembers = v),
//             ),
//           ),
//         ]),
//         FormCard(title: 'Siblings', children: [
//           CounterTile(
//             label: 'Brothers',
//             value: d.brothers,
//             onChanged: (v) => setState(() {
//               d.brothers = v;
//               if (d.brothersMarried > v) d.brothersMarried = v;
//             }),
//           ),
//           CounterTile(
//             label: 'Brothers married',
//             value: d.brothersMarried,
//             max: d.brothers,
//             onChanged: (v) => setState(() => d.brothersMarried = v),
//           ),
//           CounterTile(
//             label: 'Sisters',
//             value: d.sisters,
//             onChanged: (v) => setState(() {
//               d.sisters = v;
//               if (d.sistersMarried > v) d.sistersMarried = v;
//             }),
//           ),
//           CounterTile(
//             label: 'Sisters married',
//             value: d.sistersMarried,
//             max: d.sisters,
//             onChanged: (v) => setState(() => d.sistersMarried = v),
//           ),
//         ]),
//         FormCard(title: 'Parents & contact', children: [
//           TwoColumn(
//             left: DropdownField(
//               label: "Father's occupation",
//               value: d.fatherOccupation,
//               items: SignUpOptions.parentOccupations,
//               onChanged: (v) => setState(() => d.fatherOccupation = v),
//             ),
//             right: DropdownField(
//               label: "Mother's occupation",
//               value: d.motherOccupation,
//               items: SignUpOptions.parentOccupations,
//               onChanged: (v) => setState(() => d.motherOccupation = v),
//             ),
//           ),
//           DropdownField(
//             label: 'Family property value',
//             value: d.propertyValue,
//             items: SignUpOptions.propertyValues,
//             onChanged: (v) => setState(() => d.propertyValue = v),
//           ),
//           LabeledField(
//             label: 'Second contact number',
//             child: AppTextInput(
//               controller: _phoneCtrl,
//               hint: '10-digit mobile number',
//               keyboardType: TextInputType.phone,
//               maxLength: 10,
//               counter: false,
//               formatters: [FilteringTextInputFormatter.digitsOnly],
//             ),
//           ),
//         ]),
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
import 'package:vivahbharath_app/view/register/hobbies_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_options.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class FamilyDetailsScreen extends StatefulWidget {
  const FamilyDetailsScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  late final _phoneCtrl = TextEditingController(text: d.secondContact);

  bool _busy = false;

  List<Opt> _statuses = [];
  List<Opt> _types = [];
  List<Opt> _values = [];
  List<Opt> _parentJobs = [];
  List<Opt> _propertyValues = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_init);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  List<Opt> _opts(Iterable<dynamic>? items) =>
      (items ?? const []).map<Opt>((e) => Opt(e.id as int, e.name as String)).toList();

  Future<void> _init() async {
    setState(() => _busy = true);
    final rp = _rp;
    await Future.wait([
      rp.getFamilyStatuses(),
      rp.getFamilyTypes(),
      rp.getFamilyValues(),
      rp.getOccupations(),
      rp.getValueSlabs(),
    ]);
    if (!mounted) return;
    setState(() {
      _statuses = _opts(rp.familyStatusesModel?.familyStatuses);
      _types = _opts(rp.familyTypeModel?.familyTypes);
      _values = _opts(rp.familyValuesModel?.familyValues);
      _parentJobs = _opts(rp.occupationsModel?.occupations);
      _propertyValues = _opts(rp.valueSlabModel?.valueSlabs);
      _busy = false;
    });
  }

  bool get _hasInput =>
      d.familyStatus != null ||
      d.familyType != null ||
      d.familyValues != null ||
      d.familyMembers != null ||
      d.brothers > 0 ||
      d.sisters > 0 ||
      d.fatherOccupation != null ||
      d.motherOccupation != null ||
      d.propertyValue != null ||
      d.secondContact.isNotEmpty;

  void _goNext() {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HobbiesScreen(data: d)),
    );
  }

  /// Sibling counts can only be set once the family members count is chosen.
  void _updateSiblings(VoidCallback update) {
    if (d.familyMembers == null) {
      showMsg('Please select the number of family members first');
      return;
    }
    setState(update);
  }

  Future<void> _onContinue() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    d.secondContact = _phoneCtrl.text.trim();

    // Nothing filled in -> nothing to save, just move on.
    if (!_hasInput) return _goNext();

    if (d.secondContact.isNotEmpty && d.secondContact.length != 10) {
      return showMsg('Please provide a valid 10-digit contact number');
    }

    final rp = _rp;
    setState(() => _busy = true);
    // Optional dropdowns the user left empty are sent as 0.
    final ok = await rp.familyDetails(
      familyTypeId: _types.idOf(d.familyType) ?? 0,
      familyStatusId: _statuses.idOf(d.familyStatus) ?? 0,
      familyValueId: _values.idOf(d.familyValues) ?? 0,
      membersCount: int.tryParse(d.familyMembers ?? '') ?? 0,
      brotherCount: d.brothers,
      sisterCount: d.sisters,
      brotherMarriedCount: d.brothersMarried,
      sisterMarriedCount: d.sistersMarried,
      fatherJobId: _parentJobs.idOf(d.fatherOccupation) ?? 0,
      motherJobId: _parentJobs.idOf(d.motherOccupation) ?? 0,
      familyPropertyValueId: _propertyValues.idOf(d.propertyValue) ?? 0,
      mobile2: d.secondContact,
      mobile2whatsapp:
          d.secondContact.isNotEmpty && d.secondContactWhatsapp ? 1 : 0,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(rp.familyError ?? 'Something went wrong. Please try again');
    }
    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 6,
        title: 'Family details',
        subtitle: 'Tell matches about your family.',
        primaryLabel: 'Continue',
        onPrimary: _onContinue,
        secondaryLabel: 'Skip',
        onSecondary: _goNext,
        note: 'In next two stages you can enter your hobbies, interests & horoscope details.',
        children: [
          FormCard(title: 'Family background', children: [
            TwoColumn(
              left: DropdownField(
                label: 'Family status',
                value: _statuses.valid(d.familyStatus),
                items: _statuses.names,
                onChanged: (v) => setState(() => d.familyStatus = v),
              ),
              right: DropdownField(
                label: 'Family type',
                value: _types.valid(d.familyType),
                items: _types.names,
                onChanged: (v) => setState(() => d.familyType = v),
              ),
            ),
            TwoColumn(
              left: DropdownField(
                label: 'Family values',
                value: _values.valid(d.familyValues),
                items: _values.names,
                onChanged: (v) => setState(() => d.familyValues = v),
              ),
              right: DropdownField(
                label: 'Family members',
                value: d.familyMembers,
                items: SignUpOptions.familyMemberCounts,
                onChanged: (v) => setState(() => d.familyMembers = v),
              ),
            ),
          ]),
          FormCard(title: 'Siblings', children: [
            CounterTile(
              label: 'Brothers',
              value: d.brothers,
              onChanged: (v) => _updateSiblings(() {
                d.brothers = v;
                if (d.brothersMarried > v) d.brothersMarried = v;
              }),
            ),
            CounterTile(
              label: 'Brothers married',
              value: d.brothersMarried,
              max: d.brothers,
              onChanged: (v) => _updateSiblings(() => d.brothersMarried = v),
            ),
            CounterTile(
              label: 'Sisters',
              value: d.sisters,
              onChanged: (v) => _updateSiblings(() {
                d.sisters = v;
                if (d.sistersMarried > v) d.sistersMarried = v;
              }),
            ),
            CounterTile(
              label: 'Sisters married',
              value: d.sistersMarried,
              max: d.sisters,
              onChanged: (v) => _updateSiblings(() => d.sistersMarried = v),
            ),
          ]),
          FormCard(title: 'Parents & contact', children: [
            TwoColumn(
              left: DropdownField(
                label: "Father's\n occupation",
                value: _parentJobs.valid(d.fatherOccupation),
                items: _parentJobs.names,
                onChanged: (v) => setState(() => d.fatherOccupation = v),
              ),
              right: DropdownField(
                label: "Mother's occupation",
                value: _parentJobs.valid(d.motherOccupation),
                items: _parentJobs.names,
                onChanged: (v) => setState(() => d.motherOccupation = v),
              ),
            ),
            DropdownField(
              label: 'Family property value',
              value: _propertyValues.valid(d.propertyValue),
              items: _propertyValues.names,
              onChanged: (v) => setState(() => d.propertyValue = v),
            ),
            LabeledField(
              label: 'Second contact number',
              child: AppTextInput(
                controller: _phoneCtrl,
                hint: '10-digit mobile number',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                counter: false,
                formatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => setState(() => d.secondContact = v.trim()),
              ),
            ),
            if (_phoneCtrl.text.trim().isNotEmpty)
              YesNoToggle(
                question: 'Is this a WhatsApp enabled number?',
                value: d.secondContactWhatsapp,
                onChanged: (v) => setState(() => d.secondContactWhatsapp = v),
              ),
          ]),
        ],
      ),
    );
  }
}