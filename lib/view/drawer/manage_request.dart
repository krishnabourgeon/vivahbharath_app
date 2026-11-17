// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
// import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
// import 'package:vivahbharath_app/view/drawer/common_activity.dart';


// enum RequestType {
//   name('Name', 'name', Icons.badge_outlined),
//   photo('Photo', 'photos', Icons.photo_camera_outlined),
//   number('Number', 'number', Icons.call_outlined),
//   horoscope('Horoscope', 'horoscope', Icons.auto_awesome_outlined);

//   const RequestType(this.label, this.noun, this.icon);
//   final String label;
//   final String noun;
//   final IconData icon;
// }

// class RequestItem {
//   RequestItem(this.person,
//       {required this.type, required this.when, this.status = ActStatus.pending});
//   final ActivityPerson person;
//   final RequestType type;
//   final String when;
//   ActStatus status;
// }

// /// Sample data from the app designs — replace with your API.
// List<RequestItem> sampleRequestsReceived() => [
//       RequestItem(SamplePeople.b, type: RequestType.photo, when: 'today'),
//       RequestItem(SamplePeople.e,
//           type: RequestType.photo, when: '4 days ago', status: ActStatus.accepted),
//       RequestItem(SamplePeople.c, type: RequestType.number, when: '1 day ago'),
//       RequestItem(SamplePeople.d,
//           type: RequestType.horoscope,
//           when: '1 week ago',
//           status: ActStatus.declined),
//     ];

// List<RequestItem> sampleRequestsSent() => [
//       RequestItem(SamplePeople.b, type: RequestType.photo, when: 'today'),
//       RequestItem(SamplePeople.e,
//           type: RequestType.photo, when: '4 days ago', status: ActStatus.accepted),
//       RequestItem(SamplePeople.a, type: RequestType.name, when: '2 days ago'),
//       RequestItem(SamplePeople.c,
//           type: RequestType.horoscope,
//           when: 'last week',
//           status: ActStatus.accepted),
//     ];

// class ManageRequestScreen extends StatefulWidget {
//   const ManageRequestScreen({
//     super.key,
//     this.initialTab = 0,
//     this.initialType = RequestType.photo,
//     this.received,
//     this.sent,
//     this.onApprove,
//     this.onDecline,
//     this.onRevoke,
//     this.onWithdraw,
//     this.onView,
//     this.onOpenProfile,
//     this.showBottomNav = true,
//   });

//   /// 0 = Received, 1 = Sent.
//   final int initialTab;
//   final RequestType initialType;
//   final List<RequestItem>? received;
//   final List<RequestItem>? sent;

//   // TODO: connect to your API.
//   final void Function(RequestItem item)? onApprove;
//   final void Function(RequestItem item)? onDecline;
//   final void Function(RequestItem item)? onRevoke;
//   final void Function(RequestItem item)? onWithdraw;

//   /// Open the approved name / photo / number / horoscope.
//   final void Function(RequestItem item)? onView;
//   final void Function(ActivityPerson person)? onOpenProfile;
//   final bool showBottomNav;

//   @override
//   State<ManageRequestScreen> createState() => _ManageRequestScreenState();
// }

// class _ManageRequestScreenState extends State<ManageRequestScreen> {
//   late int _tab = widget.initialTab;
//   late RequestType _type = widget.initialType;
//   ActStatus? _status; // null = all
//   late final List<RequestItem> _received =
//       widget.received ?? sampleRequestsReceived();
//   late final List<RequestItem> _sent = widget.sent ?? sampleRequestsSent();

//   List<RequestItem> get _list => _tab == 0 ? _received : _sent;
//   List<RequestItem> get _ofType => _list.where((r) => r.type == _type).toList();
//   List<RequestItem> get _visible =>
//       _status == null ? _ofType : _ofType.where((r) => r.status == _status).toList();

//   int _typeCount(RequestType t) =>
//       _list.where((r) => r.type == t && r.status == ActStatus.pending).length;

//   void _set(RequestItem r, ActStatus s, String msg) {
//     final old = r.status;
//     setState(() => r.status = s);
//     showActivityToast(context, msg,
//         onUndo: () => setState(() => r.status = old));
//   }

//   Future<void> _withdraw(RequestItem r) async {
//     final ok = await confirmAction(
//       context,
//       title: 'Withdraw request?',
//       message: 'Your ${r.type.label.toLowerCase()} request will be cancelled.',
//       confirm: 'Withdraw',
//     );
//     if (!ok || !mounted) return;
//     final idx = _sent.indexOf(r);
//     setState(() => _sent.removeAt(idx));
//     widget.onWithdraw?.call(r);
//     showActivityToast(context, 'Request withdrawn',
//         onUndo: () => setState(() => _sent.insert(idx, r)));
//   }

//   Future<void> _revoke(RequestItem r) async {
//     final ok = await confirmAction(
//       context,
//       title: 'Revoke access?',
//       message:
//           'This member will no longer be able to see your ${r.type.noun}.',
//       confirm: 'Revoke',
//     );
//     if (!ok || !mounted) return;
//     widget.onRevoke?.call(r);
//     _set(r, ActStatus.declined, 'Access revoked');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final rows = _visible;
//     final received = _tab == 0;
//     final all = _ofType;
//     int c(ActStatus s) => all.where((r) => r.status == s).length;

//     return ActivityPage(
//       title: 'Manage Request',
//       children: [
//         const SearchTopBar(title: 'Manage Request'),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: ActSegmented(
//             labels: const ['Received', 'Sent'],
//             index: _tab,
//             onPick: (i) => setState(() {
//               _tab = i;
//               _status = null;
//             }),
//           ),
//         ),
//         const SizedBox(height: 14),

//         // Request type tiles
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             children: [
//               for (final t in RequestType.values) ...[
//                 if (t != RequestType.name) const SizedBox(width: 8),
//                 Expanded(
//                   child: _TypeTile(
//                     type: t,
//                     pending: _typeCount(t),
//                     selected: t == _type,
//                     onTap: () => setState(() {
//                       _type = t;
//                       _status = null;
//                     }),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Status chips
//         SizedBox(
//           height: 38,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             children: [
//               for (final (s, label) in <(ActStatus?, String)>[
//                 (null, 'All (${all.length})'),
//                 (ActStatus.pending, 'Pending (${c(ActStatus.pending)})'),
//                 (ActStatus.accepted,
//                     '${received ? 'Approved' : 'Accepted'} (${c(ActStatus.accepted)})'),
//                 (ActStatus.declined, 'Declined (${c(ActStatus.declined)})'),
//               ]) ...[
//                 FilterPill(
//                   label: label,
//                   selected: _status == s,
//                   onTap: () => setState(() => _status = s),
//                 ),
//                 const SizedBox(width: 8),
//               ],
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//             children: [
//               if (received && rows.isNotEmpty) ...[
//                 _Info(
//                   text:
//                       'Approving lets only that member see your ${_type.noun}. You can revoke access anytime.',
//                 ),
//                 const SizedBox(height: 12),
//               ],
//               if (rows.isEmpty)
//                 ActEmpty(
//                   icon: _type.icon,
//                   text:
//                       'No ${received ? 'received' : 'sent'} ${_type.label} requests.',
//                 ),
//               for (final r in rows) ...[
//                 ActivityCard(
//                   person: r.person,
//                   highlight: received && r.status == ActStatus.pending,
//                   noteIcon: r.type.icon,
//                   note: received
//                       ? 'Asked to see your ${r.type.noun} · ${r.when}'
//                       : 'You asked to see their ${r.type.noun} · ${r.when}',
//                   actions: _actions(r, received),
//                   onTap: () => widget.onOpenProfile?.call(r.person),
//                 ),
//                 const SizedBox(height: 14),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _actions(RequestItem r, bool received) {
//     switch (r.status) {
//       case ActStatus.pending:
//         return received
//             ? actPair(
//                 actOutline('Decline', Icons.close_rounded, () {
//                   widget.onDecline?.call(r);
//                   _set(r, ActStatus.declined, 'Request declined');
//                 }),
//                 actPrimary('Approve', Icons.check_rounded, () {
//                   widget.onApprove?.call(r);
//                   _set(r, ActStatus.accepted, '${r.type.label} shared');
//                 }),
//               )
//             : actPair(
//                 actStatus('Awaiting response', Icons.schedule_rounded,
//                     ActTone.waiting),
//                 actOutline('Withdraw', Icons.undo_rounded, () => _withdraw(r)),
//               );
//       case ActStatus.accepted:
//         return received
//             ? actStatusWithLink('${r.type.label} shared', ActTone.ok,
//                 'Revoke access', () => _revoke(r))
//             : actPair(
//                 actStatus('Approved', Icons.check_rounded, ActTone.ok),
//                 actPrimary('View ${r.type.noun}', Icons.visibility_outlined,
//                     () => widget.onView?.call(r)),
//               );
//       case ActStatus.declined:
//         return received
//             ? actStatusWithLink('Declined', ActTone.bad, 'Undo',
//                 () => setState(() => r.status = ActStatus.pending))
//             : actStatus('Declined', Icons.close_rounded, ActTone.bad);
//     }
//   }
// }

// class _TypeTile extends StatelessWidget {
//   const _TypeTile({
//     required this.type,
//     required this.pending,
//     required this.selected,
//     required this.onTap,
//   });

//   final RequestType type;
//   final int pending;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final fg = selected ? Colors.white : AppColors.navy;
//     return Semantics(
//       selected: selected,
//       button: true,
//       label: '${type.label} requests, $pending pending',
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Material(
//             color: selected ? AppColors.tealMid : Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(
//                   color:
//                       selected ? AppColors.tealMid : AppColors.blueTintBorder),
//             ),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: onTap,
//               child: SizedBox(
//                 height: 70,
//                 width: double.infinity,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     matchIcon(type.icon, type.label.toLowerCase(),
//                         size: 22,
//                         color: selected ? Colors.white : AppColors.tealMid),
//                     const SizedBox(height: 6),
//                     Text(
//                       type.label,
//                       style: TextStyle(
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w700,
//                         color: fg,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (pending > 0)
//             Positioned(
//               top: -6,
//               right: -4,
//               child: Container(
//                 constraints: const BoxConstraints(minWidth: 20),
//                 height: 20,
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: AppColors.coral,
//                   borderRadius: BorderRadius.circular(999),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: Text(
//                   '$pending',
//                   style: const TextStyle(
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _Info extends StatelessWidget {
//   const _Info({required this.text});
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.blueTint,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           matchIcon(Icons.lock_outline_rounded, 'lock',
//               size: 16, color: AppColors.link),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(
//                   fontSize: 12.5, height: 1.4, color: AppColors.link),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/common_activity.dart';


enum RequestType {
  name('Name', 'name', Icons.badge_outlined),
  photo('Photo', 'photos', Icons.photo_camera_outlined),
  number('Number', 'number', Icons.call_outlined),
  horoscope('Horoscope', 'horoscope', Icons.auto_awesome_outlined);

  const RequestType(this.label, this.noun, this.icon);
  final String label;
  final String noun;
  final IconData icon;
}

class RequestItem {
  RequestItem(this.person,
      {required this.type, required this.when, this.status = ActStatus.pending});
  final ActivityPerson person;
  final RequestType type;
  final String when;
  ActStatus status;
}

/// Sample data from the app designs — replace with your API.
List<RequestItem> sampleRequestsReceived() => [
      RequestItem(SamplePeople.b, type: RequestType.photo, when: 'today'),
      RequestItem(SamplePeople.e,
          type: RequestType.photo, when: '4 days ago', status: ActStatus.accepted),
      RequestItem(SamplePeople.c, type: RequestType.number, when: '1 day ago'),
      RequestItem(SamplePeople.d,
          type: RequestType.horoscope,
          when: '1 week ago',
          status: ActStatus.declined),
    ];

List<RequestItem> sampleRequestsSent() => [
      RequestItem(SamplePeople.b, type: RequestType.photo, when: 'today'),
      RequestItem(SamplePeople.e,
          type: RequestType.photo, when: '4 days ago', status: ActStatus.accepted),
      RequestItem(SamplePeople.a, type: RequestType.name, when: '2 days ago'),
      RequestItem(SamplePeople.c,
          type: RequestType.photo, when: 'last week', status: ActStatus.withdrawn),
    ];

class ManageRequestScreen extends StatefulWidget {
  const ManageRequestScreen({
    super.key,
    this.initialTab = 0,
    this.initialType = RequestType.photo,
    this.initialFilter = ActStatus.pending,
    this.received,
    this.sent,
    this.onApprove,
    this.onDecline,
    this.onRevoke,
    this.onWithdraw,
    this.onDeleteWithdrawn,
    this.onView,
    this.onOpenProfile,
    this.showBottomNav = true,
  });

  /// 0 = Received, 1 = Sent.
  final int initialTab;
  final RequestType initialType;

  /// Which tile is selected first (null = all).
  final ActStatus? initialFilter;
  final List<RequestItem>? received;
  final List<RequestItem>? sent;

  // TODO: connect to your API.
  final void Function(RequestItem item)? onApprove;
  final void Function(RequestItem item)? onDecline;
  final void Function(RequestItem item)? onRevoke;
  final void Function(RequestItem item)? onWithdraw;
  final void Function(RequestItem item)? onDeleteWithdrawn;

  /// Open the approved name / photo / number / horoscope.
  final void Function(RequestItem item)? onView;
  final void Function(ActivityPerson person)? onOpenProfile;
  final bool showBottomNav;

  @override
  State<ManageRequestScreen> createState() => _ManageRequestScreenState();
}

class _ManageRequestScreenState extends State<ManageRequestScreen> {
  late int _tab =
      widget.initialFilter == ActStatus.withdrawn ? 1 : widget.initialTab;
  late RequestType _type = widget.initialType;
  late ActStatus? _filter = widget.initialFilter;
  late final List<RequestItem> _received =
      widget.received ?? sampleRequestsReceived();
  late final List<RequestItem> _sent = widget.sent ?? sampleRequestsSent();

  bool get _received0 => _tab == 0;
  bool get _withdrawnView => _filter == ActStatus.withdrawn;

  List<RequestItem> get _activeOfType => (_received0 ? _received : _sent)
      .where((r) => r.type == _type && r.status != ActStatus.withdrawn)
      .toList();

  List<RequestItem> get _withdrawnOfType => _sent
      .where((r) => r.type == _type && r.status == ActStatus.withdrawn)
      .toList();

  List<RequestItem> get _visible {
    if (_withdrawnView) return _withdrawnOfType;
    final a = _activeOfType;
    return _filter == null ? a : a.where((r) => r.status == _filter).toList();
  }

  Map<ActStatus, int> get _counts {
    final a = _activeOfType;
    return {
      for (final s in [ActStatus.accepted, ActStatus.pending, ActStatus.declined])
        s: a.where((r) => r.status == s).length,
      ActStatus.withdrawn: _withdrawnOfType.length,
    };
  }

  int _pendingOf(RequestType t) => (_received0 ? _received : _sent)
      .where((r) => r.type == t && r.status == ActStatus.pending)
      .length;

  void _pickFilter(ActStatus? s) => setState(() {
        _filter = s;
        if (s == ActStatus.withdrawn) _tab = 1; // withdrawn = sent only
      });

  void _set(RequestItem r, ActStatus s, String msg) {
    final old = r.status;
    setState(() => r.status = s);
    showActivityToast(context, msg,
        onUndo: () => setState(() => r.status = old));
  }

  Future<void> _withdraw(RequestItem r) async {
    final ok = await confirmAction(
      context,
      title: 'Withdraw your request?',
      message:
          'Your ${r.type.label.toLowerCase()} request will be removed for both of you. You can send it again later from their profile.',
      confirm: 'Withdraw',
    );
    if (!ok || !mounted) return;
    widget.onWithdraw?.call(r);
    _set(r, ActStatus.withdrawn, 'Request withdrawn');
  }

  Future<void> _delete(RequestItem r) async {
    final ok = await confirmAction(
      context,
      title: 'Delete this withdrawn request?',
      message: 'It will be removed from your Withdrawn list.',
      confirm: 'Delete',
    );
    if (!ok || !mounted) return;
    final idx = _sent.indexOf(r);
    setState(() => _sent.removeAt(idx));
    widget.onDeleteWithdrawn?.call(r);
    showActivityToast(context, 'Removed from Withdrawn',
        onUndo: () => setState(() => _sent.insert(idx, r)));
  }

  Future<void> _revoke(RequestItem r) async {
    final ok = await confirmAction(
      context,
      title: 'Revoke access?',
      message: 'This member will no longer be able to see your ${r.type.noun}.',
      confirm: 'Revoke',
    );
    if (!ok || !mounted) return;
    widget.onRevoke?.call(r);
    _set(r, ActStatus.declined, 'Access revoked');
  }

  (String, String) get _header {
    final n = _type.noun;
    if (_received0) {
      return switch (_filter) {
        ActStatus.pending => ('Pending List', 'Members waiting for your approval'),
        ActStatus.accepted => ('Accepted List', 'Members you shared your $n with'),
        ActStatus.declined => ('Declined List', 'Requests you declined'),
        _ => ('All Requests', 'Members who asked to see your $n'),
      };
    }
    return switch (_filter) {
      ActStatus.pending => ('Pending List', 'Waiting for their approval'),
      ActStatus.accepted => ('Accepted List', 'Members who shared their $n'),
      ActStatus.declined => ('Declined List', 'Members who declined your request'),
      ActStatus.withdrawn => ('Withdrawn List', 'Requests you withdrew'),
      null => ('All Requests', "Requests you've sent"),
    };
  }

  @override
  Widget build(BuildContext context) {
    final rows = _visible;
    final (title, subtitle) = _header;
    final received = _received0 && !_withdrawnView;

    return ActivityPage(
      title: 'Manage Request',
      children: [
        const SearchTopBar(title: 'Manage your request'),
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

              // Request type tiles
              Row(
                children: [
                  for (final t in RequestType.values) ...[
                    if (t != RequestType.name) const SizedBox(width: 8),
                    Expanded(
                      child: _TypeTile(
                        type: t,
                        pending: _withdrawnView ? 0 : _pendingOf(t),
                        selected: t == _type,
                        onTap: () => setState(() => _type = t),
                      ),
                    ),
                  ],
                ],
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

              if (received && rows.isNotEmpty) ...[
                _Info(
                  text:
                      'Approving lets only that member see your ${_type.noun}. You can revoke access anytime.',
                ),
                const SizedBox(height: 12),
              ],
              if (rows.isEmpty)
                ActEmpty(icon: _type.icon, text: _emptyText()),
              for (final r in rows) ...[
                ActivityCard(
                  person: r.person,
                  highlight: received && r.status == ActStatus.pending,
                  noteIcon: r.status == ActStatus.withdrawn
                      ? Icons.undo_rounded
                      : r.type.icon,
                  note: r.status == ActStatus.withdrawn
                      ? 'You withdrew your ${r.type.label.toLowerCase()} request · sent ${r.when}'
                      : (received
                          ? 'Asked to see your ${r.type.noun} · ${r.when}'
                          : 'You asked to see their ${r.type.noun} · ${r.when}'),
                  actions: _actions(r, received),
                  onTap: () => widget.onOpenProfile?.call(r.person),
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
    final t = _type.label.toLowerCase();
    return switch (_filter) {
      ActStatus.pending => 'No pending $dir $t requests.',
      ActStatus.accepted => 'No accepted $dir $t requests.',
      ActStatus.declined => 'No declined $dir $t requests.',
      ActStatus.withdrawn => 'No withdrawn $t requests.',
      null => 'No $dir $t requests.',
    };
  }

  Widget _actions(RequestItem r, bool received) {
    switch (r.status) {
      case ActStatus.pending:
        return received
            ? actPair(
                actOutline('Decline', Icons.close_rounded, () {
                  widget.onDecline?.call(r);
                  _set(r, ActStatus.declined, 'Request declined');
                }),
                actPrimary('Approve', Icons.check_rounded, () {
                  widget.onApprove?.call(r);
                  _set(r, ActStatus.accepted, '${r.type.label} shared');
                }),
              )
            : actPair(
                actStatus('Awaiting response', Icons.schedule_rounded,
                    ActTone.waiting),
                actOutline('Withdraw', Icons.undo_rounded, () => _withdraw(r)),
              );
      case ActStatus.accepted:
        return received
            ? actStatusWithLink('${r.type.label} shared', ActTone.ok,
                'Revoke access', () => _revoke(r))
            : actPair(
                actStatus('Approved', Icons.check_rounded, ActTone.ok),
                actPrimary('View ${r.type.noun}', Icons.visibility_outlined,
                    () => widget.onView?.call(r)),
              );
      case ActStatus.declined:
        return received
            ? actStatusWithLink('Declined', ActTone.bad, 'Undo',
                () => setState(() => r.status = ActStatus.pending))
            : actStatus('Declined', Icons.close_rounded, ActTone.bad);
      case ActStatus.withdrawn:
        return actPair(
          actStatus('Withdrawn', Icons.undo_rounded, ActTone.waiting),
          actOutline('Delete', Icons.delete_outline_rounded, () => _delete(r)),
        );
    }
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({
    required this.type,
    required this.pending,
    required this.selected,
    required this.onTap,
  });

  final RequestType type;
  final int pending;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.navy;
    return Semantics(
      selected: selected,
      button: true,
      label: '${type.label} requests, $pending pending',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: selected ? AppColors.tealMid : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color:
                      selected ? AppColors.tealMid : AppColors.blueTintBorder),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: SizedBox(
                height: 66,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    matchIcon(type.icon, type.label.toLowerCase(),
                        size: 21,
                        color: selected ? Colors.white : AppColors.tealMid),
                    const SizedBox(height: 5),
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (pending > 0)
            Positioned(
              top: -6,
              right: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 20),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '$pending',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          matchIcon(Icons.lock_outline_rounded, 'lock',
              size: 16, color: AppColors.link),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.4, color: AppColors.link),
            ),
          ),
        ],
      ),
    );
  }
}