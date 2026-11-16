import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';

const kSignUpSteps = 8;

TextStyle dmText(
  double size, {
  FontWeight w = FontWeight.w400,
  Color c = AppColors.headline,
}) => GoogleFonts.dmSans(fontSize: size, fontWeight: w, color: c);

const kTealGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [AppColors.btnA, AppColors.tealC],
);

const kCreamGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [AppColors.loginA, AppColors.loginB],
);

/* ───────────────────── Page scaffold ───────────────────── */

/// Shared layout for every sign-up step: teal header, cards, footer buttons.
class SignUpScaffold extends StatelessWidget {
  const SignUpScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.note,
    this.onHelp,
  });

  /// 1-based step number.
  final int step;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final String? note;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    final header = _Header(
      step: step,
      title: title,
      subtitle: subtitle,
      onBack: () => Navigator.maybePop(context),
      onHelp: onHelp ?? () {},
    );

    final primary = GradientButton(label: primaryLabel, onTap: onPrimary);
    final body = SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: MaxWidthBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              const SizedBox(height: 8),
              if (secondaryLabel == null)
                primary
              else
                Row(
                  children: [
                    Expanded(
                      child: CreamButton(
                        label: secondaryLabel!,
                        onTap: onSecondary ?? () {},
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: primary),
                  ],
                ),
              if (note != null)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    note!,
                    textAlign: TextAlign.center,
                    style: dmText(15, c: AppColors.body),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      // Short screens (landscape phones): header scrolls with the form.
      // Otherwise it stays pinned at the top like the design.
      body: context.isCompactHeight
          ? SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(children: [header, body]),
            )
          : Column(
              children: [
                header,
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: body,
                  ),
                ),
              ],
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onHelp,
  });

  final int step;
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    // includes the notch on landscape phones
    final pad = MediaQuery.paddingOf(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        26 + pad.left,
        pad.top + 10,
        20 + pad.right,
        26,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealC.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: MaxWidthBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo-mark-gold@3x.png',
                        height: 22,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'vivahbharath',
                            style: GoogleFonts.fraunces(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.sparkleGold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onHelp,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: kCreamGradient,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.loginBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          color: AppColors.loginText,
                          size: 19,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Help',
                          style: dmText(
                            15,
                            w: FontWeight.w700,
                            c: AppColors.loginText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STEP $step OF $kSignUpSteps',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AppColors.sparkleGold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: GoogleFonts.fraunces(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: dmText(15, c: Colors.white.withOpacity(0.85)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // step icon (tile + border are part of the image)
                Image.asset(
                  'assets/images/signup_step_$step.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                  // Step 8 (horoscope) has no icon yet — reuse step 7's.
                  errorBuilder: (_, _, _) => Image.asset(
                    'assets/images/signup_step_7.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // progress bar: done = gold, current = white, upcoming = faded
            Row(
              children: List.generate(kSignUpSteps * 2 - 1, (i) {
                if (i.isOdd) return const SizedBox(width: 6);
                final idx = i ~/ 2 + 1;
                return Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: idx < step
                          ? AppColors.sparkleGold
                          : idx == step
                          ? Colors.white
                          : Colors.white.withOpacity(0.25),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────── Cards & fields ───────────────────── */

class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.required = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool required;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Color(0xFFFFF9F1)],
      ),
      border: Border.all(color: AppColors.toggleBg),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F7A4510),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: title,
                  children: [
                    if (required)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                style: dmText(18, w: FontWeight.w700),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(subtitle!, style: dmText(15, c: AppColors.body)),
          ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}

/// Label (with optional red *) + field + optional helper text.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.child,
    this.label,
    this.required = false,
    this.helper,
  });

  final String? label;
  final bool required;
  final String? helper;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text.rich(
              TextSpan(
                text: label,
                children: [
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              style: dmText(15, w: FontWeight.w600, c: AppColors.body),
            ),
          ),
        child,
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(helper!, style: dmText(14, c: AppColors.body)),
          ),
      ],
    ),
  );
}

/// Two fields side by side; stacked when the card is too narrow
/// (very small phones or a large accessibility font).
class TwoColumn extends StatelessWidget {
  const TwoColumn({super.key, required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) => c.maxWidth < 260
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [left, right],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 14),
              Expanded(child: right),
            ],
          ),
  );
}

OutlineInputBorder _border(Color c) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(18),
  borderSide: BorderSide(color: c, width: 1.5),
);

class AppTextInput extends StatelessWidget {
  const AppTextInput({
    super.key,
    required this.controller,
     this.hint,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.counter = true,
    this.formatters,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.allowCopyPaste = true,
  });

  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;
  final int maxLines;
  final int? maxLength;
  final bool counter;
  final List<TextInputFormatter>? formatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool allowCopyPaste;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    // false disables selection, copy, cut and the long-press paste menu
    enableInteractiveSelection: allowCopyPaste,
    contextMenuBuilder: allowCopyPaste
        ? (context, state) => AdaptiveTextSelectionToolbar.editableText(
            editableTextState: state,
          )
        : null,
    enableSuggestions: allowCopyPaste,
    autocorrect: allowCopyPaste,
    keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
    obscureText: obscure,
    maxLines: maxLines,
    minLines: maxLines,
    maxLength: maxLength,
    inputFormatters: [
      ...?formatters,
      // Blocks keyboard clipboard / Ctrl+V paste (multi-char insert at once)
      if (!allowCopyPaste) const _NoPasteFormatter(),
    ],
    readOnly: readOnly,
    onTap: onTap,
    onChanged: onChanged,
    style: dmText(17),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: dmText(17, c: AppColors.hint),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      suffixIcon: suffix,
      counterText: counter ? null : '',
      counterStyle: dmText(14, c: AppColors.body),
      enabledBorder: _border(AppColors.fieldBorder),
      focusedBorder: _border(AppColors.tealA),
    ),
  );
}

/// Rejects any edit that inserts more than one character at once (a paste),
/// while still allowing normal typing and deleting.
class _NoPasteFormatter extends TextInputFormatter {
  const _NoPasteFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldSel = oldValue.selection;
    final removed = oldSel.isValid ? oldSel.end - oldSel.start : 0;
    final inserted = newValue.text.length - (oldValue.text.length - removed);
    return inserted > 1 ? oldValue : newValue;
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    this.isConfirm = false,
  });

  final TextEditingController controller;

  /// Confirm-password mode: always hidden, no show/hide toggle, no copy/paste.
  final bool isConfirm;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) => AppTextInput(
    controller: widget.controller,
    hint: '8–20 characters',
    obscure: widget.isConfirm || !_visible,
    maxLength: 20,
    counter: false,
    allowCopyPaste: !widget.isConfirm,
    suffix: widget.isConfirm
        ? null
        : IconButton(
            onPressed: () => setState(() => _visible = !_visible),
            icon: Icon(
              _visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.headline,
            ),
          ),
  );
}

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    // minHeight (not height) so it grows with large text
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.fieldBorder, width: 1.5),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: Text('Select', style: dmText(17)),
        borderRadius: BorderRadius.circular(16),
        dropdownColor: Colors.white,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.body,
        ),
        style: dmText(17),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

/// Label + dropdown in one.
class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.required = false,
  });

  final String? label;
  final bool required;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => LabeledField(
    label: label,
    required: required,
    child: AppDropdown(value: value, items: items, onChanged: onChanged),
  );
}

/* ───────────────────── Choice controls ───────────────────── */

class ChoiceChips extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.options,
    required this.isSelected,
    required this.onTap,
  });

  final List<String> options;
  final bool Function(String) isSelected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: options.map((o) {
      final sel = isSelected(o);
      return GestureDetector(
        onTap: () => onTap(o),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: sel ? kTealGradient : null,
            color: sel ? null : Colors.white,
            border: Border.all(
              color: sel ? Colors.transparent : AppColors.fieldBorder,
              width: 1.5,
            ),
            boxShadow: sel
                ? [
                    BoxShadow(
                      color: AppColors.tealC.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Text(
            o,
            style: dmText(
              16,
              w: sel ? FontWeight.w700 : FontWeight.w500,
              c: sel ? Colors.white : AppColors.headline,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

class YesNoToggle extends StatelessWidget {
  const YesNoToggle({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final String question;
  final bool value;
  final ValueChanged<bool> onChanged;

  Widget _segment(String label, bool segValue) {
    final sel = value == segValue;
    return GestureDetector(
      onTap: () => onChanged(segValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: sel ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: sel
              ? const [
                  BoxShadow(
                    color: Color(0x1A7A4510),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: dmText(
            16,
            w: FontWeight.w700,
            c: sel ? AppColors.tealB : AppColors.forever.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Expanded(
          child: Text(question, style: dmText(16, w: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.toggleBg,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [_segment('Yes', true), _segment('No', false)],
          ),
        ),
      ],
    ),
  );
}

class CounterTile extends StatelessWidget {
  const CounterTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.max = 20,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  Widget _round(IconData icon, VoidCallback? onTap) => GestureDetector(
    onTap: onTap,
    child: Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: kCreamGradient,
          border: Border.all(color: AppColors.loginBorder),
        ),
        child: Icon(icon, size: 20, color: AppColors.loginText),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.fieldBorder, width: 1.5),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: dmText(16, w: FontWeight.w600)),
        ),
        _round(
          Icons.remove_rounded,
          value > 0 ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: dmText(20, w: FontWeight.w700),
          ),
        ),
        _round(
          Icons.add_rounded,
          value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    ),
  );
}

class SameAsChip extends StatelessWidget {
  const SameAsChip({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!value),
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.fieldBorder, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: value ? kTealGradient : null,
              border: value
                  ? null
                  : Border.all(color: AppColors.fieldBorder, width: 1.5),
            ),
            child: value
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(width: 35),
          Text(
            'Same as\npermanent',
            textAlign: TextAlign.center,
            style: dmText(14, w: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFEDF3FA),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.fieldBorder),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.tealB, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: dmText(15))),
      ],
    ),
  );
}

/* ───────────────────── Buttons ───────────────────── */

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 62,
      // full length when alone; Expanded sizes it when beside Submit/Skip
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        gradient: kTealGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.tealC.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // label shrinks instead of overflowing in half-width buttons
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Text(
              label,
              style: dmText(20, w: FontWeight.w700, c: Colors.white),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.sparkleGold,
              size: 24,
            ),
          ],
        ),
      ),
    ),
  );
}

class CreamButton extends StatelessWidget {
  const CreamButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 62,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        gradient: kCreamGradient,
        border: Border.all(color: AppColors.loginBorder, width: 1.5),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: dmText(20, w: FontWeight.w700, c: AppColors.loginText),
        ),
      ),
    ),
  );
}
