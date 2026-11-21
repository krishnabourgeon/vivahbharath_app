// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
// import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
// import 'package:vivahbharath_app/view/drawer/common_activity.dart';


// class InterestItem {
//   InterestItem(this.person, {required this.when, this.status = ActStatus.pending});
//   final ActivityPerson person;
//   final String when;
//   ActStatus status;
// }

// /// Sample data from the app designs — replace with your API.
// List<InterestItem> sampleInterestsReceived() => [
//       InterestItem(SamplePeople.b, when: 'today'),
//       InterestItem(SamplePeople.c, when: 'yesterday'),
//       InterestItem(SamplePeople.a, when: '2 weeks ago', status: ActStatus.accepted),
//       InterestItem(SamplePeople.d, when: '3 days ago', status: ActStatus.declined),
//     ];

// List<InterestItem> sampleInterestsSent() => [
//       InterestItem(SamplePeople.a, when: '2 weeks ago'),
//       InterestItem(SamplePeople.b, when: 'today', status: ActStatus.accepted),
//       InterestItem(SamplePeople.c, when: 'yesterday'),
//       InterestItem(SamplePeople.d, when: '3 days ago'),
//     ];

// class ManageInterestScreen extends StatefulWidget {
//   const ManageInterestScreen({
//     super.key,
//     this.initialTab = 0,
//     this.received,
//     this.sent,
//     this.onAccept,
//     this.onDecline,
//     this.onWithdraw,
//     this.onOpenProfile,
//     this.showBottomNav = true,
//   });

//   /// 0 = Received, 1 = Sent.
//   final int initialTab;
//   final List<InterestItem>? received;
//   final List<InterestItem>? sent;

//   // TODO: connect to your API.
//   final void Function(InterestItem item)? onAccept;
//   final void Function(InterestItem item)? onDecline;
//   final void Function(InterestItem item)? onWithdraw;
//   final void Function(ActivityPerson person)? onOpenProfile;
//   final bool showBottomNav;

//   @override
//   State<ManageInterestScreen> createState() => _ManageInterestScreenState();
// }

// class _ManageInterestScreenState extends State<ManageInterestScreen> {
//   late int _tab = widget.initialTab;
//   late final List<InterestItem> _received =
//       widget.received ?? sampleInterestsReceived();
//   late final List<InterestItem> _sent = widget.sent ?? sampleInterestsSent();
//   ActStatus? _filter; // null = all

//   List<InterestItem> get _list => _tab == 0 ? _received : _sent;
//   List<InterestItem> get _visible =>
//       _filter == null ? _list : _list.where((i) => i.status == _filter).toList();
//   int _count(ActStatus s) => _list.where((i) => i.status == s).length;

//   void _set(InterestItem i, ActStatus s, String msg) {
//     final old = i.status;
//     setState(() => i.status = s);
//     showActivityToast(context, msg,
//         onUndo: () => setState(() => i.status = old));
//   }

//   Future<void> _withdraw(InterestItem i) async {
//     final ok = await confirmAction(
//       context,
//       title: 'Withdraw interest?',
//       message: 'They will no longer see your interest.',
//       confirm: 'Withdraw',
//     );
//     if (!ok || !mounted) return;
//     final idx = _sent.indexOf(i);
//     setState(() => _sent.removeAt(idx));
//     widget.onWithdraw?.call(i);
//     showActivityToast(context, 'Interest withdrawn',
//         onUndo: () => setState(() => _sent.insert(idx, i)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final rows = _visible;
//     final received = _tab == 0;

//     return ActivityPage(
//       title: 'Manage Interest',
//       children: [
//         const SearchTopBar(title: 'Manage Interest'),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: ActSegmented(
//             labels: ['Received (${_received.length})', 'Sent (${_sent.length})'],
//             index: _tab,
//             onPick: (i) => setState(() {
//               _tab = i;
//               _filter = null;
//             }),
//           ),
//         ),
//         const SizedBox(height: 14),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//             children: [
//               // Stat tiles = filters
//               Row(
//                 children: [
//                   for (final (s, label, icon, color) in [
//                     (ActStatus.pending, 'Pending', Icons.schedule_rounded, AppColors.goldDark),
//                     (ActStatus.accepted, 'Accepted', Icons.favorite_rounded, AppColors.verified),
//                     (ActStatus.declined, 'Declined', Icons.close_rounded, AppColors.coral),
//                   ]) ...[
//                     if (s != ActStatus.pending) const SizedBox(width: 8),
//                     Expanded(
//                       child: _StatTile(
//                         label: label,
//                         count: _count(s),
//                         icon: icon,
//                         color: color,
//                         selected: _filter == s,
//                         onTap: () => setState(
//                             () => _filter = _filter == s ? null : s),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _filter == null
//                           ? (received
//                               ? 'Interests you received'
//                               : "Interests you've sent")
//                           : '${_label(_filter!)} · ${rows.length}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.navy,
//                       ),
//                     ),
//                   ),
//                   if (_filter != null)
//                     TextButton(
//                       onPressed: () => setState(() => _filter = null),
//                       style:
//                           TextButton.styleFrom(foregroundColor: AppColors.link),
//                       child: const Text('Show all',
//                           style: TextStyle(fontWeight: FontWeight.w700)),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               if (rows.isEmpty)
//                 ActEmpty(
//                   icon: Icons.favorite_border_rounded,
//                   text: received
//                       ? 'No interests here yet.'
//                       : "You haven't sent any interests here yet.",
//                 ),
//               for (final i in rows) ...[
//                 ActivityCard(
//                   person: i.person,
//                   highlight: received && i.status == ActStatus.pending,
//                   noteIcon: Icons.favorite_border_rounded,
//                   note: received
//                       ? 'Sent you interest · ${i.when}'
//                       : 'You sent interest · ${i.when}',
//                   actions: _actions(i, received),
//                   onTap: () => widget.onOpenProfile?.call(i.person),
//                 ),
//                 const SizedBox(height: 14),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _label(ActStatus s) => switch (s) {
//         ActStatus.pending => 'Pending',
//         ActStatus.accepted => 'Accepted',
//         ActStatus.declined => 'Declined',
//       };

//   Widget _actions(InterestItem i, bool received) {
//     switch (i.status) {
//       case ActStatus.pending:
//         return received
//             ? actPair(
//                 actOutline('Decline', Icons.close_rounded, () {
//                   widget.onDecline?.call(i);
//                   _set(i, ActStatus.declined, 'Interest declined');
//                 }),
//                 actPrimary('Accept', Icons.check_rounded, () {
//                   widget.onAccept?.call(i);
//                   _set(i, ActStatus.accepted, 'Interest accepted. You can now chat.');
//                 }),
//               )
//             : actPair(
//                 actStatus('Awaiting response', Icons.schedule_rounded,
//                     ActTone.waiting),
//                 actOutline('Withdraw', Icons.undo_rounded, () => _withdraw(i)),
//               );
//       case ActStatus.accepted:
//         return actPair(
//           actStatus('Accepted', Icons.check_rounded, ActTone.ok),
//           actCream('Chat now', Icons.chat_bubble_outline_rounded,
//               () => openChatWith(context, i.person)),
//         );
//       case ActStatus.declined:
//         return received
//             ? actStatusWithLink('Declined', ActTone.bad, 'Undo',
//                 () => setState(() => i.status = ActStatus.pending))
//             : actStatus('Declined', Icons.close_rounded, ActTone.bad);
//     }
//   }
// }

// class _StatTile extends StatelessWidget {
//   const _StatTile({
//     required this.label,
//     required this.count,
//     required this.icon,
//     required this.color,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final int count;
//   final IconData icon;
//   final Color color;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       selected: selected,
//       button: true,
//       child: Material(
//         color: selected ? color : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(
//               color: selected ? color : AppColors.blueTintBorder),
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
//             child: Column(
//               children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: selected
//                         ? Colors.white.withValues(alpha: 0.2)
//                         : color.withValues(alpha: 0.12),
//                     shape: BoxShape.circle,
//                   ),
//                   child: matchIcon(icon, 'stat',
//                       size: 16, color: selected ? Colors.white : color),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   '$count',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: selected ? Colors.white : AppColors.navy,
//                   ),
//                 ),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: selected ? Colors.white : AppColors.textMuted,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/model/inbox_interest_model.dart';
import 'package:vivahbharath_app/provider/home_provider.dart';
import 'package:vivahbharath_app/view/custom/interest_actions.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/common_activity.dart';

/// Card person built from an API interest.
ActivityPerson activityPersonOf(Interest i) => ActivityPerson(
      id: i.profileId.isEmpty ? 'VB[ID]' : i.profileId,
      name: i.name,
      nameHidden: i.isNameHidden,
      lastSeen: i.isOnline ? 'Online now' : i.lastSeen,
      line1: i.line1,
      line2: i.line2,
      line3: i.line3,
      online: i.isOnline,
      verified: i.verified,
      photoUrl: i.photo,
    );

/// One screen's view of `GET inbox/interests`, loaded through
/// [HomeProvider.inboxMatches]. Used by Inbox and Manage Interest.
///
/// HomeProvider keeps a single [HomeProvider.inboxInterestModel], so each
/// load snapshots it here and ignores the result of a superseded load.
class InterestFeed {
  List<Interest> items = const [];
  StatusCounts counts = StatusCounts();
  bool loading = false;
  bool loaded = false;
  String? error;

  /// Interest ids with an accept / decline / withdraw in flight.
  final Set<int> busy = {};

  int _token = 0;

  bool isBusy(Interest i) => busy.contains(i.interestId);
  int count(InterestState s) => counts.of(s);

  /// Loads [dir] / [status] (null = all). Counts stay while loading so the
  /// filters don't flash to 0; pass [resetCounts] when the direction changes.
  Future<void> load(
    HomeProvider home,
    InterestDirection dir,
    InterestState? status, {
    required VoidCallback onChange,
    bool resetCounts = false,
  }) async {
    final token = ++_token;
    items = const [];
    loading = true;
    loaded = false;
    error = null;
    if (resetCounts) counts = StatusCounts();
    onChange();

    home.inboxInterestModel = null;
    await home.inboxMatches(dir.name, status?.name ?? 'all');
    if (token != _token) return;

    final m = home.inboxInterestModel;
    loading = false;
    loaded = true;
    if (m == null) {
      error = 'Could not load interests. Check your connection and try again.';
    } else {
      items = m.data;
      counts = m.statusCounts;
    }
    onChange();
  }

  /// Runs [call] with [i] marked busy. Returns null on success, else a message.
  Future<String?> _run(Interest i, Future<String?> Function() call,
      VoidCallback onChange) async {
    if (!busy.add(i.interestId)) return null;
    onChange();
    try {
      return await call();
    } finally {
      busy.remove(i.interestId);
      onChange();
    }
  }

  Future<String?> accept(Interest i, VoidCallback onChange) =>
      _run(i, () => respondInterestApi(i, accept: true), onChange);

  Future<String?> decline(Interest i, VoidCallback onChange) =>
      _run(i, () => respondInterestApi(i, accept: false), onChange);

  Future<String?> withdraw(Interest i, VoidCallback onChange) =>
      _run(i, () => withdrawInterestApi(i), onChange);

  Future<String?> delete(Interest i, VoidCallback onChange) =>
      _run(i, () => deleteWithdrawnApi(i), onChange);
}

InterestState _toState(ActStatus s) => InterestState.values.byName(s.name);

class ManageInterestScreen extends StatefulWidget {
  const ManageInterestScreen({
    super.key,
    this.initialTab = 0,
    this.initialFilter = ActStatus.pending,
    this.onOpenProfile,
    this.showBottomNav = true,
  });

  /// 0 = Received, 1 = Sent.
  final int initialTab;

  /// Which status tile is selected first.
  final ActStatus initialFilter;
  final void Function(Interest interest)? onOpenProfile;
  final bool showBottomNav;

  @override
  State<ManageInterestScreen> createState() => _ManageInterestScreenState();
}

class _ManageInterestScreenState extends State<ManageInterestScreen> {
  late int _tab = widget.initialTab;

  /// Always one of Pending / Accepted / Declined / Withdrawn (no "all" here).
  late ActStatus _filter = widget.initialFilter;
  final InterestFeed _feed = InterestFeed();

  bool get _receivedTab => _tab == 0;
  InterestDirection get _dir =>
      _receivedTab ? InterestDirection.received : InterestDirection.sent;

  HomeProvider get _home => context.read<HomeProvider>();

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load({bool resetCounts = false}) => _feed.load(
        _home,
        _dir,
        _toState(_filter),
        onChange: _changed,
        resetCounts: resetCounts,
      );

  void _pickFilter(ActStatus? s) {
    // Tapping the selected tile again keeps it selected.
    if (s == null || s == _filter) return;
    setState(() => _filter = s);
    _load();
  }

  void _pickTab(int i) {
    if (i == _tab) return;
    setState(() => _tab = i);
    _load(resetCounts: true);
  }

  void _toast(String msg) {
    if (mounted) showActivityToast(context, msg);
  }

  /// Shows [error] or [success], and reloads the list after a change.
  Future<void> _after(String? error, String success) async {
    _toast(error ?? success);
    if (error == null) await _load();
  }

  Future<void> _accept(Interest i) async =>
      _after(await _feed.accept(i, _changed),
          'Interest accepted. You can now chat.');

  Future<void> _decline(Interest i) async =>
      _after(await _feed.decline(i, _changed), 'Interest declined');

  Future<void> _delete(Interest i) async {
    final ok = await confirmAction(
      context,
      title: 'Delete this withdrawn interest?',
      message: 'It will be removed from your Withdrawn list.',
      confirm: 'Delete',
    );
    if (!ok || !mounted) return;
    await _after(await _feed.delete(i, _changed), 'Withdrawn interest deleted');
  }

  Future<void> _withdraw(Interest i) async {
    final ok = await confirmAction(
      context,
      title: 'Withdraw your interest?',
      message:
          'This interest will be removed for both of you. You can resend it later from their profile.',
      confirm: 'Withdraw',
    );
    if (!ok || !mounted) return;
    await _after(await _feed.withdraw(i, _changed), 'Interest withdrawn');
  }

  (String, String) get _header {
    if (_receivedTab) {
      return switch (_filter) {
        ActStatus.pending => ('Pending List', 'Members waiting for your reply'),
        ActStatus.accepted => ('Accepted List', 'Members you accepted'),
        ActStatus.declined => ('Declined List', 'Members you declined'),
        ActStatus.withdrawn =>
          ('Withdrawn List', 'Members who withdrew their interest'),
      };
    }
    return switch (_filter) {
      ActStatus.pending => ('Pending List', 'Waiting for their reply'),
      ActStatus.accepted =>
        ('Accepted List', 'Members who accepted your interest'),
      ActStatus.declined =>
        ('Declined List', 'Members who declined your interest'),
      ActStatus.withdrawn => ('Withdrawn List', 'Interests you withdrew'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final rows = _feed.items;
    final counts = <ActStatus, int>{
      for (final s in ActStatus.values) s: _feed.count(_toState(s)),
    };
    final (title, subtitle) = _header;

    return ActivityPage(
      title: 'Manage Interest',
      children: [
        const SearchTopBar(title: 'Manage your interest'),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                ActStatRow(
                  counts: counts,
                  selected: _filter,
                  onPick: _pickFilter,
                ),
                const SizedBox(height: 18),
                ActListHeader(title: title, subtitle: subtitle),
                const SizedBox(height: 12),
                ActSegmented(
                  labels: const ['Received', 'Sent'],
                  index: _tab,
                  onPick: _pickTab,
                ),
                const SizedBox(height: 14),
                if (rows.isEmpty && (_feed.loading || !_feed.loaded))
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (rows.isEmpty && _feed.error != null) ...[
                  ActEmpty(icon: Icons.wifi_off_rounded, text: _feed.error!),
                  TextButton(
                    onPressed: _load,
                    child: const Text('Try again'),
                  ),
                ] else if (rows.isEmpty)
                  ActEmpty(
                    icon: _filter == ActStatus.withdrawn
                        ? Icons.undo_rounded
                        : Icons.favorite_border_rounded,
                    text: _emptyText(),
                  ),
                for (final i in rows) ...[
                  ActivityCard(
                    person: activityPersonOf(i),
                    highlight: !i.isSent && i.status == InterestState.pending,
                    noteIcon: i.status == InterestState.withdrawn
                        ? Icons.undo_rounded
                        : Icons.favorite_border_rounded,
                    note: _note(i),
                    actions: _actions(i),
                    onTap: () => widget.onOpenProfile?.call(i),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _note(Interest i) {
    final when = i.timeAgo;
    if (i.status == InterestState.withdrawn) {
      return i.isSent
          ? 'You withdrew this interest · sent $when'
          : 'Withdrew their interest · sent $when';
    }
    return i.isSent ? 'You sent interest · $when' : 'Sent you interest · $when';
  }

  String _emptyText() {
    final dir = _receivedTab ? 'received' : 'sent';
    return switch (_filter) {
      ActStatus.pending => 'No pending $dir interests.',
      ActStatus.accepted => 'No accepted $dir interests.',
      ActStatus.declined => 'No declined $dir interests.',
      ActStatus.withdrawn => 'No withdrawn $dir interests.',
    };
  }

  Widget _actions(Interest i) {
    if (_feed.isBusy(i)) {
      return actStatus('Updating…', Icons.hourglass_top_rounded, ActTone.waiting);
    }
    final received = !i.isSent;
    switch (i.status) {
      case InterestState.pending:
        if (received) {
          return i.canRespond
              ? actPair(
                  actOutline('Decline', Icons.close_rounded, () => _decline(i)),
                  actPrimary('Accept', Icons.check_rounded, () => _accept(i)),
                )
              : actStatus('Pending', Icons.schedule_rounded, ActTone.waiting);
        }
        final waiting =
            actStatus('Awaiting response', Icons.schedule_rounded, ActTone.waiting);
        return i.canWithdraw
            ? actPair(waiting,
                actOutline('Withdraw', Icons.undo_rounded, () => _withdraw(i)))
            : waiting;
      case InterestState.accepted:
        return actPair(
          actStatus('Accepted', Icons.check_rounded, ActTone.ok),
          actCream('Chat now', Icons.chat_bubble_outline_rounded,
              () => openChatWith(context, activityPersonOf(i))),
        );
      case InterestState.declined:
        return received && i.canRespond
            ? actStatusWithLink(
                'Declined', ActTone.bad, 'Accept', () => _accept(i))
            : actStatus('Declined', Icons.close_rounded, ActTone.bad);
      case InterestState.withdrawn:
        final pill =
            actStatus('Withdrawn', Icons.undo_rounded, ActTone.waiting);
        // Only the member who withdrew can delete it, and only once.
        return canDeleteWithdrawn(i)
            ? actPair(
                pill,
                actOutline(
                    'Delete', Icons.delete_outline_rounded, () => _delete(i)))
            : pill;
    }
  }
}
