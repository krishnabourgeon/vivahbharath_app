import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────────────────────────────
enum InboxSection {
  interests('Interests', ['Received', 'Sent']),
  requests('Requests', ['Received', 'Sent']),
  shortlisted('Shortlisted', ['Shortlisted Me', 'Shortlisted By Me']),
  contacts('Contact Numbers View', ['By You', 'By Others']);

  const InboxSection(this.label, this.views);
  final String label;
  final List<String> views;
}

enum InboxStatus { pending, accepted, declined }

enum RequestKind {
  name('Name', 'name', Icons.badge_outlined),
  photo('Photo', 'photos', Icons.photo_camera_outlined),
  number('Number', 'number', Icons.call_outlined),
  horoscope('Horoscope', 'horoscope', Icons.auto_awesome_outlined);

  const RequestKind(this.label, this.noun, this.icon);
  final String label;
  final String noun; // "Asked to see your photos"
  final IconData icon;
}

enum HistoryRange {
  all('All time', 100000),
  today('Today', 0),
  week('Last 7 days', 7),
  month('Last 30 days', 30);

  const HistoryRange(this.label, this.maxDays);
  final String label;
  final int maxDays;
}

class InboxPerson {
  InboxPerson({
    required this.name,
    required this.lastSeen,
    required this.line1,
    required this.line2,
    required this.line3,
    this.id = 'VB[ID]',
    this.nameHidden = false,
    this.featured = false,
    this.photoRequested = false,
    this.online = false,
    this.shortlisted = false,
    this.photoUrl,
  });

  final String id;
  final String name;
  final String lastSeen;
  final String line1; // 25 Yrs · 5'2" · Hindu · Nair
  final String line2; // Masters Degree · Teacher
  final String line3; // Kozhikode · Kerala · India
  final bool nameHidden;
  final bool featured;
  final bool photoRequested;
  final bool online;
  final String? photoUrl;
  bool shortlisted;
}

class InboxEntry {
  InboxEntry(
    this.person, {
    required this.when,
    this.daysAgo = 0,
    this.status = InboxStatus.pending,
    this.kind,
    this.phone,
  });

  final InboxPerson person;
  final String when; // "2 days ago", "today"
  final int daysAgo; // used by the Shortlisted History filter
  InboxStatus status;
  final RequestKind? kind; // requests only
  final String? phone; // contact numbers only
}

// ── Sample data (from the app designs). TODO: load from your API. ───────────
class InboxData {
  InboxData() {
    final a = InboxPerson(
      name: '[Name]',
      lastSeen: 'Last seen 2 weeks ago',
      line1: '28 Yrs · 5\'4" · [Religion] · [Community]',
      line2: 'Bachelors Degree · Software Engineer',
      line3: 'Malappuram · Kerala · India',
    );
    final b = InboxPerson(
      name: '[Name]',
      lastSeen: 'Last seen 3 hours ago',
      line1: '25 Yrs · 5\'2" · Hindu · Nair',
      line2: 'Masters Degree · Teacher',
      line3: 'Kozhikode · Kerala · India',
      online: true,
    );
    final c = InboxPerson(
      name: '[Name]',
      lastSeen: 'Last seen 1 day ago',
      line1: '27 Yrs · 5\'5" · Hindu · Ezhava',
      line2: 'Bachelors Degree · Designer',
      line3: 'Thrissur · Kerala · India',
    );
    final d = InboxPerson(
      name: '[Name]',
      lastSeen: 'Last seen 55 minutes ago',
      line1: '26 Yrs · 5\'3" · Hindu · Nair',
      line2: 'MBBS · Doctor',
      line3: 'Kannur · Kerala · India',
      online: true,
    );
    final e = InboxPerson(
      name: '[Name]',
      lastSeen: 'Last seen 5 hours ago',
      line1: '24 Yrs · 5\'1" · Hindu · Nair',
      line2: 'Bachelors Degree · Accountant',
      line3: 'Kochi · Kerala · India',
    );
    final f = InboxPerson(
      name: 'Maxxxxxxxx',
      nameHidden: true,
      photoRequested: true,
      lastSeen: 'Last seen 1 week ago',
      line1: '24 Yrs · 4\'9" · Hindu · Thiyya',
      line2: 'Bachelors Degree · Software Developer',
      line3: 'Kozhikode · Kerala · India',
    );
    final g = InboxPerson(
      name: '[Name]',
      lastSeen: 'Last seen 2 hours ago',
      line1: '26 Yrs · 5\'3" · Hindu · Nair',
      line2: 'Bachelors Degree · Accountant',
      line3: 'Kochi · Kerala · India',
    );
    final h = InboxPerson(
      name: 'Axxxxxxxx',
      nameHidden: true,
      lastSeen: 'Last seen 5 days ago',
      line1: '28 Yrs · 5\'4" · Hindu · Ezhava',
      line2: 'Masters Degree · Lecturer',
      line3: 'Palakkad · Kerala · India',
    );
    final rahul = InboxPerson(
      id: 'VM2382',
      name: 'Rahul CK',
      lastSeen: 'Last seen 1 month ago',
      line1: '26 Yrs · 5\'4" · Hindu · Thiyya',
      line2: 'Master Degree · Software Developer',
      line3: 'Kozhikode · Kerala · India',
      photoRequested: true,
      shortlisted: true,
    );
    final rax = InboxPerson(
      id: 'VM2760',
      name: 'Raxxxxxxxx',
      nameHidden: true,
      featured: true,
      photoRequested: true,
      lastSeen: 'Last seen 5 hours ago',
      line1: '36 Yrs · 5\'8" · Hindu · Nair',
      line2: 'Bachelors Degree · Software Engineer',
      line3: 'Kozhikode · Kerala · India',
      shortlisted: true,
    );
    d.shortlisted = true;

    const accepted = InboxStatus.accepted;
    const declined = InboxStatus.declined;

    interestsReceived = [
      InboxEntry(a, when: '2 weeks ago', status: accepted),
      InboxEntry(b, when: 'today'),
      InboxEntry(c, when: 'yesterday'),
      InboxEntry(d, when: '3 days ago', status: declined),
    ];
    interestsSent = [
      InboxEntry(a, when: '2 weeks ago'),
      InboxEntry(b, when: 'today', status: accepted),
      InboxEntry(c, when: 'yesterday'),
      InboxEntry(d, when: '3 days ago'),
    ];
    requestsReceived = [
      InboxEntry(b, when: 'today', kind: RequestKind.photo),
      InboxEntry(e,
          when: '4 days ago', kind: RequestKind.photo, status: accepted),
      InboxEntry(c, when: '1 day ago', kind: RequestKind.number),
      InboxEntry(d,
          when: '1 week ago', kind: RequestKind.horoscope, status: declined),
    ];
    requestsSent = [
      InboxEntry(b, when: 'today', kind: RequestKind.photo),
      InboxEntry(e,
          when: '4 days ago', kind: RequestKind.photo, status: accepted),
      InboxEntry(a, when: '2 days ago', kind: RequestKind.name),
      InboxEntry(c,
          when: 'last week', kind: RequestKind.horoscope, status: accepted),
    ];
    shortlistedMe = [
      InboxEntry(b, when: 'today'),
      InboxEntry(c, when: '2 days ago', daysAgo: 2),
      InboxEntry(d, when: 'last week', daysAgo: 7),
    ];
    shortlistedByMe = [
      InboxEntry(rahul, when: 'today'),
      InboxEntry(rax, when: '2 days ago', daysAgo: 2),
      InboxEntry(d, when: '3 weeks ago', daysAgo: 21),
    ];
    contactsByYou = [
      InboxEntry(b, when: '2 days ago', phone: '+91 [Mobile number]'),
      InboxEntry(c, when: 'last week', phone: '+91 [Mobile number]'),
      InboxEntry(d, when: '2 weeks ago', phone: '+91 [Mobile number]'),
    ];
    contactsByOthers = [
      InboxEntry(f, when: '1 week ago'),
      InboxEntry(g, when: 'yesterday'),
      InboxEntry(h, when: '3 days ago'),
    ];
  }

  late List<InboxEntry> interestsReceived;
  late List<InboxEntry> interestsSent;
  late List<InboxEntry> requestsReceived;
  late List<InboxEntry> requestsSent;
  late List<InboxEntry> shortlistedMe;
  late List<InboxEntry> shortlistedByMe;
  late List<InboxEntry> contactsByYou;
  late List<InboxEntry> contactsByOthers;

  /// Contact views on the current package.
  int contactViewsUsed = 3;
  int contactViewsTotal = 10;
  String packageName = 'Launching offer';
}

// ─────────────────────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────────────────────
class InboxScreen extends StatefulWidget {
  const InboxScreen({
    super.key,
    this.initialSection = InboxSection.interests,
    this.initialView = 0,
  });

  final InboxSection initialSection;

  /// 0 = Received / Shortlisted Me / By You, 1 = Sent / Shortlisted By Me / By Others.
  final int initialView;

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final InboxData _data = InboxData();
  late InboxSection _section = widget.initialSection;
  late int _view = widget.initialView;
  InboxStatus? _status; // null = All
  RequestKind _kind = RequestKind.photo;
  HistoryRange _history = HistoryRange.all;
  final Set<InboxPerson> _interestSentTo = {};

  bool get _received => _view == 0;

  List<InboxEntry> get _source => switch (_section) {
        InboxSection.interests =>
          _received ? _data.interestsReceived : _data.interestsSent,
        InboxSection.requests =>
          _received ? _data.requestsReceived : _data.requestsSent,
        InboxSection.shortlisted =>
          _received ? _data.shortlistedMe : _data.shortlistedByMe,
        InboxSection.contacts =>
          _received ? _data.contactsByYou : _data.contactsByOthers,
      };

  /// Entries before the status filter (requests are narrowed to the kind).
  List<InboxEntry> get _base {
    var l = _source;
    if (_section == InboxSection.requests) {
      l = l.where((e) => e.kind == _kind).toList();
    }
    if (_section == InboxSection.shortlisted && !_received) {
      l = l.where((e) => e.daysAgo <= _history.maxDays).toList();
    }
    return l;
  }

  List<InboxEntry> get _visible => _status == null
      ? _base
      : _base.where((e) => e.status == _status).toList();

  int _count(List<InboxEntry> l, InboxStatus s) =>
      l.where((e) => e.status == s).length;

  void _pickSection(InboxSection s) => setState(() {
        _section = s;
        _view = 0;
        _status = null;
      });

  void _pickView(int v) => setState(() {
        _view = v;
        _status = null;
      });

  // ── Actions ────────────────────────────────────────────────────────────────
  void _toast(String msg, {VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(milliseconds: 3500),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                textColor: AppColors.goldBorder,
                onPressed: onUndo,
              ),
      ));
  }

  void _setStatus(InboxEntry e, InboxStatus s, String msg) {
    final old = e.status;
    setState(() => e.status = s);
    _toast(msg, onUndo: () => setState(() => e.status = old));
  }

  void _removeFrom(List<InboxEntry> list, InboxEntry e, String msg) {
    final i = list.indexOf(e);
    setState(() {
      list.removeAt(i);
      e.person.shortlisted = false;
    });
    _toast(msg, onUndo: () => setState(() {
          list.insert(i, e);
          e.person.shortlisted = true;
        }));
  }

  void _sendInterest(InboxPerson p) {
    setState(() => _interestSentTo.add(p));
    _toast('Interest sent');
  }

  void _toggleShortlist(InboxPerson p) {
    setState(() => p.shortlisted = !p.shortlisted);
    _toast(p.shortlisted
        ? 'Added to your shortlist'
        : 'Removed from your shortlist');
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final rows = _visible;

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
              const SearchTopBar(title: 'Inbox'),
              // Section tabs (web: Filter Interest / Filter Request / Shortlisted / Contact Numbers View)
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: InboxSection.values.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final s = InboxSection.values[i];
                    return FilterPill(
                      label: s.label,
                      selected: s == _section,
                      onTap: () => _pickSection(s),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _Segmented(
                  labels: _section.views,
                  index: _view,
                  onPick: _pickView,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    _hero(),
                    const SizedBox(height: 14),
                    if (_section == InboxSection.requests) ...[
                      _KindGrid(
                        current: _kind,
                        counts: {
                          for (final k in RequestKind.values)
                            k: _source.where((e) => e.kind == k).length,
                        },
                        onPick: (k) => setState(() {
                          _kind = k;
                          _status = null;
                        }),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_section == InboxSection.interests ||
                        _section == InboxSection.requests) ...[
                      _statusChips(),
                      const SizedBox(height: 14),
                    ],
                    if (_section == InboxSection.shortlisted && !_received) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${rows.length} ${rows.length == 1 ? 'profile' : 'profiles'}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          _HistoryDropdown(
                            value: _history,
                            onPick: (h) => setState(() => _history = h),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (rows.isEmpty) _EmptyBox(_emptyText()),
                    for (final e in rows) ...[
                      _InboxCard(
                        entry: e,
                        activity: _activity(e),
                        onShortlist: () => _toggleShortlist(e.person),
                        middle: _section == InboxSection.contacts && _received
                            ? _PhoneBox(
                                phone: e.phone ?? '',
                                onCall: () {/* TODO: call */},
                                onChat: () {/* TODO: chat */},
                              )
                            : null,
                        actions: _actions(e),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero summary per view ────────────────────────────────────────────────
  Widget _hero() {
    final all = _base;
    final counts = [
      ('Pending', _count(all, InboxStatus.pending)),
      (
        _section == InboxSection.requests ? 'Approved' : 'Accepted',
        _count(all, InboxStatus.accepted)
      ),
      ('Declined', _count(all, InboxStatus.declined)),
    ];
    final n = _source.length;

    switch (_section) {
      case InboxSection.interests:
        return _Hero(
          icon: Icons.favorite_rounded,
          iconName: 'heart',
          title: _received
              ? '$n ${n == 1 ? 'person is' : 'people are'} interested'
              : "You've sent $n ${n == 1 ? 'interest' : 'interests'}",
          subtitle: _received
              ? 'Respond to keep the conversation going'
              : "We'll let you know as soon as they reply",
          counts: counts,
        );
      case InboxSection.requests:
        return _Hero(
          icon: Icons.lock_outline_rounded,
          iconName: 'lock',
          title: _received ? 'Requests for your details' : 'Your requests',
          subtitle: _received
              ? 'You decide who can see your private details'
              : "Ask to see a member's name, photo, number or horoscope",
          counts: counts,
        );
      case InboxSection.shortlisted:
        return _Hero(
          icon: Icons.star_rounded,
          iconName: 'star',
          title: _received
              ? '$n ${n == 1 ? 'person' : 'people'} shortlisted you'
              : "You've shortlisted $n ${n == 1 ? 'profile' : 'profiles'}",
          subtitle: _received
              ? "You're on their favourite list!"
              : 'Your saved favourites, in one place',
        );
      case InboxSection.contacts:
        final used = _data.contactViewsUsed, total = _data.contactViewsTotal;
        return _Hero(
          icon: Icons.call_rounded,
          iconName: 'call',
          title: _received
              ? "Numbers you've viewed"
              : '$n ${n == 1 ? 'member' : 'members'} viewed your number',
          subtitle: _received
              ? "Call or message the families you've connected with"
              : 'They may call you soon. Keep your phone handy!',
          footer: _received
              ? _ContactViewsMeter(
                  used: used,
                  total: total,
                  packageName: _data.packageName,
                  onGetMore: () {/* TODO: open subscription */},
                )
              : null,
        );
    }
  }

  Widget _statusChips() {
    final all = _base;
    final items = <(InboxStatus?, String)>[
      (null, 'All (${all.length})'),
      (InboxStatus.pending, 'Pending (${_count(all, InboxStatus.pending)})'),
      (InboxStatus.accepted, 'Accepted (${_count(all, InboxStatus.accepted)})'),
      (InboxStatus.declined, 'Declined (${_count(all, InboxStatus.declined)})'),
    ];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => FilterPill(
          label: items[i].$2,
          selected: items[i].$1 == _status,
          onTap: () => setState(() => _status = items[i].$1),
        ),
      ),
    );
  }

  String _emptyText() {
    final dir = _received ? 'received' : 'sent';
    switch (_section) {
      case InboxSection.interests:
        return 'No $dir interests here yet.';
      case InboxSection.requests:
        return 'No $dir ${_kind.label} requests.';
      case InboxSection.shortlisted:
        return _received
            ? 'No one has shortlisted you yet.'
            : 'No shortlisted profiles in this period.';
      case InboxSection.contacts:
        return _received
            ? 'You have not viewed any contact numbers yet.'
            : 'No one has viewed your number yet.';
    }
  }

  /// The small coloured line under the profile details.
  (IconData, String, String)? _activity(InboxEntry e) {
    switch (_section) {
      case InboxSection.interests:
        return (
          Icons.favorite_border_rounded,
          'heart',
          _received
              ? 'Sent you interest · ${e.when}'
              : 'You sent interest · ${e.when}'
        );
      case InboxSection.requests:
        final k = e.kind!;
        return (
          k.icon,
          k.label.toLowerCase(),
          _received
              ? 'Asked to see your ${k.noun} · ${e.when}'
              : 'You asked to see their ${k.noun} · ${e.when}'
        );
      case InboxSection.shortlisted:
        return (
          Icons.star_border_rounded,
          'star',
          _received
              ? 'Shortlisted you · ${e.when}'
              : 'You shortlisted · ${e.when}'
        );
      case InboxSection.contacts:
        return (
          Icons.visibility_outlined,
          'eye',
          _received
              ? 'You viewed this number · ${e.when}'
              : 'Viewed your number · ${e.when}'
        );
    }
  }

  // ── Card actions per view ────────────────────────────────────────────────
  Widget? _actions(InboxEntry e) {
    final p = e.person;
    final sentInterest = _interestSentTo.contains(p);
    Widget sendInterestBtn() => sentInterest
        ? _statusPill(
            'Awaiting Response', Icons.schedule_rounded, _Tone.waiting)
        : _primary('Send Interest', Icons.send_rounded,
            () => _sendInterest(p));

    switch (_section) {
      // Interests
      case InboxSection.interests:
        switch (e.status) {
          case InboxStatus.pending:
            return _received
                ? _pair(
                    _outline('Decline', Icons.close_rounded,
                        () => _setStatus(e, InboxStatus.declined, 'Interest declined')),
                    _primary('Accept', Icons.check_rounded,
                        () => _setStatus(e, InboxStatus.accepted, 'Interest accepted')),
                  )
                : _pair(
                    _statusPill('Awaiting response', Icons.schedule_rounded,
                        _Tone.waiting),
                    _outline('Withdraw', Icons.undo_rounded, () {
                      final list = _data.interestsSent;
                      final i = list.indexOf(e);
                      setState(() => list.removeAt(i));
                      _toast('Interest withdrawn',
                          onUndo: () => setState(() => list.insert(i, e)));
                    }),
                  );
          case InboxStatus.accepted:
            return _pair(
              _statusPill('Accepted', Icons.check_rounded, _Tone.ok),
              _cream('Chat now', Icons.chat_bubble_outline_rounded,
                  () {/* TODO: open chat */}),
            );
          case InboxStatus.declined:
            return _received
                ? _statusWithLink('Declined', 'Undo',
                    () => setState(() => e.status = InboxStatus.pending))
                : _statusPill('Declined', Icons.close_rounded, _Tone.bad);
        }

      // Requests
      case InboxSection.requests:
        final k = e.kind!;
        switch (e.status) {
          case InboxStatus.pending:
            return _received
                ? _pair(
                    _outline('Decline', Icons.close_rounded,
                        () => _setStatus(e, InboxStatus.declined, 'Request declined')),
                    _primary('Approve', Icons.check_rounded,
                        () => _setStatus(e, InboxStatus.accepted,
                            '${k.label} shared')),
                  )
                : _pair(
                    _statusPill('Awaiting response', Icons.schedule_rounded,
                        _Tone.waiting),
                    _outline('Withdraw', Icons.undo_rounded, () {
                      final list = _data.requestsSent;
                      final i = list.indexOf(e);
                      setState(() => list.removeAt(i));
                      _toast('Request withdrawn',
                          onUndo: () => setState(() => list.insert(i, e)));
                    }),
                  );
          case InboxStatus.accepted:
            return _received
                ? _statusWithLink('${k.label} shared', 'Revoke access',
                    () => _setStatus(e, InboxStatus.declined, 'Access revoked'),
                    tone: _Tone.ok)
                : _pair(
                    _statusPill('Approved', Icons.check_rounded, _Tone.ok),
                    _primary('View ${k.noun}', Icons.visibility_outlined,
                        () {/* TODO: open */}),
                  );
          case InboxStatus.declined:
            return _received
                ? _statusWithLink('Declined', 'Undo',
                    () => setState(() => e.status = InboxStatus.pending))
                : _statusPill('Declined', Icons.close_rounded, _Tone.bad);
        }

      // Shortlisted
      case InboxSection.shortlisted:
        return _received
            ? _pair(
                p.shortlisted
                    ? _statusPill('Shortlisted', Icons.favorite_rounded, _Tone.ok)
                    : _outline('Shortlist back', Icons.favorite_border_rounded,
                        () => _toggleShortlist(p)),
                sendInterestBtn(),
              )
            : _pair(
                _outline('Remove', Icons.close_rounded,
                    () => _removeFrom(_data.shortlistedByMe, e,
                        'Removed from your shortlist')),
                sendInterestBtn(),
              );

      // Contacts
      case InboxSection.contacts:
        return _received ? null : sendInterestBtn();
    }
  }

  Widget _pair(Widget a, Widget b) => Row(
        children: [
          Expanded(child: a),
          const SizedBox(width: 8),
          Expanded(child: b),
        ],
      );

  Widget _primary(String label, IconData icon, VoidCallback onTap) =>
      PillButton(
        label: label,
        icon: matchIcon(icon, label.toLowerCase(), size: 17, color: Colors.white),
        foreground: Colors.white,
        gradient: kTealGradient,
        onTap: onTap,
      );

  Widget _outline(String label, IconData icon, VoidCallback onTap) =>
      PillButton(
        label: label,
        icon: matchIcon(icon, label.toLowerCase(),
            size: 17, color: AppColors.navy),
        foreground: AppColors.navy,
        background: Colors.white,
        borderColor: AppColors.fieldBorder,
        onTap: onTap,
      );

  Widget _cream(String label, IconData icon, VoidCallback onTap) => PillButton(
        label: label,
        icon: matchIcon(icon, 'chat', size: 17, color: AppColors.goldDark),
        foreground: AppColors.goldDark,
        gradient:
            const LinearGradient(colors: [AppColors.loginA, AppColors.loginB]),
        borderColor: AppColors.goldBorder,
        onTap: onTap,
      );

  Widget _statusPill(String label, IconData icon, _Tone tone) {
    final (bg, fg) = tone.colors;
    return PillButton(
      label: label,
      icon: matchIcon(icon, 'status', size: 16, color: fg),
      foreground: fg,
      background: bg,
      onTap: null,
    );
  }

  Widget _statusWithLink(String label, String link, VoidCallback onTap,
      {_Tone tone = _Tone.bad}) {
    final (bg, fg) = tone.colors;
    return Row(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              matchIcon(
                  tone == _Tone.ok ? Icons.check_rounded : Icons.close_rounded,
                  'status',
                  size: 15,
                  color: fg),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: fg)),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(foregroundColor: AppColors.link),
          child: Text(link,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

enum _Tone {
  ok,
  bad,
  waiting;

  (Color, Color) get colors => switch (this) {
        _Tone.ok => (
            AppColors.verified.withValues(alpha: 0.12),
            AppColors.verified
          ),
        _Tone.bad => (AppColors.coral.withValues(alpha: 0.1), AppColors.coral),
        _Tone.waiting => (AppColors.toggleBg, AppColors.goldDark),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.labels,
    required this.index,
    required this.onPick,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
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
                      height: 40,
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

class _Hero extends StatelessWidget {
  const _Hero({
    required this.icon,
    required this.iconName,
    required this.title,
    required this.subtitle,
    this.counts,
    this.footer,
  });

  final IconData icon;
  final String iconName;
  final String title;
  final String subtitle;
  final List<(String, int)>? counts;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sparkleGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: matchIcon(icon, iconName,
                    size: 22, color: AppColors.goldDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (counts != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                for (var i = 0; i < counts!.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${counts![i].$2}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            counts![i].$1,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 14),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _ContactViewsMeter extends StatelessWidget {
  const _ContactViewsMeter({
    required this.used,
    required this.total,
    required this.packageName,
    required this.onGetMore,
  });

  final int used;
  final int total;
  final String packageName;
  final VoidCallback onGetMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Contact views used · $packageName',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '$used of $total',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.marigoldY,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : used / total,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.marigoldO),
            ),
          ),
          TextButton(
            onPressed: onGetMore,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.marigoldY,
            ),
            child: const Text(
              'Get more contact views',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.marigoldY,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KindGrid extends StatelessWidget {
  const _KindGrid({
    required this.current,
    required this.counts,
    required this.onPick,
  });

  final RequestKind current;
  final Map<RequestKind, int> counts;
  final ValueChanged<RequestKind> onPick;

  @override
  Widget build(BuildContext context) {
    Widget tile(RequestKind k) {
      final sel = k == current;
      final fg = sel ? Colors.white : AppColors.navy;
      return Expanded(
        child: Material(
          color: sel ? AppColors.tealMid : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
                color: sel ? AppColors.tealMid : AppColors.fieldBorder),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onPick(k),
            child: SizedBox(
              height: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  matchIcon(k.icon, k.label.toLowerCase(), size: 17, color: fg),
                  const SizedBox(width: 6),
                  Text(
                    '${k.label} (${counts[k] ?? 0})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final k = RequestKind.values;
    return Column(
      children: [
        Row(children: [tile(k[0]), const SizedBox(width: 8), tile(k[1])]),
        const SizedBox(height: 8),
        Row(children: [tile(k[2]), const SizedBox(width: 8), tile(k[3])]),
      ],
    );
  }
}

class _HistoryDropdown extends StatelessWidget {
  const _HistoryDropdown({required this.value, required this.onPick});

  final HistoryRange value;
  final ValueChanged<HistoryRange> onPick;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HistoryRange>(
      tooltip: 'Shortlisted history',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.blueTintBorder),
      ),
      onSelected: onPick,
      itemBuilder: (_) => [
        const PopupMenuItem<HistoryRange>(
          enabled: false,
          height: 32,
          child: Text(
            'SHORTLISTED HISTORY',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ),
        for (final h in HistoryRange.values)
          PopupMenuItem<HistoryRange>(
            value: h,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    h.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          h == value ? FontWeight.w700 : FontWeight.w500,
                      color: h == value ? AppColors.tealMid : AppColors.navy,
                    ),
                  ),
                ),
                if (h == value)
                  matchIcon(Icons.check_rounded, 'check',
                      size: 18, color: AppColors.tealMid),
              ],
            ),
          ),
      ],
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.loginA, AppColors.loginB]),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.goldBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            matchIcon(Icons.history_rounded, 'history',
                size: 17, color: AppColors.goldDark),
            const SizedBox(width: 6),
            Text(
              value.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.goldDark,
              ),
            ),
            const SizedBox(width: 2),
            matchIcon(Icons.keyboard_arrow_down_rounded, 'arrow_down',
                size: 18, color: AppColors.goldDark),
          ],
        ),
      ),
    );
  }
}

class _InboxCard extends StatelessWidget {
  const _InboxCard({
    required this.entry,
    required this.activity,
    required this.onShortlist,
    this.middle,
    this.actions,
  });

  final InboxEntry entry;
  final (IconData, String, String)? activity;
  final VoidCallback onShortlist;
  final Widget? middle;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final p = entry.person;
    final featured = p.featured;

    final card = Container(
      margin: EdgeInsets.only(top: featured ? 10 : 0),
      decoration: BoxDecoration(
        color: featured ? null : Colors.white,
        gradient: featured
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.loginA, Colors.white],
                stops: [0, 0.45],
              )
            : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: featured ? AppColors.goldBorder : AppColors.blueTintBorder,
          width: featured ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {/* TODO: open profile */},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SmallPhoto(person: p, onShortlist: onShortlist),
                    const SizedBox(width: 12),
                    Expanded(child: _details(p)),
                  ],
                ),
                if (middle != null) ...[
                  const SizedBox(height: 12),
                  middle!,
                ],
                if (actions != null) ...[
                  const SizedBox(height: 12),
                  actions!,
                ] else if (activity != null && middle != null) ...[
                  const SizedBox(height: 8),
                  _activityLine(muted: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (!featured) return card;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: 0,
          left: 14,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 3, 10, 3),
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                matchIcon(Icons.workspace_premium_rounded, 'crown',
                    size: 13, color: AppColors.goldDark),
                const SizedBox(width: 4),
                const Text(
                  'Featured profile',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _details(InboxPerson p) {
    const detail =
        TextStyle(fontSize: 13, height: 1.4, color: AppColors.navy);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Semantics(
              label: 'Verified',
              child: matchIcon(Icons.verified_rounded, 'verified',
                  size: 16, color: AppColors.verified),
            ),
            if (p.nameHidden) ...[
              const SizedBox(width: 4),
              Semantics(
                label: 'Name hidden',
                child: matchIcon(Icons.visibility_off_outlined, 'eye_off',
                    size: 15, color: AppColors.coral),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${p.id} · ${p.lastSeen}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 4),
        Text(p.line1, style: detail),
        Text(p.line2, style: detail),
        Text(p.line3, style: detail),
        // In the contact "By You" view the activity sits under the phone box.
        if (activity != null && middle == null) ...[
          const SizedBox(height: 6),
          _activityLine(),
        ],
      ],
    );
  }

  Widget _activityLine({bool muted = false}) {
    final (icon, name, text) = activity!;
    final color = muted ? AppColors.textMuted : AppColors.brown;
    return Row(
      children: [
        matchIcon(icon, name, size: 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: muted ? FontWeight.w500 : FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallPhoto extends StatelessWidget {
  const _SmallPhoto({required this.person, required this.onShortlist});

  final InboxPerson person;
  final VoidCallback onShortlist;

  @override
  Widget build(BuildContext context) {
    final p = person;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 96,
        height: 124,
        color: AppColors.blueTint,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (p.photoUrl != null)
              Image.network(p.photoUrl!, fit: BoxFit.cover)
            else
              const CustomPaint(painter: AvatarPainter()),
            Positioned(
              top: 6,
              left: 6,
              child: Semantics(
                button: true,
                label: p.shortlisted ? 'Remove from shortlist' : 'Shortlist',
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onShortlist,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: matchIcon(
                          p.shortlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          p.shortlisted ? 'heart_filled' : 'heart',
                          size: 16,
                          color:
                              p.shortlisted ? AppColors.coral : AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (p.online)
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.online,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            if (p.photoRequested)
              Positioned(
                left: 5,
                right: 5,
                bottom: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      matchIcon(Icons.camera_alt_outlined, 'camera',
                          size: 11, color: Colors.white),
                      const SizedBox(width: 3),
                      const Expanded(
                        child: Text(
                          'Awaiting Response',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
}

class _PhoneBox extends StatelessWidget {
  const _PhoneBox({
    required this.phone,
    required this.onCall,
    required this.onChat,
  });

  final String phone;
  final VoidCallback onCall;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          matchIcon(Icons.call_outlined, 'call',
              size: 18, color: AppColors.verified),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              phone,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          CircleIconButton(
            tooltip: 'Call',
            size: 40,
            background: AppColors.tealMid,
            icon: matchIcon(Icons.call_rounded, 'call',
                size: 18, color: Colors.white),
            onTap: onCall,
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            tooltip: 'Message',
            size: 40,
            icon: matchIcon(Icons.chat_bubble_outline_rounded, 'chat',
                size: 18, color: AppColors.goldDark),
            onTap: onChat,
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBorder.withValues(alpha: 0.6)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
      ),
    );
  }
}