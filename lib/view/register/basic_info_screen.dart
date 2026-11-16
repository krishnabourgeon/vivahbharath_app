// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/register/community_location_screen.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class BasicInfoScreen extends StatefulWidget {
//   BasicInfoScreen({super.key, SignUpData? data}) : data = data ?? SignUpData();

//   final SignUpData data;

//   @override
//   State<BasicInfoScreen> createState() => _BasicInfoScreenState();
// }

// class _BasicInfoScreenState extends State<BasicInfoScreen> {
//   SignUpData get d => widget.data;

//   late final _dobCtrl = TextEditingController(text: _formatDate(d.dob));
//   late final _emailCtrl = TextEditingController(text: d.email);
//   late final _passCtrl = TextEditingController(text: d.password);
//   late final _confirmCtrl = TextEditingController(text: d.password);

//   @override
//   void dispose() {
//     _dobCtrl.dispose();
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _confirmCtrl.dispose();
//     super.dispose();
//   }

//   static String _formatDate(DateTime? date) {
//     if (date == null) return '';
//     String two(int n) => n.toString().padLeft(2, '0');
//     return '${two(date.day)}-${two(date.month)}-${date.year}';
//   }

//   Future<void> _pickDob() async {
//     final now = DateTime.now();
//     final latest = DateTime(now.year - 18, now.month, now.day);
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: d.dob ?? latest,
//       firstDate: DateTime(now.year - 80),
//       lastDate: latest,
//     );
//     if (picked == null) return;
//     setState(() {
//       d.dob = picked;
//       _dobCtrl.text = _formatDate(picked);
//     });
//   }

//   void _onContinue() {
//     FocusScope.of(context).unfocus();
//     d.email = _emailCtrl.text.trim();
//     d.password = _passCtrl.text;
//     // TODO: validate (required fields, email format, passwords match)
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CommunityLocationScreen(data: d)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 1,
//       title: 'Basic information',
//       subtitle: "Let's start with the essentials for your profile.",
//       primaryLabel: 'Continue',
//       onPrimary: _onContinue,
//       children: [
//         FormCard(title: 'About you', children: [
//           LabeledField(
//             label: 'Gender',
//             required: true,
//             child: ChoiceChips(
//               options: const ['Male', 'Female'],
//               isSelected: (o) => o == d.gender,
//               onTap: (o) => setState(() => d.gender = o),
//             ),
//           ),
//           LabeledField(
//             label: 'Date of birth',
//             required: true,
//             child: AppTextInput(
//               controller: _dobCtrl,
//               hint: 'DD-MM-YYYY',
//               readOnly: true,
//               onTap: _pickDob,
//             ),
//           ),
//           LabeledField(
//             label: 'Email',
//             required: true,
//             helper: "We'll send your account updates here",
//             child: AppTextInput(
//               controller: _emailCtrl,
//               hint: 'you@example.com',
//               keyboardType: TextInputType.emailAddress,
//             ),
//           ),
//         ]),
//         FormCard(title: 'Create a password', children: [
//           LabeledField(
//             label: 'Password',
//             required: true,
//             helper: 'Use 8–20 characters, e.g. Abcdefgh',
//             child: PasswordInput(controller: _passCtrl),
//           ),
//           LabeledField(
//             label: 'Confirm password',
//             required: true,
//             child: PasswordInput(controller: _confirmCtrl),
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
import 'package:vivahbharath_app/services/validation_helper.dart';
import 'package:vivahbharath_app/view/register/community_location_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class BasicInfoScreen extends StatefulWidget {
  BasicInfoScreen({super.key, SignUpData? data}) : data = data ?? SignUpData();

  final SignUpData data;

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  SignUpData get d => widget.data;

  late final _dobCtrl = TextEditingController(text: _formatDate(d.dob));
  late final _emailCtrl = TextEditingController(text: d.email);
  late final _passCtrl = TextEditingController(text: d.password);
  late final _confirmCtrl = TextEditingController(text: d.password);

  bool _busy = false;
  List<Opt> _genders = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_loadGenders);
  }

  @override
  void dispose() {
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadGenders() async {
    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    await rp.getGenders();
    if (!mounted) return;
    final list = (rp.genderModel?.genders ?? [])
        .map((e) => Opt(e.id, e.name))
        .toList();
    setState(() {
      _genders = list;
      // First visit: pre-select the gender the signup step already told us.
      final fresh = d.dob == null && d.email.isEmpty;
      final fromSignup = list.nameOf(rp.signupModel?.genderId);
      d.gender =
          (fresh ? fromSignup : null) ?? list.match(d.gender) ?? d.gender;
      _busy = false;
    });
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}-${two(date.month)}-${date.year}';
  }

  /// dd-MM-yyyy (PHP "d-m-Y"), the format the API expects.
  static String _apiDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}-${two(date.month)}-${date.year}';
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final latest = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: d.dob ?? latest,
      firstDate: DateTime(now.year - 80),
      lastDate: latest,
    );
    if (picked == null) return;
    setState(() {
      d.dob = picked;
      _dobCtrl.text = _formatDate(picked);
    });
  }

  Future<void> _onContinue() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;
    d.email = _emailCtrl.text.trim();
    d.password = _passCtrl.text;

    final rp = context.read<RegisterProvider>();
    final genderId = _genders.idOf(d.gender) ?? rp.signupModel?.genderId;

    if (genderId == null) return showMsg('Please select your gender');
    if (d.dob == null) return showMsg('Please select your date of birth');
    final emailErr = ValidationHelperClass.validateEmail(d.email);
    if (emailErr != null) return showMsg(emailErr);
    if (d.password.length < 8 || d.password.length > 20) {
      return showMsg('Password must be 8–20 characters');
    }
    if (d.password != _confirmCtrl.text) {
      return showMsg('Passwords do not match');
    }

    setState(() => _busy = true);
    final ok = await rp.basicInfo(
      d.email,
      d.password,
      _confirmCtrl.text,
      _apiDate(d.dob!),
      genderId,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(
        rp.basicInfoError ?? 'Something went wrong. Please try again',
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CommunityLocationScreen(data: d)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 1,
        title: 'Basic information',
        subtitle: "Let's start with the essentials for your profile.",
        primaryLabel: 'Continue',
        onPrimary: _onContinue,
        children: [
          FormCard(
            title: 'About you',
            children: [
              LabeledField(
                label: 'Gender',
                required: true,
                child: ChoiceChips(
                  options: _genders.isEmpty
                      ? const ['Male', 'Female']
                      : _genders.names,
                  isSelected: (o) => o == d.gender,
                  onTap: (o) => setState(() => d.gender = o),
                ),
              ),
              LabeledField(
                label: 'Date of birth',
                required: true,
                child: AppTextInput(
                  controller: _dobCtrl,
                  hint: 'DD-MM-YYYY',
                  readOnly: true,
                  onTap: _pickDob,
                ),
              ),
              LabeledField(
                label: 'Email',
                required: true,
                helper: "We'll send your account updates here",
                child: AppTextInput(
                  controller: _emailCtrl,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          FormCard(
            title: 'Create a password',
            children: [
              LabeledField(
                label: 'Password',
                required: true,
                helper: 'Use 8–20 characters, e.g. Abcdefgh',
                child: PasswordInput(controller: _passCtrl),
              ),
              LabeledField(
                label: 'Confirm password',
                required: true,
                child: PasswordInput(controller: _confirmCtrl, isConfirm: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
