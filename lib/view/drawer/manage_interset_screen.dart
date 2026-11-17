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
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/common_activity.dart';


class InterestItem {
  InterestItem(this.person, {required this.when, this.status = ActStatus.pending});
  final ActivityPerson person;
  final String when;
  ActStatus status;
}

/// Sample data from the app designs — replace with your API.
List<InterestItem> sampleInterestsReceived() => [
      InterestItem(SamplePeople.b, when: 'today'),
      InterestItem(SamplePeople.c, when: 'yesterday'),
      InterestItem(SamplePeople.a, when: '2 weeks ago', status: ActStatus.accepted),
      InterestItem(SamplePeople.d, when: '3 days ago', status: ActStatus.declined),
    ];

List<InterestItem> sampleInterestsSent() => [
      InterestItem(SamplePeople.a, when: '2 weeks ago'),
      InterestItem(SamplePeople.b, when: 'today', status: ActStatus.accepted),
      InterestItem(SamplePeople.c, when: 'yesterday'),
      InterestItem(SamplePeople.e, when: 'last week', status: ActStatus.withdrawn),
    ];

class ManageInterestScreen extends StatefulWidget {
  const ManageInterestScreen({
    super.key,
    this.initialTab = 0,
    this.initialFilter = ActStatus.pending,
    this.received,
    this.sent,
    this.onAccept,
    this.onDecline,
    this.onWithdraw,
    this.onDeleteWithdrawn,
    this.onOpenProfile,
    this.showBottomNav = true,
  });

  /// 0 = Received, 1 = Sent.
  final int initialTab;

  /// Which tile is selected first (null = all).
  final ActStatus? initialFilter;
  final List<InterestItem>? received;
  final List<InterestItem>? sent;

  // TODO: connect to your API.
  final void Function(InterestItem item)? onAccept;
  final void Function(InterestItem item)? onDecline;
  final void Function(InterestItem item)? onWithdraw;
  final void Function(InterestItem item)? onDeleteWithdrawn;
  final void Function(ActivityPerson person)? onOpenProfile;
  final bool showBottomNav;

  @override
  State<ManageInterestScreen> createState() => _ManageInterestScreenState();
}

class _ManageInterestScreenState extends State<ManageInterestScreen> {
  late int _tab =
      widget.initialFilter == ActStatus.withdrawn ? 1 : widget.initialTab;
  late ActStatus? _filter = widget.initialFilter;
  late final List<InterestItem> _received =
      widget.received ?? sampleInterestsReceived();
  late final List<InterestItem> _sent = widget.sent ?? sampleInterestsSent();

  bool get _received0 => _tab == 0;
  bool get _withdrawnView => _filter == ActStatus.withdrawn;

  /// Active (not withdrawn) items of the current tab.
  List<InterestItem> get _active => (_received0 ? _received : _sent)
      .where((i) => i.status != ActStatus.withdrawn)
      .toList();

  List<InterestItem> get _visible {
    if (_withdrawnView) {
      return _sent.where((i) => i.status == ActStatus.withdrawn).toList();
    }
    return _filter == null
        ? _active
        : _active.where((i) => i.status == _filter).toList();
  }

  Map<ActStatus, int> get _counts => {
        for (final s in [ActStatus.accepted, ActStatus.pending, ActStatus.declined])
          s: _active.where((i) => i.status == s).length,
        ActStatus.withdrawn:
            _sent.where((i) => i.status == ActStatus.withdrawn).length,
      };

  void _pickFilter(ActStatus? s) => setState(() {
        _filter = s;
        if (s == ActStatus.withdrawn) _tab = 1; // withdrawn = sent only
      });

  void _set(InterestItem i, ActStatus s, String msg) {
    final old = i.status;
    setState(() => i.status = s);
    showActivityToast(context, msg,
        onUndo: () => setState(() => i.status = old));
  }

  Future<void> _withdraw(InterestItem i) async {
    final ok = await confirmAction(
      context,
      title: 'Withdraw your interest?',
      message:
          'This interest will be removed for both of you. You can resend it later from their profile.',
      confirm: 'Withdraw',
    );
    if (!ok || !mounted) return;
    widget.onWithdraw?.call(i);
    _set(i, ActStatus.withdrawn, 'Interest withdrawn');
  }

  Future<void> _delete(InterestItem i) async {
    final ok = await confirmAction(
      context,
      title: 'Delete this withdrawn interest?',
      message: 'It will be removed from your Withdrawn list.',
      confirm: 'Delete',
    );
    if (!ok || !mounted) return;
    final idx = _sent.indexOf(i);
    setState(() => _sent.removeAt(idx));
    widget.onDeleteWithdrawn?.call(i);
    showActivityToast(context, 'Removed from Withdrawn',
        onUndo: () => setState(() => _sent.insert(idx, i)));
  }

  (String, String) get _header {
    if (_received0) {
      return switch (_filter) {
        ActStatus.pending => ('Pending List', 'Members waiting for your reply'),
        ActStatus.accepted => ('Accepted List', 'Members you accepted'),
        ActStatus.declined => ('Declined List', 'Members you declined'),
        _ => ('All Interests', 'Everyone who sent you interest'),
      };
    }
    return switch (_filter) {
      ActStatus.pending => ('Pending List', 'Waiting for their reply'),
      ActStatus.accepted => ('Accepted List', 'Members who accepted your interest'),
      ActStatus.declined => ('Declined List', 'Members who declined your interest'),
      ActStatus.withdrawn => ('Withdrawn List', 'Interests you withdrew'),
      null => ('All Interests', "Interests you've sent"),
    };
  }

  @override
  Widget build(BuildContext context) {
    final rows = _visible;
    final (title, subtitle) = _header;

    return ActivityPage(
      title: 'Manage Interest',
      children: [
        const SearchTopBar(title: 'Manage your interest'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              ActStatRow(
                counts: _counts,
                selected: _filter,
                onPick: _pickFilter,
              ),
              const SizedBox(height: 18),
              ActListHeader(
                title: title,
                subtitle: subtitle,
                onShowAll: _filter == null ? null : () => _pickFilter(null),
              ),
              const SizedBox(height: 12),
              if (!_withdrawnView) ...[
                ActSegmented(
                  labels: const ['Received', 'Sent'],
                  index: _tab,
                  onPick: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: 14),
              ],
              if (rows.isEmpty)
                ActEmpty(
                  icon: _withdrawnView
                      ? Icons.undo_rounded
                      : Icons.favorite_border_rounded,
                  text: _emptyText(),
                ),
              for (final i in rows) ...[
                ActivityCard(
                  person: i.person,
                  highlight: _received0 &&
                      !_withdrawnView &&
                      i.status == ActStatus.pending,
                  noteIcon: i.status == ActStatus.withdrawn
                      ? Icons.undo_rounded
                      : Icons.favorite_border_rounded,
                  note: i.status == ActStatus.withdrawn
                      ? 'You withdrew this interest · sent ${i.when}'
                      : (_received0 && !_withdrawnView
                          ? 'Sent you interest · ${i.when}'
                          : 'You sent interest · ${i.when}'),
                  actions: _actions(i),
                  onTap: () => widget.onOpenProfile?.call(i.person),
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _emptyText() {
    final dir = _received0 ? 'received' : 'sent';
    return switch (_filter) {
      ActStatus.pending => 'No pending $dir interests.',
      ActStatus.accepted => 'No accepted $dir interests.',
      ActStatus.declined => 'No declined $dir interests.',
      ActStatus.withdrawn => 'No withdrawn interests.',
      null => 'No $dir interests yet.',
    };
  }

  Widget _actions(InterestItem i) {
    final received = _received0 && !_withdrawnView;
    switch (i.status) {
      case ActStatus.pending:
        return received
            ? actPair(
                actOutline('Decline', Icons.close_rounded, () {
                  widget.onDecline?.call(i);
                  _set(i, ActStatus.declined, 'Interest declined');
                }),
                actPrimary('Accept', Icons.check_rounded, () {
                  widget.onAccept?.call(i);
                  _set(i, ActStatus.accepted,
                      'Interest accepted. You can now chat.');
                }),
              )
            : actPair(
                actStatus('Awaiting response', Icons.schedule_rounded,
                    ActTone.waiting),
                actOutline('Withdraw', Icons.undo_rounded, () => _withdraw(i)),
              );
      case ActStatus.accepted:
        return actPair(
          actStatus('Accepted', Icons.check_rounded, ActTone.ok),
          actCream('Chat now', Icons.chat_bubble_outline_rounded,
              () => openChatWith(context, i.person)),
        );
      case ActStatus.declined:
        return received
            ? actStatusWithLink('Declined', ActTone.bad, 'Undo',
                () => setState(() => i.status = ActStatus.pending))
            : actStatus('Declined', Icons.close_rounded, ActTone.bad);
      case ActStatus.withdrawn:
        return actPair(
          actStatus('Withdrawn', Icons.undo_rounded, ActTone.waiting),
          actOutline('Delete', Icons.delete_outline_rounded, () => _delete(i)),
        );
    }
  }
}