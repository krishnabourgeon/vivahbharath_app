import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/forgot_password/resetpassword_screen.dart';
import 'package:vivahbharath_app/view/forgot_password/widgets/auth_widgets.dart';

class ResetOtpScreen extends StatefulWidget {
  final String contact; // raw phone or email
  final String maskedContact;
  final bool isEmail;
  const ResetOtpScreen({
    super.key,
    required this.contact,
    required this.maskedContact,
    required this.isEmail,
  });

  @override
  State<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends State<ResetOtpScreen> {
  static const _otpLength = 6;
  static const _resendSeconds = 30;

  final _otpCtrl = TextEditingController();
  final _otpFocus = FocusNode();
  Timer? _timer;
  int _left = _resendSeconds;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _left = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_left <= 1) {
        t.cancel();
        setState(() => _left = 0);
      } else {
        setState(() => _left--);
      }
    });
  }

  String get _timerText {
    final m = (_left ~/ 60).toString().padLeft(2, '0');
    final s = (_left % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onResend() async {
    if (_busy || _left > 0) return;
    setState(() => _busy = true);
    // TODO: call your resend-code API here, e.g.
    // final ok = await context.read<AuthProvider>().forgotPassword(widget.contact);
    const ok = true;
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) return showMsg('Could not resend the code. Please try again');
    _otpCtrl.clear();
    _startTimer();
    showMsg('A new code has been sent');
  }

  Future<void> _onVerify() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    final otp = _otpCtrl.text.trim();
    if (otp.length != _otpLength) {
      return showMsg('Please enter the 6-digit code');
    }

    setState(() => _busy = true);
    // TODO: call your verify-code API here, e.g.
    // final ok = await context.read<AuthProvider>().verifyResetOtp(widget.contact, otp);
    const ok = true;
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) return showMsg('That code is incorrect. Please try again');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(contact: widget.contact, otp: otp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final side = contentSidePadding(context);
    final canResend = _left == 0;
    return BusyOverlay(
      busy: _busy,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: AuthHero(step: 1)),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24 + side, 28, 24 + side, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter verification code',
                        style: GoogleFonts.fraunces(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.headline,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'We sent a 6-digit code to ',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              height: 1.5,
                              color: AppColors.body,
                            ),
                          ),
                          Text(
                            widget.maskedContact,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.headline,
                            ),
                          ),
                          Text(
                            '. ',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: AppColors.body,
                            ),
                          ),
                          AuthLink(
                            'Change',
                            size: 16,
                            onTap: () => Navigator.maybePop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _OtpBoxes(
                        controller: _otpCtrl,
                        focusNode: _otpFocus,
                        length: _otpLength,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 20,
                              color: Color(0xFF8A4B12),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              canResend ? 'You can resend now' : 'Resend code in ',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: AppColors.body,
                              ),
                            ),
                            if (!canResend)
                              Text(
                                _timerText,
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF8A4B12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2FB),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD6E0EC)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              size: 22,
                              color: Color(0xFF1F4E8C),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Never share this code with anyone, including '
                                'people who say they are from Vivah Bharath.',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  height: 1.45,
                                  color: AppColors.body,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      AuthPrimaryButton(label: 'Verify', onTap: _onVerify),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Didn't get it? ",
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: AppColors.body,
                              ),
                            ),
                            AuthLink(
                              widget.isEmail ? 'Send again' : 'Send by SMS again',
                              onTap: canResend ? _onResend : null,
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

/* ───────────────────────── OTP BOXES ───────────────────────── */

/// Six display boxes driven by one hidden TextField, so paste, backspace and
/// SMS autofill all work without juggling six focus nodes.
class _OtpBoxes extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  const _OtpBoxes({
    required this.controller,
    required this.focusNode,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: focusNode.requestFocus,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([controller, focusNode]),
            builder: (context, _) {
              final text = controller.text;
              final activeIndex = math.min(text.length, length - 1);
              return Row(
                children: List.generate(length, (i) {
                  final filled = i < text.length;
                  final active = focusNode.hasFocus && i == activeIndex;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < length - 1 ? 10 : 0),
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: active
                                ? AppColors.tealC
                                : AppColors.fieldBorder,
                            width: active ? 2 : 1.5,
                          ),
                        ),
                        child: Text(
                          filled ? text[i] : '',
                          style: GoogleFonts.dmSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.headline,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                maxLength: length,
                showCursor: false,
                enableInteractiveSelection: false,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}