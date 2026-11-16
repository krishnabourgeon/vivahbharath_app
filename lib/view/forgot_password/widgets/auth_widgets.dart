import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';

/* ───────────────────────── HERO ───────────────────────── */

class AuthHero extends StatelessWidget {
  /// 0..2 highlights that step dot. null hides the dots.
  final int? step;
  final bool showBack;
  const AuthHero({super.key, this.step, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final top = mq.padding.top;
    final h = (mq.size.height * 0.255).clamp(150.0, 260.0);
    final k = h / 215;
    return ClipPath(
      clipper: AuthWaveClipper(),
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
            Positioned(
              top: top + (step == null ? 66 : 76) * k,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/hearts_illustration_transparent.png',
                  width: (step == null ? 156 : 140) * k,
                ),
              ),
            ),
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
            if (step != null)
              Positioned(
                top: top + 52 * k,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final active = i == step;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: active ? 26 : 8,
                      height: 8,
                      margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: active ? AppColors.sparkleGold : Colors.white38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
              ),
            if (showBack)
              Positioned(
                top: top + 8,
                left: 18,
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.16),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
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

class AuthWaveClipper extends CustomClipper<Path> {
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

/* ───────────────────────── TEXT ───────────────────────── */

class AuthTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.headline,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        subtitle,
        style: GoogleFonts.dmSans(
          fontSize: 16,
          height: 1.5,
          color: AppColors.body,
        ),
      ),
    ],
  );
}

class AuthLabel extends StatelessWidget {
  final String text;
  const AuthLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.body,
      ),
    ),
  );
}

class AuthLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double size;
  const AuthLink(this.text, {super.key, this.onTap, this.size = 15});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: onTap == null ? AppColors.hint : AppColors.link,
        decoration: TextDecoration.underline,
        decorationColor: onTap == null ? AppColors.hint : AppColors.link,
      ),
    ),
  );
}

/* ───────────────────────── FIELDS ───────────────────────── */

BoxDecoration authFieldBox() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  border: Border.all(color: AppColors.fieldBorder, width: 1.5),
);

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: authFieldBox(),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
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

class AuthPhoneField extends StatelessWidget {
  final TextEditingController controller;
  const AuthPhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: authFieldBox(),
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

/* ───────────────────────── BUTTON ───────────────────────── */

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AuthPrimaryButton({super.key, required this.label, required this.onTap});

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