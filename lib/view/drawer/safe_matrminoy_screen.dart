import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/trust_badge.dart';


class SafetySection {
  const SafetySection(this.title, this.icon, this.iconName, this.accent,
      this.tint, this.points);
  final String title;
  final IconData icon;
  final String iconName;
  final Color accent;
  final Color tint;
  final List<String> points;
}

const kSafetySections = [
  SafetySection(
    'Protect your personal information',
    Icons.lock_outline_rounded,
    'lock',
    AppColors.link,
    AppColors.blueTint,
    [
      "Don't share sensitive details such as your home address, phone number, financial details or work location until you are comfortable.",
      'Never send money or share bank details with anyone, even if the request seems urgent or emotional.',
      'Keep your contact number hidden and approve requests only from profiles you trust.',
    ],
  ),
  SafetySection(
    'Communication & verification',
    Icons.verified_user_outlined,
    'shield',
    AppColors.verified,
    Color(0xFFEAF5EF),
    [
      'Use Vivah Bharath chat for your first conversations. Avoid moving to personal numbers too soon.',
      'Look for the verified tick and Trust Badge on a profile before you share more.',
      'Have a video call with the person, and involve family early, before you meet.',
    ],
  ),
  SafetySection(
    'Meeting in person',
    Icons.location_on_outlined,
    'location',
    AppColors.brown,
    AppColors.cream,
    [
      'Meet in a busy public place for the first few times.',
      'Tell a family member or friend where you are going and who you are meeting.',
      'Arrange your own travel and keep your phone charged.',
    ],
  ),
  SafetySection(
    'Watch for warning signs',
    Icons.warning_amber_rounded,
    'warning',
    AppColors.coral,
    Color(0xFFFBF0EE),
    [
      'Asks for money, gifts, loans or help with “fees” or customs.',
      'Avoids video calls, or keeps changing their story, job or location.',
      'Pushes you to decide quickly or to keep the relationship secret from family.',
    ],
  ),
  SafetySection(
    'Report & block',
    Icons.flag_outlined,
    'flag',
    AppColors.purple,
    Color(0xFFF1EEF9),
    [
      'Report any profile that behaves suspiciously. Our team reviews every report.',
      "Block a member at any time. They won't be able to view your profile or contact you.",
      'If you feel unsafe, contact local police right away.',
    ],
  ),
];

class SafeMatrimonyScreen extends StatefulWidget {
  const SafeMatrimonyScreen({
    super.key,
    this.onReportProfile,
    this.onCallSupport,
    this.showBottomNav = true,
  });

  final VoidCallback? onReportProfile;
  final VoidCallback? onCallSupport;
  final bool showBottomNav;

  @override
  State<SafeMatrimonyScreen> createState() => _SafeMatrimonyScreenState();
}

class _SafeMatrimonyScreenState extends State<SafeMatrimonyScreen> {
  final Set<int> _open = {for (var i = 0; i < kSafetySections.length; i++) i};
  final _keys = [for (final _ in kSafetySections) GlobalKey()];

  void _jumpTo(int i) {
    setState(() => _open.add(i));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _keys[i].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            alignment: 0.05);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Quick tiles → section they open.
    final quick = <(IconData, String, String, int)>[
      (Icons.currency_rupee_rounded, 'rupee', 'Never send money', 0),
      (Icons.storefront_outlined, 'public', 'Meet in public', 2),
      (Icons.flag_outlined, 'flag', 'Report concerns', 4),
    ];

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
              const SearchTopBar(title: 'Safe Matrimony'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const InfoHero(
                        title: 'Safe Matrimony',
                        body:
                            'Your safety is our priority. Follow these guidelines for a secure and positive experience.',
                        icon: Icons.health_and_safety_outlined,
                        iconName: 'safe',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          for (var i = 0; i < quick.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            Expanded(
                              child: _QuickTile(
                                icon: quick[i].$1,
                                iconName: quick[i].$2,
                                label: quick[i].$3,
                                onTap: () => _jumpTo(quick[i].$4),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 14),
                      for (var i = 0; i < kSafetySections.length; i++) ...[
                        _SectionCard(
                          key: _keys[i],
                          section: kSafetySections[i],
                          open: _open.contains(i),
                          onToggle: () => setState(() =>
                              _open.contains(i) ? _open.remove(i) : _open.add(i)),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 4),
                      _ReportCard(
                        onReport: widget.onReportProfile ?? () {/* TODO */},
                        onCall: widget.onCallSupport ?? () {/* TODO */},
                      ),
                    ],
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

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.iconName,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String iconName;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.loginA,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.goldBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: matchIcon(icon, iconName,
                    size: 20, color: AppColors.goldDark),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    super.key,
    required this.section,
    required this.open,
    required this.onToggle,
  });

  final SafetySection section;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final s = section;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, s.tint],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: open,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: s.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: matchIcon(s.icon, s.iconName,
                          size: 20, color: s.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: matchIcon(Icons.keyboard_arrow_down_rounded,
                          'arrow_down',
                          size: 24, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      children: [
                        for (final p in s.points)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 1),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: s.accent, width: 1.5),
                                  ),
                                  child: Center(
                                    child: matchIcon(Icons.check_rounded,
                                        'check',
                                        size: 13, color: s.accent),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    p,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      height: 1.45,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.onReport, required this.onCall});
  final VoidCallback onReport;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.cream],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Something doesn't feel right?",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tell us. Reports are confidential and the member won't know who reported them.",
            style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  label: 'Report a profile',
                  icon: matchIcon(Icons.flag_outlined, 'flag',
                      size: 17, color: Colors.white),
                  foreground: Colors.white,
                  gradient: kTealGradient,
                  onTap: onReport,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PillButton(
                  label: 'Call support',
                  icon: matchIcon(Icons.call_outlined, 'call',
                      size: 17, color: AppColors.goldDark),
                  foreground: AppColors.goldDark,
                  gradient: const LinearGradient(
                      colors: [AppColors.loginA, AppColors.loginB]),
                  borderColor: AppColors.goldBorder,
                  onTap: onCall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}