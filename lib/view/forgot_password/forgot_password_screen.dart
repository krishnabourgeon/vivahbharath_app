import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/forgot_password/reset_otp_screen.dart';
import 'package:vivahbharath_app/view/forgot_password/widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _useEmail = false;
  bool _busy = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  String _maskPhone(String p) =>
      '+91 ${p.substring(0, 2)}••••••${p.substring(p.length - 2)}';

  String _maskEmail(String e) {
    final at = e.indexOf('@');
    final name = e.substring(0, at);
    final shown = name.length <= 2 ? name.substring(0, 1) : name.substring(0, 2);
    return '$shown••••${e.substring(at)}';
  }

  Future<void> _onSendCode() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    final String contact;
    final String masked;
    if (_useEmail) {
      contact = _emailCtrl.text.trim();
      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(contact)) {
        return showMsg('Please enter a valid email address');
      }
      masked = _maskEmail(contact);
    } else {
      contact = _phoneCtrl.text.trim();
      if (!RegExp(r'^\d{10}$').hasMatch(contact)) {
        return showMsg('Please provide a valid 10-digit mobile number');
      }
      masked = _maskPhone(contact);
    }

    setState(() => _busy = true);
    // TODO: call your forgot-password API here, e.g.
    // final ok = await context.read<AuthProvider>().forgotPassword(contact);
    const ok = true;
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) return showMsg('Could not send the code. Please try again');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetOtpScreen(
          contact: contact,
          maskedContact: masked,
          isEmail: _useEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final side = contentSidePadding(context);
    return BusyOverlay(
      busy: _busy,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: AuthHero(step: 0)),
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
                        title: 'Forgot password?',
                        subtitle: "No worries. Enter the mobile number or email "
                            "linked to your account and we'll send you a "
                            "6-digit code.",
                      ),
                      const SizedBox(height: 24),
                      _Toggle(
                        useEmail: _useEmail,
                        onChanged: (v) {
                          FocusScope.of(context).unfocus();
                          setState(() => _useEmail = v);
                        },
                      ),
                      const SizedBox(height: 24),
                      if (_useEmail) ...[
                        const AuthLabel('Email'),
                        AuthField(
                          controller: _emailCtrl,
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ] else ...[
                        const AuthLabel('Mobile number'),
                        AuthPhoneField(controller: _phoneCtrl),
                      ],
                      const Spacer(),
                      const SizedBox(height: 24),
                      AuthPrimaryButton(label: 'Send code', onTap: _onSendCode),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Remembered it? ',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: AppColors.body,
                              ),
                            ),
                            AuthLink(
                              'Back to log in',
                              onTap: () => Navigator.maybePop(context),
                            ),
                          ],
                        ),
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

class _Toggle extends StatelessWidget {
  final bool useEmail;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.useEmail, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFFF1E6D3),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        _seg('Mobile number', !useEmail, () => onChanged(false)),
        _seg('Email', useEmail, () => onChanged(true)),
      ],
    ),
  );

  Widget _seg(String label, bool selected, VoidCallback onTap) => Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.headline : AppColors.body,
          ),
        ),
      ),
    ),
  );
}