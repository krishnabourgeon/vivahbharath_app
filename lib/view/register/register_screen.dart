import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/services/validation_helper.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/register/sign_upverify_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _profileFor = 'Select an option';
  String? _motherTongue = 'Select an option';
  bool _busy = false;

  // Dropdown options now come from the API (created-fors, languages).
  List<Opt> _profileOptions = [];
  List<Opt> _languages = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_loadOptions);
  }

  Future<void> _loadOptions() async {
    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    await Future.wait([rp.createdFors(), rp.motherTongue()]);
    if (!mounted) return;
    setState(() {
      _profileOptions = (rp.createdForModel?.createdFors ?? [])
          .map((e) => Opt(e.id, e.name))
          .toList();
      _languages = (rp.motherTongueModel?.languages ?? [])
          .map((e) => Opt(e.id, e.name))
          .toList();
      // keep the original defaults when the API has them
      _profileFor = _profileOptions.match(_profileFor);
      _motherTongue = _languages.match(_motherTongue);
      _busy = false;
    });
    if (_profileOptions.isEmpty || _languages.isEmpty) {
      showMsg('Could not load the form options. Please check your connection.');
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _onProceed() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final createdForId = _profileOptions.idOf(_profileFor);
    final tongueId = _languages.idOf(_motherTongue);

    final nameErr = ValidationHelperClass.validateName(name);
    if (nameErr != null) return showMsg(nameErr);
    if (createdForId == null)
      return showMsg('Please select who the profile is for');
    if (tongueId == null) return showMsg('Please select the mother tongue');
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      return showMsg('Please provide a valid 10-digit mobile number');
    }

    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    final ok = await rp.signup(createdForId, name, tongueId, phone);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(rp.signupError ?? 'Signup failed. Please try again');
    }
    if (rp.signupModel?.message != null) showMsg(rp.signupModel!.message!);

    final masked =
        '+91 ${phone.substring(0, 2)}••••••${phone.substring(phone.length - 2)}';
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SignUpVerifyCodeScreen(mobile: phone, maskedPhone: masked),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hero, form and buttons scroll together, so nothing overflows on short
    // screens, in landscape or with the keyboard open. When there's spare
    // height the buttons still sit at the bottom of the screen.
    final side = contentSidePadding(context);
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
                        'Register',
                        style: GoogleFonts.fraunces(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.headline,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Let's get started. Tell us a little about the "
                        "profile you're creating.",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          height: 1.5,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _Label("Bride's/Groom's Name"),
                      _Field(
                        controller: _nameCtrl,
                        hint: 'Full name',
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 20),
                      const _Label('Create Profile For'),
                      _Dropdown(
                        value: _profileOptions.valid(_profileFor),
                        items: _profileOptions.names,
                        hint: 'Select an option',
                        onChanged: (v) => setState(() => _profileFor = v),
                      ),
                      const SizedBox(height: 20),
                      const _Label('Mother Tongue'),
                      _Dropdown(
                        value: _languages.valid(_motherTongue),
                        items: _languages.names,
                        hint: 'Select an option',
                        onChanged: (v) => setState(() => _motherTongue = v),
                      ),
                      const SizedBox(height: 20),
                      const _Label('Phone Number'),
                      _PhoneField(controller: _phoneCtrl),
                      const Spacer(),
                      const SizedBox(height: 24),
                      _PrimaryButton(label: 'Proceed', onTap: _onProceed),
                      const SizedBox(height: 14),
                      // full width, so WrapAlignment.center can centre it
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Already a member? ',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: AppColors.body,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Text(
                                'Login',
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
            // thread
            // Positioned(
            //   top: top + 68,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: Image.asset(
            //       'assets/images/part-thread.png',
            //       width: 180,
            //     ),
            //   ),
            // ),
            // logo
            Positioned(
              top: top + 14 * k,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(Icons.format_line_spacing,
                  //     size: 0), // placeholder to keep Row baseline
                  // Transform.rotate(
                  //   angle: 0.8,
                  //   child: Column(
                  //     children: List.generate(
                  //       4,
                  //       (_) => Container(
                  //         width: 22,
                  //         height: 2,
                  //         margin: const EdgeInsets.symmetric(vertical: 1.5),
                  //         color: AppColors.sparkleGold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),
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
            // step dots
            // Positioned(
            //   top: top + 58,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       _dot(26, AppColors.sparkleGold),
            //       const SizedBox(width: 6),
            //       _dot(8, Colors.white38),
            //       const SizedBox(width: 6),
            //       _dot(8, Colors.white38),
            //     ],
            //   ),
            // ),
            // back button
            // Positioned(
            //   top: top + 8,
            //   left: 18,
            //   child: GestureDetector(
            //     onTap: () => Navigator.maybePop(context),
            //     child: Container(
            //       width: 46,
            //       height: 46,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Colors.white.withOpacity(0.16),
            //         border: Border.all(color: Colors.white38),
            //       ),
            //       child: const Icon(Icons.chevron_left,
            //           color: Colors.white, size: 28),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _dot(double w, Color c) => Container(
    width: w,
    height: 8,
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
  );
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
  const _Field({
    required this.controller,
    required this.hint,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: _fieldBox(),
    child: TextField(
      controller: controller,
      textCapitalization: textCapitalization,
      style: GoogleFonts.dmSans(fontSize: 17, color: AppColors.headline),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(fontSize: 17, color: AppColors.hint),
      ),
    ),
  );
}

class _Dropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;
  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: _fieldBox(),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
        dropdownColor: Colors.white,
        hint: Text(hint!),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.body,
        ),
        style: GoogleFonts.dmSans(fontSize: 17, color: AppColors.headline),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
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
