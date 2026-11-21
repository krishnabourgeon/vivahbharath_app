import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/model/dashboard_model.dart';
import 'package:vivahbharath_app/model/match_profile.dart';
import 'package:vivahbharath_app/provider/home_provider.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/app_icon.dart';
import 'package:vivahbharath_app/view/custom/interest_actions.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/dashboard/dashboard_shell.dart';
import 'package:vivahbharath_app/view/dashboard/home_drawer.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart' show MatchesScreen;
import 'package:vivahbharath_app/view/drawer/common_activity.dart' show ActStatus;
import 'package:vivahbharath_app/view/drawer/manage_interset_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_request.dart';
import 'package:vivahbharath_app/view/drawer/subscription_screen.dart';

/// Placeholder shown while a member photo loads, or when there is none.
Widget _photoPlaceholder() =>
    const ColoredBox(color: AppColors.blueTint, child: Center(child: Icon(Icons.person, size: 40, color: AppColors.navy)));

/// Member photo from the API, or a neutral placeholder.
Widget _memberPhoto(String? url) => url == null
    ? _photoPlaceholder()
    : Image.network(url, fit: BoxFit.cover, alignment: Alignment.topCenter, errorBuilder: _avatarFallback);

bool _isOnline(MatchProfile p) => p.lastSeen == 'Online now';

/// "Name" or the profile ID when the member hides their name.
String _displayName(MatchProfile p) => p.nameHidden || p.name.isEmpty ? p.id : p.name;

void _toast(BuildContext context, String msg) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.navy,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    content: Text(msg, style: const TextStyle(fontSize: 13)),
  ));
}

void _push(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

void _goToTab(BuildContext context, int tab) => DashboardShell.of(context)?.goTo(tab);

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
  void initState() {
    super.initState();
    // After the first frame: the provider notifies as soon as a fetch starts.
    CommonFunctions.afterInit(() {
      if (mounted) context.read<HomeProvider>().getDashboard();
    });
  }

  Future<void> _refresh() => context.read<HomeProvider>().getDashboard();

  @override
  Widget build(BuildContext context) {
    final side = 16 + contentSidePadding(context);
    final hp = context.watch<HomeProvider>();
    final d = hp.dashboardModel;

    // Errors on a refresh (with data already on screen) go to a snackbar.
    if (d != null && hp.dashboardError != null && !hp.dashboardLoading) {
      final msg = hp.dashboardError!;
      hp.dashboardError = null;
      CommonFunctions.afterInit(() {
        if (mounted) _toast(context, msg);
      });
    }

    final Widget body;
    if (d == null) {
      body = hp.dashboardError != null && !hp.dashboardLoading
          ? _ErrorView(message: hp.dashboardError!, onRetry: _refresh)
          : const Center(child: CircularProgressIndicator(color: AppColors.tealMid));
    } else {
      final counts = d.activityCounts;
      body = RefreshIndicator(
        color: AppColors.tealMid,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(side, 16, side, 24),
          children: [
            _WelcomeCard(data: d),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PillButton(icon: 'gift', label: 'Launch offer', onTap: () => _push(context, const SubscriptionScreen())),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PillButton(
                    icon: 'crown',
                    label: d.subscription.isPremium && d.subscription.planName.isNotEmpty ? d.subscription.planName : 'Upgrade',
                    onTap: () => _push(context, const SubscriptionScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Recommendations(data: d.recommendations),
            const SizedBox(height: 18),
            const _SearchBar(),
            if (d.fromYourSearch.isNotEmpty) ...[
              const SizedBox(height: 22),
              _SectionHeader(title: 'From your search', onSeeAll: () => _goToTab(context, DashboardTab.search)),
              const SizedBox(height: 12),
              _FromYourSearch(profiles: d.fromYourSearch),
            ],
            const SizedBox(height: 22),
            Text('Profile Activities', style: _t(20, FontWeight.w700, AppColors.navyDark)),
            const SizedBox(height: 12),
            _ActivityGrid(items: _profileActivities, counts: counts),
            if (d.premiumMatches.isNotEmpty) ...[
              const SizedBox(height: 22),
              _Highlighted(profiles: d.premiumMatches),
            ],
            const SizedBox(height: 22),
            Text('My Activities', style: _t(20, FontWeight.w700, AppColors.navyDark)),
            const SizedBox(height: 12),
            _ActivityGrid(items: _myActivities, counts: counts),
          ],
        ),
      );
    }

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
            _TopPanel(
              onMenu: () => _scaffoldKey.currentState?.openDrawer(),
              unreadMessages: d?.messages.unreadCount ?? 0,
              unreadNotifications: d?.notifications.unreadCount ?? 0,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// First load failed: message + retry (pull-to-refresh also works).
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.tealMid,
      onRefresh: onRetry,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: _t(16, FontWeight.w600, AppColors.navyDark)),
          const SizedBox(height: 16),
          Center(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.tealMid),
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Top bar ─────────────────────────

/// Soft white panel behind the top bar (runs up under the status bar),
/// with rounded bottom corners like the mockup.
class _TopPanel extends StatelessWidget {
  const _TopPanel({required this.onMenu, this.unreadMessages = 0, this.unreadNotifications = 0});
  final VoidCallback onMenu;
  final int unreadMessages;
  final int unreadNotifications;

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
      child: MaxWidthBox(
        child: _TopBar(onMenu: onMenu, unreadMessages: unreadMessages, unreadNotifications: unreadNotifications),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onMenu, required this.unreadMessages, required this.unreadNotifications});
  final VoidCallback onMenu;
  final int unreadMessages;
  final int unreadNotifications;

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
          _GoldCircleIcon(
            icon: 'chat',
            size: circle,
            badge: unreadMessages > 0 ? unreadMessages : null,
            onTap: () => _goToTab(context, DashboardTab.inbox),
          ),
          const SizedBox(width: 10),
          // TODO: open the notifications screen once it exists.
          _GoldCircleIcon(icon: 'bell', badge: unreadNotifications > 0 ? unreadNotifications : null, size: circle),
        ],
      ),
    );
  }
}

class _GoldCircleIcon extends StatelessWidget {
  const _GoldCircleIcon({required this.icon, required this.size, this.badge, this.onTap});
  final String icon;
  final double size;
  final int? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
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
                  badge! > 99 ? '99+' : '$badge',
                  // Fixed size: a badge must not grow with accessibility text.
                  textScaler: TextScaler.noScaling,
                  style: _t(11, FontWeight.w700, Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
    if (onTap == null) return child;
    return InkWell(onTap: onTap, customBorder: const CircleBorder(), child: child);
  }
}

// ───────────────────────── Welcome card ─────────────────────────

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.data});
  final DashboardModel data;

  @override
  Widget build(BuildContext context) {
    final p = data.profile;
    final premium = p.isPremium || data.subscription.isPremium;
    final greeting = data.greeting.isEmpty ? 'Welcome,' : (data.greeting.endsWith(',') ? data.greeting : '${data.greeting},');
    final initial = p.initial.isNotEmpty ? p.initial : (p.name.isNotEmpty ? p.name[0].toUpperCase() : '?');
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
          // crown badge, top-right (premium members only)
          if (premium)
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
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.goldBorder, width: 3),
                        gradient: const LinearGradient(colors: [Color(0xFFE8A55F), Color(0xFFB8672F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                      child: p.imageUrl == null
                          ? Text(initial, textScaler: TextScaler.noScaling, style: _t(avatar * 0.45, FontWeight.w700, Colors.white))
                          : Image.network(
                              p.imageUrl!,
                              width: avatar,
                              height: avatar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  Text(initial, textScaler: TextScaler.noScaling, style: _t(avatar * 0.45, FontWeight.w700, Colors.white)),
                            ),
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
                      Text(greeting, maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(14, FontWeight.w500, AppColors.goldBorder)),
                      Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(22, FontWeight.w700, Colors.white)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const AppIcon('profile_id', size: 16, color: AppColors.goldBorder),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(p.profileId, maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w500, AppColors.goldBorder)),
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
                  child: _ProfileRing(percent: data.profileCompletion.percentage / 100, size: narrow ? 70 : 78),
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
              child: Text(percent >= 1 ? 'Profile\ncomplete' : 'Complete\nyour profile', textAlign: TextAlign.center, style: _t(11, FontWeight.w700, Colors.white, height: 1.2)),
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
  const _PillButton({required this.icon, required this.label, this.fontSize = 16, this.minHeight = 52, this.onTap});
  final String icon;
  final String label;
  final double fontSize;
  final double minHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
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
    if (onTap == null) return pill;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(minHeight / 2), child: pill),
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
  const _ProfileCard({required this.profile, this.premium = false});
  final MatchProfile profile;
  final bool premium;

  Future<void> _toggleShortlist(BuildContext context) async {
    final now = await context.read<HomeProvider>().toggleHomeShortlist(profile);
    if (!context.mounted) return;
    _toast(
      context,
      now == null ? 'Could not update your shortlist. Please try again' : (now ? 'Added to your shortlist' : 'Removed from your shortlist'),
    );
  }

  Future<void> _sendInterest(BuildContext context) async {
    final status = interestStatusOf(profile);
    if (status == InterestStatus.awaiting || status == InterestStatus.accepted) return;
    final home = context.read<HomeProvider>();
    final error = await sendInterestApi(profile.apiId);
    if (error == null) home.markHomeInterestSent(profile);
    if (!context.mounted) return;
    _toast(context, error ?? 'Interest sent to ${_displayName(profile)}');
  }

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final width = _isNarrow(context) ? 175.0 : 195.0;
    final verified = p.verified;
    final online = _isOnline(p);
    final hasPhoto = p.photoUrl != null;
    final details = [p.city, p.profession].where((s) => s.isNotEmpty).join(' · ');
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
                  _memberPhoto(p.photoUrl),
                  if (premium || verified)
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
                              : const AppIcon('verified', size: 15, color: AppColors.verified),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Semantics(
                      button: true,
                      label: p.shortlisted ? 'Remove from shortlist' : 'Add to shortlist',
                      child: InkWell(
                        onTap: () => _toggleShortlist(context),
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: Center(
                            child: AppIcon(p.shortlisted ? 'heart_filled' : 'heart', size: 18, color: p.shortlisted ? AppColors.coral : AppColors.navy),
                          ),
                        ),
                      ),
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
          Text(
            p.age == null ? _displayName(p) : '${_displayName(p)}, ${p.age}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _t(16, FontWeight.w700, AppColors.navyDark),
          ),
          const SizedBox(height: 2),
          Text(details.isEmpty ? ' ' : details, maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w400, AppColors.textMuted)),
          const SizedBox(height: 10),
          // Rebuilds when an interest to this member is sent / withdrawn anywhere.
          ListenableBuilder(
            listenable: sentInterests,
            builder: (context, _) {
              final (interestIcon, interestLabel) = switch (interestStatusOf(p)) {
                InterestStatus.send => ('send', 'Send Interest'),
                InterestStatus.awaiting => ('clock', 'Awaiting Response'),
                InterestStatus.resend => ('send', 'Resend Interest'),
                InterestStatus.accepted => ('interest_accepted', 'Connected'),
              };
              return _PillButton(icon: interestIcon, label: interestLabel, fontSize: 15, minHeight: 44, onTap: () => _sendInterest(context));
            },
          ),
        ],
      ),
    );
  }
}

/// Muted one-liner for a section with no profiles.
class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        child: Text(text, style: _t(14, FontWeight.w400, AppColors.textMuted)),
      );
}

// ───────────────────────── Recommendations ─────────────────────────

class _Recommendations extends StatelessWidget {
  const _Recommendations({required this.data});
  final Recommendations data;

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
            child: _SectionHeader(
              title: data.title,
              subtitle: data.subtitle,
              onSeeAll: () => _goToTab(context, DashboardTab.matches),
            ),
          ),
          const SizedBox(height: 12),
          if (data.profiles.isEmpty)
            _EmptyNote(
              data.hasPartnerPreferences
                  ? 'No recommendations right now. Check back soon.'
                  : 'Set your partner preferences to get recommendations.',
            )
          else
            _HScroll(children: [for (final p in data.profiles) _ProfileCard(profile: p)]),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _goToTab(context, DashboardTab.search),
        borderRadius: BorderRadius.circular(28),
        child: Container(
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
        ),
      ),
    );
  }
}

class _FromYourSearch extends StatelessWidget {
  const _FromYourSearch({required this.profiles});
  final List<MatchProfile> profiles;

  @override
  Widget build(BuildContext context) {
    return _HScroll(
      spacing: 14,
      children: [
        for (final p in profiles)
          SizedBox(
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
                      child: ClipOval(child: _memberPhoto(p.photoUrl)),
                    ),
                    if (_isOnline(p))
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(width: 14, height: 14, decoration: BoxDecoration(color: AppColors.online, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_displayName(p), maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w700, AppColors.navyDark)),
                Text(p.age == null ? ' ' : '${p.age}', maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(13, FontWeight.w400, AppColors.textMuted)),
              ],
            ),
          ),
      ],
    );
  }
}

// ───────────────────────── Activities ─────────────────────────

/// Which dashboard counter a tile shows, and where tapping it goes.
enum _ActivityKind {
  whoViewedMe,
  shortlistedMe,
  interestAccepted,
  requestApproved,
  viewedByMe,
  shortlistedByMe,
  interestSent,
  requestSent;

  int count(ActivityCounts c) => switch (this) {
        whoViewedMe => c.whoViewedMe,
        shortlistedMe => c.shortlistedMe,
        interestAccepted => c.myInterestAccepted,
        requestApproved => c.myRequestApproved,
        viewedByMe => c.viewedByMe,
        shortlistedByMe => c.shortlistedByMe,
        interestSent => c.interestSent,
        requestSent => c.requestSent,
      };

  Widget page() => switch (this) {
        whoViewedMe => const MatchesScreen(initialTab: MatchTab.viewedYou),
        shortlistedMe => const MatchesScreen(initialTab: MatchTab.shortlistedYou),
        viewedByMe => const MatchesScreen(initialTab: MatchTab.viewedByYou),
        shortlistedByMe => const MatchesScreen(initialTab: MatchTab.shortlistedByYou),
        interestAccepted => const ManageInterestScreen(initialTab: 1, initialFilter: ActStatus.accepted),
        interestSent => const ManageInterestScreen(initialTab: 1),
        requestApproved => const ManageRequestScreen(initialTab: 1, initialFilter: ActStatus.accepted),
        requestSent => const ManageRequestScreen(initialTab: 1),
      };
}

class _Activity {
  const _Activity(this.kind, this.icon, this.title, this.sub, this.iconBg, this.iconFg, this.countColor, this.tintFrom);
  final _ActivityKind kind;
  final String icon;
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
  _Activity(_ActivityKind.whoViewedMe, 'eye', 'Who Viewed Me', "See who's curious about you", _blue, AppColors.navy, AppColors.navy, Color(0xFFEAF0FA)),
  _Activity(_ActivityKind.shortlistedMe, 'star', 'Shortlisted Me', "You're on their favourite list!", _amber, AppColors.goldDark, AppColors.brown, Color(0xFFFCF2E1)),
  _Activity(_ActivityKind.interestAccepted, 'interest_accepted', 'Interest Accepted', "Great news! It's a mutual match", _rose, AppColors.coral, AppColors.coral, Color(0xFFFCE9E4)),
  _Activity(_ActivityKind.requestApproved, 'request_approved', 'Request Approved', 'You can now view their info', _lilac, AppColors.purple, AppColors.purple, Color(0xFFEFEBFA)),
];

const _myActivities = [
  _Activity(_ActivityKind.viewedByMe, 'eye', 'Viewed', "Profiles you've checked out", _blue, AppColors.navy, AppColors.navy, Color(0xFFEAF0FA)),
  _Activity(_ActivityKind.shortlistedByMe, 'bookmark', 'Shortlisted', 'Your saved favourites', _amber, AppColors.goldDark, AppColors.brown, Color(0xFFFCF2E1)),
  _Activity(_ActivityKind.interestSent, 'send', 'Interest Sent', "Profiles you've shown interest in", _rose, AppColors.coral, AppColors.coral, Color(0xFFFCE9E4)),
  _Activity(_ActivityKind.requestSent, 'clock', 'Request Sent', 'Contact requests awaiting reply', _lilac, AppColors.purple, AppColors.purple, Color(0xFFEFEBFA)),
];

/// 2 columns on phones, 4 on wide content. Each row is as tall as its
/// tallest tile (instead of a fixed aspect ratio that clips long titles).
class _ActivityGrid extends StatelessWidget {
  const _ActivityGrid({required this.items, required this.counts});
  final List<_Activity> items;
  final ActivityCounts counts;

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
                      child: j < rowItems.length
                          ? _ActivityTile(a: rowItems[j], count: rowItems[j].kind.count(counts))
                          : const SizedBox(),
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
  const _ActivityTile({required this.a, required this.count});
  final _Activity a;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => a.kind.page()));
          // Counts may have changed on the screen we opened.
          if (context.mounted) context.read<HomeProvider>().getDashboard();
        },
        child: Container(
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
                    child: Text('$count', maxLines: 1, style: _t(28, FontWeight.w800, a.countColor)),
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
        ),
      ),
    );
  }
}

// ───────────────────────── Highlighted ─────────────────────────

class _Highlighted extends StatelessWidget {
  const _Highlighted({required this.profiles});
  final List<MatchProfile> profiles;

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
                _SeeAll(onTap: () => _goToTab(context, DashboardTab.matches)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _HScroll(children: [for (final p in profiles) _ProfileCard(profile: p, premium: true)]),
        ],
      ),
    );
  }
}
