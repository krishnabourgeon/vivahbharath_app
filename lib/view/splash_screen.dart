import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/services/shared_preference_helper.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/dashboard_shell.dart';
import 'package:vivahbharath_app/view/drawer/subscription_screen.dart';
import 'package:vivahbharath_app/view/onboarding_screen.dart';
import 'package:vivahbharath_app/view/register/basic_info_screen.dart';
import 'package:vivahbharath_app/view/register/profile_under_review_screen.dart';

/// First screen of the app. Plays a short brand animation while it works
/// out where the member belongs:
///
/// * no saved token                     → Welcome (sign up / log in)
/// * token, registration not finished   → resume registration
/// * token, registered, no package yet  → choose a subscription
/// * token, registered, package chosen  → Dashboard
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.minDuration = const Duration(milliseconds: 2400),
  });

  /// The animation always plays at least this long.
  final Duration minDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final _garland = CurvedAnimation(
      parent: _intro, curve: const Interval(0, 0.5, curve: Curves.easeOutBack));
  late final _hearts = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.15, 0.7, curve: Curves.easeOutBack));
  late final _title = CurvedAnimation(
      parent: _intro, curve: const Interval(0.45, 0.85, curve: Curves.easeOut));
  late final _tagline = CurvedAnimation(
      parent: _intro, curve: const Interval(0.6, 1, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final results = await Future.wait([
      _resolveNext(),
      Future.delayed(widget.minDuration),
    ]);
    if (!mounted) return;
    final next = results.first as Widget;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => next,
        transitionsBuilder: (_, a, _, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  Future<Widget> _resolveNext() async {
    try {
      final token = await SharedPreferenceHelper.getToken();
      if (token.isEmpty) return const WelcomeScreen();
      if (!await SharedPreferenceHelper.isRegistrationComplete()) {
        return BasicInfoScreen();
      }
      // Still waiting for admin approval (saved at the last sign in).
      if (!await SharedPreferenceHelper.isApproved()) {
        return const ProfileUnderReviewScreen();
      }
      return await resolveSubscriptionChosen()
          ? const DashboardShell()
          : const SubscriptionScreen(flow: SubscriptionFlow.afterLogin);
    } catch (e) {
      debugPrint('splash routing: $e');
      return const WelcomeScreen();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heartsW = math.min(size.width * 0.62, 300.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.tealC,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background: teal gradient with a warm glow in the middle.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.12),
                  radius: 0.75,
                  colors: [AppColors.glow, AppColors.glowEnd],
                ),
              ),
            ),

            // Marigold garland drops in from the top.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _garland,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, -90 * (1 - _garland.value)),
                  child: child,
                ),
                child: Image.asset(
                  'assets/images/marigold-garland.png',
                  width: size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // Centre: hearts + wordmark + tagline.
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge([_hearts, _float]),
                        builder: (_, child) => Opacity(
                          opacity: _hearts.value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(
                                0, math.sin(_float.value * math.pi) * -8),
                            child: Transform.scale(
                              scale: 0.6 + 0.4 * _hearts.value,
                              child: child,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: heartsW,
                          height: heartsW * 600 / 640,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                  'assets/images/part-flowers-sparkles@2x.png',
                                  fit: BoxFit.contain),
                              Image.asset(
                                  'assets/images/two-hearts-thread@2x.png',
                                  fit: BoxFit.contain),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _FadeUp(
                        animation: _title,
                        child: Text(
                          'vivahbharath',
                          style: GoogleFonts.fraunces(
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.sparkleGold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _FadeUp(
                        animation: _tagline,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _line(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.favorite_rounded,
                                      size: 12, color: AppColors.marigoldO),
                                ),
                                _line(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'Your '),
                                  TextSpan(
                                    text: 'forever',
                                    style: GoogleFonts.fraunces(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.marigoldY,
                                    ),
                                  ),
                                  const TextSpan(text: ' begins here'),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: AppColors.sparkleCream,
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

            // Bottom: loading dots + trust line.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: _FadeUp(
                    animation: _tagline,
                    child: Column(
                      children: [
                        _LoadingDots(animation: _float),
                        const SizedBox(height: 14),
                        Text(
                          'Trusted matches for Indian families',
                          style: GoogleFonts.dmSans(
                            fontSize: 12.5,
                            letterSpacing: 0.3,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line() => Container(
        width: 40,
        height: 1,
        color: AppColors.sparkleGold.withValues(alpha: 0.6),
      );
}

class _FadeUp extends StatelessWidget {
  const _FadeUp({required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (_, c) => Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - animation.value)),
            child: c,
          ),
        ),
        child: child,
      );
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (_, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Each dot pulses a little after the previous one.
            final t = (math.sin((animation.value * 2 - i * 0.3) * math.pi) + 1) / 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  AppColors.sparkleGold.withValues(alpha: 0.35),
                  AppColors.marigoldY,
                  t,
                ),
              ),
            );
          }),
        ),
      );
}
