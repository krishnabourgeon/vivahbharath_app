import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

/// Step 8 (last step) – horoscope details. Submits to `horoscope-info`
/// and then finishes the registration.
class HoroscopeDetailsScreen extends StatefulWidget {
  const HoroscopeDetailsScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<HoroscopeDetailsScreen> createState() => _HoroscopeDetailsScreenState();
}

class _HoroscopeDetailsScreenState extends State<HoroscopeDetailsScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  late final _locationCtrl = TextEditingController(text: d.birthLocation);
  late final _doshaTypeCtrl = TextEditingController(text: d.doshaType);

  bool _busy = false;
  List<Opt> _stars = [];

  static const _yesNoDontKnow = ['Yes', 'No', "Don't know"];
  static const _yesNo = ['Yes', 'No'];

  /// Order matters: match_type_id = index + 1.
  static const _matchLevels = [
    'Important',
    'Preferable',
    "Don't want",
    'Not necessary',
  ];

  @override
  void initState() {
    super.initState();
    d.horoscopeDob ??= d.dob;
    d.starMatchOnly ??= '';
    d.horoscopeMatch ??= '';
    CommonFunctions.afterInit(_loadStars);
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    _doshaTypeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadStars() async {
    final rp = _rp;
    setState(() => _busy = true);
    await rp.getStars();
    if (!mounted) return;
    setState(() {
      _stars = (rp.starsModel?.stars ?? [])
          .map((e) => Opt(e.id, e.name))
          .toList();
      _busy = false;
    });
    if (_stars.isEmpty) {
      showMsg('Could not load birth stars. Please check your connection.');
    }
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// dd-MM-yyyy (PHP "d-m-Y"), the format the API expects.
  static String _fmtDate(DateTime? v) =>
      v == null ? '' : '${_two(v.day)}-${_two(v.month)}-${v.year}';

  /// 12-hour "hh:mm"; the AM/PM part is sent separately.
  static String _fmtTime(TimeOfDay t) =>
      '${_two(t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod)}:${_two(t.minute)}';

  static String _period(TimeOfDay t) => t.period == DayPeriod.am ? 'AM' : 'PM';

  /// Yes = 1, No = 0, Don't know = 2.
  static int _jathakamCode(String? v) => switch (v) {
        'Yes' => 1,
        'No' => 0,
        _ => 2,
      };

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: d.horoscopeDob ?? DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (picked != null) setState(() => d.horoscopeDob = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: d.birthTime ?? const TimeOfDay(hour: 6, minute: 0),
    );
    if (picked != null) setState(() => d.birthTime = picked);
  }

  /// Skip: finish registration without saving this step.
  Future<void> _skip() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    await finishRegistration(context);
  }

  Future<void> _submit() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    d.birthLocation = _locationCtrl.text.trim();
    d.doshaType = d.doshaJathakam == 'Yes' ? _doshaTypeCtrl.text.trim() : '';

    // if (d.horoscopeDob == null) {
    //   return showMsg('Please select your date of birth');
    // }
    // if (d.birthTime == null) {
    //   return showMsg('Please select your time of birth');
    // }
    // if (d.birthLocation!.isEmpty) {
    //   return showMsg('Please enter your location of birth');
    // }

    final rp = _rp;
    setState(() => _busy = true);
    final ok = await rp.horoscopeDetails(
      dobHoroscope: _fmtDate(d.horoscopeDob),
      // All fields are optional — send empty strings for anything not filled.
      birthTime: d.birthTime == null ? '' : _fmtTime(d.birthTime!),
      birthTimePeriod: d.birthTime == null ? '' : _period(d.birthTime!),
      birthPlace: d.birthLocation ?? '',
      starId: _stars.idOf(d.birthStar),
      isSudhaJathakam: _jathakamCode(d.sudhaJathakam),
      isDoshaJathakam: _jathakamCode(d.doshaJathakam),
      show: d.showHoroscope ? 1 : 0,
      matchTypeId: _matchLevels.indexOf(d.horoscopeMatch ?? 'Not necessary') + 1,
      starMatch: d.starMatchOnly == 'Yes' ? 1 : 0,
      doshaType: d.doshaType,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      return showMsg(
        rp.horoscopeError ?? 'Something went wrong. Please try again',
      );
    }
    await finishRegistration(context);
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 8,
        title: 'Horoscope details',
        subtitle: 'Birth details help us find compatible matches.',
        primaryLabel: 'Submit',
        onPrimary: _submit,
        secondaryLabel: 'Skip',
        onSecondary: _skip,
        note:
            'After completing the registration, you can edit the profile from your personal dashboard.',
        children: [
          FormCard(
            title: 'Birth details',
            children: [
              TwoColumn(
                left: _PickerField(
                  label: 'Date of birth',
                  text: _fmtDate(d.horoscopeDob),
                  hint: 'DD-MM-YYYY',
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
                right: DropdownField(
                  label: 'Birth star',
                  value: _stars.valid(d.birthStar),
                  items: _stars.names,
                  onChanged: (v) => setState(() => d.birthStar = v),
                ),
              ),
              TwoColumn(
                left: _PickerField(
                  label: 'Time of birth',
                  text: d.birthTime == null
                      ? ''
                      : '${_fmtTime(d.birthTime!)} ${_period(d.birthTime!)}',
                  hint: 'HH:MM AM/PM',
                  icon: Icons.access_time,
                  onTap: _pickTime,
                ),
                right: LabeledField(
                  label: 'Location of birth',
                  child: AppTextInput(
                    controller: _locationCtrl,
                    hint: 'Enter the location',
                  ),
                ),
              ),
            ],
          ),
          FormCard(
            title: 'Jathakam',
            children: [
              LabeledField(
                label: 'Having Sudha Jathakam',
                child: ChoiceChips(
                  options: _yesNoDontKnow,
                  isSelected: (o) => o == d.sudhaJathakam,
                  onTap: (o) => setState(() => d.sudhaJathakam = o),
                ),
              ),
              LabeledField(
                label: 'Having Dosha Jathakam',
                child: ChoiceChips(
                  options: _yesNoDontKnow,
                  isSelected: (o) => o == d.doshaJathakam,
                  onTap: (o) => setState(() => d.doshaJathakam = o),
                ),
              ),
              if (d.doshaJathakam == 'Yes')
                LabeledField(
                  label: 'Dosha type',
                  child: AppTextInput(
                    controller: _doshaTypeCtrl,
                    hint: 'e.g. Chevvai dosham',
                    maxLength: 255,
                  ),
                ),
            ],
          ),
          FormCard(
            title: 'Match preference',
            children: [
              LabeledField(
                label: 'Looking for star match only?',
                child: ChoiceChips(
                  options: _yesNo,
                  isSelected: (o) => o == d.starMatchOnly,
                  onTap: (o) => setState(() => d.starMatchOnly = o),
                ),
              ),
              LabeledField(
                label: 'Horoscope matches',
                child: ChoiceChips(
                  options: _matchLevels,
                  isSelected: (o) => o == d.horoscopeMatch,
                  onTap: (o) => setState(() => d.horoscopeMatch = o),
                ),
              ),
              YesNoToggle(
                question: 'Show horoscope details on my profile?',
                value: d.showHoroscope,
                onChanged: (v) => setState(() => d.showHoroscope = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tap-to-pick field (date / time) styled like the dropdowns.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.text,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  final String label, text, hint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    return LabeledField(
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: border,
            enabledBorder: border,
            suffixIcon: Icon(icon, size: 18),
          ),
          child: Text(
            text.isEmpty ? hint : text,
            style: TextStyle(
              color: text.isEmpty ? Colors.grey.shade500 : null,
            ),
          ),
        ),
      ),
    );
  }
}
