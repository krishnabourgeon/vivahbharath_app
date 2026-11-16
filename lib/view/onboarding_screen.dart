import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/dashboard/dashboard_shell.dart';
import 'package:vivahbharath_app/view/register/login_screen.dart';
import 'package:vivahbharath_app/view/register/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, this.onLogIn});

  //final VoidCallback? onSignUp;
  final VoidCallback? onLogIn;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Short / landscape screens keep a usable hero; tall screens and
    // tablets are capped so the buttons stay close to the fold.
    final heroH = (size.height * 0.55).clamp(300.0, 480.0);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Column(
            children: [
              _Hero(height: heroH, floatAnim: _float),
              SafeArea(
                top: false,
                bottom: false,
                child: MaxWidthBox(
                  maxWidth: 480,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Your '),
                              TextSpan(
                                text: 'forever',
                                style: GoogleFonts.fraunces(
                                  fontSize: 31,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.forever,
                                ),
                              ),
                              const TextSpan(text: '\nbegins here'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fraunces(
                            fontSize: 31,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headline,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Meet someone who shares your values,\nyour family's warmth and your dreams for\nthe years ahead.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            height: 1.55,
                            color: AppColors.body,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/images/heart-divider.png',
                          width: 112,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        _SignUpButton(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _LogInButton(onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardShell()
                                //LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },),
                        const SizedBox(height: 18),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.dmSans(
                              fontSize: 12.5,
                              color: AppColors.body,
                            ),
                            children: [
                              const TextSpan(
                                text: 'By continuing, you agree to our ',
                              ),
                              TextSpan(
                                text: 'Terms',
                                style: const TextStyle(
                                  color: AppColors.link,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: AppColors.link,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20 + MediaQuery.of(context).padding.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── HERO ─────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.height, required this.floatAnim});

  final double height;
  final Animation<double> floatAnim;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final topInset = MediaQuery.of(context).padding.top;

    return ClipPath(
      clipper: _WaveClipper(),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: [
            // Teal gradient
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
                  ),
                ),
              ),
            ),
            // Warm glow behind illustration
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 0.12),
                    radius: 0.62,
                    colors: const [AppColors.glow, AppColors.glowEnd],
                  ),
                ),
              ),
            ),
            // Falling petals
            Positioned.fill(child: CustomPaint(painter: _PetalPainter())),
            // Garland
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              height: 90,
              child: CustomPaint(painter: _GarlandPainter()),
            ),
            // Logo
            Positioned(
              top: 90 + (topInset > 24 ? 0 : 0),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-mark-gold@3x.png',
                    height: 25,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Image.asset(
                      'assets/images/logo_wordmark_welcome.png',
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // Hearts + thread illustration (gentle float)
            // top + bottom bound the image so it shrinks on short screens
            Positioned(
              left: 0,
              right: 0,
              top: height * 0.27,
              bottom: height * 0.05,
              // child: AnimatedBuilder(
              //   animation: floatAnim,
              //   builder: (_, child) => Transform.translate(
              //     offset: Offset(0, -6 * Curves.easeInOut.transform(floatAnim.value)),
              //     child: child,
              //   ),
              child: Center(
                child: Image.asset(
                  'assets/images/two-hearts-thread@2x.png',
                  width: math.min(w * 0.82, 460),
                  fit: BoxFit.contain,
                ),
              ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft wave at the bottom of the hero.
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final w = s.width, h = s.height;
    final p = Path()
      ..lineTo(0, h * 0.992)
      ..cubicTo(w * 0.10, h * 0.965, w * 0.22, h * 0.965, w * 0.38, h * 0.992)
      ..cubicTo(w * 0.55, h * 1.02, w * 0.72, h * 0.93, w * 0.80, h * 0.935)
      ..cubicTo(w * 0.90, h * 0.94, w * 0.96, h * 0.955, w, h * 0.972)
      ..lineTo(w, 0)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

// ───────────────────────── PAINTERS ─────────────────────────

class _GarlandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    // Main swag: y = base + sag * sin(pi * t)
    double swagY(double x) => 12 + 22 * math.sin(math.pi * (x / w));

    // String
    final string = Paint()
      ..color = const Color(0xFFC9B58A)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0, swagY(0));
    for (double x = 0; x <= w; x += 4) {
      path.lineTo(x, swagY(x));
    }
    canvas.drawPath(path, string);

    // Beads along the swag
    const step = 20.0;
    int i = 0;
    for (double x = 4; x < w; x += step, i++) {
      final y = swagY(x);
      if (i.isOdd) {
        _leaf(canvas, Offset(x, y + 1), 5);
      } else {
        _marigold(canvas, Offset(x, y), 9.5, i % 4 == 0);
      }
    }

    // Three hanging pendants
    for (final fx in [0.16, 0.5, 0.84]) {
      final x = w * fx;
      final y0 = swagY(x);
      final len = fx == 0.5 ? 3 : 3;
      for (int k = 0; k < len; k++) {
        final y = y0 + 16 + k * 13;
        if (k == len - 1) {
          _leaf(canvas, Offset(x, y + 2), 5.5, vertical: true);
        } else {
          _marigold(canvas, Offset(x, y), 7.5, k == 1);
        }
      }
    }
  }

  void _marigold(Canvas c, Offset o, double r, bool orange) {
    // soft shadow
    c.drawCircle(
      o.translate(0, 2),
      r,
      Paint()..color = const Color(0x33000000),
    );
    c.drawCircle(
      o,
      r,
      Paint()..color = orange ? AppColors.marigoldO : AppColors.marigoldY,
    );
  }

  void _leaf(Canvas c, Offset o, double r, {bool vertical = false}) {
    c.save();
    c.translate(o.dx, o.dy);
    c.rotate(vertical ? 0 : math.pi / 5);
    c.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 1.4),
      Paint()..color = AppColors.leaf,
    );
    c.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _PetalPainter extends CustomPainter {
  // x, y (fractions of hero), size, rotation, colour
  static const _petals = <List<Object>>[
    [0.24, 0.25, 8.0, 0.6, Color(0xFFD9C79A)],
    [0.77, 0.25, 8.0, 1.5, Color(0xFFE0B83C)],
    [0.10, 0.31, 9.0, -0.5, Color(0xFFE0B83C)],
    //[0.88, 0.33, 9.0, 0.4, Color(0xFFD9993A)],
    //[0.16, 0.60, 9.0, 0.5, Color(0xFFD9C79A)],
    [0.08, 0.90, 8.0, -0.4, Color(0xFFD9993A)],
    [0.91, 0.78, 9.0, 0.7, Color(0xFFD9C79A)],
    [0.50, 0.90, 9.0, 0.2, Color(0xFFD9993A)],
  ];

  // small round marigold blossoms
  static const _blossoms = <List<Object>>[
    //[0.24, 0.43, 6.0, Color(0xFFF2C14E)],
    [0.73, 0.40, 6.0, Color(0xFFF8D0D6)],
    //[0.30, 0.72, 6.0, Color(0xFFFFF1C9)],
    [0.76, 0.72, 6.5, Color(0xFFF2A33A)],
  ];

  // 4-point sparkles
  // static const _sparkles = <List<Object>>[
  //   //[0.24, 0.34, 11.0, AppColors.sparkleCream],
  //   [0.76, 0.32, 6.0, AppColors.sparkleCream],
  //   //[0.19, 0.58, 8.0, AppColors.sparkleGold],
  //   [0.81, 0.55, 8.0, AppColors.sparkleGold],
  // ];

  @override
  void paint(Canvas canvas, Size s) {
    for (final p in _petals) {
      final o = Offset(s.width * (p[0] as double), s.height * (p[1] as double));
      final r = p[2] as double;
      canvas.save();
      canvas.translate(o.dx, o.dy);
      canvas.rotate(p[3] as double);
      final path = Path()
        ..moveTo(0, -r)
        ..quadraticBezierTo(r * 0.9, -r * 0.4, r * 0.3, r)
        ..quadraticBezierTo(-r * 0.9, r * 0.5, 0, -r);
      canvas.drawPath(path, Paint()..color = p[4] as Color);
      canvas.restore();
    }

    // for (final b in _blossoms) {
    //   final o = Offset(s.width * (b[0] as double), s.height * (b[1] as double));
    //   final r = b[2] as double;
    //   canvas.drawCircle(o, r, Paint()..color = b[3] as Color);
    //   canvas.drawCircle(o, r * 0.32, Paint()..color = AppColors.marigoldCentre);
    // }

    // for (final sp in _sparkles) {
    //   final o = Offset(s.width * (sp[0] as double), s.height * (sp[1] as double));
    //   _sparkle(canvas, o, sp[2] as double, sp[3] as Color);
    // }
  }

  void _sparkle(Canvas c, Offset o, double r, Color color) {
    final k = r * 0.22;
    final path = Path()
      ..moveTo(o.dx, o.dy - r)
      ..quadraticBezierTo(o.dx + k, o.dy - k, o.dx + r, o.dy)
      ..quadraticBezierTo(o.dx + k, o.dy + k, o.dx, o.dy + r)
      ..quadraticBezierTo(o.dx - k, o.dy + k, o.dx - r, o.dy)
      ..quadraticBezierTo(o.dx - k, o.dy - k, o.dx, o.dy - r)
      ..close();
    c.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ───────────────────────── BUTTONS ─────────────────────────

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.btnA, AppColors.tealB, AppColors.tealC],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x401B6670),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(27),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign up free',
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.loginBorder,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogInButton extends StatelessWidget {
  const _LogInButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.loginA, AppColors.loginB],
        ),
        border: Border.all(color: AppColors.loginBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1FE7C9A1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(27),
          onTap: onTap,
          child: Center(
            child: Text(
              'Login',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.loginText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
