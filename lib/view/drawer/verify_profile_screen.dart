import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/trust_badge.dart';

/// Verify your profile: phone + email, each with its own send-code / verify flow.
/// A channel that is already verified only shows the verified card.
class VerifyProfileScreen extends StatelessWidget {
  const VerifyProfileScreen({
    super.key,
    this.phone,
    this.phoneVerified = false,
    this.email,
    this.emailVerified = false,
    this.onSendPhoneCode,
    this.onVerifyPhoneCode,
    this.onSendEmailCode,
    this.onVerifyEmailCode,
    this.showBottomNav = true,
  });

  /// Phone already on the account (10 digits, with or without +91).
  final String? phone;
  final bool phoneVerified;

  /// Email already on the account, if any.
  final String? email;
  final bool emailVerified;

  /// Send a 6-digit code to the 10-digit [phone]. Return true if sent.
  /// TODO: call your API.
  final Future<bool> Function(String phone)? onSendPhoneCode;

  /// Check the phone code. Return true if correct. TODO: call your API.
  final Future<bool> Function(String phone, String code)? onVerifyPhoneCode;

  /// Send a 6-digit code to [email]. Return true if sent. TODO: call your API.
  final Future<bool> Function(String email)? onSendEmailCode;

  /// Check the email code. Return true if correct. TODO: call your API.
  final Future<bool> Function(String email, String code)? onVerifyEmailCode;
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
            stops: [0, 0.4],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SearchTopBar(title: 'Verify your profile'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    const InfoHero(
                      title: 'Verify your profile',
                      body:
                          'Your safety is our priority. To ensure a secure & positive experience, please follow these guidelines.',
                      icon: Icons.verified_rounded,
                      iconName: 'verify_profile',
                    ),
                    const SizedBox(height: 14),
                    _ChannelVerifier(
                      key: const ValueKey('phone'),
                      isPhone: true,
                      initialValue: phone,
                      initiallyVerified: phoneVerified,
                      onSend: onSendPhoneCode,
                      onVerify: onVerifyPhoneCode,
                    ),
                    const SizedBox(height: 14),
                    _ChannelVerifier(
                      key: const ValueKey('email'),
                      isPhone: false,
                      initialValue: email,
                      initiallyVerified: emailVerified,
                      onSend: onSendEmailCode,
                      onVerify: onVerifyEmailCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Step { enter, code, done }

/// One verification flow (phone or email) with its own state, timer and code.
class _ChannelVerifier extends StatefulWidget {
  const _ChannelVerifier({
    super.key,
    required this.isPhone,
    required this.initialValue,
    required this.initiallyVerified,
    required this.onSend,
    required this.onVerify,
  });

  final bool isPhone;
  final String? initialValue;
  final bool initiallyVerified;
  final Future<bool> Function(String value)? onSend;
  final Future<bool> Function(String value, String code)? onVerify;

  @override
  State<_ChannelVerifier> createState() => _ChannelVerifierState();
}

class _ChannelVerifierState extends State<_ChannelVerifier> {
  static const _resendSeconds = 30;

  late _Step _step =
      widget.initiallyVerified ? _Step.done : _Step.enter;
  late final TextEditingController _valueCtrl =
      TextEditingController(text: _initialText());
  final _codeCtrl = TextEditingController();
  String? _valueError;
  String? _codeError;
  bool _busy = false;
  int _wait = 0;
  Timer? _timer;

  bool get _isPhone => widget.isPhone;

  String _initialText() {
    final v = widget.initialValue ?? '';
    if (!_isPhone) return v;
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10 ? digits.substring(digits.length - 10) : '';
  }

  String get _value => _valueCtrl.text.trim();
  String get _display => _isPhone ? '+91 $_value' : _value;

  @override
  void dispose() {
    _timer?.cancel();
    _valueCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  bool _valid(String v) => _isPhone
      ? RegExp(r'^[6-9]\d{9}$').hasMatch(v)
      : RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  void _startTimer() {
    _timer?.cancel();
    setState(() => _wait = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _wait--);
      if (_wait <= 0) t.cancel();
    });
  }

  Future<void> _sendCode() async {
    final v = _value;
    if (!_valid(v)) {
      setState(() => _valueError =
          _isPhone ? 'Enter a valid 10-digit mobile number' : 'Enter a valid email address');
      return;
    }
    setState(() {
      _valueError = null;
      _busy = true;
    });
    try {
      final ok = await (widget.onSend?.call(v) ??
          Future.value(true)); // TODO: remove default once API is connected
      if (!mounted) return;
      if (ok) {
        setState(() {
          _step = _Step.code;
          _codeCtrl.clear();
          _codeError = null;
        });
        _startTimer();
      } else {
        setState(() => _valueError = "Couldn't send the code. Try again.");
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _codeError = 'Enter the 6-digit code');
      return;
    }
    setState(() {
      _codeError = null;
      _busy = true;
    });
    try {
      final ok = await (widget.onVerify?.call(_value, code) ??
          Future.value(true)); // TODO: remove default once API is connected
      if (!mounted) return;
      if (ok) {
        _timer?.cancel();
        setState(() => _step = _Step.done);
      } else {
        setState(
            () => _codeError = "That code isn't right. Check and try again.");
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconName = _isPhone ? 'call' : 'email';

    switch (_step) {
      // ── Already verified: no field, no button ──────────────────────────
      case _Step.done:
        return _Card(
          icon: _isPhone
              ? Icons.phone_iphone_rounded
              : Icons.mark_email_read_outlined,
          iconName: iconName,
          accent: AppColors.verified,
          title: _isPhone ? 'Phone Number Verified' : 'Email Verified',
          subtitle: _isPhone
              ? 'Your mobile number has been verified'
              : 'Your email address has been verified',
          status: _Status.verified,
          child: _ValueBox(
            icon: _isPhone ? Icons.call_outlined : Icons.mail_outline_rounded,
            iconName: iconName,
            text: _display,
            trailing: matchIcon(Icons.check_circle_rounded, 'verified',
                size: 20, color: AppColors.verified),
          ),
        );

      // ── Enter phone / email + Send Code ────────────────────────────────
      case _Step.enter:
        return _Card(
          icon: _isPhone ? Icons.phone_iphone_rounded : Icons.mail_outline_rounded,
          iconName: iconName,
          accent: _isPhone ? AppColors.brown : AppColors.link,
          title: _isPhone ? 'Phone Verification' : 'Email Verification',
          subtitle: _isPhone
              ? 'Verify your number by entering the code we send via SMS.'
              : 'Verify your email ID by entering the code we send to your email.',
          status: _Status.pending,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _valueCtrl,
                keyboardType: _isPhone
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                autocorrect: false,
                maxLength: _isPhone ? 10 : null,
                inputFormatters: _isPhone
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendCode(),
                style: const TextStyle(fontSize: 14, color: AppColors.navy),
                decoration: searchInputDecoration(
                        _isPhone ? 'Enter your mobile number' : 'Enter your email ID')
                    .copyWith(
                  counterText: '',
                  errorText: _valueError,
                  prefixText: _isPhone ? '+91  ' : null,
                  prefixStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PillButton(
                label: _busy ? 'Sending…' : 'Send Code',
                icon: matchIcon(Icons.send_rounded, 'send',
                    size: 16, color: Colors.white),
                foreground: Colors.white,
                gradient: kTealGradient,
                onTap: _busy ? null : _sendCode,
              ),
            ],
          ),
        );

      // ── Enter 6-digit code ─────────────────────────────────────────────
      case _Step.code:
        return _Card(
          icon: _isPhone ? Icons.sms_outlined : Icons.mail_lock_outlined,
          iconName: iconName,
          accent: _isPhone ? AppColors.brown : AppColors.link,
          title: 'Enter verification code',
          subtitle: 'We sent a 6-digit code to',
          status: _Status.pending,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ValueBox(
                icon: _isPhone
                    ? Icons.call_outlined
                    : Icons.mail_outline_rounded,
                iconName: iconName,
                text: _display,
                trailing: TextButton(
                  onPressed: () {
                    _timer?.cancel();
                    setState(() {
                      _step = _Step.enter;
                      _wait = 0;
                    });
                  },
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.tealMid),
                  child: const Text('Change',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _codeCtrl,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) {
                  if (v.length == 6) _verify();
                },
                style: const TextStyle(
                  fontSize: 22,
                  letterSpacing: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
                decoration: searchInputDecoration('• • • • • •').copyWith(
                  counterText: '',
                  errorText: _codeError,
                  hintStyle: const TextStyle(
                      fontSize: 18, letterSpacing: 8, color: AppColors.hint),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Never share this code with anyone.',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                  TextButton(
                    onPressed: _wait > 0 || _busy ? null : _sendCode,
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.tealMid),
                    child: Text(
                      _wait > 0
                          ? 'Resend in 00:${_wait.toString().padLeft(2, '0')}'
                          : 'Resend code',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              PillButton(
                label: _busy ? 'Verifying…' : 'Verify',
                icon: matchIcon(Icons.check_rounded, 'check',
                    size: 18, color: Colors.white),
                foreground: Colors.white,
                gradient: kTealGradient,
                onTap: _busy ? null : _verify,
              ),
            ],
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
enum _Status { verified, pending }

class _Card extends StatelessWidget {
  const _Card({
    required this.icon,
    required this.iconName,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.child,
  });

  final IconData icon;
  final String iconName;
  final Color accent;
  final String title;
  final String subtitle;
  final _Status status;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ok = status == _Status.verified;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            ok ? const Color(0xFFEAF5EF) : AppColors.blueTint,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: matchIcon(icon, iconName, size: 21, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ok
                      ? AppColors.verified.withValues(alpha: 0.12)
                      : AppColors.toggleBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  ok ? 'Verified' : 'Not verified',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ok ? AppColors.verified : AppColors.goldDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ValueBox extends StatelessWidget {
  const _ValueBox({
    required this.icon,
    required this.iconName,
    required this.text,
    this.trailing,
  });
  final IconData icon;
  final String iconName;
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.only(left: 14, right: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          matchIcon(icon, iconName, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}