// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_options.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class HobbiesScreen extends StatefulWidget {
//   const HobbiesScreen({super.key, required this.data});

//   final SignUpData data;

//   @override
//   State<HobbiesScreen> createState() => _HobbiesScreenState();
// }

// class _HobbiesScreenState extends State<HobbiesScreen> {
//   SignUpData get d => widget.data;

//   late final _otherCtrl = TextEditingController(text: d.otherHobbies);

//   @override
//   void dispose() {
//     _otherCtrl.dispose();
//     super.dispose();
//   }

//   void _toggleHobby(String hobby) => setState(() =>
//       d.hobbies.contains(hobby) ? d.hobbies.remove(hobby) : d.hobbies.add(hobby));

//   void _submit() {
//     FocusScope.of(context).unfocus();
//     // TODO: submit the full profile (widget.data), then go to the dashboard
//   }

//   void _onFinish() {
//     d.otherHobbies = _otherCtrl.text.trim();
//     _submit();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 7,
//       title: 'Hobbies & interests',
//       subtitle: 'Shared interests make great conversations.',
//       primaryLabel: 'Finish',
//       onPrimary: _onFinish,
//       secondaryLabel: 'Skip',
//       onSecondary: _submit,
//       note: 'You can edit all of this later from your dashboard.',
//       children: [
//         FormCard(title: 'Pick what you enjoy', children: [
//           LabeledField(
//             child: ChoiceChips(
//               options: SignUpOptions.hobbies,
//               isSelected: d.hobbies.contains,
//               onTap: _toggleHobby,
//             ),
//           ),
//           LabeledField(
//             label: 'Anything else?',
//             child: AppTextInput(
//               controller: _otherCtrl,
//               hint: 'Tell us more',
//               maxLines: 4,
//               maxLength: 255,
//             ),
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
import 'package:vivahbharath_app/view/register/horoscopr_details_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class HobbiesScreen extends StatefulWidget {
  const HobbiesScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<HobbiesScreen> createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  late final _otherCtrl = TextEditingController(text: d.otherHobbies);

  bool _busy = false;
  List<Opt> _hobbies = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_loadHobbies);
  }

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadHobbies() async {
    final rp = _rp;
    setState(() => _busy = true);
    await rp.getHobbies();
    if (!mounted) return;
    setState(() {
      _hobbies = (rp.hobbiesModel?.hobbies ?? [])
          .map((e) => Opt(e.id, e.name))
          .toList();
      _busy = false;
    });
    if (_hobbies.isEmpty) {
      showMsg('Could not load hobbies. Please check your connection.');
    }
  }

  void _toggleHobby(String hobby) => setState(
    () => d.hobbies.contains(hobby)
        ? d.hobbies.remove(hobby)
        : d.hobbies.add(hobby),
  );

  void _goNext() {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HoroscopeDetailsScreen(data: d)),
    );
  }

  /// Skip: go to the next step without saving anything on this one.
  void _skip() {
    if (_busy) return;
    _goNext();
  }

  Future<void> _onFinish() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    d.otherHobbies = _otherCtrl.text.trim();

    final ids = d.hobbies.map(_hobbies.idOf).whereType<int>().toList();
    if (ids.isNotEmpty || d.otherHobbies.isNotEmpty) {
      final rp = _rp;
      setState(() => _busy = true);
      final ok = await rp.saveHobbies(
        hobbies: ids,
        otherHobbies: d.otherHobbies,
      );
      if (!mounted) return;
      setState(() => _busy = false);
      if (!ok) {
        return showMsg(
          rp.hobbyError ?? 'Something went wrong. Please try again',
        );
      }
    }
    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 7,
        title: 'Hobbies & interests',
        subtitle: 'Shared interests make great conversations.',
        primaryLabel: 'Continue',
        onPrimary: _onFinish,
        secondaryLabel: 'Skip',
        onSecondary: _skip,
        note: 'Next you can add your horoscope details.',
        children: [
          FormCard(
            title: 'Pick what you enjoy',
            children: [
              LabeledField(
                child: ChoiceChips(
                  options: _hobbies.names,
                  isSelected: d.hobbies.contains,
                  onTap: _toggleHobby,
                ),
              ),
              LabeledField(
                label: 'Anything else?',
                child: AppTextInput(
                  controller: _otherCtrl,
                  hint: 'Tell us more',
                  maxLines: 4,
                  maxLength: 255,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
