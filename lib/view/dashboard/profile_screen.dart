import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/edit_profile_screen.dart';
import 'package:vivahbharath_app/view/dashboard/manage_account_screen.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_photo_screen.dart';
import 'package:vivahbharath_app/view/drawer/partner_preference_screen.dart';
import 'package:vivahbharath_app/view/drawer/safe_matrminoy_screen.dart';
import 'package:vivahbharath_app/view/drawer/trust_badge.dart';


// ─────────────────────────────────────────────────────────────────────────────
//  Membership model
// ─────────────────────────────────────────────────────────────────────────────
class MembershipUsage {
  const MembershipUsage(this.label, this.icon, this.iconName, this.used, this.total);
  final String label;
  final IconData icon;
  final String iconName;
  final int used;
  final int total;
  int get left => (total - used).clamp(0, total);
}

class Membership {
  const Membership({
    required this.name,
    required this.validTill,
    required this.items,
  });
  final String name;
  final String validTill;
  final List<MembershipUsage> items;
}

/// Sample plan from the web popup — replace with your API data.
const kSampleMembership = Membership(
  name: 'Launching offer package',
  validTill: '12 Feb 2027',
  items: [
    MembershipUsage('Interests', Icons.favorite_border_rounded, 'heart', 3, 3),
    MembershipUsage('Name requests', Icons.badge_outlined, 'name', 1, 2),
    MembershipUsage('Photo requests', Icons.photo_camera_outlined, 'photo', 2, 2),
    MembershipUsage('Horoscope requests', Icons.auto_awesome_outlined, 'horoscope', 0, 2),
    MembershipUsage('Number requests', Icons.dialpad_rounded, 'number', 0, 2),
    MembershipUsage('Contacts', Icons.call_outlined, 'call', 0, 3),
    MembershipUsage('Shortlists', Icons.star_border_rounded, 'star', 2, 3),
    MembershipUsage('Messages', Icons.chat_bubble_outline_rounded, 'chat', 0, 3),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
//  Profile tab
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.profile,
    this.membership = kSampleMembership,
    this.profileId = 'VB[ID]',
    this.completion = 0.63,
    this.onLogout,
    this.onUpgrade,
    this.showBottomNav = true,
  });

  final Map<String, Object?>? profile;
  final Membership membership;
  final String profileId;

  /// 0.0 – 1.0
  final double completion;
  final VoidCallback? onLogout;
  final VoidCallback? onUpgrade;
  final bool showBottomNav;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Map<String, Object?> _profile = widget.profile ?? sampleProfile();

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  void _openEdit() => _push(EditProfileScreen(initial: _profile));

  Future<void> _openMembership() => showMembershipSheet(
        context,
        widget.membership,
        onUpgrade: widget.onUpgrade,
      );

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log out?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        content: const Text(
          "You'll need your mobile number or email and password to log in again.",
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (ok == true) widget.onLogout?.call(); // TODO: clear session & go to login
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.completion * 100).round();

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      // bottomNavigationBar:
      //     widget.showBottomNav ? const AppBottomNav(currentIndex: 4) : null,
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 14),

              // Header
              ProfileHeaderCard(
                data: _profile,
                buttonLabel: 'Edit Profile',
                buttonIcon: Icons.edit_outlined,
                onButton: _openEdit,
                footer: _Completion(id: widget.profileId, pct: pct),
              ),
              const SizedBox(height: 14),

              // Membership
              _MembershipCard(
                membership: widget.membership,
                onView: _openMembership,
                onUpgrade: widget.onUpgrade ?? () {/* TODO */},
              ),
              const SizedBox(height: 18),

              _MenuGroup(
                title: 'MY PROFILE',
                items: [
                  _MenuItem(Icons.edit_outlined, 'edit', 'Edit Profile',
                      AppColors.link, _openEdit),
                  _MenuItem(Icons.photo_library_outlined, 'photos',
                      'Manage Photos', AppColors.brown, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePhotosScreen(),));
                      }),
                  _MenuItem(Icons.favorite_border_rounded, 'heart',
                      'Partner Preferences', AppColors.coral, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerPreferencesScreen(),));
                      }),
                  _MenuItem(Icons.verified_user_outlined, 'trust',
                      'Trust Badge', AppColors.verified, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrustBadgeScreen(),));
                      }),
                  _MenuItem(Icons.shield_outlined, 'safe', 'Safe Matrimony',
                      AppColors.purple, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SafeMatrimonyScreen(),));
                      }),
                ],
              ),
              const SizedBox(height: 18),
              _MenuGroup(
                title: 'ACCOUNT',
                items: [
                  _MenuItem(
                    Icons.manage_accounts_outlined,
                    'account',
                    'Manage Account',
                    AppColors.link,
                    () => _push(const ManageAccountScreen()),
                    subtitle: 'Change password or delete account',
                  ),
                  _MenuItem(
                    Icons.workspace_premium_outlined,
                    'crown',
                    widget.membership.name.replaceAll(' package', ''),
                    AppColors.brown,
                    _openMembership,
                    subtitle: 'Valid till ${widget.membership.validTill}',
                  ),
                  _MenuItem(Icons.privacy_tip_outlined, 'privacy',
                      'Privacy Policy', AppColors.textMuted, () {/* TODO */}),
                  _MenuItem(Icons.description_outlined, 'terms',
                      'Terms & Conditions', AppColors.textMuted, () {/* TODO */}),
                ],
              ),
              const SizedBox(height: 18),
              PillButton(
                label: 'Log out',
                icon: matchIcon(Icons.logout_rounded, 'logout',
                    size: 18, color: AppColors.coral),
                foreground: AppColors.coral,
                background: Colors.white,
                borderColor: AppColors.coral.withValues(alpha: 0.5),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
class _Completion extends StatelessWidget {
  const _Completion({required this.id, required this.pct});
  final String id;
  final int pct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(id,
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
            const Spacer(),
            Text(
              'Profile completed $pct%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.marigoldY,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: pct / 100,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation(AppColors.marigoldO),
          ),
        ),
      ],
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({
    required this.membership,
    required this.onView,
    required this.onUpgrade,
  });

  final Membership membership;
  final VoidCallback onView;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.loginA, AppColors.loginB],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: matchIcon(Icons.workspace_premium_rounded, 'crown',
                    size: 22, color: AppColors.marigoldO),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR MEMBERSHIP',
                      style: TextStyle(
                        fontSize: 10.5,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldDark,
                      ),
                    ),
                    Text(
                      membership.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      'Valid till ${membership.validTill}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  label: 'View usage',
                  icon: matchIcon(Icons.bar_chart_rounded, 'usage',
                      size: 17, color: AppColors.goldDark),
                  foreground: AppColors.goldDark,
                  background: Colors.white,
                  borderColor: AppColors.goldBorder,
                  onTap: onView,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PillButton(
                  label: 'Upgrade',
                  icon: matchIcon(Icons.arrow_upward_rounded, 'upgrade',
                      size: 17, color: Colors.white),
                  foreground: Colors.white,
                  gradient: kTealGradient,
                  onTap: onUpgrade,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.iconName, this.label, this.accent, this.onTap,
      {this.subtitle});
  final IconData icon;
  final String iconName;
  final String label;
  final Color accent;
  final VoidCallback onTap;
  final String? subtitle;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.blueTintBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    const Divider(
                        height: 1, indent: 60, color: AppColors.blueTintBorder),
                  InkWell(
                    onTap: items[i].onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: items[i].accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: matchIcon(items[i].icon, items[i].iconName,
                                size: 19, color: items[i].accent),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[i].label,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                                if (items[i].subtitle != null)
                                  Text(
                                    items[i].subtitle!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted),
                                  ),
                              ],
                            ),
                          ),
                          matchIcon(Icons.chevron_right_rounded, 'arrow_right',
                              size: 22, color: AppColors.hint),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Membership usage sheet (the web "Your membership" popup)
// ─────────────────────────────────────────────────────────────────────────────
Future<void> showMembershipSheet(
  BuildContext context,
  Membership m, {
  VoidCallback? onUpgrade,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 8, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.tealB, AppColors.tealC],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR MEMBERSHIP',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Valid till ${m.validTill}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(ctx),
                  icon: matchIcon(Icons.close_rounded, 'close',
                      size: 24, color: Colors.white),
                ),
              ],
            ),
          ),

          // Usage grid
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
              child: LayoutBuilder(
                builder: (_, box) {
                  final w = (box.maxWidth - 10) / 2;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final u in m.items)
                        SizedBox(width: w, child: _UsageTile(u)),
                    ],
                  );
                },
              ),
            ),
          ),

          // Buttons
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: PillButton(
                      label: 'Close',
                      icon: const SizedBox.shrink(),
                      foreground: AppColors.navy,
                      background: Colors.white,
                      borderColor: AppColors.fieldBorder,
                      onTap: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PillButton(
                      label: 'Upgrade Plan',
                      icon: matchIcon(Icons.arrow_upward_rounded, 'upgrade',
                          size: 17, color: Colors.white),
                      foreground: Colors.white,
                      gradient: kTealGradient,
                      onTap: () {
                        Navigator.pop(ctx);
                        onUpgrade?.call(); // TODO: open subscription page
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _UsageTile extends StatelessWidget {
  const _UsageTile(this.u);
  final MembershipUsage u;

  @override
  Widget build(BuildContext context) {
    final out = u.left == 0;
    final barColor = out ? AppColors.coral : AppColors.tealMid;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: out
                ? AppColors.coral.withValues(alpha: 0.35)
                : AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: matchIcon(u.icon, u.iconName, size: 16, color: barColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.label,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      '${u.used} of ${u.total} used',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${u.left}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: out ? AppColors.coral : AppColors.navy,
                    ),
                  ),
                  const Text('left',
                      style:
                          TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: u.total == 0 ? 0 : u.used / u.total,
              minHeight: 5,
              backgroundColor: AppColors.bgTop,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
        ],
      ),
    );
  }
}