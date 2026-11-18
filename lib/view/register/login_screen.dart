import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/services/service_config.dart';
import 'package:vivahbharath_app/services/validation_helper.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/forgot_password/forgot_password_screen.dart';
import 'package:vivahbharath_app/view/register/register_screen.dart';
import 'package:vivahbharath_app/view/register/sign_in_verify_otp_screen.dart';
import 'package:vivahbharath_app/view/register/sign_upverify_otp_screen.dart';

enum _LoginMode { otp, password }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _idCtrl = TextEditingController(); // phone number / email
  final _passCtrl = TextEditingController();
  _LoginMode _mode = _LoginMode.otp;
  bool _hidePass = true;
  bool _busy = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _setMode(_LoginMode m) {
    if (_mode == m) return;
    FocusScope.of(context).unfocus();
    setState(() => _mode = m);
  }

  Future<void> _onSendOtp() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    final phone = _phoneCtrl.text.trim();
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      return showMsg('Please provide a valid 10-digit mobile number');
    }

    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    // login_type 1 = OTP: the API sends an OTP to this number
    final ok = await rp.signIn(phone, LoginType.otp);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(rp.signInError ?? 'Could not send OTP. Please try again');
    }
    if (rp.signInModel?.message != null) showMsg(rp.signInModel!.message!);

    final masked =
        '+91 ${phone.substring(0, 2)}••••••${phone.substring(phone.length - 2)}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SignInVerifyCodeScreen(mobile: phone, maskedPhone: masked),
      ),
    );
  }

  Future<void> _onProceed() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    final id = _idCtrl.text.trim();
    final pass = _passCtrl.text;
    final isPhone = RegExp(r'^\d{10}$').hasMatch(id);
    final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(id);

    if (!isPhone && !isEmail) {
      return showMsg('Enter a valid email or 10-digit mobile number');
    }
    if (pass.isEmpty) return showMsg('Please enter your password');

    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    // login_type 2 = password: the API returns the token directly
    final ok = await rp.signIn(id, LoginType.password, password: pass);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(rp.signInError ?? 'Login failed. Please try again');
    }
    if (rp.signInModel?.message != null) showMsg(rp.signInModel!.message!);
    await routeAfterSignIn(
      context,
      registrationCompleted: rp.signInModel?.data?.registrationCompleted ?? false,
      isApproved: rp.signInModel?.data?.isApproved,
      subscriptionChosen: rp.signInModel?.data?.subscriptionChosen,
    );
  }

  void _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  void _onRegister() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final side = contentSidePadding(context);
    final isOtp = _mode == _LoginMode.otp;
    return BusyOverlay(
      busy: _busy,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: _Hero()),
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
                        'Welcome back',
                        style: GoogleFonts.fraunces(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.headline,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Log in to continue finding your match.',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          height: 1.5,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ModeToggle(mode: _mode, onChanged: _setMode),
                      const SizedBox(height: 24),
                      if (isOtp) ...[
                        const _Label('Phone Number'),
                        _PhoneField(controller: _phoneCtrl),
                        const SizedBox(height: 10),
                        Text(
                          "We'll send a 6-digit code to this number.",
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.body,
                          ),
                        ),
                      ] else ...[
                        const _Label('Phone Number / Email'),
                        _Field(
                          controller: _idCtrl,
                          hint: 'you@example.com or 10-digit number',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        const _Label('Password'),
                        _Field(
                          controller: _passCtrl,
                          hint: 'Enter your password',
                          obscureText: _hidePass,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _hidePass = !_hidePass),
                            child: Icon(
                              _hidePass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.body,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _onForgotPassword,
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.link,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.link,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      const SizedBox(height: 24),
                      _PrimaryButton(
                        label: isOtp ? 'Send OTP' : 'Proceed',
                        onTap: isOtp ? _onSendOtp : _onProceed,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Not a member? ',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: AppColors.body,
                              ),
                            ),
                            GestureDetector(
                              onTap: _onRegister,
                              child: Text(
                                'Register free',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.link,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.link,
                                ),
                              ),
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

/* ───────────────────────── HERO ───────────────────────── */

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final top = mq.padding.top;
    // 215 on a typical phone; shorter in landscape, a bit taller on tablets.
    final h = (mq.size.height * 0.255).clamp(150.0, 260.0);
    final k = h / 215;
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: h + top,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
          ),
        ),
        child: Stack(
          children: [
            // soft glow top-right
            Positioned(
              right: -40,
              top: top + 10 * k,
              child: Container(
                width: 220 * k,
                height: 220 * k,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.glow, AppColors.glowEnd],
                  ),
                ),
              ),
            ),
            // hearts
            Positioned(
              top: top + 66 * k,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/hearts_illustration_transparent.png',
                  width: 156 * k,
                ),
              ),
            ),
            // logo
            Positioned(
              top: top + 14 * k,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-mark-gold@3x.png',
                    height: 25 * k,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'vivahbharath',
                        style: GoogleFonts.fraunces(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.sparkleGold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path()..lineTo(0, size.height - 22);
    p.cubicTo(
      size.width * 0.18,
      size.height - 40,
      size.width * 0.38,
      size.height - 6,
      size.width * 0.58,
      size.height - 14,
    );
    p.cubicTo(
      size.width * 0.78,
      size.height - 22,
      size.width * 0.9,
      size.height - 44,
      size.width,
      size.height - 34,
    );
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

/* ───────────────────────── FORM PARTS ───────────────────────── */

class _ModeToggle extends StatelessWidget {
  final _LoginMode mode;
  final ValueChanged<_LoginMode> onChanged;
  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFFF1E6D3),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        _seg('Login with OTP', _LoginMode.otp),
        _seg('Login with Password', _LoginMode.password),
      ],
    ),
  );

  Widget _seg(String label, _LoginMode m) {
    final selected = mode == m;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(m),
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
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text.rich(
      TextSpan(
        text: text,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      style: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.body,
      ),
    ),
  );
}

BoxDecoration _fieldBox() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  border: Border.all(color: AppColors.fieldBorder, width: 1.5),
);

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  const _Field({
    required this.controller,
    required this.hint,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: _fieldBox(),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            style: GoogleFonts.dmSans(fontSize: 17, color: AppColors.headline),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.dmSans(
                fontSize: 17,
                color: AppColors.hint,
              ),
            ),
          ),
        ),
        if (suffix != null) ...[const SizedBox(width: 10), suffix!],
      ],
    ),
  );
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: _fieldBox(),
    child: Row(
      children: [
        Text(
          '+91',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.headline,
          ),
        ),
        Container(
          width: 1.5,
          height: 26,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          color: AppColors.fieldBorder,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            style: GoogleFonts.dmSans(fontSize: 17, color: AppColors.headline),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: '10-digit mobile number',
              hintStyle: GoogleFonts.dmSans(
                fontSize: 17,
                color: AppColors.hint,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 62,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.btnA, AppColors.tealC],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealC.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
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
  );
}
