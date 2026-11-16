import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/forgot_password/widgets/auth_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String contact;
  final String otp;
  const ResetPasswordScreen({
    super.key,
    required this.contact,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const _green = Color(0xFF2E8B57);
  static const _amber = Color(0xFFE3A64F);
  static const _red = Color(0xFFD9534F);
  static const _track = Color(0xFFE6DCCB);

  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _hideNew = true;
  bool _hideConfirm = true;
  bool _busy = false;

  @override
  void dispose() {
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String get _pass => _newCtrl.text;
  bool get _hasLength => _pass.length >= 8;
  bool get _hasNumber => RegExp(r'\d').hasMatch(_pass);
  bool get _hasCase =>
      RegExp(r'[a-z]').hasMatch(_pass) && RegExp(r'[A-Z]').hasMatch(_pass);
  bool get _hasSpecial => RegExp(r'[^A-Za-z0-9]').hasMatch(_pass);
  bool get _allRules => _hasLength && _hasNumber && _hasCase;

  /// 0-4 filled segments: one per rule met, plus one for a special character.
  int get _score {
    var s = 0;
    if (_hasLength) s++;
    if (_hasNumber) s++;
    if (_hasCase) s++;
    if (_allRules && _hasSpecial) s++;
    return s;
  }

  Color get _strengthColor {
    if (_score >= 3) return _green;
    if (_score == 2) return _amber;
    return _red;
  }

  String get _strengthLabel {
    if (_score >= 3) return 'Strong password';
    if (_score == 2) return 'Okay password';
    return 'Weak password';
  }

  Future<void> _onUpdate() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    if (!_allRules) {
      return showMsg('Your password needs to meet all the requirements');
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      return showMsg('Passwords do not match');
    }

    setState(() => _busy = true);
    // TODO: call your reset-password API here, e.g.
    // final ok = await context.read<AuthProvider>()
    //     .resetPassword(widget.contact, widget.otp, _newCtrl.text);
    const ok = true;
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) return showMsg('Could not update your password. Please try again');

    showMsg('Password updated. Please log in.');
    // Back to the first route (login) and clear the reset flow.
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  Widget _eye(bool hidden, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Icon(
      hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      color: AppColors.body,
      size: 22,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final side = contentSidePadding(context);
    final showMeter = _pass.isNotEmpty;
    return BusyOverlay(
      busy: _busy,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: AuthHero(step: 2)),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24 + side, 28, 24 + side, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthTitle(
                        title: 'Create a new password',
                        subtitle: "Choose a password you haven't used before on "
                            'Vivah Bharath.',
                      ),
                      const SizedBox(height: 24),
                      const AuthLabel('New password'),
                      AuthField(
                        controller: _newCtrl,
                        hint: '8–20 characters',
                        obscureText: _hideNew,
                        onChanged: (_) => setState(() {}),
                        suffix: _eye(
                          _hideNew,
                          () => setState(() => _hideNew = !_hideNew),
                        ),
                      ),
                      if (showMeter) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(4, (i) {
                            return Expanded(
                              child: Container(
                                height: 5,
                                margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                                decoration: BoxDecoration(
                                  color: i < _score ? _strengthColor : _track,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _strengthLabel,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _strengthColor,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      _Rule(met: _hasLength, text: 'At least 8 characters'),
                      _Rule(met: _hasNumber, text: 'Includes a number'),
                      _Rule(
                        met: _hasCase,
                        text: 'Includes upper and lower case letters',
                      ),
                      const SizedBox(height: 16),
                      const AuthLabel('Confirm new password'),
                      AuthField(
                        controller: _confirmCtrl,
                        hint: 'Re-enter new password',
                        obscureText: _hideConfirm,
                        suffix: _eye(
                          _hideConfirm,
                          () => setState(() => _hideConfirm = !_hideConfirm),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      AuthPrimaryButton(
                        label: 'Update password',
                        onTap: _onUpdate,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  final bool met;
  final String text;
  const _Rule({required this.met, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met ? const Color(0xFF2E8B57) : Colors.transparent,
            border: Border.all(
              color: met ? const Color(0xFF2E8B57) : AppColors.fieldBorder,
              width: 1.5,
            ),
          ),
          child: met
              ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.headline),
          ),
        ),
      ],
    )
  );
  }