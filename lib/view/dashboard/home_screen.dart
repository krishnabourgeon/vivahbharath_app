import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/app_icon.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/dashboard/home_drawer.dart';



const _avatarFemale = 'assets/images/avatar_female.png';
const _avatarMale = 'assets/images/avatar_male.png';

TextStyle _t(double size, FontWeight w, Color c, {double? height}) =>
    GoogleFonts.dmSans(fontSize: size, fontWeight: w, color: c, height: height);

/// Narrow phones (e.g. 320–359pt wide) get slightly smaller hero pieces.
bool _isNarrow(BuildContext context) => MediaQuery.sizeOf(context).width < 360;

/// Shown when an avatar image is missing.
Widget _avatarFallback(BuildContext _, Object _, StackTrace? _) =>
    const ColoredBox(color: AppColors.blueTint, child: Icon(Icons.person, size: 40, color: AppColors.navy));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final side = 16 + contentSidePadding(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      backgroundColor: AppColors.bgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom, AppColors.bgBottom],
            stops: [0, 0.25, 1],
          ),
        ),
        child: Column(
          children: [
            _TopPanel(onMenu: () => _scaffoldKey.currentState?.openDrawer()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(side, 16, side, 24),
                children: [
                  const _WelcomeCard(),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(child: _PillButton(icon: 'gift', label: 'Launch offer')),
                      SizedBox(width: 12),
                      Expanded(child: _PillButton(icon: 'crown', label: 'Upgrade')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _Recommendations(),
                  const SizedBox(height: 18),
                  const _SearchBar(),
                  const SizedBox(height: 22),
                  _SectionHeader(title: 'From your search', onSeeAll: () {}),
                  const SizedBox(height: 12),
                  const _FromYourSearch(),
                  const SizedBox(height: 22),
                  Text('Profile Activities', style: _t(20, FontWeight.w700, AppColors.navyDark)),
                  const SizedBox(height: 12),
                  const _ActivityGrid(items: _profileActivities),
                  const SizedBox(height: 22),
                  const _Highlighted(),
                  const SizedBox(height: 22),
                  Text('My Activities', style: _t(20, FontWeight.w700, AppColors.navyDark)),
                  const SizedBox(height: 12),
                  const _ActivityGrid(items: _myActivities),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Top bar ─────────────────────────

/// Soft white panel behind the top bar (runs up under the status bar),
/// with rounded bottom corners like the mockup.
class _TopPanel extends StatelessWidget {
  const _TopPanel({required this.onMenu});
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [BoxShadow(color: AppColors.navy.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: MaxWidthBox(child: _TopBar(onMenu: onMenu)),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onMenu});
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final circle = _isNarrow(context) ? 40.0 : 46.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          InkWell(
            onTap: onMenu,
            customBorder: const CircleBorder(),
            child: Container(
              width: circle,
              height: circle,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blueTintBorder),
              ),
              child: const Center(child: AppIcon('menu', size: 22, color: AppColors.navy)),
            ),
          ),
          const SizedBox(width: 12),
          // Gold mark tinted navy to match the dashboard header.
          Image.asset(
            'assets/images/logo-mark-gold@3x.png',
            height: 24,
            color: AppColors.navyDark,
            colorBlendMode: BlendMode.srcIn,
            errorBuilder: (_, _, _) => const SizedBox(),
          ),
          const SizedBox(width: 8),
          // Brand name shrinks rather than pushing the icons off-screen.
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'vivahbharath',
                maxLines: 1,
                style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navyDark),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _GoldCircleIcon(icon: 'chat', size: circle),
          const SizedBox(width: 10),
          _GoldCircleIcon(icon: 'bell', badge: 2, size: circle),
        ],
      ),
    );
  }
}

class _GoldCircleIcon extends StatelessWidget {
  const _GoldCircleIcon({required this.icon, required this.size, this.badge});
  final String icon;
  final double size;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 2,
      height: size + 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Center(child: AppIcon(icon, size: 22, color: AppColors.brown)),
          ),
          if (badge != null)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brown,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  // Fixed size: a badge must not grow with accessibility text.
                  textScaler: TextScaler.noScaling,
                  style: _t(11, FontWeight.w700, Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ───────────────────────── Welcome card ─────────────────────────

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final avatar = narrow ? 76.0 : 92.0;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealLight, AppColors.tealMid, AppColors.tealDark],
        ),
        boxShadow: [BoxShadow(color: AppColors.tealDark.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          // faint wave lines along the bottom
          const Positioned.fill(child: CustomPaint(painter: _CardWavePainter())),
          // crown badge, top-right
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.9),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
              ),
              child: const Center(child: AppIcon('crown', size: 17, color: AppColors.tealDark)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(narrow ? 14 : 18, 28, narrow ? 12 : 16, 28),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: avatar,
                      height: avatar,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.goldBorder, width: 3),
                        gradient: const LinearGradient(colors: [Color(0xFFE8A55F), Color(0xFFB8672F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                      child: Text('P', textScaler: TextScaler.noScaling, style: _t(avatar * 0.45, FontWeight.w700, Colors.white)),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(color: AppColors.tealMid, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Center(child: AppIcon('camera', size: 14, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: narrow ? 10 : 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome,', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(14, FontWeight.w500, AppColors.goldBorder)),
                      Text('Priyesh', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(22, FontWeight.w700, Colors.white)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const AppIcon('profile_id', size: 16, color: AppColors.goldBorder),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text('VBM26836413F', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w500, AppColors.goldBorder)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // Pushed down so it sits below the crown badge.
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: _ProfileRing(percent: 0.63, size: narrow ? 70 : 78),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Faint flowing lines across the bottom of the welcome card.
class _CardWavePainter extends CustomPainter {
  const _CardWavePainter();

  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withOpacity(0.10);
    for (var i = 0; i < 4; i++) {
      final y = s.height * (0.72 + i * 0.07);
      final path = Path()
        ..moveTo(0, y)
        ..cubicTo(s.width * 0.25, y - 22, s.width * 0.5, y + 18, s.width * 0.75, y - 8)
        ..cubicTo(s.width * 0.88, y - 20, s.width * 0.95, y - 10, s.width, y - 16);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _ProfileRing extends StatelessWidget {
  const _ProfileRing({required this.percent, required this.size});
  final double percent;

  /// Diameter of the progress ring.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 12,
      height: size + 12,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 5,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Must fit inside the ring, so it shrinks instead of overflowing.
          SizedBox(
            width: size - 16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Complete\nyour profile', textAlign: TextAlign.center, style: _t(11, FontWeight.w700, Colors.white, height: 1.2)),
            ),
          ),
          Positioned(
            top: -8,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.92), borderRadius: BorderRadius.circular(12)),
              child: Text('${(percent * 100).round()}%', textScaler: TextScaler.noScaling, style: _t(13, FontWeight.w800, AppColors.brown)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cream pill with gold border (Launch offer / Upgrade / Send Interest).
class _PillButton extends StatelessWidget {
  const _PillButton({required this.icon, required this.label, this.fontSize = 16, this.minHeight = 52});
  final String icon;
  final String label;
  final double fontSize;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(minHeight / 2),
        gradient: const LinearGradient(colors: [AppColors.loginA, AppColors.loginB]),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(icon, size: fontSize + 3, color: AppColors.loginText),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(fontSize, FontWeight.w700, AppColors.loginText)),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Shared bits ─────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.onSeeAll});
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _t(20, FontWeight.w700, AppColors.navyDark)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: _t(14, FontWeight.w400, AppColors.textMuted)),
              ],
            ],
          ),
        ),
        if (onSeeAll != null) _SeeAll(onTap: onSeeAll!),
      ],
    );
  }
}

class _SeeAll extends StatelessWidget {
  const _SeeAll({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('See all', style: _t(15, FontWeight.w700, AppColors.link)),
            const SizedBox(width: 2),
            const AppIcon('chevron_right', size: 18, color: AppColors.link),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrolling row whose height follows its children, so
/// cards never get clipped by a fixed-height list.
class _HScroll extends StatelessWidget {
  const _HScroll({required this.children, this.spacing = 12});
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final c in children) ...[c, SizedBox(width: spacing)],
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.female, this.verified = false, this.online = false, this.hasPhoto = false, this.premium = false});
  final bool female;
  final bool verified;
  final bool online;
  final bool hasPhoto;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    final width = _isNarrow(context) ? 175.0 : 195.0;
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: premium ? AppColors.gold : AppColors.blueTintBorder, width: premium ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            // Photo keeps its shape relative to the card width.
            child: AspectRatio(
              aspectRatio: 1.05,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(female ? _avatarFemale : _avatarMale, fit: BoxFit.cover, alignment: Alignment.topCenter, errorBuilder: _avatarFallback),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(color: premium ? AppColors.gold : Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: premium
                            ? const AppIcon('crown', size: 14, color: AppColors.tealDark)
                            : (verified ? const AppIcon('verified', size: 15, color: AppColors.verified) : const SizedBox()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: const Center(child: AppIcon('heart', size: 18, color: AppColors.navy)),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Row(
                      children: [
                        if (online) Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.online, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                        if (hasPhoto) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const AppIcon('camera', size: 12, color: AppColors.navy),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('[Name], [Age]', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(16, FontWeight.w700, AppColors.navyDark)),
          const SizedBox(height: 2),
          Text('[City] · [Profession]', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w400, AppColors.textMuted)),
          const SizedBox(height: 10),
          const _PillButton(icon: 'send', label: 'Send Interest', fontSize: 15, minHeight: 44),
        ],
      ),
    );
  }
}

// ───────────────────────── Recommendations ─────────────────────────

class _Recommendations extends StatelessWidget {
  const _Recommendations();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 0, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.blueTintBorder),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, AppColors.blueTint]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 12),
            child: _SectionHeader(title: 'Recommendations for you', subtitle: 'Based on your partner preferences', onSeeAll: () {}),
          ),
          const SizedBox(height: 12),
          const _HScroll(
            children: [
              _ProfileCard(female: true, verified: true, online: true, hasPhoto: true),
              _ProfileCard(female: false, verified: true, hasPhoto: true),
            ],
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Search ─────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: EdgeInsets.symmetric(horizontal: narrow ? 14 : 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Row(
        children: [
          const AppIcon('search', size: 22, color: AppColors.navy),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Search', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(17, FontWeight.w700, AppColors.navyDark)),
          ),
          const AppIcon('chevron_down', size: 20, color: AppColors.navy),
          SizedBox(width: narrow ? 8 : 12),
          Container(width: 1, height: 28, color: AppColors.blueTintBorder),
          SizedBox(width: narrow ? 10 : 14),
          const AppIcon('profile_id', size: 20, color: AppColors.hint),
          const SizedBox(width: 8),
          Flexible(
            child: Text('Profile ID search', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(15, FontWeight.w400, AppColors.hint)),
          ),
        ],
      ),
    );
  }
}

class _FromYourSearch extends StatelessWidget {
  const _FromYourSearch();

  @override
  Widget build(BuildContext context) {
    return _HScroll(
      spacing: 14,
      children: List.generate(
        5,
        (i) => SizedBox(
          width: 68,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.goldBorder, width: 2.5)),
                    child: ClipOval(child: Image.asset(i.isEven ? _avatarFemale : _avatarMale, fit: BoxFit.cover, errorBuilder: _avatarFallback)),
                  ),
                  if (i != 4)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(width: 14, height: 14, decoration: BoxDecoration(color: AppColors.online, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text('[Name]', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w700, AppColors.navyDark)),
              Text('[Age]', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w400, AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Activities ─────────────────────────

class _Activity {
  const _Activity(this.icon, this.count, this.title, this.sub, this.iconBg, this.iconFg, this.countColor, this.tintFrom);
  final String icon;
  final int count;
  final String title;
  final String sub;
  final Color iconBg;
  final Color iconFg;
  final Color countColor;
  final Color tintFrom;
}

const _blue = Color(0xFFDCE7F7);
const _amber = Color(0xFFF8E5C8);
const _rose = Color(0xFFFADDD6);
const _lilac = Color(0xFFE6E1F6);

const _profileActivities = [
  _Activity('eye', 1, 'Who Viewed Me', "See who's curious about you", _blue, AppColors.navy, AppColors.navy, Color(0xFFEAF0FA)),
  _Activity('star', 1, 'Shortlisted Me', "You're on their favourite list!", _amber, AppColors.goldDark, AppColors.brown, Color(0xFFFCF2E1)),
  _Activity('interest_accepted', 0, 'Interest Accepted', "Great news! It's a mutual match", _rose, AppColors.coral, AppColors.coral, Color(0xFFFCE9E4)),
  _Activity('request_approved', 0, 'Request Approved', 'You can now view their info', _lilac, AppColors.purple, AppColors.purple, Color(0xFFEFEBFA)),
];

const _myActivities = [
  _Activity('eye', 4, 'Viewed', "Profiles you've checked out", _blue, AppColors.navy, AppColors.navy, Color(0xFFEAF0FA)),
  _Activity('bookmark', 0, 'Shortlisted', 'Your saved favourites', _amber, AppColors.goldDark, AppColors.brown, Color(0xFFFCF2E1)),
  _Activity('send', 0, 'Interest Sent', "Profiles you've shown interest in", _rose, AppColors.coral, AppColors.coral, Color(0xFFFCE9E4)),
  _Activity('clock', 0, 'Request Sent', 'Contact requests awaiting reply', _lilac, AppColors.purple, AppColors.purple, Color(0xFFEFEBFA)),
];

/// 2 columns on phones, 4 on wide content. Each row is as tall as its
/// tallest tile (instead of a fixed aspect ratio that clips long titles).
class _ActivityGrid extends StatelessWidget {
  const _ActivityGrid({required this.items});
  final List<_Activity> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 520 ? 4 : 2;
        final rows = <Widget>[];
        for (var i = 0; i < items.length; i += cols) {
          final rowItems = items.skip(i).take(cols).toList();
          if (rows.isNotEmpty) rows.add(const SizedBox(height: 12));
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = 0; j < cols; j++) ...[
                    if (j > 0) const SizedBox(width: 12),
                    Expanded(
                      child: j < rowItems.length ? _ActivityTile(a: rowItems[j]) : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return Column(children: rows);
      },
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.a});
  final _Activity a;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: a.iconBg),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [a.tintFrom, Colors.white]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: a.iconBg, borderRadius: BorderRadius.circular(12)),
                child: Center(child: AppIcon(a.icon, size: 20, color: a.iconFg)),
              ),
              Flexible(
                child: Text('${a.count}', maxLines: 1, style: _t(28, FontWeight.w800, a.countColor)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Spacer(),
          Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: _t(16, FontWeight.w700, AppColors.navyDark)),
          const SizedBox(height: 2),
          Text(a.sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w400, AppColors.textMuted, height: 1.25)),
        ],
      ),
    );
  }
}

// ───────────────────────── Highlighted ─────────────────────────

class _Highlighted extends StatelessWidget {
  const _Highlighted();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 0, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.goldBorder),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFCF4E4), Color(0xFFF4E4C6)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 12),
            child: Row(
              children: [
                const AppIcon('crown', size: 22, color: AppColors.goldDark),
                const SizedBox(width: 8),
                Expanded(child: Text('Highlighted Profiles', style: _t(20, FontWeight.w700, AppColors.navyDark))),
                _SeeAll(onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _HScroll(
            children: [
              _ProfileCard(female: true, premium: true),
              _ProfileCard(female: false, premium: true, online: true),
            ],
          ),
        ],
      ),
    );
  }
}
