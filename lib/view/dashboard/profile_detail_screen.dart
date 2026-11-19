import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/profile_badges.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/drawer/chat_screen.dart';
import 'package:vivahbharath_app/view/drawer/subscription_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────────────────────────────
enum MemberInterest { send, awaiting, resend, accepted }

class PrefRow {
  const PrefRow(this.label, this.value, {this.matches = true});
  final String label;
  final String value;
  final bool matches;
}

class PrefSection {
  const PrefSection(this.title, this.icon, this.iconName, this.accent, this.tint, this.rows);
  final String title;
  final IconData icon;
  final String iconName;
  final Color accent;
  final Color tint;
  final List<PrefRow> rows;
}

class SimilarProfile {
  const SimilarProfile(this.name, this.line1, this.line2,
      {this.awaiting = false, this.photoUrl});
  final String name;
  final String line1; // "24 Years, 4'10" · Software Developer"
  final String line2; // "Kozhikode, Kerala"
  final bool awaiting;
  final String? photoUrl;
}

class MemberProfile {
  MemberProfile({
    required this.name,
    required this.id,
    required this.lastSeen,
    required this.chips,
    required this.about,
    required this.basic,
    required this.moreBasic,
    required this.maskedPhone,
    required this.family,
    required this.horoscope,
    required this.preferences,
    this.female = true,
    this.online = false,
    this.verified = true,
    this.premium = false,
    this.featured = false,
    this.nameHidden = false,
    this.photoHidden = false,
    this.photoCount = 4,
    this.photoUrls = const [],
    this.phone,
    this.shortlisted = false,
    this.interest = MemberInterest.awaiting,
    this.similar = const [],
  });

  final String name;
  final String id;
  final String lastSeen;
  final bool female;
  final bool online;
  final bool verified;
  /// Paid member — shows the "Paid Member" badge.
  final bool premium;
  final bool featured;
  final bool nameHidden;
  final bool photoHidden;
  final int photoCount;
  final List<String> photoUrls;
  final List<String> chips; // 33 yrs, Hindu, Bachelors Degree …
  final String about;
  final List<(String, String)> basic;
  final List<(String, String)> moreBasic; // shown after "Show more"
  final String maskedPhone;
  final String? phone; // set when the viewer may see it
  final List<(String, String)> family;
  final List<(String, String)> horoscope;
  final List<PrefSection> preferences;
  final List<SimilarProfile> similar;
  bool shortlisted;
  MemberInterest interest;

  String get pronoun => female ? 'Her' : 'His';
  int get prefTotal =>
      preferences.fold(0, (n, s) => n + s.rows.length);
  int get prefMatched => preferences.fold(
      0, (n, s) => n + s.rows.where((r) => r.matches).length);
}

/// Sample member from the app design — replace with your API data.
MemberProfile sampleMember() {
  const dash = '—';
  PrefRow r(String l) => PrefRow(l, dash);
  return MemberProfile(
    name: '[Name]',
    id: 'VB[Profile ID]',
    lastSeen: 'Last seen 55 minutes ago',
    premium: true,
    featured: true,
    online: true,
    chips: const ['33 yrs', 'Hindu', 'Bachelors Degree', 'Software Engineer', 'Kerala', 'India'],
    about:
        '[A few lines the member writes about herself, her family and what she is looking for.]',
    basic: const [
      ('Age', '33 Years & 7 Months'),
      ('Physique', '5\'1"'),
      ('Marital Status', 'Never Married'),
      ('Lives In', 'Kozhikode, Kerala'),
      ('Resident Status', 'Permanent'),
      ('Education', 'Bachelors Degree'),
      ('Occupation', 'Software Engineer'),
      ('Works In', 'Kozhikode, Kerala, India'),
      ('Annual Income', 'Rupee 1000000-'),
    ],
    moreBasic: const [
      ('Religion', 'Hindu'),
      ('Caste', dash),
      ('Mother Tongue', dash),
      ('Diet', dash),
      ('Smoking', dash),
      ('Drinking', dash),
    ],
    maskedPhone: '90******12',
    family: const [
      ('Family Type', dash),
      ('Family Status', dash),
      ('Family Values', dash),
      ("Father's Occupation", dash),
      ("Mother's Occupation", dash),
      ('Brothers', dash),
      ('Brothers Married', dash),
      ('Sisters', dash),
      ('Sisters Married', dash),
    ],
    horoscope: const [
      ('Date of birth', dash),
      ('Time of birth', dash),
      ('Location of birth', dash),
      ('Birth star', dash),
      ('Shudha jathakam', dash),
      ('Dosha jathakam', dash),
      ('Horoscope match', dash),
    ],
    preferences: [
      PrefSection('basic preferences', Icons.person_outline_rounded, 'basic',
          AppColors.link, AppColors.blueTint, [
        r('Preferred age of groom'),
        r('Preferred height'),
        r('Preferred marital status'),
        r('Preferred religion and caste'),
        r('Preferred mother tongue'),
        r('Preferred physical status'),
        r('Preferred diet'),
      ]),
      PrefSection('Education & career', Icons.school_outlined, 'education',
          AppColors.brown, AppColors.cream, [
        r('Preferred education'),
        r('Preferred occupation'),
        r('Preferred annual income'),
        r('Preferred employed in'),
      ]),
      PrefSection('Location', Icons.location_on_outlined, 'location',
          AppColors.purple, const Color(0xFFF1EEF9), [
        r('Preferred country'),
        r('Preferred state'),
        r('Preferred city'),
        r('Preferred citizenship'),
      ]),
      PrefSection('Family & horoscope', Icons.star_border_rounded, 'family',
          AppColors.coral, const Color(0xFFFBF0EE), [
        r('Preferred family type'),
        r('Preferred family values'),
        r('Preferred birth star'),
        r('Preferred dosha'),
      ]),
    ],
    similar: const [
      SimilarProfile('[Name]', '24 Years, 4\'10" · Software Developer',
          'Kozhikode, Kerala',
          awaiting: true),
      SimilarProfile('[Name]', '18 Years · Doctor', 'Kozhikode, Kerala'),
      SimilarProfile('[Name]', '18 Years, 5\'9" · Software Developer',
          'Kozhikode, Kerala'),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────────────────────
class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({
    super.key,
    this.profile,
    this.initialTab = 0,
    this.onShare,
    this.onCall,
    this.onWhatsApp,
    this.onSendInterest,
    this.onDontShow,
    this.onRequestPhoto,
    this.onReport,
    this.onBlock,
    this.onOpenSimilar,
    this.onUpgrade,
    this.showBottomNav = true,
  });

  final MemberProfile? profile;

  /// 0 = Details, 1 = Partner preferences.
  final int initialTab;

  // TODO: connect to your API / intents.
  final VoidCallback? onShare;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;
  final VoidCallback? onSendInterest;
  final VoidCallback? onDontShow;
  final VoidCallback? onRequestPhoto;
  final VoidCallback? onReport;
  final VoidCallback? onBlock;
  final void Function(SimilarProfile p)? onOpenSimilar;
  final VoidCallback? onUpgrade;
  final bool showBottomNav;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late final MemberProfile _p = widget.profile ?? sampleMember();
  late int _tab = widget.initialTab;
  int _photo = 0;
  bool _moreBasic = false;
  final _scroll = ScrollController();
  final _tabsKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _toast(String msg, {VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                textColor: AppColors.goldBorder,
                onPressed: onUndo),
      ));
  }

  void _toggleShortlist() {
    setState(() => _p.shortlisted = !_p.shortlisted);
    _toast(_p.shortlisted ? 'Added to your shortlist' : 'Removed from your shortlist');
  }

  void _sendInterest() {
    setState(() => _p.interest = MemberInterest.awaiting);
    widget.onSendInterest?.call();
    _toast('Interest sent');
  }

  void _dontShow() {
    widget.onDontShow?.call();
    _toast("You won't see this profile in your matches");
    Navigator.of(context).maybePop();
  }

  void _openChat() {
    if (_p.interest != MemberInterest.accepted) {
      _toast('You can chat once ${_p.pronoun.toLowerCase() == 'her' ? 'she' : 'he'} accepts your interest');
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChatScreen(
        thread: ChatThread(
          name: _p.name,
          id: _p.id,
          time: 'Now',
          online: _p.online,
          lastSeen: _p.lastSeen,
        ),
      ),
    ));
  }

  void _upgrade() => widget.onUpgrade != null
      ? widget.onUpgrade!()
      : Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SubscriptionScreen()));

  void _goToPrefs() {
    setState(() => _tab = 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _tabsKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
  }

  Future<void> _menu() async {
    final pick = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              for (final (icon, label, value, danger) in [
                (
                  _p.shortlisted
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  _p.shortlisted ? 'Remove from shortlist' : 'Shortlist',
                  'shortlist',
                  false
                ),
                (Icons.share_outlined, 'Share profile', 'share', false),
                (Icons.block_rounded, 'Block', 'block', true),
                (Icons.flag_outlined, 'Report profile', 'report', true),
              ])
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  leading: matchIcon(icon, value,
                      size: 22,
                      color: danger ? AppColors.coral : AppColors.navy),
                  title: Text(label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: danger ? AppColors.coral : AppColors.navy)),
                  onTap: () => Navigator.pop(ctx, value),
                ),
            ],
          ),
        ),
      ),
    );
    switch (pick) {
      case 'shortlist':
        _toggleShortlist();
      case 'share':
        widget.onShare?.call();
      case 'block':
        widget.onBlock?.call();
      case 'report':
        widget.onReport?.call();
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: ListView(
        controller: _scroll,
        padding: EdgeInsets.zero,
        children: [
          // Photo + overlapping info card
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 430 + top,
                child: _PhotoPager(
                  profile: _p,
                  index: _photo,
                  onPage: (i) => setState(() => _photo = i),
                  onRequestPhoto: () {
                    widget.onRequestPhoto?.call();
                    _toast('Photo request sent');
                  },
                ),
              ),
              Positioned(
                top: top + 10,
                left: 14,
                right: 14,
                child: Row(
                  children: [
                    CircleIconButton(
                      tooltip: 'Back',
                      size: 42,
                      icon: matchIcon(Icons.chevron_left_rounded, 'back',
                          size: 26, color: AppColors.goldDark),
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    CircleIconButton(
                      tooltip: _p.shortlisted
                          ? 'Remove from shortlist'
                          : 'Shortlist',
                      size: 42,
                      background: Colors.white,
                      icon: matchIcon(
                          _p.shortlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          'heart',
                          size: 21,
                          color: _p.shortlisted
                              ? AppColors.coral
                              : AppColors.navy),
                      onTap: _toggleShortlist,
                    ),
                    const SizedBox(width: 8),
                    CircleIconButton(
                      tooltip: 'More',
                      size: 42,
                      background: Colors.white,
                      icon: matchIcon(Icons.more_vert_rounded, 'more',
                          size: 21, color: AppColors.navy),
                      onTap: _menu,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14, 380 + top, 14, 0),
                child: withFeaturedRibbon(
                  _InfoCard(profile: _p),
                  featured: _p.featured,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quick actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _QuickAction(Icons.share_outlined, 'share', 'Share',
                        widget.onShare ?? () {/* TODO */}),
                    _QuickAction(Icons.chat_bubble_outline_rounded, 'chat',
                        'Chat', _openChat),
                    _QuickAction(Icons.call_outlined, 'call', 'Call',
                        widget.onCall ?? _upgrade),
                    _QuickAction(Icons.chat_rounded, 'whatsapp', 'WhatsApp',
                        widget.onWhatsApp ?? _upgrade),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: PillButton(
                        label: "Don't show",
                        icon: matchIcon(Icons.visibility_off_outlined,
                            'eye_off',
                            size: 17, color: AppColors.navy),
                        foreground: AppColors.navy,
                        background: Colors.white,
                        borderColor: AppColors.fieldBorder,
                        onTap: _dontShow,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _interestButton()),
                  ],
                ),
                const SizedBox(height: 16),
                _Tabs(
                  key: _tabsKey,
                  index: _tab,
                  onPick: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: 14),
                if (_tab == 0) ..._details() else ..._preferences(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestButton() {
    switch (_p.interest) {
      case MemberInterest.send:
        return PillButton(
          label: 'Send Interest',
          icon: matchIcon(Icons.send_rounded, 'send',
              size: 16, color: Colors.white),
          foreground: Colors.white,
          gradient: kTealGradient,
          onTap: _sendInterest,
        );
      case MemberInterest.resend:
        return PillButton(
          label: 'Resend interest',
          icon: matchIcon(Icons.refresh_rounded, 'refresh',
              size: 17, color: AppColors.tealMid),
          foreground: AppColors.tealMid,
          background: Colors.white,
          borderColor: AppColors.tealMid,
          borderWidth: 1.5,
          onTap: _sendInterest,
        );
      case MemberInterest.awaiting:
        return PillButton(
          label: 'Awaiting Response',
          icon: matchIcon(Icons.schedule_rounded, 'clock',
              size: 16, color: AppColors.goldDark),
          foreground: AppColors.goldDark,
          background: AppColors.toggleBg,
          onTap: null,
        );
      case MemberInterest.accepted:
        return PillButton(
          label: 'Chat now',
          icon: matchIcon(Icons.chat_bubble_outline_rounded, 'chat',
              size: 16, color: Colors.white),
          foreground: Colors.white,
          gradient: kTealGradient,
          onTap: _openChat,
        );
    }
  }

  // ── Details tab ──────────────────────────────────────────────────────────
  List<Widget> _details() {
    final pr = _p.pronoun;
    return [
      _Section(
        title: 'About Profile',
        icon: Icons.info_outline_rounded,
        iconName: 'info',
        accent: AppColors.link,
        tint: AppColors.blueTint,
        child: Text(
          _p.about,
          style: const TextStyle(
              fontSize: 14, height: 1.5, color: AppColors.navy),
        ),
      ),
      const SizedBox(height: 14),
      _Section(
        title: '$pr Basic Details',
        icon: Icons.person_outline_rounded,
        iconName: 'basic',
        accent: AppColors.brown,
        tint: AppColors.cream,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Rows([..._p.basic, if (_moreBasic) ..._p.moreBasic]),
            if (_p.moreBasic.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _moreBasic = !_moreBasic),
                  style: TextButton.styleFrom(foregroundColor: AppColors.link),
                  child: Text(_moreBasic ? 'Show less' : 'Show more',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _Section(
        title: 'Contact details',
        icon: Icons.call_outlined,
        iconName: 'call',
        accent: AppColors.brown,
        tint: AppColors.cream,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Mobile Number',
                      style:
                          TextStyle(fontSize: 13.5, color: AppColors.textMuted)),
                ),
                Text(
                  _p.phone ?? _p.maskedPhone,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                if (_p.phone == null) ...[
                  const SizedBox(width: 6),
                  matchIcon(Icons.lock_outline_rounded, 'lock',
                      size: 16, color: AppColors.goldDark),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (_p.phone == null)
              PillButton(
                label: 'Upgrade to view',
                icon: matchIcon(Icons.lock_open_rounded, 'unlock',
                    size: 16, color: AppColors.goldDark),
                foreground: AppColors.goldDark,
                gradient: const LinearGradient(
                    colors: [AppColors.loginA, AppColors.loginB]),
                borderColor: AppColors.goldBorder,
                onTap: _upgrade,
              )
            else
              PillButton(
                label: 'Call now',
                icon: matchIcon(Icons.call_rounded, 'call',
                    size: 16, color: Colors.white),
                foreground: Colors.white,
                gradient: kTealGradient,
                onTap: widget.onCall ?? () {/* TODO */},
              ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _Section(
        title: 'Family Details',
        icon: Icons.home_outlined,
        iconName: 'family',
        accent: AppColors.purple,
        tint: const Color(0xFFF1EEF9),
        child: _Rows(_p.family),
      ),
      const SizedBox(height: 14),
      _Section(
        title: 'Horoscope details',
        icon: Icons.auto_awesome_outlined,
        iconName: 'horoscope',
        accent: AppColors.coral,
        tint: const Color(0xFFFBF0EE),
        child: _Rows(_p.horoscope),
      ),
      const SizedBox(height: 14),
      _MatchBanner(
        matched: _p.prefMatched,
        total: _p.prefTotal,
        pronoun: pr.toLowerCase(),
        onTap: _goToPrefs,
      ),
      if (_p.similar.isNotEmpty) ...[
        const SizedBox(height: 20),
        const Text(
          'Similar Profiles',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 262,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: _p.similar.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _SimilarCard(
              p: _p.similar[i],
              onOpen: () => widget.onOpenSimilar?.call(_p.similar[i]),
            ),
          ),
        ),
      ],
    ];
  }

  // ── Partner preferences tab ──────────────────────────────────────────────
  List<Widget> _preferences() {
    final pr = _p.pronoun;
    return [
      _MatchHeader(
        matched: _p.prefMatched,
        total: _p.prefTotal,
        pronoun: pr,
        female: _p.female,
      ),
      const SizedBox(height: 14),
      for (final s in _p.preferences) ...[
        _Section(
          title: s.title == 'basic preferences' ? '$pr basic preferences' : s.title,
          icon: s.icon,
          iconName: s.iconName,
          accent: s.accent,
          tint: s.tint,
          child: Column(
            children: [
              for (var i = 0; i < s.rows.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, color: AppColors.blueTintBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          _p.female
                              ? s.rows[i].label
                              : s.rows[i].label.replaceAll('groom', 'bride'),
                          style: const TextStyle(
                              fontSize: 13.5, color: AppColors.navy),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          s.rows[i].value,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      Semantics(
                        label: s.rows[i].matches ? 'Matches' : 'Does not match',
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: s.rows[i].matches
                                ? AppColors.verified
                                : AppColors.bgTop,
                          ),
                          child: Center(
                            child: matchIcon(
                              s.rows[i].matches
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              'match',
                              size: 15,
                              color: s.rows[i].matches
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
class _PhotoPager extends StatelessWidget {
  const _PhotoPager({
    required this.profile,
    required this.index,
    required this.onPage,
    required this.onRequestPhoto,
  });

  final MemberProfile profile;
  final int index;
  final ValueChanged<int> onPage;
  final VoidCallback onRequestPhoto;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final count = p.photoUrls.isNotEmpty ? p.photoUrls.length : p.photoCount;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.blueTint),
          if (p.photoHidden)
            _HiddenPhoto(onRequest: onRequestPhoto)
          else
            PageView.builder(
              itemCount: count,
              onPageChanged: onPage,
              itemBuilder: (_, i) => p.photoUrls.isNotEmpty
                  ? Image.network(p.photoUrls[i], fit: BoxFit.cover)
                  : const Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: 0.82,
                        child: AspectRatio(
                          aspectRatio: 112 / 150,
                          child: CustomPaint(painter: AvatarPainter()),
                        ),
                      ),
                    ),
            ),
          if (!p.photoHidden && count > 0)
            Positioned(
              left: 16,
              bottom: 64,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    matchIcon(Icons.photo_library_outlined, 'photos',
                        size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      '${index + 1} / $count photos',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!p.photoHidden && count > 1)
            Positioned(
              right: 16,
              bottom: 70,
              child: Row(
                children: [
                  for (var i = 0; i < count; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 4),
                      width: i == index ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(999),
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

class _HiddenPhoto extends StatelessWidget {
  const _HiddenPhoto({required this.onRequest});
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueTint,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: matchIcon(Icons.lock_outline_rounded, 'lock',
                size: 28, color: AppColors.tealMid),
          ),
          const SizedBox(height: 10),
          const Text('Photos are hidden',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy)),
          const SizedBox(height: 10),
          SizedBox(
            width: 180,
            child: PillButton(
              label: 'Request Photo',
              icon: matchIcon(Icons.photo_camera_outlined, 'camera',
                  size: 16, color: Colors.white),
              foreground: Colors.white,
              gradient: kTealGradient,
              onTap: onRequest,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.profile});
  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: p.featured ? null : Colors.white,
        gradient: p.featured
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.loginA, Colors.white],
                stops: [0, 0.45],
              )
            : null,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: p.featured ? AppColors.goldBorder : AppColors.blueTintBorder,
          width: p.featured ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (p.verified || p.premium) ...[
            ProfileBadges(verified: p.verified, paid: p.premium),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Flexible(
                child: Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              if (p.nameHidden) ...[
                const SizedBox(width: 6),
                Semantics(
                  label: 'Name hidden',
                  child: matchIcon(Icons.visibility_off_outlined, 'eye_off',
                      size: 18, color: AppColors.coral),
                ),
              ],
              if (p.online) ...[
                const SizedBox(width: 8),
                const OnlineBadge(),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (p.online) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.online, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: Text(
                  '${p.id} · ${p.online ? 'Online now' : p.lastSeen}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12.5, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final c in p.chips)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.blueTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    c,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(this.icon, this.iconName, this.label, this.onTap);
  final IconData icon;
  final String iconName;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.toggleBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldBorder),
                ),
                child: matchIcon(icon, iconName,
                    size: 21, color: AppColors.goldDark),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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

class _Tabs extends StatelessWidget {
  const _Tabs({super.key, required this.index, required this.onPick});
  final int index;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    const labels = ['Details', 'Partner preferences'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (var i = 0; i < 2; i++)
            Expanded(
              child: Semantics(
                selected: i == index,
                button: true,
                child: Material(
                  color: i == index ? Colors.white : Colors.transparent,
                  elevation: i == index ? 1 : 0,
                  shadowColor: AppColors.tealDark.withValues(alpha: 0.2),
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => onPick(i),
                    child: SizedBox(
                      height: 42,
                      child: Center(
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                i == index ? FontWeight.w700 : FontWeight.w600,
                            color: i == index
                                ? AppColors.navy
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.iconName,
    required this.accent,
    required this.tint,
    required this.child,
  });

  final String title;
  final IconData icon;
  final String iconName;
  final Color accent;
  final Color tint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, tint],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: matchIcon(icon, iconName, size: 19, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Rows extends StatelessWidget {
  const _Rows(this.rows);
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.blueTintBorder),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    rows[i].$1,
                    style: const TextStyle(
                        fontSize: 13.5, color: AppColors.textMuted),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    rows[i].$2,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MatchBanner extends StatelessWidget {
  const _MatchBanner({
    required this.matched,
    required this.total,
    required this.pronoun,
    required this.onTap,
  });
  final int matched;
  final int total;
  final String pronoun;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.tealB, AppColors.tealC],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 42,
                  child: Stack(
                    children: [
                      _MiniAvatar(left: 0),
                      _MiniAvatar(left: 26),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You match $matched/$total',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.sparkleGold,
                        ),
                      ),
                      Text(
                        'of $pronoun partner preferences',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                matchIcon(Icons.chevron_right_rounded, 'arrow_right',
                    size: 24, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar({required this.left});
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blueTint,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const ClipOval(child: CustomPaint(painter: AvatarPainter())),
      ),
    );
  }
}

class _MatchHeader extends StatelessWidget {
  const _MatchHeader({
    required this.matched,
    required this.total,
    required this.pronoun,
    required this.female,
  });
  final int matched;
  final int total;
  final String pronoun;
  final bool female;

  @override
  Widget build(BuildContext context) {
    Widget person(String label) => Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blueTint,
                border: Border.all(color: AppColors.sparkleGold, width: 2.5),
              ),
              child:
                  const ClipOval(child: CustomPaint(painter: AvatarPainter())),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              person('You'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Text(
                        '$matched/$total',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.sparkleGold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: total == 0 ? 0 : matched / total,
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.marigoldO),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              person(pronoun),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: 'You match ',
              children: [
                TextSpan(
                  text: '$matched of $total',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.marigoldY),
                ),
                TextSpan(text: ' of ${pronoun.toLowerCase()} preferences'),
              ],
            ),
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  const _SimilarCard({required this.p, required this.onOpen});
  final SimilarProfile p;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.blueTintBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: AppColors.blueTint),
                    if (p.photoUrl != null)
                      Image.network(p.photoUrl!, fit: BoxFit.cover)
                    else
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 104,
                          height: 140,
                          child: CustomPaint(painter: AvatarPainter()),
                        ),
                      ),
                    if (p.awaiting)
                      Positioned(
                        left: 6,
                        right: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.goldSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Awaiting Response',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldDark,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 2),
                    Text(p.line1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11.5,
                            height: 1.3,
                            color: AppColors.textMuted)),
                    Text(p.line2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11.5, color: AppColors.textMuted)),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  'View profile',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.link,
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