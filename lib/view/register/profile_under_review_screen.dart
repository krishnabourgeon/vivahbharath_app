import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/onboarding_screen.dart';

/// Shown once registration is submitted. After [delay] it moves on to the
/// welcome (onboarding) screen by itself.
class ProfileUnderReviewScreen extends StatefulWidget {
  const ProfileUnderReviewScreen({
    super.key,
    this.delay = const Duration(seconds: 10),
  });

  final Duration delay;

  @override
  State<ProfileUnderReviewScreen> createState() =>
      _ProfileUnderReviewScreenState();
}

class _ProfileUnderReviewScreenState extends State<ProfileUnderReviewScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, _goToWelcome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToWelcome() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Back is disabled: the only way on is the automatic move to Welcome.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: const MaxWidthBox(
                maxWidth: 480,
                child: ProfileUnderReviewCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileUnderReviewCard extends StatelessWidget {
  const ProfileUnderReviewCard({super.key});

  static const _coral = Color(0xFFF28B82);
  static const _softTeal = Color(0xFF2A7480);
  static const _mutedText = Color(0xFFDCEBEC);
  static const _pendingLine = Color(0xFF4D8A94);
  static const _pendingText = Color(0xFFA9CBD0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealC.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // hourglass
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _softTeal,
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: _coral,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Profile under review',
            textAlign: TextAlign.center,
            style: GoogleFonts.fraunces(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.sparkleGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Thanks for completing your profile! Our team is reviewing it "
            "now. You'll be able to view matches and subscribe to a plan "
            "once it's approved.",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              height: 1.55,
              color: _mutedText,
            ),
          ),
          const SizedBox(height: 22),
          const _Stepper(),
          const SizedBox(height: 18),
          // notify pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: _softTeal,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  size: 17,
                  color: AppColors.sparkleGold,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "We'll notify you as soon as it's approved",
                    style: GoogleFonts.dmSans(fontSize: 13, color: _mutedText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────── STEPPER ───────────────────────── */

class _Stepper extends StatelessWidget {
  const _Stepper();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: _Step(label: 'Submitted', state: _StepState.done)),
        _line(AppColors.sparkleGold),
        const Expanded(child: _Step(label: 'In review', state: _StepState.current)),
        _line(ProfileUnderReviewCard._pendingLine),
        const Expanded(child: _Step(label: 'Approved', state: _StepState.pending)),
      ],
    );
  }

  Widget _line(Color c) => Container(
    width: 28,
    height: 2,
    margin: const EdgeInsets.only(top: 14),
    color: c,
  );
}

enum _StepState { done, current, pending }

class _Step extends StatelessWidget {
  final String label;
  final _StepState state;
  const _Step({required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final Widget dot;
    Color textColor;
    FontWeight weight = FontWeight.w500;

    switch (state) {
      case _StepState.done:
        dot = Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.sparkleGold,
          ),
          child: const Icon(Icons.check_rounded, size: 18, color: AppColors.tealC),
        );
        textColor = AppColors.sparkleGold;
        break;
      case _StepState.current:
        dot = Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ProfileUnderReviewCard._coral,
            boxShadow: [
              BoxShadow(
                color: ProfileUnderReviewCard._coral.withOpacity(0.35),
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.schedule_rounded, size: 17, color: Colors.white),
        );
        textColor = Colors.white;
        weight = FontWeight.w700;
        break;
      case _StepState.pending:
        dot = Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8DB7BD), width: 1.5),
          ),
        );
        textColor = ProfileUnderReviewCard._pendingText;
        break;
    }

    return Column(
      children: [
        dot,
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 12.5,
            fontWeight: weight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}